# Typed

Types for Elixir

## To Do
 - [x] add `deft` to define a typed public function
 - [x] add `defpt` to define a typed private function
 - [] define typed struct

### Examples

```elixir
  defmodule T do
    use Typed

    deft sum( x: integer, y: integer ) :: integer do
      x + y
    end
    deft alert( msg: String.t ) :: :ok do
      :ok = testing(123,12312)
    end
    defpt testing(a: number, b: number ) :: :ok do
      IO.puts("impact #{a} and #{b}")
    end
  end
```

### Tips and tricks
  using the vscode extension [Elixir Custom Highlight](https://github.com/andridus/vscode-elixir-custom-highlighting) to help you and facilitate coloring,

## Installation

```elixir
def deps do
  [
    {:typed, "~> 0.1.0"}
  ]
end
```