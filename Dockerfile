# Taken and adapted from: https://hexdocs.pm/phoenix/releases.html#containers
# to not use releases and to be a single stage build

FROM elixir:alpine

# Install dependencies
RUN apk add --no-cache npm

# Prepare dir
WORKDIR /app

ENV HOME=/app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set ENV variables
ENV MIX_ENV prod

# Blank expected variables that will be overriden
ENV DATABASE_URL ""
ENV SECRET_KEY_BASE ""

# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get --only prod, deps.compile

# Copy and compile
COPY lib lib
RUN mix compile

# Install NPM depdendencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# Build assets
COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy && \
    mix phx.digest

# Drop permissions
RUN chown -R nobody:nobody /app
USER nobody:nobody

# Run the server
EXPOSE 4000
CMD ["mix", "phx.server"]
