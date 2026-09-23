<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CarRental.aspx.cs" Inherits="CarRentalForm.CarRental" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Car Rental Form</title>
    <link href="Content/style.css" rel="stylesheet" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="form-container">
            <h2>Car Rental Form</h2>
            
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error-summary" HeaderText="Please fix the following errors:" />

            <!-- CUSTOMER DETAILS -->
            <fieldset>
                <legend>Customer Details</legend>
                <div class="form-group">
                    <label>Full Name *</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full Name is required." CssClass="error-text" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Email *</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="error-text" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid email format." ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" CssClass="error-text" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Phone Number *</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone Number is required." CssClass="error-text" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Invalid Indian phone number." ValidationExpression="^[6-9]\d{9}$" CssClass="error-text" Display="Dynamic" />
                </div>
            </fieldset>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <!-- CAR DETAILS -->
                    <fieldset>
                        <legend>Car Details</legend>
                        <div class="form-group">
                            <label>Car Category *</label>
                            <asp:DropDownList ID="ddlCarCategory" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select Category" Value="" />
                                <asp:ListItem Text="Economy" Value="Economy" />
                                <asp:ListItem Text="Sedan" Value="Sedan" />
                                <asp:ListItem Text="SUV" Value="SUV" />
                                <asp:ListItem Text="Luxury" Value="Luxury" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCarCategory" runat="server" ControlToValidate="ddlCarCategory" ErrorMessage="Car Category is required." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Select Car *</label>
                            <asp:DropDownList ID="ddlCarName" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="CalculatePrice_Event">
                                <asp:ListItem Text="Select Car" Value="" />
                                <asp:ListItem Text="Maruti Swift" Value="Maruti Swift" />
                                <asp:ListItem Text="Hyundai i20" Value="Hyundai i20" />
                                <asp:ListItem Text="Tata Nexon" Value="Tata Nexon" />
                                <asp:ListItem Text="Honda City" Value="Honda City" />
                                <asp:ListItem Text="Toyota Innova" Value="Toyota Innova" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCarName" runat="server" ControlToValidate="ddlCarName" ErrorMessage="Please select a car." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Transmission *</label>
                            <asp:RadioButtonList ID="rblTransmission" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Manual" Value="Manual" />
                                <asp:ListItem Text="Automatic" Value="Automatic" />
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="rfvTransmission" runat="server" ControlToValidate="rblTransmission" ErrorMessage="Transmission is required." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Fuel Type *</label>
                            <asp:RadioButtonList ID="rblFuelType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Petrol" Value="Petrol" />
                                <asp:ListItem Text="Diesel" Value="Diesel" />
                                <asp:ListItem Text="CNG" Value="CNG" />
                                <asp:ListItem Text="Electric" Value="Electric" />
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="rfvFuelType" runat="server" ControlToValidate="rblFuelType" ErrorMessage="Fuel Type is required." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Number of Passengers *</label>
                            <asp:DropDownList ID="ddlPassengers" runat="server" CssClass="form-control">
                                <asp:ListItem Text="2" Value="2" />
                                <asp:ListItem Text="4" Value="4" Selected="True" />
                                <asp:ListItem Text="5" Value="5" />
                                <asp:ListItem Text="7" Value="7" />
                            </asp:DropDownList>
                        </div>
                    </fieldset>

                    <!-- RENTAL DETAILS -->
                    <fieldset>
                        <legend>Rental Details</legend>
                        <div class="form-group">
                            <label>Pickup Location *</label>
                            <asp:DropDownList ID="ddlPickupLocation" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select Location" Value="" />
                                <asp:ListItem Text="Vadodara" Value="Vadodara" />
                                <asp:ListItem Text="Ahmedabad" Value="Ahmedabad" />
                                <asp:ListItem Text="Surat" Value="Surat" />
                                <asp:ListItem Text="Rajkot" Value="Rajkot" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvPickupLocation" runat="server" ControlToValidate="ddlPickupLocation" ErrorMessage="Pickup location is required." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Rental Date *</label>
                            <asp:TextBox ID="txtRentalDate" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="CalculatePrice_Event" />
                            <asp:RequiredFieldValidator ID="rfvRentalDate" runat="server" ControlToValidate="txtRentalDate" ErrorMessage="Rental Date is required." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Return Date *</label>
                            <asp:TextBox ID="txtReturnDate" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="CalculatePrice_Event" />
                            <asp:RequiredFieldValidator ID="rfvReturnDate" runat="server" ControlToValidate="txtReturnDate" ErrorMessage="Return Date is required." CssClass="error-text" Display="Dynamic" />
                            <asp:CompareValidator ID="cvDate" runat="server" ControlToCompare="txtRentalDate" ControlToValidate="txtReturnDate" Type="Date" Operator="GreaterThanEqual" ErrorMessage="Return date cannot be earlier than rental date." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Pickup Time *</label>
                            <asp:DropDownList ID="ddlPickupTime" runat="server" CssClass="form-control">
                                <asp:ListItem Text="09:00 AM" Value="09:00 AM" />
                                <asp:ListItem Text="12:00 PM" Value="12:00 PM" />
                                <asp:ListItem Text="03:00 PM" Value="03:00 PM" />
                                <asp:ListItem Text="06:00 PM" Value="06:00 PM" />
                            </asp:DropDownList>
                        </div>
                    </fieldset>

                    <!-- DRIVING OPTION & INSURANCE & EXTRAS -->
                    <fieldset>
                        <legend>Options</legend>
                        <div class="form-group">
                            <label>Driving Type *</label>
                            <asp:RadioButtonList ID="rblDrivingType" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="CalculatePrice_Event">
                                <asp:ListItem Text="Self Drive" Value="Self Drive" Selected="True" />
                                <asp:ListItem Text="With Driver" Value="With Driver" />
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="rfvDrivingType" runat="server" ControlToValidate="rblDrivingType" ErrorMessage="Driving Type is required." CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label>Insurance</label>
                            <asp:RadioButtonList ID="rblInsurance" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="CalculatePrice_Event">
                                <asp:ListItem Text="No Additional Insurance" Value="No Additional Insurance" Selected="True" />
                                <asp:ListItem Text="Basic Insurance" Value="Basic Insurance" />
                                <asp:ListItem Text="Full Insurance" Value="Full Insurance" />
                            </asp:RadioButtonList>
                        </div>

                        <div class="form-group">
                            <label>Extras</label>
                            <asp:CheckBoxList ID="cblExtras" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="CalculatePrice_Event">
                                <asp:ListItem Text="GPS" Value="GPS" />
                                <asp:ListItem Text="Child Seat" Value="Child Seat" />
                                <asp:ListItem Text="Additional Driver" Value="Additional Driver" />
                            </asp:CheckBoxList>
                        </div>
                    </fieldset>

                    <!-- PRICE SUMMARY -->
                    <asp:Panel ID="pnlSummary" runat="server" CssClass="summary-panel">
                        <h4>Rental Summary</h4>
                        <p><strong>Selected Car:</strong> <asp:Label ID="lblSumCar" runat="server" Text="-" /></p>
                        <p><strong>Daily Rate:</strong> <asp:Label ID="lblSumRate" runat="server" Text="-" /></p>
                        <p><strong>Rental Duration:</strong> <asp:Label ID="lblSumDays" runat="server" Text="-" /></p>
                        <p><strong>Insurance:</strong> <asp:Label ID="lblSumInsurance" runat="server" Text="-" /></p>
                        <p><strong>Extras:</strong> <asp:Label ID="lblSumExtras" runat="server" Text="-" /></p>
                        <p><strong>Driving Type:</strong> <asp:Label ID="lblSumDriver" runat="server" Text="-" /></p>
                        <hr />
                        <h5>Estimated Total: <asp:Label ID="lblSumTotal" runat="server" Text="₹0" /></h5>
                        <asp:Label ID="lblSummaryError" runat="server" CssClass="error-text" Visible="false" />
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- SPECIAL REQUIREMENTS -->
            <fieldset>
                <legend>Special Requirements</legend>
                <div class="form-group">
                    <label>Additional Requirements</label>
                    <asp:TextBox ID="txtRequirements" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Any special requirements?" />
                </div>
            </fieldset>

            <div class="button-group">
                <asp:Button ID="btnCalculate" runat="server" Text="Calculate Estimate" CssClass="btn-secondary" CausesValidation="false" OnClick="CalculatePrice_Event" />
                <asp:Button ID="btnSubmit" runat="server" Text="Rent Car" CssClass="btn-primary" OnClick="btnSubmit_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn-secondary" CausesValidation="false" OnClick="btnClear_Click" />
            </div>

            <!-- SUCCESS MESSAGE -->
            <asp:Panel ID="pnlConfirmation" runat="server" CssClass="confirmation-panel" Visible="false">
                <h3>Booking Submitted Successfully</h3>
                <p><strong>Booking ID:</strong> <asp:Label ID="lblConfBookingId" runat="server" /></p>
                <p><strong>Customer:</strong> <asp:Label ID="lblConfCustomer" runat="server" /></p>
                <p><strong>Car:</strong> <asp:Label ID="lblConfCar" runat="server" /></p>
                <p><strong>Rental Period:</strong> <asp:Label ID="lblConfPeriod" runat="server" /></p>
                <p><strong>Duration:</strong> <asp:Label ID="lblConfDuration" runat="server" /></p>
                <p><strong>Pickup:</strong> <asp:Label ID="lblConfPickup" runat="server" /></p>
                <p><strong>Total:</strong> <asp:Label ID="lblConfTotal" runat="server" /></p>
            </asp:Panel>
            
            <!-- ERROR MESSAGE -->
            <asp:Label ID="lblError" runat="server" CssClass="error-text" Visible="false" />
            
            <div style="margin-top:20px; text-align:center;">
                <a href="Bookings.aspx">View All Bookings</a>
            </div>
        </div>
    </form>
</body>
</html>
