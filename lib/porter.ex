defmodule Porter do
  use Application
  alias Alchemy.{Client, Cogs}

  defmodule Commands do
    use Alchemy.Cogs
    alias Alchemy.{Client, Voice}

    Cogs.set_parser(:play, &List.wrap/1)

    # Cogs.def join(id) do
    #   {:ok, channels} = Client.get_channels(id)
    #   Voice.join(id, default_voice_channel.id)
    # end

    Cogs.def play(query) do
      {:ok, id} = Cogs.guild_id()

      {:ok, url} = Utils.search(query)

      Voice.stop_audio(id)

      {:ok, channels} = Client.get_channels(id)

      default_voice_channel = Enum.find(channels, &match?(%{name: "Spoilers"}, &1))
      |> IO.inspect()

      Voice.join(id, default_voice_channel.id)
      Voice.play_url(id, url)
      Cogs.say("Now playing #{url}")
    end

    Cogs.def stop do
      {:ok, id} = Cogs.guild_id()
      Voice.stop_audio(id)
    end

    Cogs.def leave do
      {:ok, id} = Cogs.guild_id()

      case Voice.leave(id) do
        :ok -> nil
        {:error, error} -> Cogs.say("Oops #{error}")
      end
    end
  end

  def start(_type, _args) do
    token = Application.fetch_env!(:porter, :discord_token)
    prefix = Application.fetch_env!(:porter, :prefix)

    run = Client.start(token)
    use Commands
    Cogs.set_prefix(prefix)
    run
  end
end
