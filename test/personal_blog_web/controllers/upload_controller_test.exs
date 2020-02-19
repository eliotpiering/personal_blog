defmodule PersonalBlogWeb.UploadControllerTest do
  use PersonalBlogWeb.ConnCase

  alias PersonalBlog.Main
  alias PersonalBlog.Main.Upload
  alias PersonalBlogWeb.TestHelpers

  @create_attrs %{
    post_id: 42,
    title: "some title"
  }
  @invalid_attrs %{"post_id" => nil, "title" => nil, "file" => %Plug.Upload{path: nil}}

  @valid_params %{
    "file" => %Plug.Upload{
      content_type: "image/png",
      filename: "tree-winter.png",
      path: "/tmp/test-tmp-file"
    },
    "post_id" => "42",
    "title" => "1580408101450-tree-winter.png"
  }

  def fixture(:upload) do
    tmp_file = TestHelpers.create_test_file(@create_attrs[:title])
    {:ok, upload} = Main.create_upload(@create_attrs, tmp_file)
    upload
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    File.touch("/tmp/test-tmp-file")
  end

  describe "create upload" do
    test "renders upload when data is valid", %{conn: conn} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> post(Routes.upload_path(conn, :create), @valid_params)

      assert %{"id" => id} = json_response(conn, 204)["data"]

      conn = get(conn, Routes.upload_path(conn, :show, id))
      path = PersonalBlog.Main.Upload.path(%{title: "1580408101450-tree-winter.png"})

      assert %{
               "id" => id,
               "path" => path,
               "post_id" => 42,
               "title" => "1580408101450-tree-winter.png"
             } = json_response(conn, 200)["data"]
    end

    test "Uploaded file gets moved to permenent location" do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> post(Routes.upload_path(conn, :create), @valid_params)

      assert %{"id" => id} = json_response(conn, 204)["data"]

      conn = get(conn, Routes.upload_path(conn, :show, id))
      path = PersonalBlog.Main.Upload.path(%{title: "1580408101450-tree-winter.png"})
      assert File.exists?(path)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> post(Routes.upload_path(conn, :create), @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete upload" do
    setup [:create_upload]

    test "deletes chosen upload", %{conn: conn, upload: upload} do
      conn =
        conn
        |> TestHelpers.authenticate_user()
        |> delete(Routes.upload_path(conn, :delete, upload))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.upload_path(conn, :show, upload))
      end
    end
  end

  defp create_upload(_) do
    upload = fixture(:upload)
    {:ok, upload: upload}
  end
end
