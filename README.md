# benchee_json [![Hex Version](https://img.shields.io/hexpm/v/benchee_json.svg)](https://hex.pm/packages/benchee_json) [![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/benchee_json/) [![CI](https://github.com/bencheeorg/benchee_json/actions/workflows/main.yml/badge.svg)](https://github.com/bencheeorg/benchee_json/actions/workflows/main.yml) [![Coverage Status](https://coveralls.io/repos/github/bencheeorg/benchee_json/badge.svg?branch=master)](https://coveralls.io/github/bencheeorg/benchee_json?branch=master) [![Total Download](https://img.shields.io/hexpm/dt/benchee_json.svg)](https://hex.pm/packages/benchee_json) [![License](https://img.shields.io/hexpm/l/benchee_json.svg)](https://github.com/bencheeorg/benchee_json/blob/master/LICENSE)

Formats a benchee benchmarking suite to a JSON representation and can also write it to disk. Actively used in [benchee_html](https://github.com/PragTob/benchee_html) to generate JSON, and embed it into the JavaScript to give the JS access to the benchmarking results for graphing purposes.

## Installation

Add `:benchee_json` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:benchee_json, "~> 1.0", only: :dev}
  ]
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
    {Benchee.Formatters.JSON, file: "my.json"},
    Benchee.Formatters.Console
  ]
)
```

## Contributing

Contributions to `:benchee_json` are very welcome! Bug reports, documentation, spelling corrections, whole features, feature ideas, bugfixes, new plugins, fancy graphics... all of those (and probably more) are much appreciated contributions!

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

## Copyright and License

Copyright (c) 2016 Tobias Pfeiffer

This library is released under the MIT License. See the [LICENSE.md](./LICENSE.md) file
for further details.
