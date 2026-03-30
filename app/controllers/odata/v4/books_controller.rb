class Odata::V4::BooksController < ApplicationController
  skip_before_action :verify_authenticity_token # TODO: Implement Authentication?

  def index
    @books = Book.all
    render json: {
      "@odata.context" => odata_context_url,
      "value" => Book.all
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
