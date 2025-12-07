# Sprout - Express.js-style web framework for Hemlock
# https://github.com/nbeerbower/sprout

HEMLOCK ?= hemlock
VERSION := 1.0.0

.PHONY: all test clean help

all: test

# Run the test suite
test:
	@$(HEMLOCK) test_sprout.hml

# Run the example server
run:
	@$(HEMLOCK) test_server.hml

# Clean up any generated files
clean:
	@rm -f *.hmlp

# Show help
help:
	@echo "Sprout $(VERSION) - Express.js-style web framework for Hemlock"
	@echo ""
	@echo "Usage:"
	@echo "  make test    - Run the test suite (131 tests)"
	@echo "  make run     - Run the example server on port 8080"
	@echo "  make clean   - Remove generated files"
	@echo "  make help    - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  HEMLOCK      - Path to hemlock interpreter (default: hemlock)"
