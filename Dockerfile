FROM thehyve/ohdsi-r-base:3.6.1

RUN install.r \
      data.table \
      bit64 \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

WORKDIR /opt/app
COPY . /opt/app

RUN install.r . \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && mv docker-etl-synthea /usr/local/bin/etl-synthea \
  && chmod +x /usr/local/bin/etl-synthea

CMD ["etl-synthea"]
