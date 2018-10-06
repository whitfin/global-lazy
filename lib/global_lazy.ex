defmodule GlobalLazy do
  @moduledoc """
  Lazy global initialization for Elixir, without state.

  This module provides a very simple `global_lazy/2` function
  to enable lazy initialization. This is useful when you need to
  prepare one-time setups, but you don't want to waste a process,
  start an ETS table, and cannot rely on the process dictionary.

  It works using a super simple atom table check, which makes the
  check almost instant (no cross process communication required).

  Here is an example to lazily initialize an `Agent` on the first
  time your function is called:

      defmodule MyLibrary do

        @doc "Retrieves the next integer"
        def next_int do
          # initializes the Agent only the first time called
          GlobalLazy.init("my_library:started", fn ->
            Agent.start(fn -> 1 end, [ name: :my_library_agent ])
          end)

          # guaranteed to now have a started agent
          Agent.get_and_update(:my_library_agent, fn count ->
            {count, count + 1}
          end)
        end

      end

  This example shows an `Agent` being used to track integers, but
  without having to be explicitly started and linked. Of course,
  there are cases where it makes more sense to link - so think about
  your use case appropriately.
  """

  # inline it because it's tiny
  @compile {:inline, init: 2}

  @doc """
  Global initializes a resource using a function.

  The flag provided is global to the current VM instance, so make
  sure to sufficiently namespace your flags to avoid clashing.

  The returned value of your provided function is irrelevant, it's
  entirely ignored - as such, make sure to handle all errors. It's
  fine to crash; the flag is only changed after successful init.

  See the module documentation for example usage.
  """
  @spec init(binary, (() -> any)) :: :ok
  def init(flag, action)
  when is_binary(flag) and is_function(action, 0) do
    try do
      # atom doesn't exist if not running
      String.to_existing_atom("global_lazy:#{flag}")
    rescue
      _ ->
        # so run the action
        action.()

        # and set the flag on success
        String.to_atom("global_lazy:#{flag}")
    end
    :ok
  end
end
