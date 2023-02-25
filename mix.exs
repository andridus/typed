defmodule Typed.MixProject do
  use Mix.Project

  def project do
    [
      name: "Typed",
      app: :typed,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
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
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/andridus/typed"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev, runtime: false}]
  end
end
