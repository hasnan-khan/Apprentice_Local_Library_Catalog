class Odata::V4::BooksController < ApplicationController
  skip_before_action :verify_authenticity_token # TODO: Implement Authentication?
  def index
    Rails.logger.info("**\nSalesforce Odata Filter: #{params["$filter"].inspect}")
    Rails.logger.info(" Full request params: #{params.to_unsafe_h.inspect}")
    @books = apply_odata_filters(Book.all, params["$filter"])
    render json: {
      "@odata.context": "#{request.base_url}/odata/v4/$metadata#Books",
      "value": @books
    }
  end

  def show
    @book = Book.find_by(id: params[:id])

    if @book
      render json: @book.as_json.merge({
         "@odata_context" => "#{odata_context_url}/entity"
                                       })
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    @book = Book.find_by(id: params[:id])
    if @book&.update(book_params)
      render json: @book
    else
      render json: { error: @book ? @book.errors : "Book not found" }, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find_by(id: params[:id])
    if @book
      @book.destroy
      head :no_content
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :short_description, :status)
  end

  def odata_context_url
    "#{request.base_url}/odata/v4/$metadata#Books"
  end
end

def apply_odata_filters(scope, filter_param)
  Rails.logger.info("\n🚨 ODATA FILTER RECEIVED: #{filter_param.inspect}\n")
  return scope if filter_param.blank?
  case filter_param
  when /ExternalId eq (\d+)/
    scope.where(id: Regexp.last_match(1))
  when /id eq (\d+)/i
  scope.where(id: Regexp.last_match(1))
  when /author eq ([^']+)/i
      search_term = Regexp.last_match(1)
      scope.author_contains(search_term)
  when /contains\(title,\s*'([^']+)'\)/i
    search_term = Regexp.last_match(1)
    scope.title_contains(search_term)
  when /title eq ([^']+)/i
    search_term = Regexp.last_match(1)
    scope.title_contains(search_term)
  when /genre eq '([^']+)'/i
    scope.where(genre: Regexp.last_match(1))
  else
    Rails.logger.warn("⚠️ UNRECOGNIZED ODATA FILTER: #{filter_param.inspect}. Defaulting to returning all books.")
    scope
  end
end
