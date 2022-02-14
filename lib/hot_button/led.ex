defmodule LED do
  @led Path.join("/sys/class/leds", "led0")

  def switch(:on) do
    File.write(Path.join(@led, "brightness"), "1")
  end

  def switch(:off) do
    File.write(Path.join(@led, "brightness"), "0")
  end
end
