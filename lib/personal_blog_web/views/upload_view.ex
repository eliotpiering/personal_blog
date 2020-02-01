defmodule PersonalBlogWeb.UploadView do
  use PersonalBlogWeb, :view
  alias PersonalBlogWeb.UploadView

  def render("index.json", %{uploads: uploads}) do
    %{data: render_many(uploads, UploadView, "upload.json")}
  end

  def render("show.json", %{upload: upload}) do
    %{data: render_one(upload, UploadView, "upload.json")}
  end

  def render("upload.json", %{upload: upload}) do
    %{id: upload.id,
      title: upload.title,
      path: PersonalBlog.Main.Upload.path(upload),
      post_id: upload.post_id,
      url: PersonalBlog.Main.Upload.url(upload)
    }
  end
end
