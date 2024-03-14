defmodule AshSqids.Type do
  @moduledoc """
  `AshSqids.Type` implements `Ash.Type` behaviour in a module that `use`s it.

  By default Sqids options are looked up by doing `Application.compile_env!(:ash_sqids, [:opts, __MODULE__])`.

  `use AshSqids.Type` accepts two optional exclusive options to change that - `opts` and `config`:
  - `opts` provides options directly and disables config lookup from environment.
  - `config` specifies a key to be used instead of a module name.

  Having either options in config environment or in `opts` is required, even if you want to use default ones
  (in that case pass empty list `[]`).

  Sqids options include `alphabet`, `min_length` and `blocklist`. It is recommended to provide `alphabet`.
  It can be a default one - `abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789` - but just shuffled.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      use Ash.Type

      defstruct [:integer, :string]

      @sqids Sqids.new!(opts[:opts] || Application.compile_env!(:ash_sqids, [:opts, opts[:config] || __MODULE__]))
      def sqids(), do: @sqids

      @impl true
      def storage_type(_), do: :integer

      @impl true
      def cast_input(string, _) when is_binary(string) do
        try do
          [integer] = Sqids.decode!(@sqids, string)
          {:ok, %__MODULE__{integer: integer, string: string}}
        rescue _ ->
          :error
        end
      end

      def cast_input(%__MODULE__{} = struct, _), do: {:ok, struct}
      def cast_input(nil, _), do: {:ok, nil}
      def cast_input(_, _), do: :error

      @impl true
      def cast_stored(integer, _) when is_integer(integer) and integer >= 0 do
        try do
          string = Sqids.encode!(@sqids, [integer])
          {:ok, %__MODULE__{integer: integer, string: string}}
        rescue _ ->
          :error
        end
      end

      def cast_stored(%__MODULE__{} = struct, _), do: {:ok, struct}
      def cast_stored(nil, _), do: {:ok, nil}
      def cast_stored(_, _), do: :error

      @impl true
      def dump_to_native(%__MODULE__{} = struct, _), do: {:ok, struct.integer}
      def dump_to_native(nil, _), do: {:ok, nil}
      def dump_to_native(_, _), do: :error

      @impl true
      def generator(_), do: Ash.Type.Integer.generator(min: 0) |> Stream.map(&cast_stored(&1, nil))

      defimpl String.Chars do
        def to_string(struct), do: struct.string
      end

      defimpl Jason.Encoder do
        def encode(struct, opts), do: Jason.Encode.string(struct.string, opts)
      end

      defimpl Inspect do
        import Inspect.Algebra

        def inspect(struct, opts) do
          module = to_doc(struct.__struct__, opts)
          integer = to_doc(struct.integer, opts)
          string = to_doc(struct.string, opts)
          concat(["#", module, "<", integer, ", ", string, ">"])
        end
      end
    end
  end
end
