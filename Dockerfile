# ?? Torque Empire Backend — Shiny + Plumber API Hybrid
FROM rocker/shiny:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libv8-dev \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /srv/shiny-server/

# Copy project files
COPY . .

# Copy Shiny server configuration
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# Install R packages (including plumber)
RUN R -e "install.packages(c('shiny','plumber','future','ggplot2','dplyr','plotly','DT','httr','jsonlite','curl'), repos='https://cloud.r-project.org/')"

# Expose ports for both Shiny and API
EXPOSE 3838 8000

# Start both servers in parallel
CMD R -e "future::plan('multisession'); \
          shiny::runApp('/srv/shiny-server/app.R', port=3838, host='0.0.0.0', launch.browser=FALSE) & \
          pr <- plumber::plumb('/srv/shiny-server/api.R'); \
          pr(host='0.0.0.0', port=8000)"
