class Odata::V4::BooksController < ApplicationController
  skip_before_action :verify_authenticity_token # TODO: Implement Authentication?
  def index
    Rails.logger.info("\n**{\n❗ Salesforce Odata Filter: #{params["$filter"].inspect}\n")
    Rails.logger.info("\n❗ Full request params: #{params.to_unsafe_h.inspect}\n**}\n")
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
  Rails.logger.info("\n🚨 Applying Odata Filters: #{filter_param.inspect}\n")
  return scope if filter_param.blank?
  case filter_param
  when /contains\(short_description,'([^']+)'\) eq true or contains\(author/i
    Rails.logger.info("\n🌍 Global Search triggered: #{filter_param.inspect}\n")
    search_term = Regexp.last_match(1)

    scope.where("short_description LIKE ?", "%#{search_term}%")
         .or(scope.where("author LIKE ?", "%#{search_term}%"))
         .or(scope.where("genre LIKE ?", "%#{search_term}%"))
         .or(scope.where("title LIKE ?", "%#{search_term}%"))
         .or(scope.where("status LIKE ?", "%#{search_term}%"))
  when /ExternalId eq (\d+)/
    Rails.logger.info("\n🪪 Filtered by ExternalId: #{filter_param.inspect}\n")
    scope.where(id: Regexp.last_match(1))
  when /id eq (\d+)/i
    Rails.logger.info("\n🪪 Filtered by id: #{filter_param.inspect}\n")
    scope.where(id: Regexp.last_match(1))
  when /contains\(author,\s*'([^']+)'\)/i
    Rails.logger.info("\n🖋 Filtered by author: #{filter_param.inspect}\n")

    search_term = Regexp.last_match(1)
    scope.author_contains(search_term)
  when /contains\(title,\s*'([^']+)'\)/i
    Rails.logger.info("\n📘 Filtered by title: #{filter_param.inspect}\n")
    search_term = Regexp.last_match(1)
    scope.title_contains(search_term)
  # when /title eq ([^']+)/i
  #   search_term = Regexp.last_match(1)
  #   scope.title_contains(search_term)
  when /genre eq '([^']+)'/i
    Rails.logger.info("\nFiltered by genre: #{filter_param.inspect}\n")
    scope.where(genre: Regexp.last_match(1))
  else
    Rails.logger.warn("⚠️ UNRECOGNIZED ODATA FILTER: #{filter_param.inspect}. Defaulting to returning all books.")
    scope
  end
end
