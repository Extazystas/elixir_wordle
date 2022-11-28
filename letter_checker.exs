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
      |> Enum.reduce({[], secret_letter_charlist}), fn {guess_letter, {_status, secret_letter}},
                                                       {result, remaining_letters} ->
                                                        compare_letters()
                                                       end
  end
end
