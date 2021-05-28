#!/bin/sh

# Taken and adapted from
# https://fly.io/docs/getting-started/elixir/

# Run migrations before startup
/app/bin/ratethedub eval "RateTheDub.Release.migrate"

exec $@
