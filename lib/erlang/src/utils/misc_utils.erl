-module (misc_utils).
-compile (export_all).

-define (ADJECTIVES, [
  "fast", "quick", "clean", "positive", "generous", "silly", "enjoyable", "friendly", "flighty", "handsome"
]).

-define (NOUNS, [
  "giant", "bee", "queenbee", "sound", "music", "honey", "smile", "balloon", "bird", "wind", "dog", "cat"
]).

-define (LETTERS, "abcdefghijklmnopqrstuvwxyz0123456789").

generate_unique_name(Num) ->
  lists:flatten([
    random_word(?ADJECTIVES),"-",
    random_word(?NOUNS),"-",
    random_word(?LETTERS, Num, [])
  ]).

random_word(_, 0, Acc) -> lists:reverse(Acc);
random_word(List, Length, Acc) ->
  random_word(List, Length - 1, [random_word(List)|Acc]).
  
random_word(List) ->
  lists:nth(random:uniform(erlang:length(List)), List).
  
to_list(Bin) when is_binary(Bin) -> erlang:binary_to_list(Bin);
to_list(Atom) when is_atom(Atom) -> erlang:atom_to_list(Atom);
to_list(Float) when is_float(Float) -> erlang:float_to_list(Float);
to_list(Int) when is_integer(Int) -> erlang:integer_to_list(Int);
to_list(List) -> List.

to_atom(Bin) when is_binary(Bin) -> to_atom(erlang:binary_to_list(Bin));
to_atom(List) when is_list(List) -> erlang:list_to_atom(List);
to_atom(Atom) -> Atom.

to_bin(undefined) -> <<"undefined">>;
to_bin(Tuple) when is_tuple(Tuple) -> to_bin(erlang:term_to_binary(Tuple));
to_bin(Atom) when is_atom(Atom) -> to_bin(erlang:atom_to_list(Atom));
to_bin(Int) when is_integer(Int) -> to_bin(erlang:integer_to_list(Int));
to_bin(Float) when is_float(Float) -> to_bin(erlang:float_to_list(Float));
to_bin(List) when is_list(List) -> erlang:list_to_binary(List);
to_bin(Bin) -> Bin.

to_integer(Str) when is_list(Str) -> erlang:list_to_integer(Str);
to_integer(Int) -> Int.

max([]) -> 0;
max([H|T]) -> max(H, T).
max(M, []) -> M;
max(M, [H|L]) when M > H -> max(M, L);
max(_M, [H|L]) -> max(H,L).

% Only choose values that are actually in the proplist
filter_proplist(_Proplist, [], Acc) -> Acc;
filter_proplist(Proplist, [{K,V}|Rest], Acc) ->
  case proplists:is_defined(K, Proplist) of
    false -> filter_proplist(Proplist, Rest, Acc);
    true -> filter_proplist(Proplist, Rest, [{K,V}|Acc])
  end.

new_or_previous_value(_NewProplist, [], Acc) -> Acc;
new_or_previous_value(NewProplist, [{K,V}|Rest], Acc) ->
  case proplists:is_defined(K,NewProplist) of
    true -> 
      NewV = proplists:get_value(K, NewProplist),
      new_or_previous_value(NewProplist, Rest, [{K, NewV}|Acc]);
    false ->
      new_or_previous_value(NewProplist, Rest, [{K, V}|Acc])
  end.

% From rabbitmq
localnode(Name) ->
  list_to_atom(lists:append([atom_to_list(Name), "@", nodehost(node())])).

nodehost(Node) ->
  tl(lists:dropwhile(fun (E) -> E =/= $@ end, atom_to_list(Node))).
