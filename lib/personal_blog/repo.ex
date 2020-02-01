defmodule PersonalBlog.Repo do
  use Ecto.Repo,
    otp_app: :personal_blog,
    adapter: Ecto.Adapters.Postgres
end
