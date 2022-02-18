defmodule HotButton do
  use GenServer

  alias Circuits

  require Logger

  @threshold 500 * 10 ** 4

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init({last_switch}) do
    Logger.info("HotButton init")

    {:ok, pin} = Circuits.GPIO.open(21, :input)

    # We will configure the button interrupts for both rising and falling.
    Circuits.GPIO.set_interrupts(pin, :both, suppress_glitches: true)
    Circuits.GPIO.set_pull_mode(pin, :pulldown)

    {:ok, %{pin: pin, last_switch: last_switch}}
  end

  @impl true
  def handle_info({:circuits_gpio, _p, now, switch_state}, %{last_switch: last_switch} = state) do
    Logger.info("HotButton handle_info :circuits_gpio")

    last_switch =
      switch_state
      |> to_action()
      |> receive_msg(last_switch, now)

    {:noreply, %{state | last_switch: last_switch}}
  end

  def to_action(1), do: :on
  def to_action(0), do: :off

  def receive_msg(action, last, now) when now >= last + @threshold do
    Logger.info("#{now} #{action}")

    :ok = LED.switch(action)

    maybe_notify(action)
    now
  end

  def receive_msg(_action, last, _now), do: last

  def maybe_notify(:on), do: Slack.post()
  def maybe_notify(:off), do: nil
end
