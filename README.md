# Library Catalog System (v2.0)

A hybrid software system featuring a public-facing Ruby on Rails portal for the community and a Salesforce Lightning interface for library staff. This project demonstrates cross-stack integration using the OData protocol to share a single source of truth.

## Technical Architecture

### Rails Public Portal

- **Framework:** Ruby on Rails 8.1

- **Primary Interface:** A RESTful web application for browsing, searching, and managing the book collection.

- **Core Features:**

  - Keyword search (Title/Author) and Genre filtering.

  - Real-time availability tracking (Available, Checked Out, Reserved).

### Integration Bridge (OData API)

The application serves as an OData V4 producer, allowing external systems to interact with the library database.

- Service Root: `https://[YOUR-APP-URL]/odata/v4/`

- Metadata: `https://[YOUR-APP-URL]/odata/v4/$metadata`

- Books Endpoint: `https://[YOUR-APP-URL]/odata/v4/Books`

Replace `[YOUR-APP-URL]` with `http://localhost:3000` OR `https://apprentice-local-library-catalog.onrender.org.com` for either local or live

### Salesforce Staff Interface

- **Connection:** Salesforce Connect via External Data Source.

- **Staff Features:**

  - **Lightning Web Components** (LWC) for viewing live Rails data.

  - **Screen Flows** for logging Patron Recommendations.

## API Reference (OData V4)

### Notes for SalesForce Connect
#### Connectivity
Library Catalog URL: `https://apprentice-local-library-catalog.onrender.com/odata/v4/`
_The trailing "/" is necessary._
#### Authentication
Authentication is bypassed. Identity type can be `Anonymous` and Authentication protocol `No Authentication`.
#### Conventions
- Using capitalized `Books` in URL to match controller casing and avoid SalesForce/Ruby collisions
  - Fields/parameters: [`title`, `author`,`genre`,`status`,`short_description`]
  - `External ID` should be in the layout, mapped to the `id`
  - Book actions: [`index`; shows full list of catalogued Books, `create`; `POST` to create new Book, `update`; writes a `PATCH`to update specific field of a Book, `destroy`; `DELETE` book]

### Example JSON Response 
_URL:(https://apprentice-local-library-catalog.onrender.com/odata/v4/Books/1)_

```json
[
    {
        "id": 1,
        "title": "To Kill a Mockingbird",
        "author": "Harper Lee",
        "genre": "Fiction",
        "short_description": "A story about racial injustice and moral growth in the American South.",
        "status": "Available",
        "created_at": "2026-03-03T21:15:59.000Z"
    }
]
```

## Security and Connectivity

- **CORS:** Configured via `rack-cors` to permit cross-origin requests from Salesforce.

- **Handshake:** Supports `$metadata` discovery for automatic Salesforce External Object mapping.

## Development Setup

### API Development
#### Verify Dependencies
- Install Dependencies:
```bash
bundle install
```
- In `config/routes.rb`:
```ruby
# CORS needed for Salesforce Connect
gem "rack-cors"
```
- Install any missing dependencies:
```bash
bundle install
```
- Environment: Ensure `rack-cors` is present and configured in `config/initializers/cors.rb` for external connectivity.

- Verify curl install:

```bash
curl --version
```
_If not installed_
```bash
brew install curl
```


#### Setup Database:  (Loads 18 core library seeds)
```bash
bin/rails db:prepare
```
3. Migrate database changes
```bash
bin/rails db:migrate
```
3. Start Server:
```bash
bin/rails server
```

## Testing

### Browser:
_It is important to note that the paths contain "Books" with a capital "B"_ and that once deployed, replacing localhost with the live URL will yield similar results.
- visit:
`http://apprentice-local-library-catalog.onrender.com` and interact with UI
  - Add book
  - Edit Book
  - Delete Book
  - Search by Author, Title or Genre
### Terminal (via curl):
#### Books Controller
_Verify CRUD operations for Book objects. This can also be done via localhost:3000 (https not enforced)_
- Create a book:
```bash
curl -X POST 'https://apprentice-local-library-catalog.onrender.com/odata/v4/Books' \
-H "Content-Type: application/json" \
-d '{"book": {"title": "OData API Mastery", "author": "Jeremy", "genre": "Technology", "short_description": "Testing the new status field.", "status": "Available"}}'
```
_Expect Output: JSON with book info including an "id:"_
- Update the book:
```bash
curl -X PATCH 'https://apprentice-local-library-catalog.onrender.com/odata/v4/Books/[YOUR_NEW_ID]' \
-H "Content-Type: application/json" \
-d '{"book": {"status": "Checked Out"}}'
```
_Expect Output: JSON with book info now showing status: "Checked Out". If needed, run the read curl again to verify._
- Delete the book:
```bash
curl -i -X DELETE 'https://apprentice-local-library-catalog.onrender.com/odata/v4/Books/[YOUR_NEW_ID]'
```
_Expect Output with HTTP 2xx and No Content_
```text
HTTP/1.1 204 No Content
```
- Verify the deletion (and confirm error render for no book matching id)
```bash
curl 'https://apprentice-local-library-catalog.onrender.com/odata/v4/Books/[YOUR_NEW_ID]'
```
_Expect Output:_
`{"error":"Book not found"}`

#### Filters (mimic Salesforce URL calls)
- Filter by id
```bash
 curl -g "https://apprentice-local-library-catalog.onrender.com/odata/v4/Books?\$filter=id%20eq%201"
 ```
_Expect JSON object with one book. This example should return "To Kill A Mockingbird" on base seed database._
- Filter by author
```bash
curl -g "https://apprentice-local-library-catalog.onrender.com/odata/v4/Books?\$filter=contains(author,'ing')"
```
_Expect JSON object with books by Stephen King and J.K. Rowling (multiple). Can test single entries with specific author or nil with an Author not in Library._
- Filter by title
```bash
curl -g "https://apprentice-local-library-catalog.onrender.com/odata/v4/Books?\$filter=contains(title,'the')"
```
_Expect JSON object with multiple book entries. Similarly, can be tested with "Gatsby" for one book or "Lord of the Flies" for a nil return._
- Filter by genre
```bash
curl -g "https://apprentice-local-library-catalog.onrender.com/odata/v4/Books?\$filter=genre%20eq%20'Romance'"
```
_Assuming finite list of genres. Returns all books which match criteria._
## Project Team
- Amna (Rails): Search & Filter Logic, Data models, & Web-based UI.
- Hasnan (Rails): Availability Status, Web-based UI & Lifecycle Tracking.
- Jeremy (Rails): OData API Architecture & Integration Bridge.
- Lee (Salesforce): External Data Integration & Staff Portal.

## Project Structure
```text
.
├── CHANGELOG.md
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app
│   ├── assets
│   │   ├── images
│   │   └── stylesheets
│   │       ├── application.css
│   │       └── books.css
│   ├── controllers
│   │   ├── application_controller.rb
│   │   ├── books_controller.rb
│   │   ├── concerns
│   │   └── odata
│   │       └── v4
│   │           ├── books_controller.rb
│   │           ├── metadata_controller.rb
│   │           ├── recommendations_controller.rb
│   │           └── service_controller.rb
│   ├── helpers
│   │   ├── application_helper.rb
│   │   └── books_helper.rb
│   ├── javascript
│   │   ├── application.js
│   │   ├── books.js
│   │   └── controllers
│   │       ├── application.js
│   │       ├── hello_controller.js
│   │       └── index.js
│   ├── jobs
│   │   └── application_job.rb
│   ├── mailers
│   │   └── application_mailer.rb
│   ├── models
│   │   ├── application_record.rb
│   │   ├── book.rb
│   │   ├── concerns
│   │   ├── recommendation.rb
│   │   └── request_note.rb
│   └── views
│       ├── books
│       │   ├── _form.html.erb
│       │   ├── edit.html.erb
│       │   ├── index.html.erb
│       │   ├── new.html.erb
│       │   └── show.html.erb
│       ├── layouts
│       │   ├── application.html.erb
│       │   ├── mailer.html.erb
│       │   └── mailer.text.erb
│       └── pwa
│           ├── manifest.json.erb
│           └── service-worker.js
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── bundler-audit.yml
│   ├── cable.yml
│   ├── cache.yml
│   ├── ci.rb
│   ├── credentials.yml.enc
│   ├── database.yml
│   ├── deploy.yml
│   ├── environment.rb
│   ├── environments
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── importmap.rb
│   ├── initializers
│   │   ├── assets.rb
│   │   ├── content_security_policy.rb
│   │   ├── cors.rb
│   │   ├── filter_parameter_logging.rb
│   │   └── inflections.rb
│   ├── locales
│   │   └── en.yml
│   ├── master.key
│   ├── puma.rb
│   ├── queue.yml
│   ├── recurring.yml
│   ├── routes.rb
│   └── storage.yml
├── config.ru
├── db
│   ├── cable_schema.rb
│   ├── cache_schema.rb
│   ├── migrate
│   │   ├── 20250327200500_add_status_to_books.rb
│   │   ├── 20260303211559_create_books.rb
│   │   ├── 20260330195343_create_recommendations.rb
│   │   ├── 20260330195405_create_request_notes.rb
│   │   └── 20260331173857_change_request_count_default.rb
│   ├── queue_schema.rb
│   ├── schema.rb
│   └── seeds.rb
├── lib
│   └── tasks
├── render.yaml
└── tree.txt

28 directories, 76 files
```
