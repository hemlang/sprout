# Sprout Framework - Claude Guide

> Express.js-style web framework for Hemlock

This document provides essential context for AI assistants working with Sprout.

## Project Structure

```
sprout/
├── sprout.hml        # Main framework - all exports
├── example.hml       # Full example application
├── test_sprout.hml   # Comprehensive test suite (131 tests)
├── test_simple.hml   # Simple test for debugging
├── README.md         # User documentation
├── CLAUDE.md         # This file
└── LICENSE           # MIT License
```

## Key Concepts

### Hemlock Language Notes

Sprout is written in Hemlock. Key syntax rules:

- **Semicolons required** - All statements end with `;`
- **Braces required** - No braceless if/while/for
- **No string interpolation** - Use concatenation: `"Hello " + name`
- **Object field access**:
  - `obj.field` throws error if field doesn't exist
  - `obj["field"]` returns `null` if field doesn't exist
  - Use bracket notation for optional/dynamic fields
- **Optional parameters**: `fn foo(a, b?: null)` - b defaults to null
- **Self reference**: Use `self` inside object methods

### Framework Architecture

```
App/Router
    └── _routes[]        # Route definitions
    └── _middleware[]    # Middleware stack
    └── _mounted_routers[] # Sub-routers
    └── _static_routes[] # Static file routes

Request (created per-request)
    └── method, path, url, headers
    └── params, query, body, cookies
    └── get(), has(), is(), accepts()

Response (created per-request)
    └── _status, _headers, _cookies, _chunks
    └── status(), set(), type(), cookie()
    └── send(), json(), redirect(), end()
```

### Exported Functions

```hemlock
// Core
export fn App(options)
export fn Router()
export fn create_request(method, url, headers, body, options)
export fn create_response(stream)

// Utilities
export fn get_status_text(code)
export fn split_once(s, delim)
export fn url_decode(s)
export fn parse_query_string(qs)
export fn parse_cookies(header)
export fn get_content_type_category(ct)
export fn get_mime_type(ext)
export fn get_extension(path)
export fn get_basename(path)
export fn normalize_path(path)
export fn remove_trailing_slash(path)

// Path Matching
export fn compile_path_pattern(pattern)
export fn match_path(compiled, path, case_sensitive)

// Middleware Factories
export fn json()
export fn urlencoded()
export fn cookie_parser()
export fn cors(options)
export fn logger(format)
export fn static_files(root, options)
export fn error_handler(handler)
```

## Common Patterns

### Adding New Route Methods

Route methods take path + up to 5 optional handlers:

```hemlock
get: fn(path, h1, h2?: null, h3?: null, h4?: null, h5?: null) {
    let handlers = [h1];
    if (h2 != null) { handlers.push(h2); }
    // ... etc
    self._add_route("GET", path, handlers);
    return self;  // Enable chaining
}
```

### Safe Options Access

Always use bracket notation for user-provided options:

```hemlock
// Bad - throws if field doesn't exist
if (options.max_age != null) { ... }

// Good - returns null if field doesn't exist
if (options["max_age"] != null) { ... }
```

### Response Methods Return Self

All response methods should return `self` for chaining:

```hemlock
status: fn(code) {
    self._status = code;
    return self;  // Enables res.status(200).json({})
}
```

## Testing

Run tests from the hemlock directory:

```bash
cd /path/to/hemlock
./hemlock /path/to/sprout/test_sprout.hml
```

Test structure uses `@stdlib/testing`:

```hemlock
describe("feature", fn() {
    test("does something", fn() {
        expect(value).to_equal(expected);
        expect(bool).to_be_true();
        expect(str.contains("x")).to_be_true();
    });
});

run();  // Must call at end
```

## Known Hemlock Quirks

1. **Object literals need identifier keys** - `{ foo: 1 }` works, `{ "foo": 1 }` doesn't
2. **Numeric object keys don't work** - Build objects dynamically with `obj[key] = val`
3. **Rune to int** - Use type annotation: `let code: i32 = rune_val;`
4. **Setting function properties** - Can't do `fn.prop = val`, wrap in object instead

## Adding Features

When adding new features:

1. Add to `sprout.hml` with `export` if public
2. Add tests to `test_sprout.hml`
3. Update `example.hml` if it's a user-facing feature
4. Update `README.md` documentation

## Dependencies

- `@stdlib/net` - TcpListener, TcpStream
- `@stdlib/json` - parse, stringify
- `@stdlib/testing` - Test framework (dev only)
