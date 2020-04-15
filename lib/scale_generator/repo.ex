defmodule ScaleGenerator.Repo do
  use Ecto.Repo,
    otp_app: :scale_generator,
    adapter: Ecto.Adapters.Postgres
end
