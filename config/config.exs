import Config

config :porter,
  discord_token: System.get_env("DISCORD_TOKEN"),
  prefix: "!"

config :alchemy,
  ffmpeg_path: "ffmpeg",
  youtube_dl_path: "/usr/local/bin/yt-dlp"
