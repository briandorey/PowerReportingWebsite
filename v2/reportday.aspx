<%@ Page Title="Daily Home Solar PV and Water Current Report" Language="C#"  Debug="true" MasterPageFile="~/MasterPage.master" EnableViewState="false" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            setdata(DateTime.Now);
            getPVBatteryCharge(DateTime.Now);
        }
    }

    protected void Calendar1_SelectionChanged(object sender, EventArgs e)
    {

        setdata(Calendar1.SelectedDate.Date);
        getPVBatteryCharge(Calendar1.SelectedDate.Date);
    }
    public void getPVBatteryCharge(DateTime dt)
    {
        string sqlstr = "SELECT solarc, eDate FROM dbo.HomeLogGeneral  WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") AND (solarc > 0.1) ORDER BY eDate ASC";
        DataSet dp = new DataSet();
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
        SqlDataAdapter evdb = new SqlDataAdapter(sqlstr, conn);
        evdb.Fill(dp, "HomeLogGeneral");
        evdb.Dispose();
        conn.Close();
        conn.Dispose();

    
        DataTable articleData = dp.Tables[0];
        int TotalRows = dp.Tables[0].Rows.Count;
        
        double chargetemp = 0.0;
        for (int i = 0; i < TotalRows; i++)
        {

            chargetemp = chargetemp + double.Parse(articleData.Rows[i]["solarc"].ToString().Trim());

        }
        double hours = TotalRows / 60;
        LitPVAhours.Text = (chargetemp / TotalRows).ToString("0.0") + "<span> Ah<span>";
        dp.Dispose();
    }
    public void setdata(DateTime dt){
        Literal1.Text = dt.ToShortDateString();

        SqlDataSource1.SelectCommand = "SELECT TOP (100) PERCENT AVG(watertop) AS watertop, AVG(waterbase) AS waterbase, AVG(waterpanel) AS waterpanel, AVG(TempLivingRoom) AS TempLivingRoom, AVG(TempBedroomTwo) AS TempBedroomTwo, AVG(TempBedroomOne) AS TempBedroomOne, AVG(outdoortemp) as outdoortemp, DATEPART(hh, eDate) AS Hour, DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal, pumprunning  FROM dbo.HomeLogGeneral WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0), DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate), pumprunning";
        Repeater1.DataBind();



        SqlDataSourceMains.SelectCommand = "SELECT avgmainsc AS mainsc, maxmainsc AS mainscmax, DATEPART(hh, EntryDate) AS Hour, DATEPART(minute, EntryDate) AS MinVal  FROM dbo.MainsData WHERE  (DATEPART(dd, EntryDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, EntryDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, EntryDate) = " + dt.ToString("yyyy") + ") order by EntryDate asc";

        RepeaterMains.DataBind();


        SqlDataSourceHumidity.SelectCommand = "SELECT TOP (100) PERCENT AVG(humidity) AS humidity, DATEPART(hh, eDate) AS Hour, DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal  FROM dbo.HomeLogGeneral WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0), DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";

        RepeaterHumidity.DataBind();

        SqlDataSourcePressure.SelectCommand = "SELECT TOP (100) PERCENT AVG(pressure) AS pressure, DATEPART(hh, eDate) AS Hour, DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal  FROM dbo.HomeLogGeneral WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0), DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";

        RepeaterPressure.DataBind();




        System.Data.DataSet dsTax = new System.Data.DataSet();
        System.Data.SqlClient.SqlConnection objConn = new System.Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
        objConn.Open();
        System.Data.SqlClient.SqlDataAdapter daTax = new System.Data.SqlClient.SqlDataAdapter("SELECT MAX(waterbase) as waterbase, MAX(batteryv) AS batteryv,MAX(watertop) AS watertop, MAX(waterpanel) AS waterpanel, MAX(TempLivingRoom) AS TempLivingRoom, MAX(solarc) AS solarc, MAX(offgridc) AS offgridc  FROM dbo.HomeLogGeneral  WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ")", objConn);
        daTax.FillSchema(dsTax, System.Data.SchemaType.Source, "HomeLog");
        daTax.Fill(dsTax, "HomeLog");
        daTax.Dispose();
        objConn.Close();
        try
        {
            if (dsTax.Tables[0].Rows.Count > 0)
            {

                LitHome.Text = dsTax.Tables[0].Rows[0]["TempLivingRoom"].ToString() + "<span> &deg;C<span>";
                LitCollector.Text = dsTax.Tables[0].Rows[0]["waterpanel"].ToString() + "<span> &deg;C<span>";
                LitCylinder.Text = dsTax.Tables[0].Rows[0]["watertop"].ToString() + "<span> &deg;C<span>";
                // LitReturn.Text = dsTax.Tables[0].Rows[0]["waterbase"].ToString() + "<span> &deg;C<span>";

                double solarcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["solarc"].ToString());
                LitPV.Text = formatKW(solarcwatts);
                LitPVAmps.Text = dsTax.Tables[0].Rows[0]["solarc"].ToString() + " amp<span>";
             
                double offgridcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["offgridc"].ToString());

                LitGeneral.Text = formatKW(offgridcwatts);
                LitGeneralAmps.Text = dsTax.Tables[0].Rows[0]["offgridc"].ToString() + " amp<span>";


            }
        }
        catch { }
        dsTax.Dispose();

        // pv data
        SqlDataSourcePV.SelectCommand = "SELECT TOP (100) PERCENT AVG(solarc) AS solarc,AVG(offgridc) AS offgridc ,DATEPART(hh, eDate) AS Hour , DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal FROM dbo.HomeLogGeneral  WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0),  DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
        Repeater2.DataBind();

        // battery data
        SqlDataSourceBattery.SelectCommand = "SELECT TOP (100) PERCENT AVG(batteryv) AS batteryv , DATEPART(hh, eDate) AS Hour  , DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal FROM dbo.HomeLogGeneral   WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY  dateadd(minute,(datediff(minute,0,eDate)/15)*15,0),  DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
        RepeaterBattery.DataBind();


    }
    public string formatKW(double watts)
    {
        if (watts > 1000)
        {
            return (watts / 1000).ToString("0.0") + "<span> Kw";
        }
        else
        {
            return watts.ToString("0.") + "<span> watts";
        }
    }
    public string CheckLen(string inval)
    {
        if (inval.Length <= 1)
        {
            return "0" + inval;
        }
        else
        {
            return inval;
        }
    }

    public string CheckPump(string inval)
    {
        if (inval.Equals("0"))
        {
            return "0";
        }
        else
        {
            return "10";
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
         ['Hour', 'Cylinder Top', 'Solar Collector', 'Living Room', 'Andrew BR', 'Brian BR', 'Outdoor','Pump Running'],
         <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate> ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "watertop") %>,  <%# DataBinder.Eval(Container.DataItem, "waterpanel") %>, <%# DataBinder.Eval(Container.DataItem, "TempLivingRoom") %>, <%# DataBinder.Eval(Container.DataItem, "TempBedroomTwo") %>, <%# DataBinder.Eval(Container.DataItem, "TempBedroomOne") %>, <%# DataBinder.Eval(Container.DataItem, "outdoortemp") %>,<%# CheckPump(DataBinder.Eval(Container.DataItem, "pumprunning").ToString()) %>], </ItemTemplate>
</asp:Repeater>
            ]);

            var options = {
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };
            

            var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
            chart.draw(data, options);

            // pv chart

            var dataPV = google.visualization.arrayToDataTable([
         ['Hour', 'Panel Current', '12 Out Current'],
         <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSourcePV">
  <ItemTemplate>['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "solarc") %>, <%# DataBinder.Eval(Container.DataItem, "offgridc") %>],  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsPV = {
               
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };

            var chartPV = new google.visualization.LineChart(document.getElementById('chart_divPV'));
            chartPV.draw(dataPV, optionsPV);

            // voltage 

            var datavoltage = google.visualization.arrayToDataTable([
         ['Hour', 'Volts'],
         <asp:Repeater ID="RepeaterBattery" runat="server" DataSourceID="SqlDataSourceBattery">
  <ItemTemplate>['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "batteryv") %>],  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsvoltage = {
              
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };

            var chartvoltage = new google.visualization.LineChart(document.getElementById('chart_divVoltage'));
            chartvoltage.draw(datavoltage, optionsvoltage);


             // Mains Current 

            var datamains = google.visualization.arrayToDataTable([
         ['Hour', 'Max Amps', 'Avg Amps'],
         <asp:Repeater ID="RepeaterMains" runat="server" DataSourceID="SqlDataSourceMains">
  <ItemTemplate> ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "mainscmax") %>, <%# DataBinder.Eval(Container.DataItem, "mainsc") %>], </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsmains = {
              
                chartArea:{left:40,top:10,width:"80%",height:"70%"},
                series: {
                    0: { color: '#f2a6b8' },
                    1: { color: '#0048ff' }
                  
                }
            };

            var chartmains = new google.visualization.LineChart(document.getElementById('chart_divMains'));
            chartmains.draw(datamains, optionsmains);


       

        //humidity
      
        var datahumidity = google.visualization.arrayToDataTable([
         ['Hour', 'Humidity %'],
         <asp:Repeater ID="RepeaterHumidity" runat="server" DataSourceID="SqlDataSourceHumidity">
  <ItemTemplate> ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "humidity") %>], </ItemTemplate>
</asp:Repeater>
            ]);

        var optionshumidity = {
              
            chartArea:{left:40,top:10,width:"80%",height:"70%"}
        }; 
        
       
        var charthumidity = new google.visualization.LineChart(document.getElementById('chart_divHumidity'));
        charthumidity.draw(datahumidity, optionshumidity);

            //pressure
      
        var datapressure = google.visualization.arrayToDataTable([
         ['Hour', 'Pressure %'],
         <asp:Repeater ID="RepeaterPressure" runat="server" DataSourceID="SqlDataSourcePressure">
  <ItemTemplate> ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "pressure") %>], </ItemTemplate>
</asp:Repeater>
            ]);

        var optionshumidity = {
              
            chartArea:{left:40,top:10,width:"80%",height:"70%"}
        }; 
        
       
        var chartpressure = new google.visualization.LineChart(document.getElementById('chart_divpressure'));
        chartpressure.draw(datapressure, optionshumidity);


        }
        
    </script>
