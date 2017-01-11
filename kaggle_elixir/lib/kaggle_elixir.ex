defmodule KaggleElixir do
  @moduledoc """
  Documentation for KaggleElixir.
  """

  @doc """
  Hello world.

  ## Examples

      iex> KaggleElixir.hello
      :world

  """
  def data(path \\ "../data/winequality-data.csv") do
    Path.expand(path)
    |> File.stream!
    |> CSV.decode()
  end

  def row(data) do
   Enum.map(data, fn(datum) ->
      input = Enum.take(datum, 11)
              |> Enum.map(&(elem(Float.parse(&1), 0)))
      vec = Enum.map(1..10, fn(_elm) -> 0 end)
      foo = Enum.at(datum, 11)
      |> String.to_integer()
      index = foo - 1
      output = List.replace_at(vec, index, 1)
      %{input: input, output: output}
    end)
  end

  def run() do
    {:ok, network_pid} = NeuralNetwork.Network.start_link([11, 100, 10])
    NeuralNetwork.Network.get(network_pid)
    data_with_out_headers = Stream.drop(data, 1)
    data_inputs = KaggleElixir.row(data_with_out_headers)
    NeuralNetwork.Trainer.train(network_pid, data_inputs, %{epochs: 1, log_freqs: 1})
  end
end
