-module(automat).

-export([start/0, squirrel/1, pet/1]).

squirrel(Pid) ->
    Pid ! squirrel. % actiunea see_squirrels

pet(Pid) ->
    Pid ! pet. % actiunea gets_petted

start() ->
    spawn(fun() -> bark() end). % starea initiala

bark() ->
    io:format("Dog says: BARK! BARK!~n"),
    receive
        pet ->
            wag_tail();
        _ ->
            io:format("Dog is confused~n"),
            bark()
    after 2000 ->
        bark()
    end.

wag_tail() ->
    io:format("Dog wags its tail~n"),
    receive
        pet ->
            sit();
        _ ->
            io:format("Dog is confused~n"),
            wag_tail()
    after 30000 ->
        bark() % actiunea waits
    end.

sit() ->
    io:format("Dog is sitting. Gooooood boy!~n"),
    receive
        squirrel ->
            bark();
        _ ->
            io:format("Dog is confused~n"),
            sit()
    end.
