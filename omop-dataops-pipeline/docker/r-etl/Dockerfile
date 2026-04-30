FROM rocker/r-ver:4.2.0

# Установка системных зависимостей для R-пакетов OHDSI
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    openjdk-11-jdk \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Настройка Java для R
RUN R CMD javareconf

# Установка менеджера пакетов и основных библиотек OHDSI
RUN R -e "install.packages('remotes')" \
    && R -e "remotes::install_github('OHDSI/DatabaseConnector')" \
    && R -e "remotes::install_github('OHDSI/SqlRender')" \
    && R -e "remotes::install_github('OHDSI/ETL-Synthea')"

# Папка для драйверов БД и скриптов
RUN mkdir -p /drivers /scripts /data
WORKDIR /scripts

# По умолчанию запускаем наш будущий скрипт маппинга
CMD ["Rscript", "run_etl.R"]