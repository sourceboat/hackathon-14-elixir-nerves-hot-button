defmodule HotButton do
  use GenServer

  alias Circuits

  @threshold 500 * 10 ** 4

  @impl true
  def init({timestamp}) do
    {:ok, button_input} = Circuits.GPIO.open(21, :input)

    # We will configure the button interrupts for both rising and falling.
    Circuits.GPIO.set_interrupts(button_input, :both, suppress_glitches: true)
    Circuits.GPIO.set_pull_mode(button_input, :pulldown)

    {:ok, timestamp}
  end

  @impl true
  def handle_info({:circuits_gpio, _p, now, switch_state}, last) do
    switch_state
    |> to_action()
    |> receive_msg(last, now)
  end

  def to_action(1), do: :on
  def to_action(0), do: :off

  def receive_msg(action, last, now) when now >= last + @threshold do
    IO.puts("#{now} #{action}")

    :ok = LED.switch(action)

    maybe_notify(action)
    {:noreply, now}
  end

  def receive_msg(_action, last, _now), do: {:noreply, last}

  def maybe_notify(:on), do: Slack.post()
  def maybe_notify(:off), do: nil
end
