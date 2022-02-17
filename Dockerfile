FROM elixir:1.12.3

ENV DEBCONF_NOWARNINGS yes

# Install libraries for Nerves development
RUN apt-get update && \
    apt-get install -y libc6-arm64-cross build-essential automake autoconf git squashfs-tools ssh-askpass pkg-config curl && \
    rm -rf /var/lib/apt/lists/*


# Install fwup (https://github.com/fwup-home/fwup)
ENV FWUP_VERSION="1.9.0"
RUN wget https://github.com/fwup-home/fwup/releases/download/v${FWUP_VERSION}/fwup_${FWUP_VERSION}_amd64.deb
RUN dpkg -i ./fwup_${FWUP_VERSION}_amd64.deb

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force
# Install Mix environment for Nerves
RUN mix archive.install hex nerves_bootstrap 1.10.5 --force

# Copy project files
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .

# Run forever
CMD ["sleep", "infinity"]
