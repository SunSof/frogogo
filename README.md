# README

# Frogogo

This README provides the necessary steps to get your application up and running.

## Versions

- Ruby: 3.3.0
- Rails: 8.0.2

## System Dependencies

Ensure you have the following installed:

- Ruby 3.3.0
- Rails 8.0.2
- PostgreSQL 

## Configuration
  ```bash
    bundle install
  ```
## Database Setup

To set up the database, run the following commands:

1. Create the database:
    ```bash
    rails db:create
    ```

2. Run migrations:
    ```bash
    rails db:migrate
    ```

3. Seed the database:
    ```bash
    rails db:seed
    ```
## Running the Application

To start the application locally, run:

```bash
./bin/dev
```