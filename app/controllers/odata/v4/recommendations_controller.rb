class Odata::V4::RecommendationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    if Book.exists?(title: params[:title], author: params[:author]) # Check Library first.
      return render json: { error: "This book is already in the catalogue" }, status: :conflict
    end

    @recommendation = Recommendation.find_or_initialize_by( # Check Recommendations first, then edit or create.
      title: params[:title],
      author: params[:author]
    )

    if @recommendation.save
      if params[:note_text].present? && params[:note_text].strip.present?
        @recommendation.request_notes.create(
          patron_name: params[:patron_name],
          note_text: params[:note_text]
        )
      else # Note is blank, do not create a new note. Just increment recommendation counter.
        @recommendation.increment!(:request_count)
      end
      render json: @recommendation.as_json(include: :request_notes), status: :ok
    else
      render json: @recommendation.errors, status: :unprocessable_entity
    end
  end
end
