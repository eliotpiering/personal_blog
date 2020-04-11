defmodule PersonalBlogWeb.UploadController do
  use PersonalBlogWeb, :controller

  alias PersonalBlog.Main
  alias PersonalBlog.Main.Upload

  action_fallback PersonalBlogWeb.FallbackController

  def create(conn, %{
        "file" => %Plug.Upload{path: tmp_path},
        "post_id" => post_id,
        "title" => title
      }) do
    with {:ok, %Upload{} = upload} <-
           Main.create_upload(%{post_id: post_id, title: title}, tmp_path) do
      conn
      |> put_status(:no_content)
      |> put_resp_header("location", Routes.upload_path(conn, :show, upload.id))
      |> render("show.json", upload: upload)
    end
  end

  def show(conn, %{"id" => id}) do
    upload = Main.get_upload!(id)
    render(conn, "show.json", upload: upload)
  end

  def delete(conn, %{"id" => id}) do
    upload = Main.get_upload!(id)

    with {:ok, %Upload{}} <- Main.delete_upload(upload) do
      send_resp(conn, :no_content, "")
    end
  end
end
