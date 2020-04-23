
FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Paris
ENV CRON 50 1 * * *

RUN useradd -m -d /app -s /bin/bash app
WORKDIR /app

RUN apt-get update \
    && apt-get install -y git cron libxmltv-perl python3 tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN git clone https://github.com/zubrick/tv_grab_fr_telerama.git \
    && cp tv_grab_fr_telerama/tv_grab_fr_telerama /usr/local/bin/tv_grab_fr_telerama \
    && echo "$CRON app /usr/local/bin/tv_grab_fr_telerama --output /app/all.xml" | tee -a /etc/cron.d/tv_grab

COPY entrypoint.sh /entrypoint.sh
COPY start.sh /start.sh

VOLUME /app
EXPOSE 8000

CMD /entrypoint.sh

