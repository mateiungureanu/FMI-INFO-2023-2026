-module(library).

-export([start_parking/1, start_car/1, main/1]).

% Problem: Library Terminal (from parcare.erl lines 126-135)
% Mapping:
% - Parking -> Terminal
% - Car -> Student
% - Gate -> Removed (Not in Library Model)

start_parking(TotalSpaces) ->
  spawn(fun() -> parking_loop(idle, TotalSpaces, []) end).

% parametrizata de stare, numarul maxim de locuri, si lista masinilor
parking_loop(State, SpacesLeft, Cars) ->
  io:format("Terminal (Parking): Stare ~p, Locuri: ~p, Studenti: ~p~n",
            [State, SpacesLeft, Cars]),
  receive
    {request_entry, CarPid} when State =:= idle ->
      io:format("Terminal: Acces permis studentului ~p~n", [CarPid]),
      CarPid ! {entry_granted, self()},
      NewSpaces = SpacesLeft - 1,
      if NewSpaces == 0 ->
           parking_loop(in_use, 0, [CarPid | Cars]);
         true ->
           parking_loop(idle, NewSpaces, [CarPid | Cars])
      end;
    {request_entry, CarPid} when State =:= in_use ->
      io:format("Terminal: Ocupat (Full). Studentul ~p asteapta.~n", [CarPid]),
      parking_loop(in_use, SpacesLeft, Cars);
    {car_exit, CarPid} ->
      io:format("Studentul ~p elibereaza terminalul~n", [CarPid]),
      NewCars = lists:delete(CarPid, Cars),
      NewSpaces = SpacesLeft + 1,
      parking_loop(idle, NewSpaces, NewCars);
    _ ->
      io:format("Comanda invalida~n"),
      parking_loop(State, SpacesLeft, Cars)
  end.

% Removed GatePid argument as Library has no Gate
start_car(ParkingPid) ->
  spawn(fun() -> car_loop(waiting, ParkingPid) end).

car_loop(State, ParkingPid) ->
  io:format("Student (Masina) ~p: Stare ~p~n", [self(), State]),
  case State of
    waiting ->
      ParkingPid ! {request_entry, self()},
      receive
        {entry_granted, _Parking} ->
          % Removed Gate interactions
          io:format("Student ~p: Incepe cautarea (Searching)~n", [self()]),
          car_loop(searching, ParkingPid);
        _ ->
          io:format("Acces refuzat pt ~p. Retrying...~n", [self()]),
          timer:sleep(1000),
          car_loop(waiting, ParkingPid)
      after 1000 ->
        io:format("Student ~p: Timeout waiting for access. Retrying...~n", [self()]),
        car_loop(waiting, ParkingPid)
      end;
    searching ->
      timer:sleep(3000),
      io:format("Student ~p: Gata cautarea. Eliberam.~n", [self()]),
      ParkingPid ! {car_exit, self()},
      io:format("Student ~p: Pleaca.~n",
                [self()])    % car_loop(waiting, ParkingPid) -- Stop after one search usually
  end.

main(_) ->
  ParkingPid = start_parking(1),

  io:format("======== Simulam Studenti la Terminal =========~n"),
  _Car1 = start_car(ParkingPid),
  _Car2 = start_car(ParkingPid),
  _Car3 = start_car(ParkingPid),
  ok.
