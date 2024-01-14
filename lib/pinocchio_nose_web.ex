defmodule Pinocchio.NoseWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Pinocchio.NoseWeb, :controller
      use Pinocchio.NoseWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Pinocchio.NoseWeb

      import Plug.Conn
      alias Pinocchio.NoseWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/pinocchio_nose_web/templates",
        namespace: Pinocchio.NoseWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def rate_limit_on_deny(conn, opts) do
    remote_ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

    :ok =
      :telemetry.execute([:pinocchio_nose, :rate_limit, :denied], %{count: 1}, %{ip: remote_ip})

    Hammer.Plug.default_on_deny_handler(conn, opts)
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import Pinocchio.NoseWeb.ErrorHelpers
      alias Pinocchio.NoseWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
