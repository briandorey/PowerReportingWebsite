<%@ Page Title="Home Solar PV and Water Current Report" Language="C#" MasterPageFile="~/MasterPage.master" enableViewState="false"  Debug="false" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.AppendHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        Response.AppendHeader("Pragma", "no-cache"); // HTTP 1.0.
        Response.AppendHeader("Expires", "0"); // Proxies.
        if (!IsPostBack)
        {




            System.Data.DataSet dsTax = new System.Data.DataSet();
            System.Data.SqlClient.SqlConnection objConn = new System.Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
            objConn.Open();
            System.Data.SqlClient.SqlDataAdapter daTax = new System.Data.SqlClient.SqlDataAdapter("SELECT TOP 1 * FROM dbo.HomeLogGeneral order by eDate DESC", objConn);
            daTax.FillSchema(dsTax, System.Data.SchemaType.Source, "HomeLogGeneral");
            daTax.Fill(dsTax, "HomeLogGeneral");
            daTax.Dispose();

            System.Data.SqlClient.SqlDataAdapter daTax2 = new System.Data.SqlClient.SqlDataAdapter("SELECT TOP 1 * FROM dbo.MainsData order by EntryDate DESC", objConn);
            daTax2.FillSchema(dsTax, System.Data.SchemaType.Source, "MainsData");
            daTax2.Fill(dsTax, "MainsData");
            daTax2.Dispose();

            objConn.Close();

            LitDate.Text = DateTime.Parse(dsTax.Tables[0].Rows[0]["eDate"].ToString()).ToString("dddd dd MMM yyyy   HH:mm:ss"); ;

            double hometemp = (Double.Parse(dsTax.Tables[0].Rows[0]["TempLivingRoom"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBedroomTwo"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBedroomOne"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBedroomThree"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempKitchen"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBathroom"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempLoft"].ToString())) / 7;


            LitHome.Text = hometemp.ToString("0.##");
           
            LitHomeOutdoor.Text = dsTax.Tables[0].Rows[0]["outdoortemp"].ToString();
            LitHomePressure.Text = dsTax.Tables[0].Rows[0]["pressure"].ToString();
            LitHomeHumidity.Text = dsTax.Tables[0].Rows[0]["humidity"].ToString();




            LitCollector.Text = dsTax.Tables[0].Rows[0]["waterpanel"].ToString();
            LitCylinder.Text =  dsTax.Tables[0].Rows[0]["watertop"].ToString();
            LitCylinderBase.Text = dsTax.Tables[0].Rows[0]["waterbase"].ToString();

            if (dsTax.Tables[0].Rows[0]["pumprunning"].ToString().Equals("1"))
            {
                LitPump.Text = "Pump Running";
            }
            else
            {
                LitPump.Text = "Pump Stopped";
            }

            // LitBattery.Text = dsTax.Tables[0].Rows[0]["batteryv"].ToString() + "<span> volts</span>";
            LitBattery.Text = dsTax.Tables[0].Rows[0]["batteryv"].ToString();


            double solarcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["solarc"].ToString());
            LitPV.Text = formatKW(solarcwatts);
            LitPVAmps.Text = dsTax.Tables[0].Rows[0]["solarc"].ToString();


            double offgridcwatts = Double.Parse(dsTax.Tables[0].Rows[0]["batteryv"].ToString()) * Double.Parse(dsTax.Tables[0].Rows[0]["offgridc"].ToString());

            LitGeneral.Text =  formatKW(offgridcwatts);
            LitGeneralAmps.Text =  dsTax.Tables[0].Rows[0]["offgridc"].ToString();

            LiteralAverage.Text = dsTax.Tables["MainsData"].Rows[0]["avgmainsc"].ToString();
            LiteralMax.Text = dsTax.Tables["MainsData"].Rows[0]["maxmainsc"].ToString();

            //  LitPVUsage.Text = formatKW(invertercwatts + offgridcwatts);
            dsTax.Dispose();



        }
    }

    public string getcolour(double tempvalue, double maxval) {
        // 91c8a0 green
        //efad50 orange
        // f5332f red
        double lowcuttoff = (maxval / 100) * 40;
        double midcuttoff = (maxval / 100) * 60;
        if (tempvalue <= lowcuttoff) {
            return "8ded80";
        }
        if (tempvalue <= midcuttoff) {
            return "efad50";
        }
        if (tempvalue > midcuttoff) {
            return "f82b15";
        }
        return "ccc";
    }
    public string formatKW(double watts)
    {
        // if (watts > 1000)
        //{
        //    return (watts / 1000).ToString("0.0") + "<span> Kw";
        //}
        // else
        // {
        return watts.ToString("0.");
        //}
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

<asp:Panel id="panel" runat="server">
   
</asp:Panel>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MainConn %>" >
    </asp:SqlDataSource>
    <style type="text/css">
   

     .box  span {font-size: 12pt; margin-left: 10px;}
     .box p.smaller {font-size: 12pt; padding: 0; margin: 10px 0 0 0; }
     
     .box p { font-size: 30pt; margin: 30px 0 0 0; padding: 0; font-weight: 300; text-align: center;}
	 .box p.running { font-size: 12pt; padding: 25px 0 0 0; padding: 0;}
     .box p.first { margin: 20px 0 0 0;}
     .green { color: #fff;
         background: #8acc48;
     }
     .green span.header { color: #8acc48;  background: #fff;}
     .blue {background: #47479F; color: #fff;}
     .blue span.header { color: #47479F;  background: #fff;}


     .red {color: #fff; background: #c94143;}
     .red span.header { color: #c94143;  background: #fff;}
     span.header {color: #eff4f8; background-color: #6c7a8e; text-align: left; 
             font-size: 18pt;
            font-weight: 300;
           text-align: left;
            margin: 10px 0 0 10px;;
            padding: 10px;
            display: inline-block;
            }
     span.header a {color: #eff4f8; }
     span.header i { padding: 0 10px 0 0;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <h1><a href="/default.aspx"><i class="fa fa-home" aria-hidden="true"></i> Overview</a> <span><asp:Literal ID="LitDate" runat="server"></asp:Literal></span></h1>  
      
  <div class="box green"><span class="header"><i class="fa fa-battery-full" aria-hidden="true"></i> Battery</span>
                        <p class="first"><asp:Literal ID="LitBattery" runat="server"></asp:Literal><span>V</span></p>
                  <p><asp:Literal ID="LitGeneral" runat="server"></asp:Literal><span>watts</span></p>
                  <p><asp:Literal ID="LitGeneralAmps" runat="server"></asp:Literal><span>amps</span></p></div>
                      
  
                      
    <div class="box blue"><span class="header"><i class="fa fa-tint" aria-hidden="true"></i>Thermal</span>
                    
                 <p class="first"><asp:Literal ID="LitCylinder" runat="server"></asp:Literal><span>&deg;C cyl top</span></p>
                     <p><asp:Literal ID="LitCylinderBase" runat="server"></asp:Literal><span>&deg;C cyl base</span></p>
                <p><asp:Literal ID="LitCollector" runat="server"></asp:Literal><span>&deg;C panel</span></p>
                <p class="smaller"><asp:Literal ID="LitPump" runat="server"></asp:Literal></p>


                </div>
    <div class="box green"><span class="header"><i class="fa fa-sun-o" aria-hidden="true"></i>Offgrid PV</span>
                  <p class="first"><asp:Literal ID="LitPV" runat="server"></asp:Literal><span>watts</span></p>
                  <p><asp:Literal ID="LitPVAmps" runat="server"></asp:Literal><span>amps</span></p>

    </div>

 <div class="box"><a href="rooms.aspx"><span class="header"><i class="fa fa-home" aria-hidden="true"></i>Home</span>
                    <p class="first"><asp:Literal ID="LitHome" runat="server"></asp:Literal><span>&deg;C Average</span></p>
                    
          </a>
           </div>
           
              <div class="box red"><span class="header"><i class="fa fa-bolt" aria-hidden="true"></i> Mains Current</span>
                  <p class="first"><asp:Literal ID="LiteralAverage" runat="server"></asp:Literal><span> av amps</span></p>
                  <p><asp:Literal ID="LiteralMax" runat="server"></asp:Literal><span>max amps</span></p>

              </div>   
         
                <div class="box"><span class="header"><a href="rooms.aspx"><i class="fa fa-leaf" aria-hidden="true"></i>Outdoors</a></span>
                    <p class="first"><asp:Literal ID="LitHomeOutdoor" runat="server"></asp:Literal><span>&deg;C Outdoor</span></p>
                        <p><asp:Literal ID="LitHomeHumidity" runat="server"></asp:Literal><span>% Humidity</span></p>
                        <p><asp:Literal ID="LitHomePressure" runat="server"></asp:Literal><span>hPa Pressure</span></p>
         
           </div>
          <div style="clear: both;"></div>
   
    <div style="clear: both;"></div>

</asp:Content>

