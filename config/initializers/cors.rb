# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:4173", "localhost:5173", "junyuhuang.github.io"

    resource "*",
      headers: :any,
      credentials: true,
      methods: [:get, :post, :patch, :delete]
  end
end
