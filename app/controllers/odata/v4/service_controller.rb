class Odata::V4::ServiceController < ApplicationController
  skip_before_action :verify_authenticity_token

  def root
    render json: {
      "@odata.context": "#{request.base_url}/odata/v4/$metadata",
      "value": [
        { "name": "books", "kind": "EntitySet", "url": "books" }
      ]
    }
  end
end