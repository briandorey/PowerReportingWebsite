<%@ Page Title="Daily Home Solar PV and Water Current Report" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            setdata(DateTime.Now);
        }
    }
    
    protected void Calendar1_SelectionChanged(object sender, EventArgs e)
    {
       
        setdata(Calendar1.SelectedDate.Date);
    }
    
    public void setdata(DateTime dt){
        Literal1.Text = dt.ToShortDateString();

        SqlDataSource1.SelectCommand = "SELECT TOP (100) PERCENT AVG(watertop) AS watertop, AVG(waterbase) AS waterbase, AVG(waterpanel) AS waterpanel, AVG(hometemp) AS hometemp, DATEPART(hh, eDate) AS Hour, DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal, pumprunning  FROM dbo.HomeLog WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0), DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate), pumprunning";
            Repeater1.DataBind();
            
            

            System.Data.DataSet dsTax = new System.Data.DataSet();
            System.Data.SqlClient.SqlConnection objConn = new System.Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
            objConn.Open();
            System.Data.SqlClient.SqlDataAdapter daTax = new System.Data.SqlClient.SqlDataAdapter("SELECT MAX(waterbase) as waterbase, MAX(batteryv) AS batteryv,MAX(watertop) AS watertop, MAX(waterpanel) AS waterpanel, MAX(hometemp) AS hometemp, MAX(mainsc) AS mainsc, MAX(solarc) AS solarc, MAX(inverterc) AS inverterc, MAX(generalc) AS generalc  FROM dbo.HomeLog  WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ")", objConn);
            daTax.FillSchema(dsTax, System.Data.SchemaType.Source, "HomeLog");
            daTax.Fill(dsTax, "HomeLog");
            daTax.Dispose();
            objConn.Close();
            try
            {
                if (dsTax.Tables[0].Rows.Count > 0)
                {

                    LitHome.Text = dsTax.Tables[0].Rows[0]["hometemp"].ToString() + "<span> &deg;C<span>";
                    LitCollector.Text = dsTax.Tables[0].Rows[0]["waterpanel"].ToString() + "<span> &deg;C<span>";
                    LitCylinder.Text = dsTax.Tables[0].Rows[0]["watertop"].ToString() + "<span> &deg;C<span>";
                   // LitReturn.Text = dsTax.Tables[0].Rows[0]["waterbase"].ToString() + "<span> &deg;C<span>";

                    double solarcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["solarc"].ToString());
                    LitPV.Text = formatKW(solarcwatts);
                    LitPVAmps.Text = dsTax.Tables[0].Rows[0]["solarc"].ToString() + " amp<span>";
                    double invertercwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["inverterc"].ToString());

                    LitInverter.Text = formatKW(invertercwatts);
                    LitInverterAmps.Text = dsTax.Tables[0].Rows[0]["inverterc"].ToString() + " amp<span>";
                    double generalcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["generalc"].ToString());

                    LitGeneral.Text = formatKW(generalcwatts);
                    LitGeneralAmps.Text = dsTax.Tables[0].Rows[0]["generalc"].ToString() + " amp<span>";


                }
            }
            catch { } 
            dsTax.Dispose();

            // pv data
            SqlDataSourcePV.SelectCommand = "SELECT TOP (100) PERCENT AVG(mainsc) AS mainsc, AVG(solarc) AS solarc, AVG(inverterc) AS inverterc,AVG(generalc) AS generalc ,DATEPART(hh, eDate) AS Hour , DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal FROM dbo.HomeLog  WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0),  DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
            Repeater2.DataBind();

            // battery data
            SqlDataSourceBattery.SelectCommand = "SELECT TOP (100) PERCENT AVG(batteryv) AS batteryv , DATEPART(hh, eDate) AS Hour  , DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal FROM dbo.HomeLog   WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY  dateadd(minute,(datediff(minute,0,eDate)/15)*15,0),  DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
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
         ['Hour', 'Cylinder Top', 'Solar Collector', 'Home Temp', 'Pump Running'],
         <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate>
     
      ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "watertop") %>,  <%# DataBinder.Eval(Container.DataItem, "waterpanel") %>, <%# DataBinder.Eval(Container.DataItem, "hometemp") %>, <%# CheckPump(DataBinder.Eval(Container.DataItem, "pumprunning").ToString()) %>],

      
  </ItemTemplate>
</asp:Repeater>
            ]);

            var options = {
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };
            

            var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
            chart.draw(data, options);

            // pv chart

            var dataPV = google.visualization.arrayToDataTable([
         ['Hour', 'Panel Current', 'Inverter Input Current', '12 Out Current','Mains Current'],
         <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSourcePV">
  <ItemTemplate>
     
      ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "solarc") %>, <%# DataBinder.Eval(Container.DataItem, "inverterc") %>, <%# DataBinder.Eval(Container.DataItem, "generalc") %>, <%# DataBinder.Eval(Container.DataItem, "mainsc") %>],
  </ItemTemplate>
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
  <ItemTemplate>
     
      ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "batteryv") %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var optionsvoltage = {
              
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };

            var chartvoltage = new google.visualization.LineChart(document.getElementById('chart_divVoltage'));
            chartvoltage.draw(datavoltage, optionsvoltage);

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

  
    
    <style>
        .calendar1 td,  .calendar1 th  {
             font-size:  8pt;
             padding: 2px;
        }
        
        
    </style>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1>Data for <asp:Literal ID="Literal1" runat="server"></asp:Literal></h1>
    <asp:Literal ID="Literal2" runat="server"></asp:Literal>
    <asp:Literal ID="litError" runat="server"></asp:Literal>
<table width="960">
        <tr>
            <td valign="top" style="width:  800px;">
                <h2>Temperature Sensors</h2>
 <div id="chart_div" style="width: 800px; height: 400px;"></div>
                <h2>Current Usage</h2>
    <div id="chart_divPV" style="width: 800px; height:400px; "></div>
                <h2>Battery Voltage</h2>
    <div id="chart_divVoltage" style="width: 800px; height: 400px; "></div>
               
            </td>
            <td valign="top">  <asp:Calendar ID="Calendar1" runat="server"  NextPrevFormat="FullMonth" 
            OnSelectionChanged="Calendar1_SelectionChanged" CssClass="calendar1">
        </asp:Calendar>
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
                   </td>
                         </tr>
                    <tr>
                   <td class="darkbluebox">
                       <h1>Inverter</h1>
                        <h3><asp:Literal ID="LitInverter" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitInverterAmps" runat="server"></asp:Literal></h4>
                   </td>
                         </tr>
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
   
</asp:Content>

