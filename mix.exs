defmodule {{BOT_APP_NAME_CAMEL}}.MixProject do
  use Mix.Project

  def project do
    [
      app: :{{BOT_APP_NAME}},
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        {{BOT_RELEASE_NAME}}: [
          applications: [{{BOT_APP_NAME}}: :permanent]
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {{{BOT_APP_NAME_CAMEL}}.Application, []}
    ]
  end

  defp deps do
    [
      {:bot_army_library_core, "~> 0.1"},
      {:bot_army_library_runtime, "~> 0.14"},
      {:jason, "~> 1.4"},
      {:logger_json, "~> 5.1"},

      # Development/Test
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
