﻿<%@ Page Title="Monthly Home Solar PV and Water Current Report" Language="C#" MasterPageFile="~/MasterPage.master" Debug="true" %>

<script runat="server">
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            SqlDataSource1.SelectCommand = "SELECT        TOP (100) PERCENT MAX(watertop) AS watertop, MAX(waterbase) AS waterbase, MAX(waterpanel) AS waterpanel, MAX(TempLivingRoom) AS TempLivingRoom,  MAX(solarc) AS solarc, MAX(offgridc) AS offgridc, MAX(batteryv) AS batteryv,  DATEPART(mm, eDate) AS DateMonth, DATEPART(yyyy, eDate) AS DateYear FROM   dbo.HomeLogGeneral GROUP BY DATEPART(mm, eDate), DATEPART(yyyy, eDate)ORDER BY DateYear ASC, DateMonth ASC ";
            Repeater1.DataBind();
            Repeater2.DataBind();
            RepeaterBattery.DataBind();
          
            
                
                
                
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
         ['Hour', 'Cylinder Top',  'Solar Collector', 'Home Temp'],
         <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate>
     
      ['<%# DataBinder.Eval(Container.DataItem, "DateYear") %>.<%# DataBinder.Eval(Container.DataItem, "DateMonth") %>', <%# DataBinder.Eval(Container.DataItem, "watertop") %>,  <%# DataBinder.Eval(Container.DataItem, "waterpanel") %>, <%# DataBinder.Eval(Container.DataItem, "TempLivingRoom") %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var options = {
                vAxis: { title: "Dec C" },
                hAxis: { title: "Month" },
                seriesType: "bars",
                series: { 5: { type: "line" } },
                chartArea:{left:60,top:10,width:"70%",height:"70%"},
                colors: ['#c94143', '#8acc48','#47479F']
            };
            

            var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
            chart.draw(data, options);

            // pv chart

            var dataPV = google.visualization.arrayToDataTable([
         ['Hour', 'Panel Current', '12 Out Current'],
         <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate>
     
      ['<%# DataBinder.Eval(Container.DataItem, "DateYear") %>.<%# DataBinder.Eval(Container.DataItem, "DateMonth") %>',  <%# DataBinder.Eval(Container.DataItem, "solarc") %>, <%# DataBinder.Eval(Container.DataItem, "offgridc") %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsPV = {
               
                vAxis: { title: "Amps" },
                hAxis: { title: "Month" },
                seriesType: "bars",
                series: { 5: { type: "line" } },
                chartArea:{left:60,top:10,width:"70%",height:"70%"},
                colors: ['#8acc48', '#c94143']
            };

            var chartPV = new google.visualization.ComboChart(document.getElementById('chart_divPV'));
            chartPV.draw(dataPV, optionsPV);

            // voltage 

            var datavoltage = google.visualization.arrayToDataTable([
         ['Hour', 'Volts'],
         <asp:Repeater ID="RepeaterBattery" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate>
     
      ['<%# DataBinder.Eval(Container.DataItem, "DateYear") %>.<%# DataBinder.Eval(Container.DataItem, "DateMonth") %>', <%# DataBinder.Eval(Container.DataItem, "batteryv") %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsvoltage = {
              
                vAxis: { title: "Voltage" },
                hAxis: { title: "Month" },
                seriesType: "bars",
                series: { 5: { type: "line" } },
                chartArea:{left:60,top:10,width:"70%",height:"70%"},
                colors: ['#8acc48']
            };
            var chartvoltage = new google.visualization.ComboChart(document.getElementById('chart_divVoltage'));
            chartvoltage.draw(datavoltage, optionsvoltage);

           

        }
    </script>
</asp:Panel>
   
      <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

   
  
    
    
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <h1><a href="/default.aspx"><i class="fa fa-calendar-plus-o" aria-hidden="true"></i> Monthly Max Report</a></h1>
    <asp:Literal ID="litError" runat="server"></asp:Literal>
   
                <h2>Temperature Sensors</h2>
 <div id="chart_div" style="width: 100%; height: 250px;"></div>
                <h2>Current Usage</h2>
    <div id="chart_divPV" style="width: 100%; height:250px; "></div>
                <h2>Battery Voltage</h2>
    <div id="chart_divVoltage" style="width: 100%; height: 250px; "></div>

</asp:Content>

