defmodule Slack do
  @url "hooks.slack.com"

  def post do
    {:ok, conn} = Mint.HTTP.connect(:https, @url, 443)

    {:ok, _conn, _request_ref} =
      Mint.HTTP.request(
        conn,
        "POST",
        Application.fetch_env!(:hot_button, :slack_webhook),
        [],
        "{\"channel\": \"#_hot_button\", \"username\": \"Hot Button\", \"text\": \"Someone pressed the hot button and it was successfully debounced by our awesome script.\", \"icon_emoji\": \":ghost:\"}"
      )
  end
end
