defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase
  alias BananaBank.Users
  alias Users.User

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      params = %{
        "name" => "Nath",
        "cep" => "04324090",
        "email" => "nat@test.com",
        "password" => "123456"
      }

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
        "name" => "Nath",
        "cep" => "12",
        "email" => "nat@test.com",
        "password" => "123456"
      }

      expected_response = %{"status" => "bad_request"}

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn} do
      params = %{
        "name" => "Nath",
        "cep" => "04324090",
        "email" => "nat@test.com",
        "password" => "123456"
      }

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
