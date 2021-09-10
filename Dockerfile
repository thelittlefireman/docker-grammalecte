FROM python:3.7-alpine AS src

ENV VERSION 2.1.1

RUN apk add --update --no-cache \
      unzip \
      wget \
 && wget https://grammalecte.net/grammalecte/zip/Grammalecte-fr-v${VERSION}.zip \
 && unzip Grammalecte-fr-v${VERSION}.zip -d /srv

FROM python:3.7-alpine

COPY --from=src /srv/ /srv

ENV PYTHONUNBUFFERED TRUE

EXPOSE 8080

WORKDIR /srv

ENTRYPOINT ["python3"]

CMD ["grammalecte-server.py","-ht", "0.0.0.0","-p","8080","-t"]
