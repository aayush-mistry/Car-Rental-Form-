FROM ubuntu:20.04

# Avoid user interaction during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Mono repository
RUN apt-get update && apt-get install -y ca-certificates gnupg && rm -rf /var/lib/apt/lists/*

# Add Mono official repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" > /etc/apt/sources.list.d/mono-official-stable.list

# Install mono, xsp4, and sqlite3 from Mono repository and Ubuntu
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
