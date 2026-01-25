% scrieti un thread care primeste mesaje constituind operatii
% pe liste de forma {map, plus_1, List, From}
%                   {filter, odd, List, From}
%                   {sum, List, From}
%                   {product, List, From}

-module(list_processor).

-export([start/0]).

start() ->
    spawn(fun() -> loop() end).

loop() ->
    receive
        {map, plus_1, List, From} ->
            Result = [X + 1 || X <- List],
            From ! {result, Result},
            loop();
        {filter, odd, List, From} ->
            Result = [X || X <- List, X rem 2 /= 0],
            From ! {result, Result},
            loop();
        {sum, List, From} ->
            Result = lists:sum(List),
            From ! {result, Result},
            loop();
        {product, List, From} ->
            Result = lists:foldl(fun(X, Acc) -> X * Acc end, 1, List),
            From ! {result, Result},
            loop();
        Unknown ->
            io:format("Comanda necunoscuta: ~p~n", [Unknown]),
            loop()
    end.
