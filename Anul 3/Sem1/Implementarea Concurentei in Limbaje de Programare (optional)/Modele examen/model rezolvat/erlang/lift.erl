-module(lift).

-export([start/0, stop/0, client/2, lift_loop/1]).

% Start the Lift process
start() ->
    Pid = spawn(lift, lift_loop, [0]), % Start at Ground Floor (0)
    register(lift_pid, Pid),
    io:format("Lift started at Floor 0.~n"),
    % Spawn clients driven by a main coordinator or just for demo
    spawn(lift, client, [lift_pid, 3]), % Client wants to go to Floor 3
    spawn(lift, client, [lift_pid, 1]), % Client wants to go to Floor 1
    spawn(lift, client, [lift_pid, 5]), % Client wants to go to Floor 5
    ok.

stop() ->
    lift_pid ! stop,
    ok.

% Lift Process Loop
% State: CurrentFloor
lift_loop(CurrentFloor) ->
    receive
        {call, TargetFloor, ClientPid} ->
            io:format("Lift: Received call for Floor ~p (Current: ~p)~n",
                      [TargetFloor, CurrentFloor]),
            move_lift(CurrentFloor, TargetFloor),
            ClientPid ! {arrived, TargetFloor},
            lift_loop(TargetFloor);
        stop ->
            io:format("Lift: Stopping.~n"),
            ok;
        _ ->
            io:format("Lift: Unknown message.~n"),
            lift_loop(CurrentFloor)
    end.

% Helper to simulate movement
move_lift(Current, Target) when Current == Target ->
    io:format("Lift: Already at Floor ~p. Opening doors.~n", [Current]);
move_lift(Current, Target) when Current < Target ->
    io:format("Lift: Moving UP from ~p to ~p...~n", [Current, Current + 1]),
    timer:sleep(500), % Simulate travel time
    move_lift(Current + 1, Target);
move_lift(Current, Target) when Current > Target ->
    io:format("Lift: Moving DOWN from ~p to ~p...~n", [Current, Current - 1]),
    timer:sleep(500),
    move_lift(Current - 1, Target).

% Client Process
client(LiftPid, TargetFloor) ->
    io:format("Client ~p: Calling lift to go to Floor ~p~n", [self(), TargetFloor]),
    LiftPid ! {call, TargetFloor, self()},
    receive
        {arrived, Floor} ->
            io:format("Client ~p: Arrived at Floor ~p. Exiting.~n", [self(), Floor])
    end.
