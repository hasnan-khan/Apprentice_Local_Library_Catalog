# Changelog

## V2.0_Unreleased 2026-03-30

## Added
- Salesforce bridge via OData v4 API Endpoints (`/odata/v4/books`)
- Metadata handshake for SalesForce Connect 
  - Added XML CSDL generation at `/$metadata`
- Configured `rack-cors` to allow cross-origin requests from staff portal
  - currently accepts "anything" from "anywhere". *may want to improve security
- Implemented availability status in `book` model. `status:`

## Changed
- Replaced `find` with `find_by` in controllers to handle 404 errors more gracefully. (`error` JSON)

## Security
- patched following dependencies: [`action_text-trix`, `activestorage`, `json`, `loofah`] to resolve CI/CD Failures
- patched `mcp` gem to `>= 0.9.2` to resolve CICD Failures for Vulnerabilities.