FROM mono:latest

# Install sqlite3
RUN apt-get update && apt-get install -y sqlite3 mono-xsp4 nuget && rm -rf /var/lib/apt/lists/*

# Set up application directory
WORKDIR /app

# Copy all source files
COPY . .

# Install System.Data.SQLite.Core and copy to bin/
RUN nuget install System.Data.SQLite.Core -Version 1.0.118.0 -OutputDirectory packages
RUN mkdir -p bin && cp packages/System.Data.SQLite.Core.1.0.118.0/lib/net46/System.Data.SQLite.dll bin/

# Initialize SQLite database
RUN mkdir -p App_Data
RUN sqlite3 App_Data/CarRentalDB.sqlite < Database/CarRental_SQLite.sql

# Expose port for Render
EXPOSE 8080

# Start xsp4 web server
CMD ["xsp4", "--port", "8080", "--nonstop"]
