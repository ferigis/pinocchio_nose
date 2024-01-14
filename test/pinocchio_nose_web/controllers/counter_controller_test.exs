defmodule Pinocchio.NoseWeb.CounterControllerTest do
  use Pinocchio.NoseWeb.ConnCase

  alias Pinocchio.Nose.Counters

  describe "POST /api/v1/increment" do
    test "error: wrong format", %{conn: conn} do
      assert resp =
               conn
               |> post(Routes.counter_path(conn, :increment), %{key: "key", value: "one"})
               |> json_response(422)

      assert resp["errors"] == %{"value" => ["is invalid"]}
    end

    test "ok", %{conn: conn} do
      assert nil == Counters.get_counter_by_key("key")

      assert conn
             |> post(Routes.counter_path(conn, :increment), %{key: "key", value: 3})
             |> response(202)

      assert_condition(fn ->
        assert counter = Counters.get_counter_by_key("key")
        assert counter.value == 3
      end)
    end
  end

  describe "GET /api/v1/increment/:key" do
    test "ok: empty key", %{conn: conn} do
      assert resp =
               conn
               |> get(Routes.counter_path(conn, :show, "key"))
               |> json_response(200)

      assert resp["data"] == %{"value" => 0}
    end

    test "ok", %{conn: conn} do
      assert {:ok, _} = Counters.create_counter(%{key: "key", value: 3})

      assert resp =
               conn
               |> get(Routes.counter_path(conn, :show, "key"))
               |> json_response(200)

      assert resp["data"] == %{"value" => 3}
    end
  end
end
