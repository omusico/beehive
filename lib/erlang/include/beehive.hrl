-define(PROXY_HANDLER, proxy_handler).

% Extra time to give an app instance breathing room
-define (TIME_BUFFER, 20).

-define(BUFSIZ, (128*1024)).

% Time period to kill an instance after: defaults to an hour
-define (RUN_INSTANCE_TIME_PERIOD, 3600).

% Max bees available on every host
-define (MAX_BACKENDS_PER_HOST, 3).

% Get the fields of a record into a proplist
-define(rec_info(T,R),lists:zip(record_info(fields,T),tl(tuple_to_list(R)))). 

% Messages
-define (NEEDS_BACKEND_MSG, needs_bee).
-define (BACKEND_TIMEOUT_MSG, bee_timeout).
-define (MUST_WAIT_MSG, bee_must_wait).

% STORES
-define (WAIT_DB, waiting_db).

% EVENTS
-define (EVENT_MANAGER, event_manager).
-define (NOTIFY (Event), ?EVENT_MANAGER:notify(Event)).

% Port to start on
-define (STARTING_PORT, 5001).

% Expand when
-define (EXPAND_WHEN_PENDING_REQUESTS, 3).

% Time (in seconds) to check the directory for new apps
-define (IDLE_TIMEOUT, timer:seconds(30)).
-define (CONNECT_TIMEOUT, timer:seconds(5)).
-define (MAX_HEADERS, 100).
% Maximum recv_body() length of 1MB
-define(MAX_RECV_BODY, (1024*1024)).
-define (MAX_INSTANCES_PER_NODE, 20).

% Default KV store
-define (QSTORE, queue_store).

% Application bee
% Yes, the id is redundant, optimization of this might be ideal... i.e. remove the host/port/app_name
% fields
-record (bee, {
  id,                       % tuple id of the app_name, host and port {app_name, host, port}
  app_name,                 % name of the app this bee supports
  host,
  port,
  routing_param,            % meta data on the bee allows for more granualar abstract parameters
                            % should be a tuple, e.g. {ports: 2}
  start_time    = 0,        % starting time
  pid,                      % pid of os port process
  sticky        = false,    % keep this bee around, don't remove it from the bee list if it dies
  lastresp_time = 0,
  lasterr       = 0,
  lasterr_time  = 0,
  act_time      = 0,
  status        = ready,    % pending | ready | broken
  maxconn       = 10,
  act_count     = 0
}).

% Application configuration
-record (app, {
  name,
  path,
  url,
  concurrency,
  routing_param = undefined,        % determine the method of choosing the backend
  timeout,
  sticky        = false,            % if an app is sticky, the apps are not requested after timeout time
  min_instances,
  max_instances,
  updated_at,
  user,
  group,
  start_command,
  stop_command
}).

% User levels
-define (ADMIN_USER_LEVEL, 1).
-define (REGULAR_USER_LEVEL, 2).

% User
-record (user, {
  email,
  password,
  key,
  token,
  level   = ?REGULAR_USER_LEVEL
}).


-record (bee_pid, {pid, status, start_time, bee_name}).

%% Overall proxy_state of the proxy
-record(proxy_state, {
  local_port,				          % Local TCP port number
  local_host,                 % Local host ip tuple or name
  conn_timeout = (1*1000),		% Connection timeout (ms)
  act_timeout = (120*1000),		% Activity timeout (ms)
  acceptor,				            % Pid of listener proc
  start_time  = 0,            % Proxy start timestamp
  to_timer 				            % Timeout timer ref
}).

% Stats for a bee
-record (bee_stat, {
  total_requests,   % total requests for the bee
  current,          % current number of requests
  total_time,       % total active time
  average_req_time, % average request time
  % packets
  packet_count,     % total packet counts
  bytes_received    % total bytes received by packet
}).

-record (node, {
  name,               % name of the node
  host                % host of the node (ip)
}).

-record (http_request, {
  client_socket,
  version = {1,1},
  headers = [],
  body = [],
  method,
  path,
  length = 0
}).