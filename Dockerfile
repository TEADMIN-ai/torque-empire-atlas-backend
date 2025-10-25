FROM rocker/r-ver:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpq-dev \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('plumber', 'jsonlite', 'DBI', 'RPostgres', 'future'), repos = 'https://cloud.r-project.org')"

# Set working directory
WORKDIR /srv/shiny-server

# Copy project files into container
COPY ./api ./api
COPY docker/start_servers.sh ./start_servers.sh
COPY docker/run_api.R ./run_api.R

# Make startup script executable
RUN chmod +x ./start_servers.sh

# Expose Plumber API port
EXPOSE 8000

# Launch script
CMD ["bash", "./start_servers.sh"]
