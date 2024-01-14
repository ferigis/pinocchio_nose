defmodule Pinocchio.NoseWeb.CounterView do
  use Pinocchio.NoseWeb, :view

  def render("show.json", %{counter: nil}) do
    %{data: %{value: 0}}
  end

  def render("show.json", %{counter: counter}) do
    %{data: render_one(counter, __MODULE__, "counter.json")}
  end

  def render("counter.json", %{counter: counter}) do
    %{
      value: counter.value
    }
  end
end
