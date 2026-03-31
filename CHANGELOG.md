# Changelog

## V2.0_Unreleased 2026-03-30

## Added
- Salesforce bridge via OData v4 API Endpoints (`/odata/v4/Books`)
- Metadata handshake for SalesForce Connect 
  - Added XML CSDL generation at `/$metadata`
- Configured `rack-cors` to allow cross-origin requests from staff portal
  - currently accepts "anything" from "anywhere". *may want to improve security
- Implemented availability status in `book` model. `status:`
- `Recommendation` class to handle patron book recommendations (requests) for books to be added to library.
- `RecommendationsController` class to handle recommendation (request) flow.
- `RequestNotes` class (belongs to `Recommendation`) to serve as individual "notes" or "comments" for a book recommendation from separate patrons.
- Data migration to change `Recommendation` counter from `nil` to `0` to avoid errors using incremnenters.

## Changed
- Replaced `find` with `find_by` in controllers to handle 404 errors more gracefully. (`error` JSON)
- `books` path explicitly capitalized to help with Salesforce matching to controller class names. `URL/odata/v4/Books`

## Security
- patched following dependencies: [`action_text-trix`, `activestorage`, `json`, `loofah`] to resolve CI/CD Failures
- patched `mcp` gem to `>= 0.9.2` to resolve CICD Failures for Vulnerabilities.