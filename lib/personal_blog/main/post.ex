defmodule PersonalBlog.Main.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string
    field :type, :integer
    field :published, :boolean, default: false
    field :published_at, :utc_datetime

    timestamps()
  end

  @doc false

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :type, :published, :published_at])
    |> validate_required([:title, :content, :type, :published])
    |> set_published_at()
  end

  def type_enum do
    %{blog_post: 0, project: 1, music: 2}
  end

  def get_type!(type) do
    Map.get(type_enum(), type)
  end

  def set_published_at(changeset) do
    if changeset.changes[:published] && !changeset.changes[:published_at] do
      {:ok, now} = DateTime.now("Etc/UTC")
      changeset |> change(published_at: now |> DateTime.truncate(:second))
    else
      changeset
    end
  end
end
