defmodule Sett.Repo do
  use Ecto.Repo,
    otp_app: :sett,
    adapter: Ecto.Adapters.Postgres
end
