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
      render :new, status: :unprocessable_entity
    end
  end

  # READ logic ==================================
  # index Displays list of all books. Sends READ call to model db
  def index
    # instance variable is used by View to iterate over list of books.
    @books = Book.all
  end
  # show Displays the detail page for a single Book instance. Sends READ call to model db
  def show
    # Get specific book by ID
    @book = Book.find(params[:id])
  end

  # UPDATE logic ================================
  # edit Opens single Book instance for edit. Should call the edit form in View
  def edit
    # uses @book instanced variable as object to display attributes on edit form
    @book = Book.find(params[:id])
  end

  # update Saves changes to current Book instance. Send Update call to model db
  def update
    # writes the form content to @book instance
    # makes UPDATE call to model with sanitized params
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to @book, notice: "#{@book.title} successfully updated!" # confirmation notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DESTROY logic ===============================
  # destroy Removes book from library catalog. send Delete call to model db
  def destroy
    @book = Book.find(params[:id])
    dt = @book.title # deleted title for explicit confirmation
    @book.destroy
    redirect_to books_path, notice: "#{dt} successfully removed!"
  end

  private

  # Allows only our agreed book attributes to be sent to model db
  def book_params
    params.require(:book).permit(:title, :author, :genre, :short_description)
    # TODO: Any additional sanitization necessary before making the db call?
  end
end
