class Odata::V4::MetadataController < ApplicationController
  def show
    render json: {
      "definitions": {
        "Book": {
          "type": "object",
          "properties": {
            "id": { "type": "integer" },
            "title": { "type": "string" },
            "author": { "type": "string" },
            "genre": { "type": "string" },
            "short_description": { "type": "string" }
          }
        }
      }
    }
  end
end
