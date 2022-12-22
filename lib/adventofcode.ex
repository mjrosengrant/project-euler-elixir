defmodule AdventOfCode01 do
  @doc ~S"""
    --- Day 1: Calorie Counting ---

    This list represents the Calories of the food carried by five Elves:

        The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories.
        The second Elf is carrying one food item with 4000 Calories.
        The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories.
        The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories.
        The fifth Elf is carrying one food item with 10000 Calories.

    In case the Elves get hungry and need extra snacks, they need to know which Elf to ask: they'd like to know how many Calories are being carried by the Elf carrying the most Calories. In the example above, this is 24000 (carried by the fourth Elf).

    Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?
  """
  def solve do
    # Read the contents of the file into a string
    # assets_dir = 
    {:ok, contents} = File.read("lib/assets/adventofcode_01.txt")

    elf_calories =
      contents
      |> String.split("\n")
      |> Enum.chunk_by(&(&1 != ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn list_of_lists ->
        Enum.map(list_of_lists, &(Integer.parse(&1) |> elem(0)))
      end)

    total_calories_per_elf =
      elf_calories
      |> Enum.map(fn calorie_list -> Enum.sum(calorie_list) end)

    highest_calories =
      total_calories_per_elf
      |> Enum.reduce(&max/2)

    # |> IO.inspect()

    elf_with_most_calories = total_calories_per_elf |> Enum.find_index(&(&1 == highest_calories))
    IO.puts("Elf " <> to_string(elf_with_most_calories))
    IO.puts(to_string(highest_calories) <> " Calories")
    # |> Enum.map(&String.to_integer/1)
  end
end

AdventOfCode01.solve()
