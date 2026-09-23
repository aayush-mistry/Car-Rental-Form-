<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Bookings.aspx.cs" Inherits="CarRentalForm.Bookings" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Bookings</title>
    <link href="Content/style.css" rel="stylesheet" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="form-container" style="max-width: 1000px; width: 90%;">
            <h2>Rental Bookings</h2>
            
            <div class="search-panel">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" style="display:inline-block; width:60%;" placeholder="Search by Customer or Car Name..." />
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-primary" style="display:inline-block; width:18%;" OnClick="btnSearch_Click" />
                <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn-secondary" style="display:inline-block; width:18%;" OnClick="btnShowAll_Click" />
            </div>

            <hr style="margin: 30px 0; border: 1px solid #eee;" />

            <div style="overflow-x: auto;">
                <asp:GridView ID="gvBookings" runat="server" CssClass="gridview" AutoGenerateColumns="False" 
                    DataKeyNames="BookingId" OnRowDeleting="gvBookings_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="BookingId" HeaderText="ID" />
                        <asp:BoundField DataField="FullName" HeaderText="Customer" />
                        <asp:BoundField DataField="CarName" HeaderText="Car" />
                        <asp:BoundField DataField="PickupLocation" HeaderText="Pickup" />
                        <asp:BoundField DataField="RentalDate" HeaderText="From" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="ReturnDate" HeaderText="To" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="RentalDays" HeaderText="Days" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Total (₹)" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" Text="Delete" 
                                    OnClientClick="return confirm('Are you sure you want to delete this booking?');" CssClass="delete-link" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding: 20px;">No bookings found.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
            
            <div style="margin-top:20px; text-align:center;">
                <a href="CarRental.aspx">Back to Car Rental Form</a>
            </div>
        </div>
    </form>
</body>
</html>
