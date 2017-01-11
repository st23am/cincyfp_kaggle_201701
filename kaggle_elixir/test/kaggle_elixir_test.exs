defmodule KaggleElixirTest do
  use ExUnit.Case
  doctest KaggleElixir
  setup do
    %{csv: KaggleElixir.data()}
  end

  test "the truth", %{csv: csv} do
    {:ok, network_pid} = NeuralNetwork.Network.start_link([11, 10, 10])
    NeuralNetwork.Network.get(network_pid)
    data = Stream.drop(csv, 1)
    data_inputs = KaggleElixir.row(data)
    NeuralNetwork.Trainer.train(network_pid, data_inputs, %{epochs: 100, log_freqs: 10})
    assert 1 + 1 == 2
  end
end
