<%@ Page Title="Home Solar PV and Water Current Report" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            SqlDataSource1.SelectCommand = "SELECT TOP 240 pumprunning, AVG(watertop) AS watertop, AVG(waterbase) AS waterbase, AVG(waterpanel) AS waterpanel, AVG(hometemp) AS hometemp, eDate FROM dbo.HomeLog  GROUP BY DATEPART(mi, eDate), eDate, pumprunning order by eDate DESC";
            System.Data.DataView dv;
            dv = (System.Data.DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
            dv.Sort = "eDate ASC";
            Repeater1.DataSource = dv;
            Repeater1.DataBind();
            dv.Dispose();
            

            System.Data.DataSet dsTax = new System.Data.DataSet();
            System.Data.SqlClient.SqlConnection objConn = new System.Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
            objConn.Open();
            System.Data.SqlClient.SqlDataAdapter daTax = new System.Data.SqlClient.SqlDataAdapter("SELECT TOP 1 * FROM dbo.HomeLog order by eDate DESC", objConn);
            daTax.FillSchema(dsTax, System.Data.SchemaType.Source, "HomeLog");
            daTax.Fill(dsTax, "HomeLog");
            daTax.Dispose();
            objConn.Close();

            LitDate.Text = DateTime.Parse(dsTax.Tables[0].Rows[0]["eDate"].ToString()).ToString("dddd dd MMM yyyy   HH:mm:ss"); ;

            LitHome.Text = dsTax.Tables[0].Rows[0]["hometemp"].ToString() + "<span> &deg;C<span>";
            LitCollector.Text = dsTax.Tables[0].Rows[0]["waterpanel"].ToString() + "<span> &deg;C<span>";
            LitCylinder.Text = dsTax.Tables[0].Rows[0]["watertop"].ToString() + "<span> &deg;C<span>";
            LitCylinderBase.Text = dsTax.Tables[0].Rows[0]["waterbase"].ToString() + "<span> &deg;C<span>";
            
           // LitLight.Text = Double.Parse(dsTax.Tables[0].Rows[0]["lightlux"].ToString()).ToString("0,0") + "<span> lux<span>";
           // LitMainsVolts.Text = dsTax.Tables[0].Rows[0]["mainsv"].ToString() + " V " + dsTax.Tables[0].Rows[0]["mainsc"].ToString() + " A";
            
           double mainswatts = 245 * Double.Parse(dsTax.Tables[0].Rows[0]["mainsc"].ToString());
           LitMainsA.Text = formatKW(mainswatts);
           LitMainsAmps.Text = dsTax.Tables[0].Rows[0]["mainsc"].ToString() + " amp<span>";


           if (dsTax.Tables[0].Rows[0]["pumprunning"].ToString().Equals("1"))
            {
                LitPump.Text = "<span>Running</span>";
            }
            else
            {
                LitPump.Text = "<span>Not Running</span>";
            }

            LitBattery.Text = dsTax.Tables[0].Rows[0]["batteryv"].ToString() + "<span> volts</span>";

            double solarcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["solarc"].ToString());
            LitPV.Text = formatKW(solarcwatts);
            LitPVAmps.Text = dsTax.Tables[0].Rows[0]["solarc"].ToString() + " amp<span>";
            
            double invertercwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["inverterc"].ToString());
            
            LitInverter.Text = formatKW(invertercwatts);
            LitInverterAmps.Text = dsTax.Tables[0].Rows[0]["inverterc"].ToString() + " amp<span>";
            double generalcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["generalc"].ToString());
            
            LitGeneral.Text = formatKW(generalcwatts);
            LitGeneralAmps.Text = dsTax.Tables[0].Rows[0]["generalc"].ToString() + " amp<span>";

          //  LitPVUsage.Text = formatKW(invertercwatts + generalcwatts);
           // dsTax.Dispose();


                
        }
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
<meta http-equiv="refresh" content="120" /> 
          
          
 
 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <asp:Panel id="panel" runat="server">
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart", 'gauge'] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
         ['Hour', 'Cylinder Top', 'Cylinder Base', 'Solar Collector', 'Home Temp', 'Pump Running'],
         <asp:Repeater ID="Repeater1" runat="server" >
  <ItemTemplate>
     
      ['<%# DataBinder.Eval(Container.DataItem, "eDate") %>', <%# DataBinder.Eval(Container.DataItem, "watertop") %>, <%# DataBinder.Eval(Container.DataItem, "waterbase") %>,  <%# DataBinder.Eval(Container.DataItem, "waterpanel") %>, <%# DataBinder.Eval(Container.DataItem, "hometemp") %>, <%# CheckPump(DataBinder.Eval(Container.DataItem, "pumprunning").ToString()) %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var options = {
               
                chartArea:{left:40,top:10,width:"80%",height:"70%"}
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
            chart.draw(data, options);

          
        }
    </script>
</asp:Panel>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>
    <style type="text/css">
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1>Current Power Usage<span><asp:Literal ID="LitDate" runat="server"></asp:Literal></span></h1>
<table class="boxes" width="100%">
                <tr>
                    <td class="greenbox">
                        <h1>Home</h1>
                        <h3><asp:Literal ID="LitHome" runat="server"></asp:Literal></h3>
                    </td>
                    <td class="greenbox">
                        <h1>Collector Outlet</h1>
                        <h3><asp:Literal ID="LitCollector" runat="server"></asp:Literal></h3>
                    </td>
                    <td class="greenbox">
                        <h1>Cylinder Top</h1>
                        <h3><asp:Literal ID="LitCylinder" runat="server"></asp:Literal></h3>
                    </td>
                    <td class="greenbox">
                      <h1>Cylinder Base</h1>
                        <h3><asp:Literal ID="LitCylinderBase" runat="server"></asp:Literal></h3>
                    </td>
                </tr>
              
    <tr>
        <td class="darkbluebox">
                        <h1>Battery</h1>
                        <h3><asp:Literal ID="LitBattery" runat="server"></asp:Literal></h3>
                   </td>
                   
                   <td class="darkbluebox">
                       <h1>PV Input</h1>
                        <h3><asp:Literal ID="LitPV" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitPVAmps" runat="server"></asp:Literal></h4>
                   </td>
                   <td class="darkbluebox">
                       <h1>Inverter</h1>
                        <h3><asp:Literal ID="LitInverter" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitInverterAmps" runat="server"></asp:Literal></h4>
                   </td>
                   <td class="darkbluebox">
                       <h1>General 12v</h1>
                        <h3><asp:Literal ID="LitGeneral" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitGeneralAmps" runat="server"></asp:Literal></h4>
                   </td>
                </tr>
     <tr>
        <td class="bluebox">
                        <h1>Pump</h1>
                        <h3><asp:Literal ID="LitPump" runat="server"></asp:Literal></h3>
                   </td>
                   
                   <td class="bluebox">
                       <h1>Mains</h1>
                        <h3><asp:Literal ID="LitMainsA" runat="server"></asp:Literal></h3>
                       <h4><asp:Literal ID="LitMainsAmps" runat="server"></asp:Literal></h4>
                   </td>
                   <td>
                      
                   </td>
                   <td>
                      
                   </td>
                </tr>
            </table>
                <h2>Temperature Sensors</h2>
 <div id="chart_div" style="width: 960px; height: 400px;"></div>
               
   
</asp:Content>

