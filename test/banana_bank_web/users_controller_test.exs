defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      params = %{
        name: "Nath",
        cep: "12345678",
        email: "nat@test.com",
        password: "123456"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "12345678", "email" => "nat@test.com", "id" => _id, "name" => "Nath"},
               "message" => "User criado com sucesso!"
             } = response
    end

    test "when there are invalids params returns an error", %{conn: conn} do
      params = %{
        name: "Nath",
        cep: "12",
        email: "nat@test.com",
        password: "123456"
      }

      expected_response = %{"errors" => %{"cep" => ["should be 8 character(s)"]}}

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert response == expected_response
    end
  end
end
