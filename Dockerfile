FROM ubuntu:22.04

# Avoid user interaction during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install mono, xsp4, nuget and sqlite3 from Ubuntu repositories
RUN apt-get update && apt-get install -y \
    mono-complete \
    mono-xsp4 \
    nuget \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Set up application directory
WORKDIR /app

# Copy all source files
COPY . .

# Install System.Data.SQLite.Core and copy to bin/
# Using 1.0.115.5 to avoid a nuget dependency parsing bug in Ubuntu's older nuget package
RUN nuget install System.Data.SQLite.Core -Version 1.0.115.5 -OutputDirectory packages
RUN mkdir -p bin && cp packages/System.Data.SQLite.Core.1.0.115.5/lib/net46/System.Data.SQLite.dll bin/

# Initialize SQLite database
RUN mkdir -p App_Data
RUN sqlite3 App_Data/CarRentalDB.sqlite < Database/CarRental_SQLite.sql

# Expose port for Render
EXPOSE 8080

# Start xsp4 web server
CMD ["xsp4", "--port", "8080", "--nonstop"]
