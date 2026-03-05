window.toggleBook = function(book) {
    // Close any other open books
    document.querySelectorAll(".book.open").forEach(function(openBook) {
        if (openBook !== book) {
        openBook.classList.remove("open");
        }
    });

  // Open the clicked book
  book.classList.toggle("open");
}

document.addEventListener("click", function(e) {
  if (!e.target.closest(".book")) {
    document.querySelectorAll(".book.open").forEach(function(book) {
      book.classList.remove("open");
    });
  }
});