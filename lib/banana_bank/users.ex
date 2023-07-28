defmodule BananaBank.Users do
  alias BananaBank.Users.{Create, Get, Update}

  defdelegate create(params), to: Create, as: :call
  defdelegate get(params), to: Get, as: :call
  defdelegate update(params), to: Update, as: :call
end
