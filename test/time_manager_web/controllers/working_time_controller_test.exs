defmodule TimeManagerWeb.WorkingTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ManagementFixtures
  import TimeManager.AccountFixtures
  alias TimeManager.Management.WorkingTime
    alias TimeManager.Account.User

  @create_attrs %{
    end: ~N[2021-10-25 09:44:00],
    start: ~N[2021-10-25 09:44:00]
  }
  @update_attrs %{
    end: ~N[2021-10-26 09:44:00],
    start: ~N[2021-10-26 09:44:00]
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get workingtime" do
  setup [:create_user]
  # get workingtime by id
    test "get workingtime by user id", %{conn: conn, user: %User{id: id} = user} do
      conn = get(conn, Routes.working_time_path(conn, :index, user.id))
      assert json_response(conn, 200)["data"] == []
    end
  # get workingtime by userid and id
    test "get workingtime by user id and id", %{conn: conn, user: %User{id: id} = user} do
    conn = post(conn, Routes.working_time_path(conn, :create, user.id), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.working_time_path(conn, :showByUser, user.id, id))
      assert %{
               "id" => ^id,
               "end" => "2021-10-25T09:44:00",
               "start" => "2021-10-25T09:44:00"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create working_time" do
  setup [:create_user]
    test "renders working_time when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = post(conn, Routes.working_time_path(conn, :create, user.id), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.working_time_path(conn, :showByUser,user.id, id ))

      assert %{
               "id" => ^id,
               "end" => "2021-10-25T09:44:00",
               "start" => "2021-10-25T09:44:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: %User{id: id} = user} do
      conn = post(conn, Routes.working_time_path(conn, :create, user.id), working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_user]
    test "renders working_time when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = post(conn, Routes.working_time_path(conn, :create, user.id), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.working_time_path(conn, :showByUser, user.id, id ))
      conn = put(conn, Routes.working_time_path(conn, :update, id), working_time: @update_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]
      conn = get(conn, Routes.working_time_path(conn, :showByUser, user.id, id))
      userid = user.id
      assert %{
               "id" => ^id,
               "end" => "2021-10-26T09:44:00",
               "start" => "2021-10-26T09:44:00",
               "user" => userid
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: %User{id: id} = user} do
    conn = post(conn, Routes.working_time_path(conn, :create, user.id), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = put(conn, Routes.working_time_path(conn, :update, id), working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_user]
    test "deletes chosen working_time", %{conn: conn, user: %User{id: id} = user} do
      conn = post(conn, Routes.working_time_path(conn, :create, user.id), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = delete(conn, Routes.working_time_path(conn, :delete, id))
      assert response(conn, 204)

    # Check if data is exist
      conn = get(conn, Routes.working_time_path(conn, :showByUser, user.id, id))
      assert %{
               "data" => null
             } = json_response(conn, 200)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_working_time(_) do
  IO.puts("teszt #{working_time_fixture()}")
    working_time = working_time_fixture()
    %{working_time: working_time}
  end
end
