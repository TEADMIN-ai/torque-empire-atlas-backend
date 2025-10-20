FROM rocker/shiny:latest

# Install dependencies for httr/plotly etc.
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libv8-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/shiny-server/
COPY . .
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN R -e "install.packages(c('shiny','ggplot2','dplyr','plotly','DT','httr','jsonlite','curl'), repos='https://cloud.r-project.org/')"

EXPOSE 3838
CMD ["/usr/bin/shiny-server"]
