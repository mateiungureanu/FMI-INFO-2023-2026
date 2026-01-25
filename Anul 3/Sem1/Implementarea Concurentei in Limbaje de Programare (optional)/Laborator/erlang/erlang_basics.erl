-module(erlang_basics).

-export([sum/2, sum_even/1, myThread/0, main/1]).

% sum / 2
sum(X, Y) ->
  X + Y.

% fibo / 1
fibo(X) when X < 1 ->
  0;
fibo(X) when X =:= 1 ->
  1;
fibo(X) ->
  fibo(X - 1) + fibo(X - 2).

% sum_even / 1
sum_even([]) ->
  0;
sum_even([H | T]) ->
  if H rem 2 =:= 0 ->
       H + sum_even(T);
     true ->
       sum_even(T)
  end.

% functiile inline (anonime) au sintaxa fun (arg) -> body end
% lists:map(fun(X) -> X + 1 end, L)
% lists:filter(fun(X) -> cond(X) end, L)

% pentru a pornit un thread se foloseste functia spawn
% spawn(inline function)

% Pid ! msg
% receive ... end.

myThread() ->
  io:format("Running ~p...~n", [self()]),
  receive
    {hello, From} ->
      io:format("Hello, ~p!~n", [From]),
      myThread();
    {sum_even, List} ->
      io:format("Sum even of ~p is ~p~n", [List, sum_even(List)]),
      myThread();
    {send_random, From} ->
      From ! random,
      myThread();
    _ ->
      io:format("Unknown command~n"),
      myThread()
  end.

main(_) ->
  io:format("O   diimineata ~p  ..... FRUMOASA ~p !!! .... ~n Spor la cafeluta "
            "! ~n",
            [[1, 2, 3], 2]),
  Sum = sum(2, 5),
  io:format("Suma este ~p~n", [Sum]),
  X = 10,
  io:format("Fibo(~p) = ~p~n", [X, fibo(X)]),
  L = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  io:format("Suma elementelor pare din ~p este ~p~n", [L, sum_even(L)]),
  io:format("Map (+1) ~p = ~p~n", [L, lists:map(fun(N) -> N + 1 end, L)]),
  People =
    [{andrew, male, 42},
     {olivia, female, 35},
     {peter, male, 60},
     {andy, male, 25},
     {mary, female, 36}],
  % determinam numele barbatilor care au peste 40 de ani -> [andrew, peter]
  FilteredPeople =
    lists:filter(fun({_, Gender, Age}) -> Gender == male andalso Age >= 40 end, People),
  io:format("Barbatii peste 40 de ani sunt ~p~n",
            [lists:map(fun({Name, _, _}) -> Name end, FilteredPeople)]),
  Pid = spawn(fun() -> myThread() end),
  io:format("Pornim thread-ul ~p~n", [Pid]),
  Pid ! {hello, self()},
  Pid ! taci,
  Pid ! {sum_even, L},
  Pid ! {send_random, self()},
  receive
    random ->
      io:format("Am primit~n");
    _ ->
      io:format("Unknown command")
  end,
  timer:sleep(500),
  MyList = [N || N <- L, N rem 2 =:= 0],
  io:format("MyList = ~p~n", [MyList]).
