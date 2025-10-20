# 🧠 Torque Empire Backend - Shiny + Plumber API

# Base image with R + Shiny preinstalled
FROM rocker/shiny:latest

# Install Linux dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libv8-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /srv/shiny-server/

# Copy project files
COPY . .

# Copy Shiny Server configuration
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# Install required R packages (including Plumber for API)
RUN R -e "install.packages(c('shiny', 'ggplot2', 'dplyr', 'plotly', 'DT', 'httr', 'jsonlite', 'curl', 'plumber'), repos='https://cloud.r-project.org/')"

# Expose ports for both Shiny (3838) and API (8000)
EXPOSE 3838 8000

# ✅ Start both Shiny and Plumber API
CMD R -e "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=3838, launch.browser=FALSE)" & \
    R -e "source('/srv/shiny-server/api.R')"