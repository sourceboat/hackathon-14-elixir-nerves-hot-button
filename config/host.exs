import Config

# Add configuration that is only needed when running on the host here.

config :hot_button,
  slack_webhook: System.get_env("SLACK_WEBHOOK_URL")
