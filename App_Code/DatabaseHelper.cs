using System;
using System.Configuration;
using System.Data.SQLite;

namespace CarRentalForm
{
    public static class DatabaseHelper
    {
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["StudentPortalConnection"].ConnectionString;
        }

        public static SQLiteConnection GetConnection()
        {
            return new SQLiteConnection(GetConnectionString());
        }
    }
}
