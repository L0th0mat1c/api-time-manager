# Use an official Elixir runtime as a parent image
FROM elixir:latest

ENV MIX_ENV=test
ENV PORT=4000

# COPY . /app
RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

# install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# compile dependencies
COPY config ./config/

# copy only elixir files to keep the cache
COPY lib ./lib/
COPY priv ./priv/
COPY test ./test/
EXPOSE ${PORT}

ENTRYPOINT ["mix", "test"]