using System;
using System.Data;
using System.Data.SQLite;
using System.Web.UI;

namespace CarRentalForm
{
    public partial class CarRental : Page
    {
        // Pricing constants
        private const decimal PriceSwift = 1200;
        private const decimal PriceI20 = 1500;
        private const decimal PriceNexon = 1800;
        private const decimal PriceCity = 2000;
        private const decimal PriceInnova = 2500;

        private const decimal PriceBasicInsurance = 500;
        private const decimal PriceFullInsurance = 1000;
        private const decimal PriceGPS = 300;
        private const decimal PriceChildSeat = 200;
        private const decimal PriceAdditionalDriver = 500;
        private const decimal PriceWithDriverPerDay = 800;

        protected void Page_Load(object sender, EventArgs e)
        {
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
        }

        protected void CalculatePrice_Event(object sender, EventArgs e)
        {
            CalculateEstimate();
        }

        private bool CalculateEstimate()
        {
            lblSummaryError.Visible = false;

            if (string.IsNullOrEmpty(ddlCarName.SelectedValue))
            {
                lblSumCar.Text = "-";
                lblSumRate.Text = "-";
                lblSumTotal.Text = "₹0";
                return false;
            }

            DateTime rentalDate, returnDate;
            bool isRentalValid = DateTime.TryParse(txtRentalDate.Text, out rentalDate);
            bool isReturnValid = DateTime.TryParse(txtReturnDate.Text, out returnDate);

            if (!isRentalValid || !isReturnValid)
            {
                lblSummaryError.Text = "Please enter valid rental and return dates.";
                lblSummaryError.Visible = true;
                return false;
            }

            if (returnDate < rentalDate)
            {
                lblSummaryError.Text = "Return date cannot be earlier than rental date.";
                lblSummaryError.Visible = true;
                return false;
            }

            int days = (returnDate - rentalDate).Days;
            if (days == 0) days = 1;

            decimal dailyRate = 0;
            switch (ddlCarName.SelectedValue)
            {
                case "Maruti Swift": dailyRate = PriceSwift; break;
                case "Hyundai i20": dailyRate = PriceI20; break;
                case "Tata Nexon": dailyRate = PriceNexon; break;
                case "Honda City": dailyRate = PriceCity; break;
                case "Toyota Innova": dailyRate = PriceInnova; break;
            }

            decimal basePrice = dailyRate * days;
            
            decimal insurancePrice = 0;
            if (rblInsurance.SelectedValue == "Basic Insurance") insurancePrice = PriceBasicInsurance;
            else if (rblInsurance.SelectedValue == "Full Insurance") insurancePrice = PriceFullInsurance;

            decimal driverPrice = 0;
            if (rblDrivingType.SelectedValue == "With Driver")
            {
                driverPrice = PriceWithDriverPerDay * days;
            }

            decimal extrasPrice = 0;
            foreach (System.Web.UI.WebControls.ListItem item in cblExtras.Items)
            {
                if (item.Selected)
                {
                    if (item.Value == "GPS") extrasPrice += PriceGPS;
                    else if (item.Value == "Child Seat") extrasPrice += PriceChildSeat;
                    else if (item.Value == "Additional Driver") extrasPrice += PriceAdditionalDriver;
                }
            }

            decimal totalAmount = basePrice + insurancePrice + driverPrice + extrasPrice;

            // Update UI
            lblSumCar.Text = ddlCarName.SelectedValue;
            lblSumRate.Text = string.Format("₹{0}/day", dailyRate);
            lblSumDays.Text = string.Format("{0} Day(s)", days);
            lblSumInsurance.Text = string.Format("₹{0}", insurancePrice);
            
            string extrasText = extrasPrice > 0 ? string.Format("₹{0}", extrasPrice) : "None";
            lblSumExtras.Text = extrasText;

            string driverText = driverPrice > 0 ? string.Format("₹{0}", driverPrice) : "Self Drive";
            lblSumDriver.Text = driverText;

            lblSumTotal.Text = string.Format("₹{0:N0}", totalAmount);

            return true;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblError.Visible = false;
            pnlConfirmation.Visible = false;

            if (!CalculateEstimate())
            {
                lblError.Text = "Please resolve the errors before submitting.";
                lblError.Visible = true;
                return;
            }

            try
            {
                DateTime rentalDate = DateTime.Parse(txtRentalDate.Text);
                DateTime returnDate = DateTime.Parse(txtReturnDate.Text);
                int days = (returnDate - rentalDate).Days;
                if (days == 0) days = 1;

                decimal dailyRate = 0;
                switch (ddlCarName.SelectedValue)
                {
                    case "Maruti Swift": dailyRate = PriceSwift; break;
                    case "Hyundai i20": dailyRate = PriceI20; break;
                    case "Tata Nexon": dailyRate = PriceNexon; break;
                    case "Honda City": dailyRate = PriceCity; break;
                    case "Toyota Innova": dailyRate = PriceInnova; break;
                }

                decimal totalAmount = decimal.Parse(lblSumTotal.Text.Replace("₹", "").Replace(",", ""));
                
                bool hasGps = false, hasChildSeat = false, hasAdditionalDriver = false;
                foreach (System.Web.UI.WebControls.ListItem item in cblExtras.Items)
                {
                    if (item.Selected)
                    {
                        if (item.Value == "GPS") hasGps = true;
                        if (item.Value == "Child Seat") hasChildSeat = true;
                        if (item.Value == "Additional Driver") hasAdditionalDriver = true;
                    }
                }

                int bookingId = 0;

                using (SQLiteConnection con = DatabaseHelper.GetConnection())
                {
                    string sql = @"
                        INSERT INTO RentalBookings
                        (
                            FullName, Email, Phone, CarCategory, CarName, Transmission, FuelType, 
                            Passengers, PickupLocation, RentalDate, ReturnDate, PickupTime, 
                            DrivingType, Insurance, GPS, ChildSeat, AdditionalDriver, 
                            AdditionalRequirements, RentalDays, DailyRate, TotalAmount
                        )
                        VALUES
                        (
                            @FullName, @Email, @Phone, @CarCategory, @CarName, @Transmission, @FuelType, 
                            @Passengers, @PickupLocation, @RentalDate, @ReturnDate, @PickupTime, 
                            @DrivingType, @Insurance, @GPS, @ChildSeat, @AdditionalDriver, 
                            @AdditionalRequirements, @RentalDays, @DailyRate, @TotalAmount
                        );
                        SELECT last_insert_rowid();";

                    using (SQLiteCommand cmd = new SQLiteCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@CarCategory", ddlCarCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@CarName", ddlCarName.SelectedValue);
                        cmd.Parameters.AddWithValue("@Transmission", rblTransmission.SelectedValue);
                        cmd.Parameters.AddWithValue("@FuelType", rblFuelType.SelectedValue);
                        cmd.Parameters.AddWithValue("@Passengers", Convert.ToInt32(ddlPassengers.SelectedValue));
                        cmd.Parameters.AddWithValue("@PickupLocation", ddlPickupLocation.SelectedValue);
                        cmd.Parameters.AddWithValue("@RentalDate", rentalDate);
                        cmd.Parameters.AddWithValue("@ReturnDate", returnDate);
                        cmd.Parameters.AddWithValue("@PickupTime", ddlPickupTime.SelectedValue);
                        cmd.Parameters.AddWithValue("@DrivingType", rblDrivingType.SelectedValue);
                        cmd.Parameters.AddWithValue("@Insurance", rblInsurance.SelectedValue);
                        cmd.Parameters.AddWithValue("@GPS", hasGps);
                        cmd.Parameters.AddWithValue("@ChildSeat", hasChildSeat);
                        cmd.Parameters.AddWithValue("@AdditionalDriver", hasAdditionalDriver);
                        cmd.Parameters.AddWithValue("@AdditionalRequirements", string.IsNullOrEmpty(txtRequirements.Text) ? (object)DBNull.Value : txtRequirements.Text.Trim());
                        cmd.Parameters.AddWithValue("@RentalDays", days);
                        cmd.Parameters.AddWithValue("@DailyRate", dailyRate);
                        cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);

                        con.Open();
                        object result = cmd.ExecuteScalar();
                        bookingId = Convert.ToInt32(result);
                    }
                }

