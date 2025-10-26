import Config

config :dgii_gw,
  port: String.to_integer(System.get_env("PORT", "3022")),
  log_dir: System.get_env("LOG_DIR", "/home/wilton/odoo-requests") # per your spec
