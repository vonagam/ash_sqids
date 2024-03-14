defmodule AshSqids.Test do
  use ExUnit.Case, async: true

  defmodule Id, do: use(AshSqids.Type, opts: [])

  @pairs [
    {0, "bM"},
    {1, "Uk"},
    {12, "vE"},
    {123, "UKk"},
    {1234, "A4W"},
    {12345, "A6da"},
  ]

  describe "cast_input/2" do
    test "returns `{:ok, sqid}` for valid strings" do
      for {integer, string} <- @pairs do
        assert Id.cast_input(string, nil) == {:ok, %Id{integer: integer, string: string}}
      end
    end

    test "returns `{:ok, nil}` for `nil`" do
      assert Id.cast_input(nil, nil) == {:ok, nil}
    end

    test "returns `{:ok, sqid}` for sqid" do
      assert Id.cast_input(%Id{integer: -1, string: ""}, nil) == {:ok, %Id{integer: -1, string: ""}}
    end

    test "returns `:error` for invalid values" do
      for value <- ["", " ", " Uk", "!", "!Uk", 0, 1] do
        assert Id.cast_input(value, nil) == :error
      end
    end
  end

  describe "cast_stored/2" do
    test "returns `{:ok, sqid}` for valid integers" do
      for {integer, string} <- @pairs do
        assert Id.cast_stored(integer, nil) == {:ok, %Id{integer: integer, string: string}}
      end
    end

    test "returns `{:ok, nil}` for `nil`" do
      assert Id.cast_stored(nil, nil) == {:ok, nil}
    end

    test "returns `{:ok, sqid}` for sqid" do
      assert Id.cast_stored(%Id{integer: -1, string: ""}, nil) == {:ok, %Id{integer: -1, string: ""}}
    end

    test "returns `:error` for invalid values" do
      for value <- [-1, "", "Uk"] do
        assert Id.cast_stored(value, nil) == :error
      end
    end
  end

  describe "dump_to_native/2" do
    test "returns `{:ok, integer}` from sqid" do
      for integer <- [-1, 0, 1] do
        assert Id.dump_to_native(%Id{integer: integer, string: ""}, nil) == {:ok, integer}
      end
    end

    test "returns `{:ok, nil}` for `nil`" do
      assert Id.dump_to_native(nil, nil) == {:ok, nil}
    end

    test "returns `:error` for invalid values" do
      for value <- [-1, 0, 1, "", "Uk"] do
        assert Id.dump_to_native(value, nil) == :error
      end
    end
  end

  describe "generator/1" do
    test "returns enumerable of random sqids" do
      assert {:ok, %Id{integer: integer, string: string}} = Id.generator(nil) |> Enum.at(0)
      assert integer >= 0
      assert is_binary(string)
      assert Id.cast_stored(integer, nil) == {:ok, %Id{integer: integer, string: string}}
    end
  end

  describe "String.Chars.to_string/1" do
    test "returns its string for sqid" do
      for string <- ["", "Uk", "!"] do
        assert "#{%Id{integer: -1, string: string}}" == string
      end
    end
  end

  describe "Jason.Encoder.encode/2" do
    test "return `{:ok, string}` for sqid" do
      for string <- ["", "Uk", "!"] do
        assert Jason.encode(%Id{integer: -1, string: string}) == {:ok, "\"" <> string <> "\""}
      end
    end
  end
end
