defmodule PersonalBlogWeb.PostController do
  use PersonalBlogWeb, :controller

  alias PersonalBlog.Main
  alias PersonalBlog.Main.Post

  def index(conn, _params) do
    posts = Main.list_posts(:blog_post)
    render(conn, "index.html", posts: posts)
  end

  def projects(conn, _params) do
    posts = Main.list_posts(:project)
    render(conn, "index.html", posts: posts)
  end

  def music(conn, _params) do
    posts = Main.list_posts(:music)
    render(conn, "index.html", posts: posts)
  end

  def create(conn, _params) do
    case Main.create_post() do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :edit, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        redirect(conn, to: Routes.posts_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    post = Main.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Main.get_post!(id)
    changeset = Main.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Main.get_post!(id)

    case Main.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Main.get_post!(id)
    {:ok, _post} = Main.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
