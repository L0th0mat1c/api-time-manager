defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ManagementFixtures
  import TimeManager.AccountFixtures

  alias TimeManager.Management.Clock
  alias TimeManager.Account.User



  @create_attrs %{
    status: true,
    time: ~N[2021-10-25 09:58:00]
  }
  @update_attrs %{
    status: false,
    time: ~N[2021-10-26 09:58:00]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get clock" do
  setup [:create_user]
    test "get clock by user id", %{conn: conn, user: %User{id: id} = user} do
      conn = get(conn, Routes.clock_path(conn, :show, user.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
  setup [:create_user]

    test "renders clock when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = post(conn, Routes.clock_path(conn, :create, user.id), clock:  @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.clock_path(conn, :show, user.id))
     
      userid = user.id
        IO.puts "user id after: #{inspect(id)}"
      assert [%{
               "id" => ^id,
               "status" => true,
               "time" => "2021-10-25T09:58:00",
               "user" => ^userid
             }] = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: %User{id: id} = user} do
      conn = post(conn, Routes.clock_path(conn, :create, user), clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update clock" do
  #   setup [:create_clock]

  #   test "renders clock when data is valid", %{conn: conn, clock: %Clock{id: id} = clock} do
  #     conn = put(conn, Routes.clock_path(conn, :update, clock), clock: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.clock_path(conn, :show, id))

  #     assert %{
  #              "id" => ^id,
  #              "status" => false,
  #              "time" => "2021-10-26T09:58:00"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, clock: clock} do
  #     conn = put(conn, Routes.clock_path(conn, :update, clock), clock: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete clock" do
  #   setup [:create_clock]

  #   test "deletes chosen clock", %{conn: conn, clock: clock} do
  #     conn = delete(conn, Routes.clock_path(conn, :delete, clock))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.clock_path(conn, :show, clock))
  #     end
  #   end
  # end
  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_clock(_) do
    clock = clock_fixture()
    %{clock: clock}
  end
end
