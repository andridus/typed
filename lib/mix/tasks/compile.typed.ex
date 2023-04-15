defmodule Mix.Tasks.Compile.Typed do
  alias Mix.Tasks.Dialyzer
  use Mix.Task
  @spec run(any()) :: :ok
  def run(_args) do
    Dialyzer.run([
      "--no-check",
      "--no-compile",
      "--format",
      "dialyxir",
      "--ignore-exit-status",
      "--quiet"
    ])
  end
end
