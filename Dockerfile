FROM elixir

RUN apt-get update -y && \
    apt-get install -y build-essential git

WORKDIR /bin

# install goon
RUN wget https://github.com/alco/goon/releases/download/v1.1.1/goon_linux_amd64.tar.gz && \
    tar -xvzf goon_linux_amd64.tar.gz -C /usr/local/bin

# install yt-dlp
RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

# install ffmpeg
RUN apt-get install ffmpeg -y

WORKDIR /app

COPY . .
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile

WORKDIR "/app"

CMD ["mix", "run", "--no-halt"]

