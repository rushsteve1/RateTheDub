# [RateTheDub](https://ratethedub.com)

> Was the dub for that anime any good?

[![GitHub CI](https://github.com/rushsteve1/RateTheDub/actions/workflows/elixir.yml/badge.svg)](https://github.com/rushsteve1/RateTheDub/actions/workflows/elixir.yml)

RateTheDub is a site where you can view and vote on whether or not the dub for
various anime series was any good. Its goal is to the need for random searching
and browsing random forum posts when trying to figure out if the dub for an
anime was worth watching.

This project use the [Jikan.moe](https://jikan.moe) API for
[MyAnimeList](https://myanimelist.net), so a huge shoutout and thank you to them
for all their hard work!

## Additional Documentation

Project-level documentation can be found in the [`docs/` folder](./docs).

- [Contributing Guide](./docs/CONTRIBUTING.md)
- [Installation Guide](./docs/INSTALL.md)
- [REST API](./docs/API.md)
- [Security Policy](./docs/SECURITY.md)

## Major Dependencies

These are the most important dependencies of this project. The full lists can be
found in [`mix.exs`](./mix.exs) and
[`assets/package/json`](./assets/package.json). In no particular order...

- [PostgreSQL](https://www.postgresql.org/)
- [Erlang / BEAM VM and the OTP](https://erlang.org/)
- [Elixir](https://elixir-lang.org/)
- [Phoenix](https://phoenixframework.org/)
- [Tesla](https://github.com/teamon/tesla)
- [Ecto](https://github.com/elixir-ecto/ecto)
- [NodeJS](https://nodejs.org/)
- [Webpack](https://webpack.js.org/)
- [Tailwind](https://tailwindcss.com/)
- [Swup](https://swup.js.org/)

A huge thank you to the developers of these projects and all the others for
their hard work! This project is built on the shoulders of giants.

---

## Phoenix Documentation

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
