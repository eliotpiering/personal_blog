defmodule PersonalBlogWeb.PostView do
  alias Phoenix.HTML
  use PersonalBlogWeb, :view

  def select_post_type(form) do
    HTML.Form.select form, :type, PersonalBlog.Main.Post.type_enum
  end

  def safe_content(content) do
    content |> HtmlSanitizeEx.basic_html() |> HTML.raw()
  end
end
