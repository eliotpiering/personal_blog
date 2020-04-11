defmodule PersonalBlog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :type, :integer
      add :published, :boolean

      timestamps()
    end

  end
end
