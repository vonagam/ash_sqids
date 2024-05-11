# AshSqids

[![Module Version](https://img.shields.io/hexpm/v/ash_sqids)](https://hex.pm/packages/ash_sqids)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen)](https://hexdocs.pm/ash_sqids/)
[![License](https://img.shields.io/hexpm/l/ash_sqids)](https://github.com/vonagam/ash_sqids/blob/master/LICENSE.md)

[Sqids](https://sqids.org/) type for [Ash](https://ash-hq.org/) framework.

For what are Sqids and why would you want to use them I recommend looking at the linked website. But basically it is a pretty presentation for integer type. You might prefer having url like `/rooms/DcHPs` over `/rooms/151` or `/rooms/48922bf6-c418-4023-a478-0cca4dd04e68`.

The library consists of a single module `AshSqids.Type` that provides `Ash.Type` implementation.

## Installation

Add to the deps, get deps (`mix deps.get`), compile them (`mix deps.compile`).

```elixir
def deps do
  [
    {:ash_sqids, "~> 0.1.0"},
  ]
end
```

## Usage

Define a module that will represent a Sqid type and `use AshSqids.Type` in it. Provide configuration for it in `config :ash_sqids, :opts`. And then use it as type in attributes and arguments.

```elixir
# lib/example/posts/resources/comment.ex
defmodule Example.Posts.Comment do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  # 1) define a type module
  defmodule Id, do: use(AshSqids.Type)

  attributes do
    # 2) use it as an attribute type
    integer_primary_key :id, type: Id

    # ...
  end

  relationships do
    # 3) use as `attribute_type` in `belongs_to` like this
    belongs_to :post, Example.Posts.Post, attribute_type: Example.Posts.Post.Id
  end
end
```

### Primary key

As shown if you want to use it as a primary key (main use case) then add `integer_primary_key` with `type` option.

And don't forget `attribute_type` in `belongs_to` for references to a resource with sqids.

### Config

Here is how mentioned config is supposed to look:

```elixir
# config/config.exs
import Config

config :ash_sqids, :opts, [
  {Example.Posts.Comment.Id, []}, # use default options
  {Example.Posts.Post.Id, min_length: 7} # some custom values
]
```

Options are passed into `Sqids.new!` and at the time of writing there are three options there -
`alphabet`, `min_length` and `blocklist`.

It is better to provide alphabet. It can be a default one - `abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789` - but just shuffled.

`use AshSqids.Type` accepts optional `config` option that allows you to reuse configurations.
So if in the example we wanted for comments ids and posts ids to be in the same style then we could do it like this:
```elixir
# `config` is an atom (defaulting to a module name) that will be used as a key
# to look up Sqids options from `config :ash_sqids, :opts`
defmodule Id, do: use(AshSqids.Type, config: Example.Posts.Post.Id)
```

### Protocols

`AshSqids.Type` provides implementation for following protocols: 
- `String.Chars` - so `"#{id}"` results in a sqid string.
- `Jason.Encoder` - same, returns a sqid string.
- `Inspect` - with the format of `#Example.Posts.Comment.Id<1, "Uk">`.

## References

Sqids - [website](https://sqids.org/), [github](https://github.com/sqids), [elixir library](https://github.com/sqids/sqids-elixir).

Ash - [website](https://ash-hq.org/), [github](https://github.com/ash-project), [`Ash.Type` docs](https://hexdocs.pm/ash/Ash.Type.html).
