# Makefile for setting up a Rails project from a GitHub repository

# Variables
APP_DIR := recovery_agency

# Default target
.PHONY: all
all: install_ruby install_dependencies setup_database server

# Install Ruby (if not already installed)
.PHONY: install_ruby
install_ruby:
	@echo "Checking for Ruby installation..."
	ruby -v || (echo "Installing Ruby..." && choco install ruby -y)

# Install Bundler
.PHONY: install_bundler
install_bundler:
	@echo "Checking for Bundler installation..."
	bundle -v || gem install bundler

# Install required gems
.PHONY: install_dependencies
install_dependencies: install_ruby install_bundler
	@echo "Installing required gems..."
	bundle install

# Setup the database
.PHONY: setup_database
setup_database:
	@echo "Setting up the database..."
	rails db:create db:migrate db:seed assets:precompile

# Run the Rails server
.PHONY: server
server:
	@echo "Starting Rails server..."
	rails server

# Cleanup generated files (if necessary)
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf $(APP_DIR)

# List of available commands
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make               - Setup the entire Rails project"
	@echo "  make install_ruby  - Install Ruby (if not already installed)"
	@echo "  make install_bundler - Install Bundler (if not already installed)"
	@echo "  make install_dependencies - Install all required gems"
	@echo "  make setup_database - Setup the database"
	@echo "  make server        - Run the Rails server"
	@echo "  make clean         - Cleanup generated files"
