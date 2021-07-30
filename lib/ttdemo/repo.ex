defmodule Ttdemo.Repo do
  use Ecto.Repo,
    otp_app: :ttdemo,
    adapter: Ecto.Adapters.Postgres

  def init(opts) do
    IO.inspect opts
  end
end
