using System;
using System.Data;
using System.Data.SQLite;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalForm
{
    public partial class Bookings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBookings();
            }
        }

        private void LoadBookings(string searchTerm = "")
        {
            using (SQLiteConnection con = DatabaseHelper.GetConnection())
            {
                string sql = "SELECT * FROM RentalBookings";
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    sql += " WHERE FullName LIKE @Search OR CarName LIKE @Search";
                }
                sql += " ORDER BY CreatedAt DESC";

                using (SQLiteCommand cmd = new SQLiteCommand(sql, con))
                {
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                    }

                    using (SQLiteDataAdapter sda = new SQLiteDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvBookings.DataSource = dt;
                        gvBookings.DataBind();
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadBookings(txtSearch.Text.Trim());
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadBookings();
        }

        protected void gvBookings_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int bookingId = Convert.ToInt32(gvBookings.DataKeys[e.RowIndex].Value);

            using (SQLiteConnection con = DatabaseHelper.GetConnection())
            {
                string sql = "DELETE FROM RentalBookings WHERE BookingId = @BookingId";
                using (SQLiteCommand cmd = new SQLiteCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@BookingId", bookingId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LoadBookings(txtSearch.Text.Trim());
        }
    }
}
