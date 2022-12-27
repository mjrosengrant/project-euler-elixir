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

    elf_with_most_calories = total_calories_per_elf |> Enum.find_index(&(&1 == highest_calories))
    IO.puts("Elf " <> to_string(elf_with_most_calories))
    IO.puts(to_string(highest_calories) <> " Calories")

    # Find the top three Elves carrying the most Calories.
    # How many Calories are those Elves carrying in total?
    top_3_calorie_sum =
      total_calories_per_elf
      |> Enum.sort(&(&1 >= &2))
      |> Enum.slice(0, 3)
      |> Enum.sum()

    IO.puts("Top 3 elves are carrying " <> to_string(top_3_calorie_sum) <> " calories")
  end
end

defmodule AdventOfCode02 do
  @doc ~S"""
  --- Day 2: Rock paper scissors ---
  Suppose you were given the following strategy guide:

  A Y
  B X
  C Z

  This strategy guide predicts and recommends the following:

      In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
      In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
      The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.

  In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

  What would your total score be if everything goes exactly according to your strategy guide?
  """
  @p1_rock "A"
  @p1_paper "B"
  @p1_scissors "C"

  @p2_rock "X"
  @p2_paper "Y"
  @p2_scissors "Z"

  @rock_val 1
  @paper_val 2
  @scissors_val 3

  @win_val 6
  @loss_val 0
  @tie_val 3

  def solve do
    {:ok, contents} = File.read("lib/assets/adventofcode_02.txt")
    # contents = "A Y\nB X\nC Z"

    round_list =
      contents
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " "))
      |> Enum.reject(&(&1 == [""]))

    round_scores = Enum.map(round_list, &score_round(&1))
    total_score = Enum.sum(round_scores)
    IO.puts("Pt 1 SCORE: " <> to_string(total_score))
    pt_2_score = Enum.map(round_list, &score_round_pt_2(&1)) |> Enum.sum()
    IO.puts("Pt 2 SCORE: " <> to_string(pt_2_score))
  end

  def score_round(pair_list) do
    # Paper covers rock, p2 wins
    case pair_list do
      [@p1_rock, @p2_scissors] -> @loss_val + @scissors_val
      [@p1_rock, @p2_rock] -> @tie_val + @rock_val
      [@p1_rock, @p2_paper] -> @win_val + @paper_val
      [@p1_paper, @p2_rock] -> @loss_val + @rock_val
      [@p1_paper, @p2_paper] -> @tie_val + @paper_val
      [@p1_paper, @p2_scissors] -> @win_val + @scissors_val
      [@p1_scissors, @p2_rock] -> @win_val + @rock_val
      [@p1_scissors, @p2_scissors] -> @tie_val + @scissors_val
      [@p1_scissors, @p2_paper] -> @loss_val + @paper_val
    end
  end

  def score_round_pt_2(pair_list) do
    lose = "X"
    tie = "Y"
    win = "Z"

    case pair_list do
      [@p1_rock, ^lose] -> @loss_val + @scissors_val
      [@p1_rock, ^tie] -> @tie_val + @rock_val
      [@p1_rock, ^win] -> @win_val + @paper_val
      [@p1_paper, ^lose] -> @loss_val + @rock_val
      [@p1_paper, ^tie] -> @tie_val + @paper_val
      [@p1_paper, ^win] -> @win_val + @scissors_val
      [@p1_scissors, ^lose] -> @loss_val + @paper_val
      [@p1_scissors, ^tie] -> @tie_val + @scissors_val
      [@p1_scissors, ^win] -> @win_val + @rock_val
    end
  end
end

