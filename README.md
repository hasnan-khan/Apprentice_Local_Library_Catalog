# Apprentice Local Library Catalog

A professional, CRUD-compliant Ruby on Rails application developed as part of the **Nava PBC Apprentice Program**. This project serves as a centralized digital catalog for managing a local library's book inventory, featuring a fully integrated Model-View-Controller (MVC) architecture.

## Quick Start
To view the catalog immediately, the application is configured to boot directly to the library index.

1. **Install Dependencies**: `bundle install`
2. **Setup Database**: `bin/rails db:prepare` (Runs migrations and loads 18 core library seeds)
3. **Start Server**: `bin/rails server --open` (Automatically opens `localhost:3000`)

---

## Technical Architecture
This project was built using a collaborative team workflow, ensuring strict separation of concerns.

### The "Bridge" (Controller & Routing)
* **RESTful Routing**: Utilizes `resources :books` to map browser requests to backend logic.
* **Root Configuration**: The application entry point is mapped to `books#index` for immediate catalog access.
* **CRUD Logic**: The `BooksController` handles the lifecycle of book records, including strict parameter sanitization via **Strong Parameters** to prevent mass-assignment vulnerabilities.

### Data Integrity (Model & Schema)
* **Schema Evolution**: The database includes the `short_description` text field to support rich book summaries.
* **Validations**: Active Record validations ensure that every book entry contains a mandatory `title` and `author`.
* **Seed Data**: A curated set of 18 classic and contemporary titles is included for immediate demonstration.

### User Interface (Views)
* **Flash Notifications**: Integrated success notices (e.g., "Book successfully added!") are displayed via the global `application.html.erb` layout.
* **Shared Forms**: Optimized `_form.html.erb` partial used for both creation and editing to ensure UI consistency.



---

## 🛠️ Development & Quality Assurance
We maintain high standards for code quality and security.

* **Linting**: All code adheres to the project's RuboCop configuration for consistent Ruby styling.
* **Security**: Protected against SQL injection via ActiveRecord's parameterized queries and Strong Parameters.
* **Testing**: Automated CI pipeline verifies system and controller integrity on every push.

---

## 📂 Project Structure
```text
├── app
│   ├── controllers
│   │   └── books_controller.rb    # Jeremy: Core CRUD logic
│   ├── models
│   │   └── book.rb                # Amna: Validations & Logic
│   └── views
│       └── books                  # Hasnan: UI & Partials
├── config
│   └── routes.rb                  # Jeremy: Application routing
├── db
│   ├── schema.rb                  # Database source of truth
│   └── seeds.rb                   # 18 Initial book records
└── test                           # Automated test suite