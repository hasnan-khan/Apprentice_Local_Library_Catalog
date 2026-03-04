# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Book.destroy_all

Book.create!([
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    genre: "Fiction",
    short_description: "A story about racial injustice and moral growth in the American South."
  },
  {
    title: "1984",
    author: "George Orwell",
    genre: "Dystopian",
    short_description: "A chilling novel about surveillance and totalitarian control."
  },
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    genre: "Classic",
    short_description: "A tragic tale of wealth, love, and the American Dream."
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    genre: "Romance",
    short_description: "A witty story of love, misunderstandings, and social class."
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    genre: "Fantasy",
    short_description: "A hobbit embarks on an epic journey to reclaim a lost treasure."
  },
  {
    title: "The Catcher in the Rye",
    author: "J.D. Salinger",
    genre: "Coming-of-Age",
    short_description: "A teenager struggles with identity and belonging in New York City."
  },
  {
    title: "The Alchemist",
    author: "Paulo Coelho",
    genre: "Adventure",
    short_description: "A shepherd follows his dreams in search of treasure and destiny."
  },
  {
    title: "The Hunger Games",
    author: "Suzanne Collins",
    genre: "Sci-Fi",
    short_description: "A young girl fights for survival in a deadly televised competition."
  },
  {
    title: "The Book Thief",
    author: "Markus Zusak",
    genre: "Historical Fiction",
    short_description: "A girl in Nazi Germany finds comfort in stealing and sharing books."
  },
  {
    title: "The Chronicles of Narnia",
    author: "C.S. Lewis",
    genre: "Fantasy",
    short_description: "Children discover a magical world filled with adventure and danger."
  },
  {
    title: "Moby-Dick",
    author: "Herman Melville",
    genre: "Classic",
    short_description: "A sea captain obsessively hunts a legendary white whale."
  },
  {
    title: "The Fault in Our Stars",
    author: "John Green",
    genre: "Romance",
    short_description: "Two teenagers with cancer fall in love and explore life's meaning."
  },
  {
    title: "Brave New World",
    author: "Aldous Huxley",
    genre: "Dystopian",
    short_description: "A futuristic society sacrifices individuality for stability."
  },
  {
    title: "The Da Vinci Code",
    author: "Dan Brown",
    genre: "Mystery",
    short_description: "A symbologist uncovers secrets hidden in famous works of art."
  },
  {
    title: "The Shining",
    author: "Stephen King",
    genre: "Horror",
    short_description: "A family isolated in a hotel faces terrifying supernatural forces."
  },
  {
    title: "Harry Potter and the Sorcerer's Stone",
    author: "J.K. Rowling",
    genre: "Fantasy",
    short_description: "A young boy discovers he is a wizard and begins his magical education."
  },
  {
    title: "The Kite Runner",
    author: "Khaled Hosseini",
    genre: "Drama",
    short_description: "A powerful story of friendship, betrayal, and redemption."
  },
  {
    title: "Life of Pi",
    author: "Yann Martel",
    genre: "Adventure",
    short_description: "A boy survives a shipwreck and shares a lifeboat with a tiger."
  }
])
