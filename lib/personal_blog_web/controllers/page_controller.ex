defmodule PersonalBlogWeb.PageController do
  use PersonalBlogWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end

end
