# Load config/config.yml, store to CONFIG
path = Rails.root.join("config","config.yml")
CONFIG = YAML.load(File.read(path))[Rails.env]
