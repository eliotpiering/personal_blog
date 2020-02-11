defmodule PersonalBlog.Main.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :post_id, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:title, :post_id])
    |> validate_required([:title, :post_id])
  end

  def store_file!(upload_changeset, tmp_path) do
    if(upload_changeset.valid? && File.exists?(tmp_path)) do
      new_path = Path.join(base_storage_dir, upload_changeset.changes[:title])
      File.cp!(tmp_path, new_path)
      File.rm(tmp_path)
      upload_changeset
    else
      upload_changeset
    end
  end

  def path(upload) do
    Path.join(base_storage_dir, upload.title)
  end

  def url(upload) do
    Enum.join([PersonalBlogWeb.Endpoint.url(), path(upload)], "/")
  end

  defp base_storage_dir do
    if Mix.env() == :test do
      Path.join(File.cwd!(), "test/test_uploads/")
    else
      Path.join(File.cwd!(), "priv/static/uploads/")
    end
  end
end
