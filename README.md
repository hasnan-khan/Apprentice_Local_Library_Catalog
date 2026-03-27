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

### Salesforce Staff Interface

- **Connection:** Salesforce Connect via External Data Source.

- **Staff Features:**

  - **Lightning Web Components** (LWC) for viewing live Rails data.

  - **Screen Flows** for logging Patron Recommendations.

## API Reference (OData V4)

### Example JSON Response (GET /odata/v4/books)

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

1. Install Dependencies: ` bundle install `

2. Setup Database: `bin/rails db:prepare (Loads 18 core library seeds)`

3. Start Server: ` bin/rails server `

4. Environment: Ensure `rack-cors` is configured in `config/initializers/cors.rb` for external connectivity.

## Project Team
- Amna (Rails): Search & Filter Logic.
- Hasnan (Rails): Availability Status & Lifecycle Tracking.
- Jeremy (Rails): OData API Architecture & Integration Bridge.
- Lee (Salesforce): External Data Integration & Staff UI.

## Project Structure
```text
├── app
│   ├── controllers
│   │   ├── books_controller.rb             # Web UI Logic
│   │   └── odata
│   │       └── v4
│   │           ├── books_controller.rb     # API CRUD Logic
│   │           ├── metadata_controller.rb  # API Discovery
│   │           └── service_controller.rb   # API Discovery
│   ├── models
    │   │   └── book.rb                     # Validations & Logic
├── config
│   ├── initializers
│   │   └── cors.rb                         # API Security
│   └── routes.rb                           # Application routing
└── db
    ├── schema.rb                           # Database source of truth
└── seeds.rb                                # 18 Initial book records
```