# Compound

A minimalistic TCP Server written in Elixir.

## Introduction 

## Installation 

Compound can be added to your project 
by append `compound` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:compound, "~> 0.1.0"}
  ]
end
```

and then running `mix deps.get` to install it.

## Preparation

Before you can use Compound you have to take a few steps.

First you need to add one or more server configurations to your config:

```elixir
config :compound, tcp_servers: [
  %{id: "example", port: 3001},
  ...
]
```

A server configuration consists of an id (as a `string`) and a port (as an `integer`).

After starting your elixir app simply call `Compound.TCP.set_default_callback(server, callback)` with the id of the server from the configuration and a pid. 
Incoming packets for that server will be forwarded to your callback process as `{:new_packet, packet, sender}`.