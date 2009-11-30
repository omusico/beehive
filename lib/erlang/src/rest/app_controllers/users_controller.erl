%%%-------------------------------------------------------------------
%%% File    : users_controller.erl
%%% Author  : Ari Lerner
%%% Description : 
%%%
%%% Created :  Sat Nov 28 23:03:51 PST 2009
%%%-------------------------------------------------------------------

-module (users_controller).

-include ("beehive.hrl").
-include ("http.hrl").
-export ([get/1, post/2, put/2, delete/2]).

get(_) -> 
  All = users:all(),
  {struct, [{
    "users",
    lists:map(fun(A) ->
      {struct, ?BINIFY([
        {"email", A#user.email}
      ])}
    end, All)
  }]}.

post(["new"], Data) ->
  auth_utils:run_if_admin(fun() ->
    case users:create(Data) of
      User when is_record(User, user) -> 
        {struct, ?BINIFY([{"user", misc_utils:to_bin(User#user.email)}])};
      _ -> "There was an error adding bee\n"
    end
  end, Data);
      
post(_Path, _Data) -> "unhandled".
put(_Path, _Data) -> "unhandled".

delete([], Data) ->
  auth_utils:run_if_admin(fun() ->
    case proplists:is_defined(email, Data) of
      false -> misc_utils:to_bin("No email given");
      true ->
        Email = proplists:get_value(email, Data),
        users:delete(Email)
    end
  end, Data);
delete(_Path, _Data) -> "unhandled".