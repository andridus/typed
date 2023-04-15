defmodule Typed do
  @moduledoc """
    Generate typed function by easy macro `deft`or `defpt`
  """
  defmacro __using__(_) do
    quote do
      require Typed
      import Typed
    end
  end

  defmacro defpt({:"::", _, [{fun_name, env, args}, type]}) do
    create_function(:defp, {fun_name, env, args}, type, nil)
  end

  defmacro defpt({:"::", _, [{fun_name, env, args}, type]}, do: block) do
    create_function(:defp, {fun_name, env, args}, type, block)
  end

  defmacro deft({:"::", _, [{fun_name, env, args}, type]}) do
    create_function(:def, {fun_name, env, args}, type, nil)
  end

  defmacro deft({:"::", _, [{fun_name, env, args}, type]}, do: block) do
    create_function(:def, {fun_name, env, args}, type, block)
  end

  defp create_function(fns, {fun_name, env, args}, type, block) do
    {args, types} =
      Macro.prewalk(args, [], fn
        {key, type}, acc ->
          case type do
            {:\\, env, [type, opt]} ->
              {{:\\, env, [{key, [], nil}, opt]}, [{parse_type(type), :__NIL__} | acc]}

            _ ->
              {{key, [], nil}, [{parse_type(type), :__REQUIRED__} | acc]}
          end

        ast, acc ->
          {ast, acc}
      end)

    types =
      types
      |> Enum.reverse()

    total =
      types
      |> Enum.reduce(0, fn
        {_, :__NIL__}, acc -> acc + 1
        _, acc -> acc
      end)

    types = total..0 |> Enum.map(fn x -> remove_nils(types, x) end)
    args = args |> List.flatten()

    spec =
      Enum.map(types, fn t ->
        {:@, [], [{:spec, [], [{:"::", [], [{fun_name, env, t}, parse_type(type)]}]}]}
      end)

    case {fns, block} do
      {:def, nil} ->
        quote do
          unquote(spec)

          def unquote(fun_name)(unquote_splicing(args))
        end

      {:def, block} ->
        quote do
          unquote(spec)

          def unquote(fun_name)(unquote_splicing(args)) do
            unquote(block)
          end
        end

      _ ->
        quote do
          unquote(spec)

          defp unquote(fun_name)(unquote_splicing(args)) do
            unquote(block)
          end
        end
    end
  end

  def remove_nils(_old_items, _num, _new_items \\ [])
  def remove_nils(items, 0, new_items), do: new_items ++ Enum.map(items, fn {i, _} -> i end)

  def remove_nils([{_item, :__NIL__} | items], num, new_items),
    do: remove_nils(items, num - 1, new_items)

  def remove_nils([{item, _} | items], num, new_items),
    do: remove_nils(items, num, [item | new_items])

  def parse_type(:Atom), do: :atom
  def parse_type(:Float), do: :float
  def parse_type(:Function), do: :function
  def parse_type(:Number), do: :number
  def parse_type(:Integer), do: :integer
  def parse_type(:List), do: :list
  def parse_type(:Map), do: :map
  def parse_type(:Process), do: :process
  def parse_type(:Port), do: :port
  def parse_type(:Tuple), do: :tuple
  def parse_type(:Date), do: :date
  def parse_type(:DateTime), do: :datetime
  def parse_type(:Exception), do: :exeption
  def parse_type(:MapSet), do: :mapset
  def parse_type(:NaiveDateTime), do: :naive_datetime
  def parse_type(:Keyword), do: :keyword
  def parse_type(:Range), do: :range
  def parse_type(:Regex), do: :regex
  def parse_type(:String), do: {{:., [], [{:__aliases__, [], [:String]}, :t]}, [], []}
  def parse_type(:Time), do: :time
  def parse_type(:URI), do: :uri
  def parse_type(:Version), do: :version
  def parse_type({:__aliases__, _, [:Atom]}), do: {:atom, [], []}
  def parse_type({:__aliases__, _, [:Float]}), do: {:float, [], []}
  def parse_type({:__aliases__, _, [:Function]}), do: {:function, [], []}
  def parse_type({:__aliases__, _, [:Integer]}), do: {:integer, [], []}
  def parse_type({:__aliases__, _, [:Number]}), do: {:number, [], []}
  def parse_type({:__aliases__, _, [:List]}), do: {:list, [], []}
  def parse_type({:__aliases__, _, [:Map]}), do: {:map, [], []}
  def parse_type({:__aliases__, _, [:Process]}), do: {:process, [], []}
  def parse_type({:__aliases__, _, [:Port]}), do: {:port, [], []}
  def parse_type({:__aliases__, _, [:Tuple]}), do: {:tuple, [], []}
  def parse_type({:__aliases__, _, [:Date]}), do: {:date, [], []}
  def parse_type({:__aliases__, _, [:DateTime]}), do: {:datetime, [], []}
  def parse_type({:__aliases__, _, [:Exception]}), do: {:exeption, [], []}
  def parse_type({:__aliases__, _, [:MapSet]}), do: {:mapset, [], []}
  def parse_type({:__aliases__, _, [:NaiveDateTime]}), do: {:naive_datetime, [], []}
  def parse_type({:__aliases__, _, [:Keyword]}), do: {:keyword, [], []}
  def parse_type({:__aliases__, _, [:Range]}), do: {:range, [], []}
  def parse_type({:__aliases__, _, [:Regex]}), do: {:regex, [], []}
  def parse_type({:__aliases__, _, [:Time]}), do: {:time, [], []}
  def parse_type({:__aliases__, _, [:URI]}), do: {:uri, [], []}
  def parse_type({:__aliases__, _, [:Version]}), do: {:version, [], []}

  def parse_type({:__aliases__, _, [:String]}),
    do: {{:., [], [{:__aliases__, [], [:String]}, :t]}, [], []}

  def parse_type({{:., _, _}, _, _} = type), do: type
  def parse_type(custom_type), do: custom_type

  def reload(bool \\ false) do
    IEx.Helpers.recompile(force: bool)
  end
end
