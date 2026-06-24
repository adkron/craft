defmodule Craft.RPC do
  def cast(node, m, f, a) do
    :erlang.spawn_request(node, __MODULE__, :execute, [{m, f, a}], reply: :no)
  end

  def call(node, m, f, a, timeout_or_opts \\ %{}) when is_atom(node) and is_atom(m) and is_atom(f) and is_list(a) do
    try do
      :erpc.call(node, m, f, a, timeout_or_opts)
    catch
      :error, error ->
        {:error, error}

      :exit, {:exception, {:timeout, _}} ->
        {:error, :timeout}

      kind, error ->
        {:error, {kind, error}}
    end
  end

  def execute({m, f, a}) do
    try do
      apply(m, f, a)
    catch
      :error, error ->
        {:error, error}

      kind, error ->
        {:error, {kind, error}}
    end
  end
end
