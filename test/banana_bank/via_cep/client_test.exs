defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      cep = "04324090"

      body = ~s({
          "bairro": "Vila do Encontro",
          "cep": "04324-090",
          "complemento": "",
          "ddd": "11",
          "gia": "1004",
          "ibge": "3550308",
          "localidade": "São Paulo",
          "logradouro": "Avenida Barro Branco",
          "siafi": "7107",
          "uf": "SP"
      })

      expected_response =
        {:ok,
         %{
           "bairro" => "Vila do Encontro",
           "cep" => "04324-090",
           "complemento" => "",
           "ddd" => "11",
           "gia" => "1004",
           "ibge" => "3550308",
           "localidade" => "São Paulo",
           "logradouro" => "Avenida Barro Branco",
           "siafi" => "7107",
           "uf" => "SP"
         }}

      Bypass.expect(bypass, "GET", "/04324090/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
