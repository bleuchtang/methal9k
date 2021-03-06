defmodule Hal do
  @moduledoc """
  Initialize an IRC connection based on various credentials and parameters
  """

  use Application

  defmodule State do
    @moduledoc """
    This module holds the global hal9k state in order to have a nice IRC
    connection. Those informations are:
    - `client` store the ExIrc client state
    - `host` irc host (chat.freenode.net)
    - `port`  irc port (6697)
    - `chans` irc channels (["#awesome-chan", "#pulp-fiction"]
    - `nick` login for the irc server
    - `pass` the associated password
    - `user` misc infos
    - `name` misc infos
    - `uids` ETS table storing the current jobs being run
    """

    defstruct client: nil,
      host: "127.0.0.1",
      port: 6697,
      chans: ["#hal", "#test"],
      nick: "hal",
      name: "hal",
      user: "hal",
      pass: "",
      uids: %{}
  end

  def start(_type, [credentials]) do
    import Supervisor.Spec, warn: false

    # read config file or fallback to internal configuration
    confs = parse_conf(credentials)

    # launch Mnesia
    :mnesia.create_schema([node()])
    :mnesia.start()

    # static processes
    children = [
      worker(Hal.Keeper, [[], [name: :hal_keeper]]),
      worker(Hal.Shepherd, [[], [name: :hal_shepherd]]),
      supervisor(Hal.IrcSupervisor, [confs, []])
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp parse_conf(credentials) do
    try do
      YamlElixir.read_all_from_file(credentials)
    catch
      _ -> [%State{}]
    else
      [yaml] ->
        Enum.map(yaml["servers"], fn(s) ->
          %State{host: s["host"],
                 port: s["port"],
                 chans: s["chans"],
                 nick: s["nick"],
                 name: s["name"],
                 user: s["user"],
                 pass: s["pass"]}
        end)
    end
  end

end
