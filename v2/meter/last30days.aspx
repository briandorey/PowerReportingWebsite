<%@ Page Title="Meter Readings by Last 30 Days" Language="C#" MasterPageFile="~/MasterPage.master" Debug="true" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            SqlDataSource1.SelectCommand = "SELECT * from View_Electric30Days order by ReadingDate asc";
            Repeater1.DataBind();

            SqlDataSource2.SelectCommand = "SELECT * from View_Gas30Days order by ReadingDate asc";
           Repeater2.DataBind();

        }
    }
    public string CheckNull(string inval)
    {
        if (inval!= null && inval.Length > 0)
        {
            return inval;
        } else
        {
            return "0";
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

          
          
 
 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <asp:Panel id="panel" runat="server">
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart", 'gauge'] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
         ['Month', 'Usage'],
         <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate> ['<%# DateTime.Parse(DataBinder.Eval(Container.DataItem, "ReadingDate").ToString()).ToShortDateString() %>',  <%# CheckNull(DataBinder.Eval(Container.DataItem, "DailyElectricUsage").ToString()) %>], </ItemTemplate>
</asp:Repeater>
            ]);
            
            var options = {
                colors: ['6f9654'],
                vAxis: { title: "Avg Units Per Day" },
                hAxis: { title: "Date" },
                seriesType: "bars",
                series: { 5: { type: "line"} },
                chartArea:{left:60,top:10,width:"80%",height:"70%"}
            };
            

             var chart = new google.visualization.ComboChart(document.getElementById('chart_divGas'));
             chart.draw(data, options);

            // pv chart
           
            var dataPV = google.visualization.arrayToDataTable([
         ['Month', 'Usage'],
         <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource2">
  <ItemTemplate> ['<%# DateTime.Parse(DataBinder.Eval(Container.DataItem, "ReadingDate").ToString()).ToShortDateString() %>',  <%# CheckNull(DataBinder.Eval(Container.DataItem, "DailyGasUsage").ToString()) %>], </ItemTemplate></asp:Repeater>
            ]);

            var optionsPV = {
                vAxis: { title: "Avg Units Per Day" },
                hAxis: { title: "Year and Month" },
                seriesType: "bars",
                series: { 5: { type: "line" } },
                chartArea:{left:60,top:10,width:"80%",height:"70%"}
            };

            var chartPV = new google.visualization.ComboChart(document.getElementById('chart_divElectric'));
               chartPV.draw(dataPV, optionsPV);
        }
    </script>
</asp:Panel>
   
      <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>
    
    
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1><a href="/default.aspx"><i class="fa fa-plug" aria-hidden="true"></i> Last 30 days Meter Readings</a></h1> 
    <p class="subnav"><a href="default.aspx">All Readings</a> | <a href="last30days.aspx">Last 30 Days</a> | <a href="month.aspx">Readings by Month and year</a></p>
    <asp:Literal ID="litError" runat="server"></asp:Literal>
   
                <h2>Gas Meter</h2>
 <div id="chart_divGas" style="width: 100%; height: 250px;"></div>
                <h2>Electric Meter</h2>
    <div id="chart_divElectric" style="width: 100%; height:250px; "></div>
              

</asp:Content>

