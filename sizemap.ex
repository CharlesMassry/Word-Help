defmodule SizeMap do
  def from_string(string) do
    string |> String.graphemes |> Enum.reduce(%{}, fn (letter, acc) -> 
      [ _, value ] = Map.get_and_update(acc, letter, fn (current_value) -> 
        { current_value, nil_to_integer(current_value) + 1 }
      end) |> Tuple.to_list
      acc |> Map.merge(value)
    end)
  end

  def matches?(size_map_a, size_map_b) when is_map(size_map_a) and is_map(size_map_b) do
    size_map_b |> Enum.reduce_while(false, fn ({letter, size_b}, _) -> 
      size_a = size_map_a |> Map.get(letter)
      if size_a && size_b <= size_a do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  def matches?(string_a, string_b) when is_bitstring(string_a) and is_bitstring(string_b) do
    matches?(from_string(string_a), from_string(string_b))
  end

  defp nil_to_integer(bool) do
    if bool, do: bool, else: 0
  end
end
