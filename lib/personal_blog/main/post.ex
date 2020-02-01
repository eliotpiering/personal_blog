defmodule PersonalBlog.Main.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string
    field :type, :integer
    field :published, :boolean, default: false

    timestamps()
  end

  @doc false

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :type])
    |> validate_required([:title, :content, :type])
  end

  def type_enum do
    %{blog_post: 0, project: 1, music: 2}
  end

  def get_type!(type) do
    Map.get(type_enum(), type)
  end

end
