# 🌱 Sprout

> Express.js-style web framework for the Hemlock programming language

Sprout is a lightweight, fast, and flexible web framework that brings the familiar Express.js API to Hemlock. Build web applications and APIs with routing, middleware, and all the features you'd expect from a modern web framework.

## Features

- **Express-like API** - Familiar routing and middleware patterns
- **Route Parameters** - `:id`, `:name?` (optional), `:version(v1|v2)` (regex constraints)
- **Wildcard Routes** - `/files/*` captures the rest of the path
- **Middleware Stack** - Global, path-specific, and route-level middleware
- **Sub-Routers** - Mount routers at path prefixes
- **Request/Response Objects** - Full-featured req/res with headers, cookies, body parsing
- **Static File Serving** - Serve files from directories with MIME type detection
- **Built-in Middleware** - JSON parsing, CORS, logging, cookies, error handling

## Quick Start

```hemlock
import { App } from "./sprout.hml";

let app = App(null);

app.get("/", fn(req, res, next) {
    res.send("Hello, World!");
});

app.get("/users/:id", fn(req, res, next) {
    let user_id = req.params["id"];
    res.json({ user_id: user_id });
});

app.listen(3000, fn() {
    print("Server running on http://localhost:3000");
});
```

## Installation

Copy `sprout.hml` to your project directory and import it:

```hemlock
import { App, Router, json, cors, logger } from "./sprout.hml";
```

## API Reference

### App

```hemlock
let app = App({
    trust_proxy: false,           // Trust X-Forwarded-* headers
    case_sensitive_routing: false, // /Foo and /foo are different
    strict_routing: false          // /foo and /foo/ are different
});
```

#### Routing Methods

```hemlock
app.get(path, handler);
app.post(path, handler);
app.put(path, handler);
app.delete(path, handler);
app.patch(path, handler);
app.head(path, handler);
app.options(path, handler);
app.all(path, handler);  // All HTTP methods
```

#### Middleware

```hemlock
app.use(middleware);              // Global middleware
app.use("/api", middleware);      // Path-specific middleware
app.use("/api", router);          // Mount sub-router
```

#### Static Files

```hemlock
app.static("/assets", "./public", {
    max_age: 86400,
    index: "index.html",
    dotfiles: "ignore"
});
```

#### Start Server

```hemlock
app.listen(3000, fn() {
    print("Server started!");
});
```

### Router

```hemlock
let api = Router();

api.get("/users", fn(req, res, next) {
    res.json({ users: [] });
});

api.post("/users", fn(req, res, next) {
    res.status(201).json({ created: true });
});

// Mount at /api/v1
app.use("/api/v1", api);
```

### Request Object

| Property | Description |
|----------|-------------|
| `req.method` | HTTP method (GET, POST, etc.) |
| `req.path` | Request path |
| `req.url` | Full URL including query string |
| `req.params` | Route parameters object |
| `req.query` | Query string parameters object |
| `req.body` | Parsed request body |
| `req.headers` | Request headers object |
| `req.cookies` | Parsed cookies object |
| `req.ip` | Client IP address |
| `req.protocol` | "http" or "https" |
| `req.hostname` | Request hostname |

#### Request Methods

```hemlock
req.get("content-type");           // Get header value
req.get("x-custom", "default");    // With default
req.has("authorization");          // Check if header exists
req.is("json");                    // Check content type
req.accepts("json");               // Check Accept header
```

### Response Object

#### Setting Status and Headers

```hemlock
res.status(201);                   // Set status code
res.set("X-Custom", "value");      // Set header
res.header("X-Custom", "value");   // Alias for set()
res.type("json");                  // Set Content-Type
res.type("application/xml");       // Full MIME type
```

#### Sending Responses

```hemlock
res.send("Hello");                 // Send text
res.send({ key: "value" });        // Auto-converts to JSON
res.json({ key: "value" });        // Send JSON
res.redirect("/login");            // 302 redirect
res.redirect(301, "/new-url");     // Custom status redirect
```

#### Cookies

```hemlock
res.cookie("session", "abc123", {
    max_age: 3600,
    http_only: true,
    secure: true,
    same_site: "strict",
    path: "/",
    domain: ".example.com"
});

res.clear_cookie("session");
```

#### Streaming

```hemlock
res.write("chunk 1");
res.write("chunk 2");
res.end();
```

#### Chaining

All response methods return `self` for chaining:

```hemlock
res.status(201).set("X-Id", "123").json({ created: true });
```

### Route Patterns

```hemlock
// Literal path
app.get("/users", handler);

// Named parameter
app.get("/users/:id", handler);  // req.params["id"]

// Multiple parameters
app.get("/posts/:year/:month/:slug", handler);

// Optional parameter
app.get("/docs/:page?", handler);  // page is optional

// Regex constraint
app.get("/api/:version(v1|v2)/status", handler);

// Wildcard (captures rest of path)
app.get("/files/*", handler);  // req.params["*"]
```

### Built-in Middleware

#### JSON Body Parser

```hemlock
app.use(json());
```

#### URL-encoded Body Parser

```hemlock
app.use(urlencoded());
```

#### Cookie Parser

```hemlock
app.use(cookie_parser());
```

#### CORS

```hemlock
app.use(cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true
}));
```

#### Logger

```hemlock
app.use(logger("dev"));    // Development format
app.use(logger("common")); // Common log format
```

#### Error Handler

```hemlock
app.use(error_handler(fn(err, req, res, next) {
    print("Error: " + err);
    res.status(500).json({ error: "Internal Server Error" });
}));
```

### Middleware Pattern

Middleware functions receive `req`, `res`, and `next`:

```hemlock
fn auth_middleware(req, res, next) {
    let token = req.get("authorization", null);

    if (token == null) {
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    // Continue to next middleware/route
    next();
}

app.get("/protected", auth_middleware, fn(req, res, next) {
    res.json({ secret: "data" });
});
```

### Multiple Handlers

Routes can have multiple handlers (middleware chain):

```hemlock
app.get("/admin",
    auth_middleware,
    admin_check_middleware,
    rate_limit_middleware,
    fn(req, res, next) {
        res.json({ admin: true });
    }
);
```

## Example Application

See `example.hml` for a complete example demonstrating all features.

## Running

```bash
hemlock example.hml
```

Then visit http://localhost:8080

## Requirements

- Hemlock programming language
- `@stdlib/net` for TCP networking
- `@stdlib/json` for JSON parsing

## License

MIT License - see LICENSE file
