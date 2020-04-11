defmodule PersonalBlogUmbrella.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp deps do
    [
      {:distillery, "~> 2.1", warn_missing: false},
      {:edeliver, ">= 1.6.0"}
    ]
  end

  def application do
    [
      mod: {PersonalBlogUmbrella.Application, []},
      extra_applications: [:edeliver]
    ]
  end


end
