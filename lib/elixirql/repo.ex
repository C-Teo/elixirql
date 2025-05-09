defmodule Elixirql.Repo do
  use Ecto.Repo,
    otp_app: :elixirql,
    adapter: Ecto.Adapters.Postgres
end
