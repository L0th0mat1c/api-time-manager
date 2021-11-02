defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.WorkingTime
  alias TimeManager.Account

  require Logger

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => userID} = _params) do
    if (_params["start"] != nil and _params["end"] != nil) do
      workingtimes = Management.get_working_time_by_user!(userID, _params["start"], _params["end"])
      render(conn, "index.json", workingtimes: workingtimes)
    else
      workingtimes = Management.get_all_working_time_by_user!(userID)
      render(conn, "index.json", workingtimes: workingtimes)
    end
  end

  def create(conn, %{"userID" => userID, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Management.create_working_time(userID, working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :create, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  #def create(conn, %{"userID" => userID, "working_time" => working_time_params}) do
  #  with {:ok, %WorkingTime{} = working_time} <- Management.create_working_time(working_time_params) do
  #    conn
  #    |> put_status(:created)
  #    |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
  #    |> render("show.json", working_time: working_time)
  #  end
  #end
    def showByUser(conn, %{"userID" => userID, "id" => id}) do
    working_time = Management.get_working_time_by_user!(userID, id)
    render(conn, "show.json", working_time: working_time)
  end

  def show(conn, %{"id" => id}) do
    working_time = Management.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Management.get_working_time_by_id!(id)

    with {:ok, %WorkingTime{} = working_time} <- Management.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Management.get_working_time_by_id!(id)

    with {:ok, %WorkingTime{}} <- Management.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
