defmodule AshSqids.Bench do
  use Benchfella

  defmodule Id, do: use(AshSqids.Type, opts: [])

  bench "cast_input/2 1_000" do
    Id.cast_input("pnd", nil)
  end

  bench "cast_input/2 1_000_000" do
    Id.cast_input("gMvFo", nil)
  end

  bench "cast_input/2 1_000_000_000" do
    Id.cast_input("seqWcQz", nil)
  end

  bench "cast_stored/2 1_000" do
    Id.cast_stored(1_000, nil)
  end

  bench "cast_stored/2 1_000_000" do
    Id.cast_stored(1_000_000, nil)
  end

  bench "cast_stored/2 1_000_000_000" do
    Id.cast_stored(1_000_000_000, nil)
  end
end
