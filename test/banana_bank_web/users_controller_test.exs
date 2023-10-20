defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  setup :verify_on_exit!

  alias BananaBank.Users
  alias Users.User

  setup do
    params = %{
      "name" => "Nath",
      "cep" => "04324090",
      "email" => "nat@test.com",
      "password" => "123456"
    }

    body = %{
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
    }

    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, body: body, user_params: params} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "04324090" -> {:ok, body} end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "04324090", "email" => "nat@test.com", "id" => _id, "name" => "Nath"},
               "message" => "User criado com sucesso!"
             } = response
    end

    test "when there are invalids params returns an error", %{conn: conn} do
      params = %{
        "name" => nil,
        "cep" => "12",
        "email" => "nat@test.com",
        "password" => "123456"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12" -> {:ok, ""} end)

      expected_response = %{"errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}}

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn, body: body, user_params: params} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "04324090" -> {:ok, body} end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => "04324090", "email" => "nat@test.com", "id" => id, "name" => "Nath"},
        "message" => "User excluído com sucesso!"
      }

      assert response == expected_response
    end
  end
end
