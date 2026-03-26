class Odata::V4::BooksController < ApplicationController
  def index
    @books = Book.all
    render json: @books
  end

  def show_detailed_exceptions?
    @book = Book.find(params[:id])

    if @book
      render json: @book
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end
end
