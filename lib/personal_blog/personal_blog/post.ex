defmodule PersonalBlog.PersonalBlog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :published_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:published_at])
    |> validate_required([:published_at])
  end
end