                // Show confirmation
                lblConfBookingId.Text = bookingId.ToString();
                lblConfCustomer.Text = Server.HtmlEncode(txtFullName.Text);
                lblConfCar.Text = Server.HtmlEncode(ddlCarName.SelectedValue);
                lblConfPeriod.Text = string.Format("{0} - {1}", rentalDate.ToShortDateString(), returnDate.ToShortDateString());
                lblConfDuration.Text = string.Format("{0} Days", days);
                lblConfPickup.Text = Server.HtmlEncode(ddlPickupLocation.SelectedValue);
                lblConfTotal.Text = string.Format("₹{0:N0}", totalAmount);

                pnlConfirmation.Visible = true;
                UpdatePanel1.Visible = false; // Hide the form for clean UI, or just leave it
            }
            catch (Exception)
            {
                lblError.Text = "Unable to save the booking. Please try again.";
                lblError.Visible = true;
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFullName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPhone.Text = string.Empty;
            ddlCarCategory.SelectedIndex = 0;
            ddlCarName.SelectedIndex = 0;
            rblTransmission.ClearSelection();
            rblFuelType.ClearSelection();
            ddlPassengers.SelectedIndex = 1; // 4
            ddlPickupLocation.SelectedIndex = 0;
            txtRentalDate.Text = string.Empty;
            txtReturnDate.Text = string.Empty;
            ddlPickupTime.SelectedIndex = 0;
            rblDrivingType.SelectedIndex = 0; // Self Drive
            rblInsurance.SelectedIndex = 0; // No Add Insurance
            cblExtras.ClearSelection();
            txtRequirements.Text = string.Empty;

            pnlConfirmation.Visible = false;
            UpdatePanel1.Visible = true;
            lblError.Visible = false;
            
            lblSumCar.Text = "-";
            lblSumRate.Text = "-";
            lblSumDays.Text = "-";
            lblSumInsurance.Text = "-";
            lblSumExtras.Text = "-";
            lblSumDriver.Text = "-";
            lblSumTotal.Text = "₹0";
        }
    }
}
