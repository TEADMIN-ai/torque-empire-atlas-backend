FROM rocker/r-ver:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Plumber in R
RUN R -e "install.packages('plumber', repos='https://cloud.r-project.org')"

# Create app directory
WORKDIR /srv/shiny-server

# Copy API files
COPY ./api ./api
COPY docker/run_api.R ./run_api.R
COPY docker/start_servers.sh ./start_servers.sh

# Make sure the script is executable
RUN chmod +x ./start_servers.sh

# Optional: Healthcheck
# HEALTHCHECK CMD curl --fail http://localhost:8000/__docs__/ || exit 1

# Set startup command
CMD ["bash", "./start_servers.sh"]

