# README

Food Recipes API is a simple API for managing recipes with categories, and authors. 
The API is built using Ruby on Rails and uses JSON:API standard.

## Ruby and Rails Version
* Ruby version: 3.0.7
* Rails version: 7.0.8.4

## Setup Steps
Clone the repository:  
```
git clone <repository_url>
cd <repository_name>
```
Install dependencies:  
```
bundle install
```
Set up the database:  
```
rails db:create
rails db:migrate
rails db:seed
```
Run the server:  
```
rails server
```
Run tests:  
```
bundle exec rspec
```

## Tasks to Solve
### 1. Add Like Resource and Endpoints:
     - User must be able to like a recipe.
     - User must be able to unlike a recipe.
     - User must be able to get a list of recipes they have liked.
### 2. Add Stats for Recipes Grouped by Week/Month:
    Add a way to get stats (count, total likes) for user/author number of recipes grouped by 
    - category
    - week/month of creation.
### 3. Add Filtering by Category:
    - Add a way to filter recipies by category.
    - Consider performance with a large number of recipies.

## Existing Endpoints
* GET /recipes
* GET /recipes/:id
* GET /categories
* GET /authors
* GET /authors/:id
