Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # TODO: Replace this with Lee's specific SalesForce Domain.

    resource "/odata/*",
             headers: :any,
             methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
