<%@ Page Title="Nest Usage Report" Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">	  
   
    public string formatTime(string datetime)
    {
        DateTime dt = DateTime.Parse(datetime);
        return "[" + dt.Hour + ", " + dt.Minute + ",0]";
    }
    public string AddTime(string datetime, string datetime2)
    {
        TimeSpan dt = TimeSpan.Parse(datetime);
        TimeSpan dt2 = TimeSpan.Parse(datetime2);
        TimeSpan dttotal = dt.Add(dt2);

        return "[" + dttotal.Hours + ", " + dttotal.Minutes + ",0]";
    }
    public string formatTimeFromMins(string datetime)
    {
        double total = Double.Parse(datetime);;
        return (total / 60).ToString("0.00");
        
    }
    public string AddTimeFromMins(string datetime, string datetime2)
    {
        double total = Double.Parse(datetime);;
         double total2 = Double.Parse(datetime2);;
        return ((total + total2) / 60).ToString("0.00");
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
 <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart", 'gauge'] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {

         var dataPV = google.visualization.arrayToDataTable([
         ['Date', 'CH', 'HW', 'Total'],
         <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSourcePV">
  <ItemTemplate>
     
      ['<%# DateTime.Parse(DataBinder.Eval(Container.DataItem, "ReadingDate").ToString()).ToShortDateString() %>', <%# formatTime(DataBinder.Eval(Container.DataItem, "CHHours").ToString()) %>, <%# formatTime(DataBinder.Eval(Container.DataItem, "HWHours").ToString()) %>, <%# AddTime(DataBinder.Eval(Container.DataItem, "HWHours").ToString(),DataBinder.Eval(Container.DataItem, "CHHours").ToString()) %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsPV = {
               
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };

            var chartPV = new google.visualization.LineChart(document.getElementById('chart_div'));
            chartPV.draw(dataPV, optionsPV);

            // weekly 
            var dataWeek = google.visualization.arrayToDataTable([
         ['Week', 'CH', 'HW', 'Total'],
         <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSourceWeeks">
  <ItemTemplate>
     
      ['<%# DataBinder.Eval(Container.DataItem, "weekno").ToString() %>', <%# formatTimeFromMins(DataBinder.Eval(Container.DataItem, "totalCH").ToString()) %>, <%# formatTimeFromMins(DataBinder.Eval(Container.DataItem, "totalHW").ToString()) %>, <%# AddTimeFromMins(DataBinder.Eval(Container.DataItem, "totalHW").ToString(),DataBinder.Eval(Container.DataItem, "totalCH").ToString()) %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsWeek = {
               
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };

            var chartWeek = new google.visualization.LineChart(document.getElementById('chart_divweek'));
            chartWeek.draw(dataWeek, optionsWeek);

        }
           
    </script>
      <asp:SqlDataSource ID="SqlDataSourcePV" runat="server" SelectCommand="Select * from Nest ORder By ReadingDate ASC" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="SqlDataSourceWeeks" runat="server" SelectCommand="SELECT DATEPART(wk, ReadingDate) AS weekno, SUM(DATEDIFF(MINUTE, '0:00:00', HWHours)) AS totalHW, SUM(DATEDIFF(MINUTE, '0:00:00', CHHours)) AS totalCH FROM dbo.Nest GROUP BY DATEPART(wk, ReadingDate) ORDER BY weekno" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <a href="/default.aspx"><img src="nest_logo.png" style="margin-bottom: 10px;" /></a>
    <h1>Central Heating & Hot Water Usage</h1>
    <div id="chart_div" style="width: 100%; height: 250px; margin-bottom: 10px;"></div>

    <h1>Weekly Hour Totals</h1>
    <div id="chart_divweek" style="width: 100%; height: 250px; margin-bottom: 10px;"></div>
  
</asp:Content>