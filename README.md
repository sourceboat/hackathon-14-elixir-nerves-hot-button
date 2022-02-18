# HotButton

During our hackathon we gave Elixir Nerves a try. We created a (Nerves Livebook)[https://github.com/livebook-dev/nerves_livebook] to handle switch events by posting a message to a slack channel (see [notebook.livemd](notebook.livemd)).

After we had a working Livebook solution we created our own Nerves firmware image and implemented a GenServer.

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * set the following environment variables like `MIX_TARGET` by exporting it via `export MIX_TARGET=my_target` or prefix every command with `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`:
    * `MIX_TARGET`
    * `WLAN_SSID`
    * `WLAN_PASSWORD`
    * `SLACK_WEBHOOK_URL`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Docker (Wip)

We created a basic Docker setup so that not everyone has to install (the dependencies)[https://hexdocs.pm/nerves/installation.html#macos] on the host system (see [Dockerfile](Dockerfile)). The setup was not tested sufficiently and is still work progress. It especially will not work on Apple Silicone because of a missing fwup build.
