CREATE DATABASE CarRentalDB;
GO

USE CarRentalDB;
GO

IF OBJECT_ID('dbo.RentalBookings', 'U') IS NOT NULL
    DROP TABLE dbo.RentalBookings;
GO

CREATE TABLE RentalBookings (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    CarCategory NVARCHAR(50) NOT NULL,
    CarName NVARCHAR(100) NOT NULL,
    Transmission NVARCHAR(30) NOT NULL,
    FuelType NVARCHAR(30) NOT NULL,
    Passengers INT NOT NULL,
    PickupLocation NVARCHAR(100) NOT NULL,
    RentalDate DATE NOT NULL,
    ReturnDate DATE NOT NULL,
    PickupTime NVARCHAR(30) NOT NULL,
    DrivingType NVARCHAR(30) NOT NULL,
    Insurance NVARCHAR(50) NOT NULL,
    GPS BIT NOT NULL DEFAULT 0,
    ChildSeat BIT NOT NULL DEFAULT 0,
    AdditionalDriver BIT NOT NULL DEFAULT 0,
    AdditionalRequirements NVARCHAR(500) NULL,
    RentalDays INT NOT NULL,
    DailyRate DECIMAL(10,2) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO
