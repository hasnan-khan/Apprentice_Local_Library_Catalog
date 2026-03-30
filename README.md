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

- Books Endpoint: `https://[YOUR-APP-URL]/odata/v4/books`

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
_URL:(https://apprentice-local-library-catalog.onrender.com/odata/v4/books/1)_

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

1. Verify DependenciesInstall Dependencies: ` bundle install `
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


2. Setup Database:  (Loads 18 core library seeds)
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

## How to test:

### Browser:
- visit:
`http://localhost:3000/odata/v4/$metadata`  | Expect XML with book params
- visit: 
`http://localhost:3000/odata/v4/books`  | Expect json with all books in library
- visit: `http://localhost:3000/odata/v4/books/5` | Any integer [1:18] returns a single book json
### curl
- Create a book:
```bash
curl -X POST 'http://localhost:3000/odata/v4/books' \
-H "Content-Type: application/json" \
-d '{"book": {"title": "OData API Mastery", "author": "Jeremy", "genre": "Technology", "short_description": "Testing the new status field.", "status": "Available"}}'
```
_Expect Output: JSON with book info including an "id:"_
- View that book:
```bash
curl 'http://localhost:3000/odata/v4/books/[YOUR_NEW_ID]'
```
_Expect Output: JSON with book info including an "id:"_
- Update the book:
```bash
curl -X PATCH 'http://localhost:3000/odata/v4/books/[YOUR_NEW_ID]' \
-H "Content-Type: application/json" \
-d '{"book": {"status": "Checked Out"}}'
```
_Expect Output: JSON with book info now showing status: "Checked Out". If needed, run the read curl again to verify._
- Delete the book:
```bash
curl -i -X DELETE 'http://localhost:3000/odata/v4/books/[YOUR_NEW_ID]'
```
_Expect Output (or similar):_
```text
HTTP/1.1 204 No Content
x-frame-options: SAMEORIGIN
x-xss-protection: 0
x-content-type-options: nosniff
x-permitted-cross-domain-policies: none
referrer-policy: strict-origin-when-cross-origin
cache-control: no-cache
x-request-id: ca52fd03-a96d-4573-9d27-81b1590ceddd
x-runtime: 0.004761
server-timing: start_processing.action_controller;dur=0.00, sql.active_record;dur=0.69, instantiation.active_record;dur=0.04, start_transaction.active_record;dur=0.00, transaction.active_record;dur=0.64, process_action.action_controller;dur=2.73
vary: Origin
```
- Verify the delete
```bash
curl 'http://localhost:3000/odata/v4/books/[YOUR_NEW_ID]'
```
_Expect Output:_
`{"error":"Book not found"}`
## Project Team
- Amna (Rails): Search & Filter Logic.
- Hasnan (Rails): Availability Status & Lifecycle Tracking.
- Jeremy (Rails): OData API Architecture & Integration Bridge.
- Lee (Salesforce): External Data Integration & Staff UI.

## Project Structure
```text
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
│   │   └── concerns
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
│           └── service-worker.js                            # 18 Initial book records
```