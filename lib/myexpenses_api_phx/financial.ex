defmodule MyexpensesApiPhx.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias MyexpensesApiPhx.Repo

  alias MyexpensesApiPhx.Financial.Receipt
  alias MyexpensesApiPhx.Data.Account

  require Timex

  @doc """
  Returns the list of receipts.

  ## Examples

      iex> list_receipts()
      [%Receipt{}, ...]

  """
  def list_receipts(user, init_date, end_date) do
    Ecto.assoc(user, :receipts)
    |> filter_by_init_date(init_date)
    |> filter_by_end_date(end_date)
    |> Repo.all()
    |> Repo.preload(:account)
  end

  @doc """
  Gets a single receipt.

  Raises `Ecto.NoResultsError` if the Receipt does not exist.

  ## Examples

      iex> get_receipt!(123)
      %Receipt{}

      iex> get_receipt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_receipt!(id) do
    Repo.get!(Receipt, id)
    |> Repo.preload(:account)
  end

  @doc """
  Creates a receipt.

  ## Examples

      iex> create_receipt(%{field: value})
      {:ok, %Receipt{}}

      iex> create_receipt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_receipt(attrs \\ %{}, user) do
    result =
      user
      |> Ecto.build_assoc(:receipts)
      |> Receipt.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, receipt} -> {:ok, get_receipt!(receipt.id)}
      _ -> result
    end
  end

  @doc """
  Updates a receipt.

  ## Examples

      iex> update_receipt(receipt, %{field: new_value})
      {:ok, %Receipt{}}

      iex> update_receipt(receipt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_receipt(%Receipt{} = receipt, attrs) do
    receipt
    |> Receipt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a receipt.

  ## Examples

      iex> delete_receipt(receipt)
      {:ok, %Receipt{}}

      iex> delete_receipt(receipt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_receipt(%Receipt{} = receipt) do
    Repo.delete(receipt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking receipt changes.

  ## Examples

      iex> change_receipt(receipt)
      %Ecto.Changeset{data: %Receipt{}}

  """
  def change_receipt(%Receipt{} = receipt, attrs \\ %{}) do
    Receipt.changeset(receipt, attrs)
  end

  def confirm_receipt(receipt) do
    Multi.new()
    |> Multi.update(
      :account,
      Account.changeset(receipt.account, %{balance: receipt.account.balance + receipt.value})
    )
    |> Multi.update(:receipt, Receipt.changeset(receipt, %{confirmed: true}))
    |> Repo.transaction()
  end

  def unconfirm_receipt(receipt) do
    Multi.new()
    |> Multi.update(
      :account,
      Account.changeset(receipt.account, %{balance: receipt.account.balance - receipt.value})
    )
    |> Multi.update(:receipt, Receipt.changeset(receipt, %{confirmed: false}))
    |> Repo.transaction()
  end

  alias MyexpensesApiPhx.Financial.Expense

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses(user, init_date, end_date) do
    Ecto.assoc(user, :expenses)
    |> filter_by_init_date(init_date)
    |> filter_by_end_date(end_date)
    |> Repo.all()
    |> Repo.preload([:account, :place, :bill, :category, :user, credit_card: [:account]])
    |> Enum.map(fn expense ->
      Map.put(expense, :installmentCount, load_installment_count(expense.installmentUUID))
    end)
  end

  defp load_installment_count(nil), do: 0

  defp load_installment_count(installmentUUID) do
    Repo.one(from e in "expenses", select: count(e.installmentUUID == ^installmentUUID))
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id) do
    expense =
      Repo.get!(Expense, id)
      |> Repo.preload([:account, :place, :bill, :category, :user, credit_card: [:account]])

    if(expense.installmentUUID) do
      Map.put(expense, :installmentCount, load_installment_count(expense.installmentUUID))
    else
      expense
    end
  end

  defp create_installment_expense(multi, attrs, user, uuid, installment, date, split_value) do
    changeset =
      user
      |> Ecto.build_assoc(:expenses)
      |> Expense.changeset(
        Map.merge(attrs, %{
          "installmentUUID" => uuid,
          "installmentNumber" => Integer.to_string(installment),
          "value" => split_value,
          "date" => date
        })
      )

    %{"installmentNumber" => installmentNumber} = attrs
    # {installmentCount, _} = Integer.parse(installmentNumber)

    if(installment < installmentNumber) do
      create_installment_expense(
        Multi.insert(multi, String.to_atom("expense#{installment}"), changeset),
        attrs,
        user,
        uuid,
        installment + 1,
        Timex.shift(date, months: 1),
        split_value
      )
    else
      Multi.insert(multi, String.to_atom("expense#{installment}"), changeset)
    end
  end

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}, user) do
    %{"installmentNumber" => installmentNumber, "date" => date, "value" => value} = attrs

    if(installmentNumber) do
      {_, parsedDate} = NaiveDateTime.from_iso8601(date)

      {result, expenses} =
        Repo.transaction(
          create_installment_expense(
            Multi.new(),
            attrs,
            user,
            Ecto.UUID.generate(),
            1,
            parsedDate,
            div(value, installmentNumber)
          )
        )

      {result, expenses.expense1}
    else
      result =
        user
        |> Ecto.build_assoc(:expenses)
        |> Expense.changeset(attrs)
        |> Repo.insert()

      case result do
        {:ok, expense} -> {:ok, get_expense!(expense.id)}
        _ -> result
      end
    end
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  def confirm_expense(expense) do
    Multi.new()
    |> Multi.update(
      :account,
      Account.changeset(expense.account, %{balance: expense.account.balance - expense.value})
    )
    |> Multi.update(:expense, Expense.changeset(expense, %{confirmed: true}))
    |> Repo.transaction()
  end

  def unconfirm_expense(expense) do
    Multi.new()
    |> Multi.update(
      :account,
      Account.changeset(expense.account, %{balance: expense.account.balance + expense.value})
    )
    |> Multi.update(:expense, Expense.changeset(expense, %{confirmed: false}))
    |> Repo.transaction()
  end

  defp filter_by_init_date(query, init_date) do
    from e in query,
      where: e.date >= ^init_date
  end

  defp filter_by_end_date(query, end_date) do
    from e in query,
      where: e.date <= ^end_date
  end
end
