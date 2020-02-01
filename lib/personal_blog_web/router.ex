defmodule PersonalBlogWeb.Router do
  use PersonalBlogWeb, :router
  alias PersonalBlog.Accounts

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :check_auth
    #TODO move to plug in another module
    defp check_auth(conn, _args) do
      if user = get_user(conn) do
        assign(conn, :current_user, user)
      else
        conn
        |> put_flash(:error, "Not Signed In!")
        |> redirect(to: __MODULE__.Helpers.post_path(conn, :index))
        |> halt()
      end
    end

    defp get_user(conn) do
      case conn.assigns[:current_user] do
        nil ->
          user_id = get_session(conn, :current_user_id)
          Accounts.get_user!(user_id)
        user ->
          user
      end
    end
  end

  scope "/", PersonalBlogWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/blog", PostController, :index
    get "/contact", PageController, :contact
    get "/projects", PostController, :projects
    get "/music", PostController, :music
    get "/post/:id", PostController, :show

    resources "/registrations", UserController, only: [:new, :create]

    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete

    get "/uploads/:id", UploadController, :show

    scope "/admin" do
      pipe_through :admin
      resources "/uploads", UploadController, only: [:create, :delete]
      resources "/posts", PostController, only: [:new, :create, :edit, :update, :delete]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PersonalBlogWeb do
  #   pipe_through :api
  # end
end
