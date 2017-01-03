<%@ Page Title="Rooms in the house" Language="C#" MasterPageFile="~/MasterPage.master" enableViewState="false"  Debug="true" %>

<script runat="server">

    string Bedroom1Colour = "ffffff";
    string Bedroom2Colour = "ffffff";
    string Bedroom3Colour = "ffffff";
    string BathroomColour = "ffffff";
    string KitchenColour = "ffffff";
    string LivingRoomColour = "ffffff";
    string LoftColour = "ffffff";
    string AverageColour = "ffffff";

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

            objConn.Close();

            LitDate.Text = DateTime.Parse(dsTax.Tables[0].Rows[0]["eDate"].ToString()).ToString("dddd dd MMM yyyy   HH:mm:ss"); ;

            LitLivingRoom.Text = dsTax.Tables[0].Rows[0]["TempLivingRoom"].ToString();
            LitBedroom1.Text = dsTax.Tables[0].Rows[0]["TempBedroomOne"].ToString();
            LitBedroom2.Text = dsTax.Tables[0].Rows[0]["TempBedroomTwo"].ToString();
            LitBedroom3.Text  = dsTax.Tables[0].Rows[0]["TempBedroomThree"].ToString();
            LitKitchen.Text = dsTax.Tables[0].Rows[0]["TempKitchen"].ToString();
            LitBathroom.Text = dsTax.Tables[0].Rows[0]["TempBathroom"].ToString();
            LitLoft.Text = dsTax.Tables[0].Rows[0]["TempLoft"].ToString();
           
            LivingRoomColour = gethousecolour(dsTax.Tables[0].Rows[0]["TempLivingRoom"].ToString());
            Bedroom3Colour = gethousecolour(dsTax.Tables[0].Rows[0]["TempBedroomThree"].ToString());
            Bedroom2Colour = gethousecolour(dsTax.Tables[0].Rows[0]["TempBedroomTwo"].ToString());
            BathroomColour = gethousecolour(dsTax.Tables[0].Rows[0]["TempBathroom"].ToString());
            KitchenColour = gethousecolour(dsTax.Tables[0].Rows[0]["TempKitchen"].ToString());
            Bedroom1Colour = gethousecolour(dsTax.Tables[0].Rows[0]["TempBedroomOne"].ToString());
            LoftColour = gethousecolour(dsTax.Tables[0].Rows[0]["TempLoft"].ToString());

            double hometemp = (Double.Parse(dsTax.Tables[0].Rows[0]["TempLivingRoom"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBedroomTwo"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBedroomOne"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBedroomThree"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempKitchen"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempBathroom"].ToString()) + Double.Parse(dsTax.Tables[0].Rows[0]["TempLoft"].ToString())) / 7;
            AverageColour = gethousecolour(hometemp.ToString());
            


            dsTax.Dispose();



        }
    }

    string gethousecolour(string inval)
    {
        try {
            int temp = (int)Convert.ToDouble(inval);
            string[] arr1 = new string[] {"0094d9", "0094d9", "0094d9", "0b98cf", "25a0ba", "4aaf9b", "71be7a", "93ca5d", "bed53a", "ded81e", "f8d807", "ffd300", "ffc300", "ffac00", "ff9500", "fe7600", "f55a00", "ec3f00", "e42400", "dd0e00", "d90100"};
            try
            {
                return arr1[temp - 10];
            } catch
            {
                return "0094d9";
            }
        } catch
        {
            return "0094d9";
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
 
     svg { width: 75%; height: auto;}
      @media only screen and (max-width : 800px) {
       svg { width: 100%; height: auto;}
   
}
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <h1><a href="/default.aspx"><i class="fa fa-building" aria-hidden="true"></i> Rooms <span><asp:Literal ID="LitDate" runat="server"></asp:Literal></span></a></h1>  


    <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="940px" height="650px" viewBox="0 0 940 650" enable-background="new 0 0 940 650" xml:space="preserve">

<rect x="329" y="2" fill="#<%=AverageColour %>" width="285" height="443"/><!-- Average -->
<rect x="3" y="199" fill="#<%=AverageColour %>" width="284" height="246"/><!-- Average -->
<rect x="330" y="2" fill="#<%=Bedroom1Colour %>" width="240" height="198"/><!-- Bedroom 1 -->
<rect x="3" y="2" fill="#<%=Bedroom2Colour %>" width="285" height="198"/><!-- Bedroom 2 -->
<rect x="330" y="445" fill="#<%=KitchenColour %>" width="164" height="195"/><!-- Kitchen -->
<rect x="3" y="445" fill="#<%=BathroomColour %>" width="164" height="195"/><!-- Bathroom -->
<rect x="650.5" y="2.5" fill="#<%=LoftColour %>" stroke="#000000" stroke-width="3" stroke-miterlimit="10" width="285" height="198"/><!-- Loft -->
<polygon fill="#<%=Bedroom3Colour %>" points="288,247 47,247 47,408 106,408 106,445 288,445 "/> <!-- Bedroom 3 -->
<polygon fill="#<%=LivingRoomColour %>" points="463,247 463,200 330,200 330,245.595 330,445 570,445 570,247 "/> <!-- Living Room -->

<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="3.5" y1="200" x2="3.5" y2="445"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="47.5" y1="247" x2="47.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="64.5" y1="247" x2="64.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="81.5" y1="247" x2="81.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="98.5" y1="247" x2="98.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="115.5" y1="247" x2="115.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="133.5" y1="247" x2="133.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="150.5" y1="247" x2="150.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="167.5" y1="247" x2="167.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="184.5" y1="247" x2="184.5" y2="200"/>
<rect x="656.5" y="107.5" fill="#CCCCCC" stroke="#000000" stroke-miterlimit="10" width="43" height="38"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="463.5" y1="246" x2="463.5" y2="199"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="480.5" y1="246" x2="480.5" y2="199"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="497.5" y1="246" x2="497.5" y2="199"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="515.5" y1="246" x2="515.5" y2="199"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="532.5" y1="246" x2="532.5" y2="199"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="549.5" y1="246" x2="549.5" y2="199"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="42.5" y1="168" x2="42.5" y2="200"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M12.5,199.5c0-17.411,14.089-31.5,31.5-31.5"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="41.5" y1="477" x2="41.5" y2="445"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M11,445.5c0,17.411,14.089,31.5,31.5,31.5"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="80.507" y1="374.507" x2="48.507" y2="374.493"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M49.493,405.993	c17.411,0.008,31.506-14.075,31.514-31.486"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="484.5" y1="476" x2="484.5" y2="444"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M454,444.5c0,17.411,14.089,31.5,31.5,31.5"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="538" y1="401.5" x2="570" y2="401.5"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M571.5,433.5c-17.411,0-31.5-14.089-31.5-31.5"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="538" y1="155.5" x2="570" y2="155.5"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M571.5,187.5c-17.411,0-31.5-14.089-31.5-31.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="287.5" y1="445" x2="287.5" y2="2"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="287" y1="2.5" x2="3" y2="2.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="2.5" y1="3" x2="2.5" y2="640"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="3" y1="640.5" x2="167" y2="640.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="166.5" y1="641" x2="166.5" y2="445"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="41" y1="445.5" x2="287" y2="445.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="3" y1="445.5" x2="9" y2="445.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="3" y1="200.5" x2="11" y2="200.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="42" y1="200.5" x2="288" y2="200.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="46.5" y1="375" x2="46.5" y2="247"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="46" y1="247.5" x2="288" y2="247.5"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="607.5" y1="413" x2="607.5" y2="445"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M577.5,444.5c0-17.411,14.089-31.5,31.5-31.5"/>
<line fill="none" stroke="#000000" stroke-miterlimit="10" x1="575.5" y1="34" x2="575.5" y2="2"/>
<path fill="none" stroke="#808080" stroke-width="0.5" stroke-miterlimit="10" d="M609,2.5c0,17.411-14.089,31.5-31.5,31.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="330" y1="2.5" x2="575" y2="2.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="607" y1="2.5" x2="614" y2="2.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="569.5" y1="2" x2="569.5" y2="156"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="569.5" y1="188" x2="569.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="569" y1="200.5" x2="330" y2="200.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="570" y1="246.5" x2="463" y2="246.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="462.5" y1="247" x2="462.5" y2="200"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="569.5" y1="445" x2="569.5" y2="434"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="569.5" y1="402" x2="569.5" y2="247"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="576" y1="445.5" x2="484" y2="445.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="452" y1="444.5" x2="330" y2="444.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="329.5" y1="2" x2="329.5" y2="640"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="329" y1="640.5" x2="494" y2="640.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="493.5" y1="641" x2="493.5" y2="445"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="607" y1="445.5" x2="614" y2="445.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="613.5" y1="446" x2="613.5" y2="3"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="46.5" y1="406" x2="46.5" y2="446"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="46" y1="408.5" x2="106" y2="408.5"/>
<line fill="none" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="105.5" y1="409" x2="105.5" y2="445"/>

<text transform="matrix(1 0 0 1 409.9756 88.1143)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Bedroom 1</text>
<text transform="matrix(1 0 0 1 100.9756 88.1143)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Bedroom 2</text>
<text transform="matrix(1 0 0 1 123.9756 330.5)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Bedroom 3</text>
<text transform="matrix(1 0 0 1 403.9771 326.1143)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Living Room</text>
<text transform="matrix(1 0 0 1 42.981 533.1143)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Bathroom</text>
<text transform="matrix(1 0 0 1 385.981 533.1143)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Kitchen</text>
<text transform="matrix(1 0 0 1 783.4883 90.5)" fill="#FFFFFF" font-family="'Open Sans'" font-size="18">Loft</text>


<text transform="matrix(1 0 0 1 405.0381 117)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitBedroom1" runat="server"></asp:Literal>°C</text>
<text transform="matrix(1 0 0 1 96.5381 117.5)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitBedroom2" runat="server"></asp:Literal>°C</text>
<text transform="matrix(1 0 0 1 120.0381 360)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitBedroom3" runat="server"></asp:Literal>°C</text>
<text transform="matrix(1 0 0 1 396.4277 359.5)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitLivingRoom" runat="server"></asp:Literal>°C</text>
<text transform="matrix(1 0 0 1 36.876 564)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitBathroom" runat="server"></asp:Literal>°C</text>
<text transform="matrix(1 0 0 1 370.876 564)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitKitchen" runat="server"></asp:Literal>°C</text>
<text transform="matrix(1 0 0 1 755.543 121)" fill="#FFFFFF" font-family="'Open Sans'" font-size="28"><asp:Literal ID="LitLoft" runat="server"></asp:Literal>°C</text>
</svg>

   <p><a href="roomsday.aspx">Show Daily Report</a></p>
    
    
    
    
    
    
    
    
    
    
    
    

</asp:Content>

