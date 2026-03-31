class BooksController < ApplicationController
  # CREATE logic ================================
  # new Creates new Book instance. Should open new book form
  def new
    @book = Book.new
  end

  # create Saves the new Book instance, makes Create call to model db
  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "#{@book.title} successfully added!"
    else
      flash.now.alert = "Book not saved!"
      render :new, status: :unprocessable_entity
    end
  end

  # READ logic ==================================
  # index Displays list of all books. Sends READ call to model db
  def index
    # instance variable is used by View to iterate over list of books.
    @books = Book.all

    @genres = Book.distinct.pluck(:genre).compact

    # apply search filter (title or author)
    if params[:search].present? && params[:search] != ""
      search_term = "%#{params[:search]}%"
      @books = @books.where("title LIKE ? COLLATE NOCASE OR author LIKE ? COLLATE NOCASE", search_term, search_term)
    end

    # apply genre filter
    if params[:genre].present? && params[:genre] != ""
      @books = @books.where(genre: params[:genre])
    end

    respond_to do |format|
      # renders index.html.erb with filtered @books
      format.html
      format.json { render json: @books }
    end
  end
  # show Displays the detail page for a single Book instance. Sends READ call to model db
  def show
    # Get specific book by ID
    @book = Book.find_by(id: params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  # update Saves changes to current Book instance. Send Update call to model db
  def update
    # writes the form content to @book instance
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to @book, notice: "#{@book.title} successfully updated!" # confirmation notice
    else
      flash.now.alert = "Book not updated!"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:id])
    dt = @book.title # deleted title for explicit confirmation
    @book.destroy
    redirect_to books_path, notice: "#{dt} successfully removed!"
  end

  private
  def book_params
    params.require(:book).permit(:title, :author, :genre, :short_description, :status)
  end
end
