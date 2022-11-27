defmodule LetterChecker do
  def call(guess, secret, letters) do
    cond do
      guess == secret -> {:correct, to_string([guess])}
      guess in letters -> {:partial, to_string([guess])}
      true -> {:incorrect, to_string([guess])}
    end
  end
end
