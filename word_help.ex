Code.require_file("./sizemap.ex")

defmodule WordHelp.CLI do
  def main(letters, number \\ nil) do
    letter_size_map = SizeMap.from_string(letters)
    File.stream!("./words.txt")
      |> Stream.map(fn (word) ->
        word |> String.downcase |> String.replace("\n", "")
      end)
      |> Stream.filter(fn (word) ->
        if number do
          word |> String.length == String.to_integer(number)
        else
          true
        end
      end)
      |> Stream.filter(fn (word) ->
        word |> has_all_letters?
      end)
      |> Stream.filter(fn (word) ->
        SizeMap.matches?(letter_size_map, SizeMap.from_string(word))
      end)
      |> Enum.each(&IO.puts/1)
  end

  defp has_all_letters?(word) do
    length = word |> String.length |> Integer.to_string
    {:ok, regex} = Regex.compile("[a-zA-Z]{" <> length <> "}")
    word |> String.match?(regex)
  end
end

if (System.argv() |> length) == 2 do
  [ letters, number ] = System.argv()
  WordHelp.CLI.main(letters, number)
else
  [ letters | _] = System.argv()
  WordHelp.CLI.main(letters)
end
exit(:shutdown)
