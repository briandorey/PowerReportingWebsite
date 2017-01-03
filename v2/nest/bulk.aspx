<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    DateTime startdate = new DateTime(2016, 07, 16);
    DateTime enddate = new DateTime(2016, 11, 25);
    public bool evenday = true;
    protected void Page_Load(Object Src, EventArgs E)
    {
        System.Data.SqlClient.SqlConnection db = new System.Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
        string sqlIns = "INSERT INTO dbo.Nest (ReadingDate, HWHours, CHHours) VALUES (@ReadingDate, @HWHours, @CHHours)";
        db.Open();

        while (startdate < enddate)
        {

            startdate = startdate.AddDays(1);

            SqlCommand cmdIns = new SqlCommand(sqlIns, db);
            cmdIns.Parameters.Add("@ReadingDate", SqlDbType.Date).Value = startdate;
            if (evenday) {
                cmdIns.Parameters.Add("@HWHours", SqlDbType.Time).Value = "00:00";
                evenday = false;
            } else
            {
                cmdIns.Parameters.Add("@HWHours", SqlDbType.Time).Value = "02:30";
                evenday = true;
            }
            
            cmdIns.Parameters.Add("@CHHours", SqlDbType.Time).Value = "00:00";

            cmdIns.ExecuteNonQuery();

            cmdIns.Parameters.Clear();
            cmdIns.Dispose();
            cmdIns = null;

        }


        db.Close();

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentSide" Runat="Server">
</asp:Content>