</asp:Panel>
   
      <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourcePV" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>
     <asp:SqlDataSource ID="SqlDataSourceBattery" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSourceMains" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceHumidity" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourcePressure" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>
   
   
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1><a href="/default.aspx"><i class="fa fa-area-chart" aria-hidden="true"></i> Data for <asp:Literal ID="Literal1" runat="server"></asp:Literal></a></h1>
    <asp:Literal ID="Literal2" runat="server"></asp:Literal>
    <asp:Literal ID="litError" runat="server"></asp:Literal>
<table width="100%">
        <tr>
            <td valign="top" style="width:  80%;">
                <h2>Temperature Sensors</h2>
 <div id="chart_div" style="width: 100%; height: 250px;"></div>
                <h2>Current Usage</h2>
    <div id="chart_divPV" style="width: 100%; height:250px; "></div>
                <h2>Battery Voltage</h2>
    <div id="chart_divVoltage" style="width:100%; height: 250px; "></div>

                 <h2>Mains Current</h2>
    <div id="chart_divMains" style="width:100%; height: 250px; "></div>
           
                 <h2>Humidity</h2>
    <div id="chart_divHumidity" style="width:100%; height: 250px; "></div>
           <h2>Pressure</h2>
    <div id="chart_divpressure" style="width:100%; height: 250px; "></div>       
                
                    
            </td>
            <td valign="top">  
                <h2>Max Values</h2>
                <table class="boxes side" width="160">
                <tr>
                    <td class="greenbox">
                        <h1>Home</h1>
                        <h3><asp:Literal ID="LitHome" runat="server"></asp:Literal></h3>
                    </td>
                    </tr>
                    <tr>
                    <td class="greenbox">
                        <h1>Collector</h1>
                        <h3><asp:Literal ID="LitCollector" runat="server"></asp:Literal></h3>
                    </td>
                        </tr>
                    <tr>
                    <td class="greenbox">
                        <h1>Water Cylinder</h1>
                        <h3><asp:Literal ID="LitCylinder" runat="server"></asp:Literal></h3>
                    </td>
                        </tr>
                    <tr>
                   
 </tr>
                    <tr>
                        <td class="darkbluebox">
                       <h1>PV Input</h1>
                        <h3><asp:Literal ID="LitPV" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitPVAmps" runat="server"></asp:Literal></h4>
                            <h3><asp:Literal ID="LitPVAhours" runat="server"></asp:Literal></h3>
                   </td>
                         </tr>
                    <tr>
                   
                    <tr>
                   <td class="darkbluebox">
                       <h1>General 12v</h1>
                        <h3><asp:Literal ID="LitGeneral" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitGeneralAmps" runat="server"></asp:Literal></h4>
                   </td>
                </tr>
</table>

            </td>

        </tr>
    </table>
   <asp:Calendar ID="Calendar1" runat="server"  NextPrevFormat="ShortMonth" TitleStyle-BackColor="Transparent"
            OnSelectionChanged="Calendar1_SelectionChanged" CssClass="calendar1" NextPrevStyle-CssClass="calheader">
        </asp:Calendar>
</asp:Content>

