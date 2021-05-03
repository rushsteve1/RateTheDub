# Taken and adapted from
# https://fly.io/docs/getting-started/elixir/

###
### First Stage - Building the Release
###
FROM elixir:alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod && \
    mix deps.compile

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets

# NOTE: If using TailwindCSS, it uses a special "purge" step and that requires
# the code in `lib` to see what is being used.
COPY lib lib

# build assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY rel rel
RUN mix do compile, release

###
### Second Stage - Setup the Runtime Environment
###

# prepare release docker image
FROM alpine AS app

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/ratethedub ./

ADD entrypoint.sh ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["bin/ratethedub", "start"]
