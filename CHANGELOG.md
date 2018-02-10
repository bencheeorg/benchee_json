## 0.5.0 - 2018-??-??

### Features

* Switched out the JSON library from poison to jason, this avoids inconsistent behaviour between poison 2.x and 3.x + is probably faster
* Compatibility with the tags and names of benchee 0.12


## 0.4.0 - 2017-10-24

### Features

* benchee 0.10 compatibility
* You can now also specify the formatter as just `Benchee.Formatters.JSON`


## 0.3.1 - 2017-05-07

### Bugfixes

* Fixed broken typespec for `.format_measurements`, thanks to @sasa1977's [help](https://elixirforum.com/t/dialyzer-gets-nested-map-wrong-and-errors-out-number-vs-map/4976)

## 0.3.0 - 2017-05-07

Benchee 0.8.0 compatibility, basic typespecs and droppinx elixir 1.2 support.

## 0.2.0 - 2017-04-23

### Features

* General `encode!` method that can encode a benchee structure to JSON - just delegates to Poison atm but decouples other plugins from it.

### Bugfixes

* Relaxed `poison` dependency to be just `>= 1.4.0`
