FROM ubuntu:22.04

# Avoid user interaction during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install mono, xsp4, and sqlite3 from Ubuntu repositories (removed nuget)
RUN apt-get update && apt-get install -y \
    mono-complete \
    mono-xsp4 \
    sqlite3 \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set up application directory
WORKDIR /app

# Copy all source files
COPY . .

# Download System.Data.SQLite.Core manually to bypass nuget bugs on Ubuntu Mono
RUN curl -L -o sqlite.zip "https://www.nuget.org/api/v2/package/Stub.System.Data.SQLite.Core.NetFramework/1.0.118.0" && \
    unzip sqlite.zip -d sqlite_pkg && \
    mkdir -p bin && \
    cp sqlite_pkg/lib/net46/System.Data.SQLite.dll bin/ && \
    rm -rf sqlite.zip sqlite_pkg

# Initialize SQLite database
RUN mkdir -p App_Data
RUN sqlite3 App_Data/CarRentalDB.sqlite < Database/CarRental_SQLite.sql

# Expose port for Render
EXPOSE 8080

# Start xsp4 web server
CMD ["xsp4", "--port", "8080", "--nonstop"]
