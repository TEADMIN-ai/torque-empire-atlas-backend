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
RUN Rscript -e "repos <- 'https://cloud.r-project.org'; \
  packages <- c('plumber','jsonlite','DBI','RPostgres','future'); \
  missing <- setdiff(packages, rownames(installed.packages())); \
  if (length(missing)) install.packages(missing, repos = repos); \
  message('Installed: ', paste(missing, collapse = ', '))"

# Set working directory
WORKDIR /srv/shiny-server

# Copy app and API files into container
COPY ./api ./api
COPY docker/start_servers.sh ./start_servers.sh
COPY docker/run_api.R ./run_api.R

# Make startup script executable
RUN chmod +x ./start_servers.sh

# Expose ports
EXPOSE 8000

# Start the Shiny and Plumber apps
CMD ["bash", "./start_servers.sh"]
