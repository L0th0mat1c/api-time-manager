#!/bin/bash
# Docker entrypoint script.

ls

# Wait until Postgres is ready
echo "Testing if Postgres is accepting connections. {db} {5432} {postgres}"
while ! pg_isready -q -h db -p 5432 -U postgres
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list time_manager_dev"` ]]; then
  echo "Database time_manager_dev does not exist. Creating..."
  
  mix ecto.create
  mix ecto.migrate
  # mix run priv/repo/seeds/user_seeds.exs
  # mix run priv/repo/seeds/clock_seeds.exs
  # mix run priv/repo/seeds/workingtime_seeds.exs
  echo "Database time_manager_dev created."
fi

exec mix phx.server