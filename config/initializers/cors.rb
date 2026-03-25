Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # TODO: replace origins with Lee's SalesForce URL
    # FIXME: This is a security risk
    origins "https://lee-salesforce-app.com", "localhost:3000"
    # TODO: replace '*' with Lee's SalesForce URL
    resource "*",
       headers: :any,
       methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
      Rails.logger.info "CORS Initialized"
    end
  end
