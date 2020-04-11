defmodule PersonalBlogWeb.Helpers.Auth do
  def signed_in?(conn) do
    user = conn.assigns[:current_user]
    if user do
      true
    else
      user_id = Plug.Conn.get_session(conn, :current_user_id)
      if user_id do
        user = PersonalBlog.Repo.get!(PersonalBlog.Accounts.User, user_id)
        Plug.Conn.assign(conn, :current_user, user)
        true
      end
    end
  end
end
