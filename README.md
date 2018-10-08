# GlobalLazy
[![Unix Build Status](https://img.shields.io/travis/whitfin/global-lazy.svg?label=unix)](https://travis-ci.org/whitfin/global-lazy) [![Windows Build Status](https://img.shields.io/appveyor/ci/whitfin/global-lazy.svg?label=win)](https://ci.appveyor.com/project/whitfin/global-lazy) [![Hex.pm Version](https://img.shields.io/hexpm/v/global_lazy.svg)](https://hex.pm/packages/global_lazy) [![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://hexdocs.pm/global_lazy/)

**NOTE:** _This library is deprecated in favour of [whitfin/global-flags](https://github.com/whitfin/global-flags). You should migrate when possible as this library will not receive updates - it only exists to avoid
breaking existing applications._

This library is designed to provide an easy way to lazily initial global
state in Elixir, without having to be linked to a main application tree.

This is useful for libraries which always require certain state, regardless
of the state of the parent application. It's aimed at use cases where it's
slow to have a separate process, and it's wasteful to start an ETS table.

This library is tiny, so you can include it with minimal overhead.

## Installation

To install it for your project, you can pull it directly from Hex. Rather
than use the version shown below, you can use the the latest version from
Hex (shown at the top of this README).

```elixir
def deps do
  [{:global_lazy, "~> 1.0"}]
end
```

Documentation and examples can be found on [Hexdocs](https://hexdocs.pm/global_lazy/)
as they're updated automatically alongside each release.

## Usage

As mentioned above, the API is extremely small, so there's really only one thing to
learn how to use. Below is an example of lazily initializing an `Agent`, used to keep
track of a global counter.

```elixir
defmodule MyLibrary do

  @doc """
  Retrieves the next integer in the global counter.
  """
  def next_int do
    # initializes the Agent only the first time called
    GlobalLazy.init("my_library:started", fn ->
      Agent.start(fn -> 1 end, [ name: :my_library_agent ])
    end)

    # guaranteed to now have a started Agent
    Agent.get_and_update(:my_library_agent, fn count ->
      {count, count + 1}
    end)
  end
end
```

You should handle all errors inside the provided function; feel free to just crash if you'd
prefer to retry initialization on the next call - the flag is only switched if the function
returns successfully. You should also be careful to namespace your flags, because they're
global (duh).
