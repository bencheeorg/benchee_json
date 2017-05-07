# 0.3.0 - 2017-05-07

Benchee 0.8.0 compatibility, basic typespecs and droppinx elixir 1.2 support.

# 0.2.0 - 2017-04-23

## Features

* General `encode!` method that can encode a benchee structure to JSON - just delegates to Poison atm but decouples other plugins from it.

## Bugfixes

* Relaxed `poison` dependency to be just `>= 1.4.0`
