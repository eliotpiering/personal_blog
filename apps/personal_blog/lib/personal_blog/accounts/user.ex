defmodule PersonalBlog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> validate_required([:email, :encrypted_password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^eliot@eliotpiering\.com$/)
    |> update_change(:encrypted_password, &Argon2.hash_pwd_salt/1)
  end
end
