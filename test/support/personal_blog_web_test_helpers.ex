defmodule PersonalBlogWeb.TestHelpers do
  import Plug.Conn

  alias PersonalBlog.Accounts

  def authenticate_user(conn) do
    authenticate_user(conn, fixture(:user))
  end

  def authenticate_user(conn, user) do
    Plug.Conn.assign(conn, :current_user, user)
  end

  def create_test_file(filename) do
    dir = System.tmp_dir!()
    tmp_file_path = Path.join(dir, filename)
    File.touch(tmp_file_path)
    tmp_file_path
  end

  defp fixture(:user) do
    {:ok, user} =
      Accounts.create_user(%{email: "eliot@eliotpiering.com", encrypted_password: "--------"})
    user
  end
end
