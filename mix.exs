defmodule GlobalLazy.MixProject do
  use Mix.Project

  @version "1.0.1"
  @url_docs "http://hexdocs.pm/global_lazy"
  @url_github "https://github.com/whitfin/global-lazy"

  def project do
    [
      app: :global_lazy,
      name: "GlobalLazy",
      description: "Lazy global initialization for Elixir, without state",
      package: %{
        files: [
          "lib",
          "mix.exs",
          "LICENSE"
        ],
        licenses: [ "MIT" ],
        links: %{
          "Docs" => @url_docs,
          "GitHub" => @url_github
        },
        maintainers: [ "Isaac Whitfield" ]
      },
      version: @version,
      elixir: "~> 1.2",
      deps: deps(),
      docs: [
        main: "GlobalLazy",
        source_ref: "v#{@version}",
        source_url: @url_github,
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Production dependencies for release builds
      { :global_flags, "~> 1.0" },
      # Local only dependencies for testing/documentation
      { :ex_doc, "~> 0.16", optional: true, only: [ :docs ] }
    ]
  end
end
