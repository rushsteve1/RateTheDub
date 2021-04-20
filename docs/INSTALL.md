# Installation Guide

This guide will help you install and get setup to develop on RateTheDub. If you
want to setup for production please follow the whole guide as well as the
Production Deployment section, as the steps are mostly the same.

The
[Phoenix Framework Install Guide](https://hexdocs.pm/phoenix/installation.html)
has further documentation on installing and setting up a Phoenix project like
RateTheDub.

## Install Dependencies

The main external dependencies of RateTheDub are...

- [NodeJS and NPM](https://nodejs.org/)
- [Erlang](https://erlang.org)
- [Elixir](https://elixir-lang.org)
- [PostgreSQL](https://www.postgresql.org/)

We intend to support only the *latest* versions of the above, though older
versions may continue to work as intended. In particular slightly older versions
of Postgres are likely fine. However please be warned that an issues caused by
using an outdated dependency version will not be given support.

It is suggested that you install these using your distribution's package manager
(if on Linux) or with Homebrew (if on MacOS). If neither of these options are
available to you

For Postgres in particular I suggest running the database within a
[Docker](https://www.docker.com/) container. Instructions for use both with and
without Docker are below.

## Setup the Database

### Running with Docker

Getting Postgres installed and setup with Docker is very simple

```sh
docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres
```

Once that is setup then any time you want to start the database again simply do

```sh
docker start postgres
```

### Running without Docker

The
[PostgreSQL Install Guide](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
has more resources on installing and getting setup.

## Setup, Compile, and Run

To install all dependencies, run all migrations, and compile everything run the
following command

```
mix setup
```

Once this has completed the development server can be run with

```
mix phx.server
```

## Production Deployment

The
[Phoenix Framework Deployment Guide](https://hexdocs.pm/phoenix/deployment.html)
has a much more detailed guide to deploying in production.

To summarize though, you should setup and secure your database properly with
strong credentials. Then you have to set following environment variables:

- `MIX_ENV=prod`
- `DATABASE_URL` to the full URL with credentials
- `SECRET_KEY_BASE` which was generated with `mix phx.gen.secret`
