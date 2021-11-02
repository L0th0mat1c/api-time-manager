defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.Clock

  alias TimeManager.Account
  alias TimeManager.Account.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Management.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"userID" => userID, "clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Management.create_clock(userID, clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"userID" => userID}) do
    # user = Account.get_user(userID)
    clocks = Management.get_clock!(userID)
    render(conn, "index.json", clocks: clocks)
  end

  # def update(conn, %{"id" => id, "clock" => clock_params}) do
  #   clock = Management.get_clock!(id)

  #   with {:ok, %Clock{} = clock} <- Management.update_clock(clock, clock_params) do
  #     render(conn, "show.json", clock: clock)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   clock = Management.get_clock!(id)

  #   with {:ok, %Clock{}} <- Management.delete_clock(clock) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
