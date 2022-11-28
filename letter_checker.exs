defmodule LetterChecker do
  def call(guess, secret) do
    guess
    |> correct_pass(secret)
    |> partial_pass(guess)
  end

  def correct_pass(guess, secret_letters) do
    secret_letter_charlist = String.to_charlist(secret_letters)

    {result, remainders} =
      guess
      |> Enum.zip(initial_state(secret_letter_charlist))
      |> Enum.reduce({[], secret_letter_charlist}, fn {guess, {_status, secret_letter}},
                                                       {result, remaining_letters} ->
        compare_letter(guess, secret_letter, result, remaining_letters)
      end)
      {Enum.reverse(result), remainders}
  end

  def compare_letter(guess, _, result, remaining_letters) do
    {[{:correct, to_string([guess])} | result], remaining_letters -- [guess]}
  end

  def compare_letter(guess, _, result, remaining_letters) do
    {[{:incorrect, to_string([guess])} | result], remaining_letters}
  end

  def partial_pass({letter_state, remainders}, guess) do
    {result, remainders} =
      guess
      |> String.to_charlist()
      |> Enum.zip(letter_state)
      |> Enum.reduce({[], remainders}, fn {guess, {status, _secret_letter}},
                                          {result, remaining_letters} ->
        partial_match(guess, status, remaining_letters, result)
      end)

      {Enum.reverse(result), remainders}
  end

  defp partial_match(guess, :correct, remainders, result) do
    {[{:correct, to_string([guess])} | result], remainders}
  end

  defp partial_match(guess, _, remainders, result) do
    cond do
      Enum.member?(remainders, guess) ->
        {[{:partial, to_string([guess])} | result], remainders -- [guess]}

      true ->
        {[{:incorrect, to_string([guess])} | result], remainders}
    end
  end
end
