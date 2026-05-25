# Bot Army Minimal Template

**Get a working Bot Army bot in 10 minutes.**

This template is the simplest starting point for building a Bot Army bot. It includes:
- NATS connection (via `bot_army_runtime`)
- HTTP health check endpoint
- One example NATS request/reply handler
- Docker build support (via `ergon-builder`)

**Not included:** Database, persistence, testing, CI/CD, complex patterns.

For a production-ready template with full features, see [ergon-bot-featured](https://github.com/ergon-automation-labs/ergon-bot-featured).

## Quick Start

### 1. Use the Setup Script

```bash
# Clone this template
git clone https://github.com/ergon-automation-labs/ergon-bot-minimal my-bot
cd my-bot

# Run setup script (interactive)
./setup_new_bot.sh
```

The script will ask for:
- Bot name (e.g., `my_task_bot`)
- Release name (e.g., `my_task_bot`)
- Short description

Then it will:
- Replace all template variables
- Rename the directory (optional)
- Initialize git

### 2. Add Your Handler

Edit `lib/{{BOT_APP_NAME}}/handlers/example_handler.ex`:
- Change the subject from `example.action` to your NATS subject
- Implement your business logic
- Update the response format

### 3. Enable Your Handler

In `lib/{{BOT_APP_NAME}}/application.ex`, uncomment:

```elixir
{{{BOT_APP_NAME_CAMEL}}.Handlers.ExampleHandler, []}
```

### 4. Test

```bash
# Install dependencies
mix deps.get

# Run tests (if you add them)
mix test

# Build release
mix release

# Run locally (requires NATS at nats://localhost:4222)
NATS_SERVERS=nats://localhost:4222 _build/prod/rel/{{BOT_RELEASE_NAME}}/bin/{{BOT_RELEASE_NAME}} start
```

### 5. Build & Deploy

```bash
# Build Docker image
docker build -t myorg/my-bot:v0.1.0 .

# Push to registry
docker push myorg/my-bot:v0.1.0

# Use in docker-compose or Kubernetes
```

## Adding Features

As your bot grows, consider:

1. **Database persistence** → Add `Ecto` and `Postgrex` to `mix.exs`, create schemas
2. **Multiple handlers** → Add more files in `lib/.../handlers/`
3. **Testing** → Add `{:mox, "~> 1.0", only: :test}` and write tests
4. **Logging** → Use `require Logger` and `Logger.info()`
5. **HTTP client** → Add `{:req, "~> 0.3"}` for external APIs

For a template with all of this built-in, use [ergon-bot-featured](https://github.com/ergon-automation-labs/ergon-bot-featured).

## NATS Pattern Examples

### Request/Reply

```elixir
# Send a request and wait for reply
{:ok, conn} = BotArmyRuntime.NATS.Connection.get_connection()
{:ok, reply} = Gnat.request(conn, "some.subject", "{\"data\":\"...\"}", receive_timeout: 5000)

# Handle a request (in your handler)
defp handle_request(msg) do
  response = BotArmyRuntime.NATS.Reply.ok(%{"result" => "..."})
  Gnat.pub(conn, msg.reply_to, response)
end
```

### Pub/Sub

```elixir
# Subscribe to a subject
Gnat.sub(conn, self(), "events.>")

# Publish an event
Gnat.pub(conn, "events.task.created", encode_event(%{"id" => task_id}))
```

## Documentation

- **[Bot Army Starter](https://github.com/ergon-automation-labs/ergon-starter)** — Deploy multiple bots with docker-compose
- **[Bot Army Builder](https://github.com/ergon-automation-labs/ergon-builder)** — Shared Docker base image
- **[Bot Army Runtime](https://github.com/ergon-automation-labs/ergon-library-runtime)** — Shared utilities (NATS, logging, tracing)

## Troubleshooting

**"NATS connection not ready"**
- Ensure NATS is running on the `NATS_SERVERS` address (default `nats://localhost:4222`)
- Check `Gnat.ConnectionSupervisor` is started by `bot_army_runtime`

**"Health check failing in Docker"**
- Ensure HTTP server is listening on port 8888
- Check Dockerfile exposes port 8888

**"Dependencies not resolving"**
- If using path-based local deps, ensure sibling repos exist: `../bot_army_library_core`, `../bot_army_library_runtime`
- Or switch to Hex packages: `{:bot_army_library_core, "~> 0.1"}` (if published)

## License

Apache 2.0 — Same as Bot Army

---

**Next Steps:**
- Read the [example handler](./lib/{{BOT_APP_NAME}}/handlers/example_handler.ex) for NATS patterns
- Check [bot_army_runtime](https://github.com/ergon-automation-labs/ergon-library-runtime) for available utilities
- See [ergon-bot-featured](https://github.com/ergon-automation-labs/ergon-bot-featured) for advanced patterns
