defmodule BananaBank.ViaCep.ClientBehaviour do
  @callback_call(String.t()) :: {:ok, map()} | {:error, :atom}
end
