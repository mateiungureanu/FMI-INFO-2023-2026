-module(problema3).

-export([main/1]).

% Feeder loop
% State: Status (idle | feeding), Queue (list of Pids)
feeder_loop(Status, Queue) ->
    receive
        {From, request_food} ->
            io:format("Feeder received request from Cat ~p~n", [From]),
            case Status of
                idle ->
                    From ! {self(), grant_food},
                    io:format("Feeder: Feeding Cat ~p directly~n", [From]),
                    feeder_loop(feeding, Queue);
                feeding ->
                    io:format("Feeder: Busy, adding Cat ~p to queue~n", [From]),
                    feeder_loop(feeding, Queue ++ [From])
            end;
        {From, finished_eating} ->
            io:format("Feeder: Cat ~p finished eating~n", [From]),
            case Queue of
                [] ->
                    io:format("Feeder: Queue empty, going idle~n"),
                    feeder_loop(idle, []);
                [NextCat | RestQueue] ->
                    NextCat ! {self(), grant_food},
                    io:format("Feeder: Feeding next Cat ~p from queue~n", [NextCat]),
                    feeder_loop(feeding, RestQueue)
            end
    end.

% Cat Logic
cat_logic(FeederPid, Name) ->
    % Request food
    io:format("Cat ~p (~s): Waiting (Requesting food)~n", [self(), Name]),
    FeederPid ! {self(), request_food},

    % Wait for permission
    receive
        {FeederPid, grant_food} ->
            io:format("Cat ~p (~s): Eating...~n", [self(), Name]),
            timer:sleep(3000), % Eat for 3 seconds
            io:format("Cat ~p (~s): Finished eating.~n", [self(), Name]),
            FeederPid ! {self(), finished_eating}
    end.

main(_) ->
    % Spawn Feeder
    Feeder = spawn(fun() -> feeder_loop(idle, []) end),
    io:format("Feeder started ~p~n", [Feeder]),

    % Spawn 5 Cats
    CatNames = ["Miau", "Chit", "Garfield", "Tom", "Sylvester"],

    SpawnCat = fun(Name) -> spawn(fun() -> cat_logic(Feeder, Name) end) end,

    lists:foreach(SpawnCat, CatNames),

    % Keep main alive for simulation to complete (simple sleep)
    % 5 cats * 3 seconds = 15 seconds min.
    timer:sleep(20000),
    io:format("Simulation finished.~n").
