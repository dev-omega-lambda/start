defmodule Chain do
  def counter do
    receive do
      n ->
        send next_pid, n + 2
    end
  end  

  def create_processes(n) do
    code_to_run = fn (_, send_to) -> 
      spawn(Chain, :counte, [send_to])
    end

    last = Enum.reduce(1..n, self(), code_to_run)

    send(last, 0)

    receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect(final_answer)}"
    end 
  end
  
  def run(n) do
    :timer.tc(Chain, :create_processes, [n])
    |> IO.inspect()
  end
end
