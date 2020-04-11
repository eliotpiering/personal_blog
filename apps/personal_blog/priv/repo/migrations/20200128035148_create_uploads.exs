defmodule PersonalBlog.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :title, :string, index: true, unique: true
      add :path, :string
      add :post_id, :integer, index: true

      timestamps()
    end

  end
end
