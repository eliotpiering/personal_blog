defmodule PersonalBlogWeb.PostControllerTest do
  use PersonalBlogWeb.ConnCase

  alias PersonalBlog.Main
  alias PersonalBlog.Accounts
  alias PersonalBlogWeb.TestHelpers

  @create_attrs %{content: "some content", title: "some title", type: 42}
  @update_attrs %{content: "some updated content", title: "some updated title", type: 43}
  @invalid_attrs %{content: nil, title: nil, type: nil}

  def fixture(:post) do
    {:ok, post} = Main.create_post()
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "Blog"
    end
  end

  # describe "new post" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.post_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Post"
  #   end
  # end

  describe "create post" do
    test "creates an empty post and redirects to edit when data is valid", %{conn: conn} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> post(Routes.post_path(conn, :create), %{})

      assert %{id: id} = redirected_params(conn)
      post = Main.get_post!(id)
      assert redirected_to(conn) == Routes.post_path(conn, :edit, id)
      refute post.published
      assert post.title == "new empty post"
    end

    # test "redirects back to index when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
    #   assert redirected_to(conn) == Routes.post_path(conn, :edit, id)
    #   assert html_response(conn, 200) =~ "New Post"
    # end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> get(Routes.post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> put(Routes.post_path(conn, :update, post), post: @update_attrs)

      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> put(Routes.post_path(conn, :update, post), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn =
        conn |> TestHelpers.authenticate_user() |> delete(Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
