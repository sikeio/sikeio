Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'a3a14c6389c422a7f463','184ba0a85c8d00e9a126809e2f4379a54e373e7e'
end