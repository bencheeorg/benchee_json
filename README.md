# BencheeJSON [![Hex Version](https://img.shields.io/hexpm/v/benchee_json.svg)](https://hex.pm/packages/benchee_json) [![Build Status](https://travis-ci.org/PragTob/benchee_json.svg?branch=master)](https://travis-ci.org/PragTob/benchee_json)

Formates a benchee benchmarking suite to a JSON representation and can also write it to disk. Actively used in [benchee_html](https://github.com/PragTob/benchee_html) to generate JSON, and embed it into the JavaScript to give the JS access to the benchmaring results for grpahing purposes.

## Installation

Add `benchee_json` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:benchee_json, "~> 0.1", only: :dev}]
end
```
## Usage

Like a normal benchee formatter:

```elixir
list = Enum.to_list(1..10_000)
map_fun = fn(i) -> [i, i * i] end

Benchee.run(%{
  "flat_map"    => fn -> Enum.flat_map(list, map_fun) end,
  "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten end
},
  formatters: [
    &Benchee.Formatters.JSON.output/1,
    &Benchee.Formatters.Console.output/1
  ],
  json: [file: "my.json"]
)
```

## Contributing

Contributions to benchee_json are very welcome! Bug reports, documentation, spelling corrections, whole features, feature ideas, bugfixes, new plugins, fancy graphics... all of those (and probably more) are much appreciated contributions!

Please respect the [Code of Conduct](//github.com/PragTob/benchee_json/blob/master/CODE_OF_CONDUCT.md).

You can get started with a look at the [open issues](https://github.com/PragTob/benchee_json/issues).

A couple of (hopefully) helpful points:

* Feel free to ask for help and guidance on an issue/PR ("How can I implement this?", "How could I test this?", ...)
* Feel free to open early/not yet complete pull requests to get some early feedback
* When in doubt if something is a good idea open an issue first to discuss it
* In case I don't respond feel free to bump the issue/PR or ping me on other places

## Development

* `mix deps.get` to install dependencies
* `mix test` to run tests
* `mix credo` or `mix credo --strict` to find code style problems (not too strict with the 80 width limit for sample output in the docs)
