defmodule Typed.MixProject do
  use Mix.Project

  def project do
    [
      name: "Typed",
      app: :typed,
      version: "0.2.0",
      elixir: "~> 1.14",
      compilers: Mix.compilers() ++ [:typed],
      start_permanent: Mix.env() == :prod,
      dialyzer: [ignore_warnings: ".dialyzer_ignore.exs"],
      # dialyzer: [flags: ["-Wunmatched_returns", :error_handling, :underspecs]],
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/andridus/typed"
    ]
  end

  defp description() do
    "Let do easy to @spec your public or private function"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "typed",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/andridus/typed"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:dialyxir, "~> 1.3", runtime: false}
    ]
  end
end
