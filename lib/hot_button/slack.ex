defmodule Slack do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://hooks.slack.com")

  def post() do
    post(
      Application.fetch_env!(:hot_button, :slack_webhook),
      "{\"channel\": \"#_hot_button\", \"username\": \"Hot Button\", \"text\": \"Someone pressed the hot button and it was successfully debounced by our awesome script.\", \"icon_emoji\": \":ghost:\"}"
    )
  end
end
