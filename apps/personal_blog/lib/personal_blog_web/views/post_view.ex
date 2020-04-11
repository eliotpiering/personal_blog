defmodule PersonalBlogWeb.PostView do
  alias Phoenix.HTML
  use PersonalBlogWeb, :view

  def select_post_type(form) do
    HTML.Form.select(form, :type, PersonalBlog.Main.Post.type_enum())
  end

  def safe_content(content) do
    content |> HtmlSanitizeEx.Scrubber.scrub(MyAllowedHtmlTags) |> HTML.raw()
  end
end

defmodule MyAllowedHtmlTags do
  @moduledoc """
  Based on the BasicHTML scrubber but with some extra stuff for the trix elements (ie figure and figcapture and classes)
  """

  require HtmlSanitizeEx.Scrubber.Meta
  alias HtmlSanitizeEx.Scrubber.Meta

  @valid_schemes ["http", "https", "mailto"]

  # Removes any CDATA tags before the traverser/scrubber runs.
  Meta.remove_cdata_sections_before_scrub()

  Meta.strip_comments()

  Meta.allow_tag_with_uri_attributes("a", ["href"], @valid_schemes)
  Meta.allow_tag_with_these_attributes("a", ["class", "name", "title"])

  Meta.allow_tag_with_these_attributes("b", ["class"])
  Meta.allow_tag_with_these_attributes("blockquote", ["class"])
  Meta.allow_tag_with_these_attributes("br", ["class"])
  Meta.allow_tag_with_these_attributes("code", ["class"])
  Meta.allow_tag_with_these_attributes("del", ["class"])
  Meta.allow_tag_with_these_attributes("em", ["class"])
  Meta.allow_tag_with_these_attributes("h1", ["class"])
  Meta.allow_tag_with_these_attributes("h2", ["class"])
  Meta.allow_tag_with_these_attributes("h3", ["class"])
  Meta.allow_tag_with_these_attributes("h4", ["class"])
  Meta.allow_tag_with_these_attributes("h5", ["class"])
  Meta.allow_tag_with_these_attributes("hr", ["class"])
  Meta.allow_tag_with_these_attributes("i", ["class"])

  Meta.allow_tag_with_uri_attributes("img", ["src"], @valid_schemes)

  Meta.allow_tag_with_these_attributes(
    "img",
    ["class", "width", "height", "title", "alt"]
  )

  Meta.allow_tag_with_these_attributes("li", ["class"])
  Meta.allow_tag_with_these_attributes("ol", ["class"])
  Meta.allow_tag_with_these_attributes("p", ["class"])
  Meta.allow_tag_with_these_attributes("pre", ["class"])
  Meta.allow_tag_with_these_attributes("span", ["class"])
  Meta.allow_tag_with_these_attributes("strong", ["class"])
  Meta.allow_tag_with_these_attributes("table", ["class"])
  Meta.allow_tag_with_these_attributes("tbody", ["class"])
  Meta.allow_tag_with_these_attributes("td", ["class"])
  Meta.allow_tag_with_these_attributes("th", ["class"])
  Meta.allow_tag_with_these_attributes("thead", ["class"])
  Meta.allow_tag_with_these_attributes("tr", ["class"])
  Meta.allow_tag_with_these_attributes("u", ["class"])
  Meta.allow_tag_with_these_attributes("ul", ["class"])
  Meta.allow_tag_with_these_attributes("figure", ["class"])
  Meta.allow_tag_with_these_attributes("figcaption", ["class"])
  Meta.allow_tag_with_these_attributes("article", ["class"])
  Meta.allow_tag_with_these_attributes("audio", ["class", "controls"])
  Meta.allow_tag_with_these_attributes("source", ["class", "src"])

  Meta.strip_everything_not_covered()
end
