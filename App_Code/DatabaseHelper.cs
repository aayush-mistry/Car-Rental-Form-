using System;
using System.Configuration;
using System.Data.SqlClient;

namespace CarRentalForm
{
    public static class DatabaseHelper
    {
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["StudentPortalConnection"].ConnectionString;
        }

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(GetConnectionString());
        }
    }
}
