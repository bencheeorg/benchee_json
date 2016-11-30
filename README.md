# BencheeJSON

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
