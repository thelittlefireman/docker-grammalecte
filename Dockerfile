FROM python:3.7-alpine AS src

ENV VERSION 2.1.1

RUN apk add --update --no-cache \
      unzip \
      wget \
 && wget https://grammalecte.net/grammalecte/zip/Grammalecte-fr-v${VERSION}.zip \
 && unzip Grammalecte-fr-v${VERSION}.zip -d /srv

# FIX
RUN sed -e "s/    if sys.version_info.major < (3, 7):/    if sys.version_info.major < 3 and sys.version_info.minor < 7:/g" /srv/grammalecte-server.py > /srv/grammalecte-server.py.tmp && mv /srv/grammalecte-server.py.tmp /srv/grammalecte-server.py

FROM python:3.7-alpine

COPY --from=src /srv/ /srv

ENV PYTHONUNBUFFERED TRUE

EXPOSE 8080

WORKDIR /srv

ENTRYPOINT ["python3"]

CMD ["grammalecte-server.py","-ht", "0.0.0.0","-p","8080","-t"]
