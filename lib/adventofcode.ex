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
    total_points = Enum.sum(round_scores)
    IO.puts("SCORE: " <> to_string(total_points))
  end

  def score_round(pair_list) when pair_list == [@p1_rock, @p2_paper] do
    # Paper covers rock, p2 wins
    @paper_val + @win_val
  end

  def score_round(pair_list) when pair_list == [@p1_rock, @p2_scissors] do
    # Rock breaks scissors, p2 loses
    @scissors_val + @loss_val
  end

  def score_round(pair_list) when pair_list == [@p1_paper, @p2_rock] do
    # Paper covers rock, p2 loses
    @rock_val + @loss_val
  end

  def score_round(pair_list) when pair_list == [@p1_paper, @p2_scissors] do
    # Scissors cut paper, p2 wins
    @scissors_val + @win_val
  end

  def score_round(pair_list) when pair_list == [@p1_scissors, @p2_rock] do
    # Rock breaks scissors, p2 wins
    @rock_val + @win_val
  end

  def score_round(pair_list) when pair_list == [@p1_scissors, @p2_paper] do
    # Scissors cut paper, p2 loses
    @paper_val + @loss_val
  end

  def score_round(pair_list) when pair_list == [@p1_rock, @p2_rock] do
    # both rock, draw
    @rock_val + @tie_val
  end

  def score_round(pair_list) when pair_list == [@p1_paper, @p2_paper] do
    # both paper, draw
    @paper_val + @tie_val
  end

  def score_round(pair_list) when pair_list == [@p1_scissors, @p2_scissors] do
    # both scissors, draw
    @scissors_val + @tie_val
  end
end

AdventOfCode02.solve()
