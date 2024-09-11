# Build stage
FROM elixir:1.13 AS build

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential npm git

WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Copy all application files
COPY . .

# Set mix env to prod
ENV MIX_ENV=prod

RUN mix esbuild.install

# Compile assets
RUN mix assets.deploy
RUN mix phx.digest

# Compile and build release
RUN mix do compile, release

# Debug: List contents of _build directory
RUN ls -R /app/_build

# App stage
FROM debian:bullseye-slim AS app

RUN apt-get update && apt-get install -y openssl libncurses5 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the release from the build stage
COPY --from=build /app/_build/prod/rel/url_shortener ./
COPY --from=build /app/priv ./priv

# Debug: List contents of /app directory
RUN ls -R /app

# Set runtime environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PHX_SERVER=true

EXPOSE 4000

# Debug: Print working directory and list its contents
RUN pwd && ls -la

# Run the Phoenix app
CMD ["/app/bin/url_shortener", "start"]
