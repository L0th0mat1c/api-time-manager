# Use an official Elixir runtime as a parent image
FROM elixir:latest
ARG POSTGRES_PASSWORD=postgres
ARG POSTGRES_USER=postgres
ARG POSTGRES_HOST_AUTH_METHOD= trust
ARG PGDATABASE= time_manager_dev
ARG PGPORT= 5432
ARG PGHOST= db
RUN apt-get update && \
  apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# Compile the project
RUN mix deps.get

EXPOSE 4000
RUN ["chmod", "+x", "./entrypoint.sh"]
CMD ["./entrypoint.sh"]