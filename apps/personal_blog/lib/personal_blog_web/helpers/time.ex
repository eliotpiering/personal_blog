defmodule PersonalBlogWeb.Helpers.Time do
  use Timex

  @timezone "America/Chicago"

  def human_readable(nil), do: ""

  def human_readable(datetime) do
    Timex.format!(datetime, "%B %e %Y", :strftime)
  end
end
