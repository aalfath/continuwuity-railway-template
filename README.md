[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/continuwuity-1?utm_medium=integration&utm_source=button&utm_campaign=continuwuity)

# Deploy and Host Continuwuity on Railway

Continuwuity is a community-run Matrix homeserver written in Rust, continuing the conduwuit project. Matrix is an open, federated chat protocol: you can chat with people on matrix.org and other servers, run bots and bridges, and use clients such as Element, Cinny or FluffyChat on desktop, web and mobile.

## About Hosting Continuwuity

This template builds the official Continuwuity v26.9.4 image (pinned by digest) from a small GitHub repo and runs it as one service, with its embedded RocksDB database on a Railway volume. No separate database is needed. The server name is your Railway domain, and Continuwuity serves the `.well-known` files itself, so clients and other Matrix servers reach it over HTTPS on port 443. The first account is created with a one-time token shown in the deploy logs and becomes the server admin; everyone after that needs a registration token that Railway generates at deploy time. Plan for roughly 100–300 MB of memory for a small server; usage grows with the rooms you join.

## Common Use Cases

* A private Matrix server for family, friends or a small team
* A home for Matrix bots and bridges to other chat networks
* Federated chat with people on matrix.org and other Matrix servers

## Dependencies for Continuwuity Hosting

* Continuwuity v26.9.4 (official image `ghcr.io/continuwuity/continuwuity`, mirror of `forgejo.ellis.link/continuwuation/continuwuity`)
* A Railway volume at `/var/lib/continuwuity` for the RocksDB database

### Deployment Dependencies

* [Continuwuity website and docs](https://continuwuity.org)
* [Continuwuity source (Forgejo)](https://forgejo.ellis.link/continuwuation/continuwuity) and [GitHub mirror](https://github.com/continuwuity/continuwuity)
* [Continuwuity v26.9.4 release](https://forgejo.ellis.link/continuwuation/continuwuity/releases/tag/v26.9.4)
* [Template repo](https://github.com/aalfath/continuwuity-railway-template)
* [Matrix federation tester](https://federationtester.matrix.org)

### Implementation Details

**First steps**

1. Open the service's latest deployment logs. On the first start, Continuwuity prints a welcome banner with a **one-time registration token** for the first account (it prints a new one on each start until that account exists).
2. In Element (or another Matrix client), choose "Create account", set the homeserver to `https://YOUR-APP.up.railway.app`, and enter that one-time token when asked.
3. The first account becomes the server admin and is joined to the admin room, where you can send commands such as `!admin users list-users`.
4. Everyone after that registers with `CONTINUWUITY_REGISTRATION_TOKEN` from the service's **Variables** tab (it only works once the first account exists).

| Variable | Default | Purpose |
| --- | --- | --- |
| `CONTINUWUITY_SERVER_NAME` | `${{RAILWAY_PUBLIC_DOMAIN}}` | The domain in user IDs (`@you:domain`). It cannot be changed after the first start without wiping the database |
| `CONTINUWUITY_REGISTRATION_TOKEN` | generated, 32 characters | Token required to create an account |
| `CONTINUWUITY_WELL_KNOWN__CLIENT` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Client discovery URL |
| `CONTINUWUITY_WELL_KNOWN__SERVER` | `${{RAILWAY_PUBLIC_DOMAIN}}:443` | Federation on port 443 instead of 8448 |
| `PORT` | `8008` | Port Continuwuity listens on, used by Railway's domain and health check |

Fixed settings are set in the repo's `Dockerfile` (listen on `[::]:8008`, database at `/var/lib/continuwuity`, token registration on, federation on, `matrix.org` as trusted key server, client IPs from `X-Forwarded-For`, and a small database thread pool: `CONTINUWUITY_DB_POOL_WORKERS_LIMIT=1` and `CONTINUWUITY_ROCKSDB_PARALLELISM_THREADS=4`, because the default pool sizing tries to start up to 1024 threads on Railway's large hosts and fails with `os error 11`). Override any of them with a Railway variable of the same name; every option in the [configuration reference](https://continuwuity.org/reference/config) maps to `CONTINUWUITY_OPTION_NAME` (nested sections use `__`).

Notes:

* **Custom domain:** to use addresses like `@you:example.com`, set `CONTINUWUITY_SERVER_NAME` and both well-known variables to your domain **before the first start**, or serve the `.well-known` files from that domain. If you add a custom domain to an existing server, pin `CONTINUWUITY_SERVER_NAME` to the original Railway domain so it does not change.
* **Closing registration:** set `CONTINUWUITY_ALLOW_REGISTRATION=false` once everyone has joined, or rotate the token. More tokens can be made with `!admin token`.
* **Display names:** Continuwuity adds a suffix to new users' display names by default; set `CONTINUWUITY_NEW_USER_DISPLAYNAME_SUFFIX` to an empty value to turn that off.
* Optional features (SMTP, OIDC login, TURN for calls, media retention) are configured with more `CONTINUWUITY_*` variables, see the docs.

**Updates:** the image is pinned by version and digest in the `Dockerfile`. New Continuwuity releases land as a change to this repo's `main` branch with a `CHANGELOG.md` entry, and Railway offers deployers the update in their dashboard; you choose when to apply it.

This is a community deployment package and is not affiliated with or endorsed by the Continuwuity project.

## Why Deploy Continuwuity on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Continuwuity on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
