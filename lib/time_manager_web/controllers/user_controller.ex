defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Account
  alias TimeManager.Account.User

  action_fallback TimeManagerWeb.FallbackController

  @doc """
    Get all users.
  """
  def index(conn, params) do
    if (params["username"] != nil and params["email"] != nil) do
      users = Account.get_user_by_params(params["username"], params["email"])
      render(conn, "index.json", users: users)
    else
      users = Account.list_users()
      render(conn, "index.json", users: users)
    end
  end

  @doc """
    Get an user by his id.
  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
