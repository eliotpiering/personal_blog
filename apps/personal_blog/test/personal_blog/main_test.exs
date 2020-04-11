defmodule PersonalBlog.MainTest do
  use PersonalBlog.DataCase

  alias PersonalBlog.Main
  alias PersonalBlogWeb.TestHelpers

  describe "posts" do
    alias PersonalBlog.Main.Post

    @valid_attrs %{content: "some content", title: "some title", type: Post.get_type!(:blog_post)}
    @update_attrs %{
      content: "some updated content",
      title: "some updated title",
      type: Post.get_type!(:music)
    }
    @invalid_attrs %{content: nil, title: nil, type: -1}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} = Main.create_post()
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, post} = Main.update_post(post, attrs)
      post
    end

    test "list_posts/1 returns by specified type posts" do
      project_post = post_fixture(type: Post.get_type!(:project))
      other_post = post_fixture(type: Post.get_type!(:music))
      assert Main.list_posts(:project) == [project_post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Main.get_post!(post.id) == post
    end

    test "create_post creates an empty unpublished post" do
      assert {:ok, %Post{} = post} = Main.create_post()
      assert post.content == nil
      assert post.title == "new empty post"
      assert post.type == nil
      refute post.published
    end

    # test "create_post/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Main.create_post(@invalid_attrs)
    # end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Main.update_post(post, @update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
      assert post.type == Post.get_type!(:music)
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Main.update_post(post, @invalid_attrs)
      assert post == Main.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Main.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Main.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Main.change_post(post)
    end
  end

  describe "uploads" do
    alias PersonalBlog.Main.Upload

    @valid_attrs %{post_id: 42, title: "some-title.txt"}
    @update_attrs %{post_id: 43, title: "some-updated-title.txt"}
    @invalid_attrs %{post_id: nil, title: nil}

    def upload_fixture(attrs \\ %{}) do
      tmp_file = TestHelpers.create_test_file(@valid_attrs[:title])

      {:ok, upload} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Main.create_upload(tmp_file)

      upload
    end

    test "list_uploads/0 returns all uploads" do
      upload = upload_fixture()
      assert Main.list_uploads() == [upload]
    end

    test "get_upload!/1 returns the upload with given id" do
      upload = upload_fixture()
      assert Main.get_upload!(upload.id) == upload
    end

    test "create_upload/1 with valid data creates a upload" do
      tmp_file = TestHelpers.create_test_file(@valid_attrs[:title])
      assert {:ok, %Upload{} = upload} = Main.create_upload(@valid_attrs, tmp_file)
      assert upload.post_id == 42
      assert upload.title == "some-title.txt"
    end

    test "create_upload/1 with valid data moves the tmp file to a permanent location" do
      tmp_file = TestHelpers.create_test_file(@valid_attrs[:title])
      assert {:ok, %Upload{} = upload} = Main.create_upload(@valid_attrs, tmp_file)
      assert upload.post_id == 42
      assert upload.title == "some-title.txt"
      assert File.exists?(Upload.path(upload))
    end

    test "create_upload/1 with valid data deletes the tmp file after moving it" do
      tmp_file = TestHelpers.create_test_file(@valid_attrs[:title])
      assert {:ok, %Upload{} = upload} = Main.create_upload(@valid_attrs, tmp_file)
      assert upload.post_id == 42
      assert upload.title == "some-title.txt"
      refute File.exists?(tmp_file)
    end

    test "create_upload/1 with invalid data returns error changeset" do
      tmp_file = TestHelpers.create_test_file(@valid_attrs[:title])
      assert {:error, %Ecto.Changeset{}} = Main.create_upload(@invalid_attrs, tmp_file)
    end

    test "update_upload/2 with valid data updates the upload" do
      upload = upload_fixture()
      assert {:ok, %Upload{} = upload} = Main.update_upload(upload, @update_attrs)
      assert upload.post_id == 43
      assert upload.title == "some-updated-title.txt"
    end

    test "update_upload/2 with invalid data returns error changeset" do
      upload = upload_fixture()
      assert {:error, %Ecto.Changeset{}} = Main.update_upload(upload, @invalid_attrs)
      assert upload == Main.get_upload!(upload.id)
    end

    test "delete_upload/1 deletes the upload" do
      upload = upload_fixture()
      assert {:ok, %Upload{}} = Main.delete_upload(upload)
      assert_raise Ecto.NoResultsError, fn -> Main.get_upload!(upload.id) end
    end

    test "change_upload/1 returns a upload changeset" do
      upload = upload_fixture()
      assert %Ecto.Changeset{} = Main.change_upload(upload)
    end
  end
end
