# Technology Thursday demo
This repo contains some of the demo code used during the Bewire Technology Thursday given 28th juli 2021. In order to run these on your local device, you'll need to have Elixir on your device.

Install dependencies with `mix deps.get`

### Language feautures
There are 3 test files located under `test/ttdemo_web/language_features_demo` to showcase some specific Elixir features you can run all test with the command
```
mix test
```
or you can run a specific test by running the command with a specific @tag, found above each of the language feature tests. For example, to run only the immutability test in `0_immutability_test.exs` you can run the following command:
```
mix test --only immutability
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:8000`](http://localhost:8000) from your browser.

For code demo purposes a couple of `/demo` were created, you can find their definitions in `lib/ttdemo_web/router.ex`

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