defmodule AdventOfCode03 do
  @doc ~S"""
  The Elves have made a list of all of the items currently in each rucksack
  (your puzzle input), but they need your help finding the errors. Every item
  type is identified by a single lowercase or uppercase letter
  (that is, a and A refer to different types of items).

  To help prioritize item rearrangement, every item type can be converted to a priority:

    Lowercase item types a through z have priorities 1 through 26.
    Uppercase item types A through Z have priorities 27 through 52.

    In the above example, the priority of the item type that appears in both
    compartments of each rucksack is 16 (p), 38 (L), 42 (P), 22 (v), 20 (t),
    and 19 (s); the sum of these is 157.

  Find the item type that appears in both compartments of each rucksack.
  What is the sum of the priorities of those item types?
  """
  def solve do
    # contents =
    #   "vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw"
    {:ok, contents} = File.read("lib/assets/adventofcode_03.txt")
    part_1(contents)
    part_2(contents)
  end

  defp part_1(contents) do
    compartment_contents =
      contents
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.split_at(&1, Integer.floor_div(String.length(&1), 2)))

    common_items = Enum.map(compartment_contents, &find_common_item(&1))
    item_priorities = Enum.map(common_items, &get_item_priority(&1))
    sum = Enum.sum(item_priorities)
    IO.puts("PT 1: " <> to_string(sum))
  end

  defp part_2(contents) do
    group_lists = String.trim(contents) |> String.split() |> Enum.chunk_every(3)
    group_sets = Enum.map(group_lists, &List.to_tuple(&1))
    group_priorities = Enum.map(group_sets, &(find_common_item(&1) |> get_item_priority()))
    score = Enum.sum(group_priorities)
    IO.puts("PT 2: " <> to_string(score))
  end

  defp find_common_item(compartment_contents) do
    # {comp1, comp2} = compartment_contents
    mapset_strings =
      Enum.map(Tuple.to_list(compartment_contents), &MapSet.new(String.graphemes(&1)))

    first_mapset = Enum.at(mapset_strings, 0)

    Enum.reduce(mapset_strings, first_mapset, fn x, acc -> MapSet.intersection(x, acc) end)
    |> MapSet.to_list()
    |> Enum.at(0)
  end

  defp priority_vals do
    a_z_list = Enum.map(?a..?z, fn x -> <<x::utf8>> end)
    a_z_list_caps = Enum.map(?A..?Z, fn x -> <<x::utf8>> end)
    Enum.zip(a_z_list, 1..26) ++ Enum.zip(a_z_list_caps, 27..52)
  end

  defp get_item_priority(item_name) do
    priority_vals = priority_vals()

    Enum.filter(priority_vals, fn {letter, val} -> letter == item_name end)
    |> Enum.at(0)
    |> elem(1)
  end
end

defmodule AdventOfCode04 do
  @doc ~S"""
  consider the following list of section assignment pairs:

  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8

  For the first few pairs, this list means:

      Within the first pair of Elves, the first Elf was assigned sections 2-4 (sections 2, 3, and 4), while the second Elf was assigned sections 6-8 (sections 6, 7, 8).
      The Elves in the second pair were each assigned two sections.
      The Elves in the third pair were each assigned three sections: one got sections 5, 6, and 7, while the other also got 7, plus 8 and 9.

  Some of the pairs have noticed that one of their assignments fully contains
  the other. For example, 2-8 fully contains 3-7, and 6-6 is fully contained by 4-6.
  In pairs where one assignment fully contains the other, one Elf in the pair
  would be exclusively cleaning sections their partner will already be cleaning,
  so these seem like the most in need of reconsideration. In this example,
  there are 2 such pairs.

  In how many assignment pairs does one range fully contain the other?
  """
  def solve do
    {:ok, contents} = File.read("lib/assets/adventofcode_04.txt")
    # contents = "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"

    assignments =
      String.trim(contents)
      |> String.split("\n")

    overlaps = Enum.map(assignments, &overlaps?(&1))
    overlap_freqs = Enum.frequencies(overlaps)
    overlap_count = overlap_freqs.true

    partial_overlaps = Enum.map(assignments, &partial_overlaps?(&1))
    partial_overlap_freqs = Enum.frequencies(partial_overlaps)
    partial_overlap_count = partial_overlap_freqs.true

    IO.puts("Overlap Count: " <> to_string(overlap_count))
    IO.puts("Parital Overlap Count: " <> to_string(partial_overlap_count))
  end

  defp parse_range_lists(assignments_str) do
    assignments_list = String.split(assignments_str, ",")

    ranges =
      Enum.map(
        assignments_list,
        &String.split(&1, "-")
      )
      |> Enum.map(
        &Range.new(String.to_integer(Enum.at(&1, 0)), String.to_integer(Enum.at(&1, 1)))
      )

    Enum.map(ranges, &Enum.to_list(&1))
  end

  defp overlaps?(assignments_str) do
    [rg1, rg2] = parse_range_lists(assignments_str)
    rg1_in_rg2 = Enum.all?(rg1, &Enum.member?(rg2, &1))
    rg2_in_rg1 = Enum.all?(rg2, &Enum.member?(rg1, &1))
    rg1_in_rg2 or rg2_in_rg1
  end

  defp partial_overlaps?(assignments_str) do
    [rg1, rg2] = parse_range_lists(assignments_str)
    rg1_in_rg2 = Enum.any?(rg1, &Enum.member?(rg2, &1))
    rg2_in_rg1 = Enum.any?(rg2, &Enum.member?(rg1, &1))
    rg1_in_rg2 or rg2_in_rg1
  end
end

AdventOfCode04.solve()
