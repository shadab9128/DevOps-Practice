FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    fortune \
    cowsay \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

EXPOSE 4499
CMD ["bash", "/app/wisecow.sh"]
