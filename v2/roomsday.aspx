<%@ Page Title="Daily Room Temperature Current Report" Language="C#"  Debug="true" MasterPageFile="~/MasterPage.master" EnableViewState="false" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
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

        SqlDataSource1.SelectCommand = "SELECT TOP (100) PERCENT AVG(TempLivingRoom) AS TempLivingRoom, AVG(TempBedroomTwo) AS TempBedroomTwo, AVG(TempBedroomOne) AS TempBedroomOne, AVG(TempBedroomThree) as TempBedroomThree, AVG(TempKitchen) as TempKitchen, AVG(TempBathroom) as TempBathroom, AVG(TempLoft) as TempLoft, AVG(outdoortemp) as outdoortemp,DATEPART(hh, eDate) AS Hour, DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS MinVal  FROM dbo.HomeLogGeneral WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0), DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
        Repeater1.DataBind();



      




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
         ['Hour', 'Living Room', 'Andrew BR', 'Brian BR', 'Bedroom Three', 'Kitchen','Bathroom', 'Loft','Outdoor'],
         <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
  <ItemTemplate> ['<%# CheckLen(DataBinder.Eval(Container.DataItem, "Hour").ToString()) %>:<%# CheckLen(DataBinder.Eval(Container.DataItem, "MinVal").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "TempLivingRoom") %>, <%# DataBinder.Eval(Container.DataItem, "TempBedroomTwo") %>, <%# DataBinder.Eval(Container.DataItem, "TempBedroomOne") %>, <%# DataBinder.Eval(Container.DataItem, "TempBedroomThree") %>,<%# DataBinder.Eval(Container.DataItem, "TempKitchen") %>,<%# DataBinder.Eval(Container.DataItem, "TempBathroom") %>,<%# DataBinder.Eval(Container.DataItem, "TempLoft") %>,<%# DataBinder.Eval(Container.DataItem, "outdoortemp") %>], </ItemTemplate>
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

  
   
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1><a href="/default.aspx"><i class="fa fa-area-chart" aria-hidden="true"></i> Rooms Data for <asp:Literal ID="Literal1" runat="server"></asp:Literal></a></h1>
    <asp:Literal ID="Literal2" runat="server"></asp:Literal>
    <asp:Literal ID="litError" runat="server"></asp:Literal>
<h2>Room Temperature Sensors</h2>
 <div id="chart_div" style="width: 100%; height: 500px;"></div>
             
                    
          
   <asp:Calendar ID="Calendar1" runat="server"  NextPrevFormat="ShortMonth" TitleStyle-BackColor="Transparent"
            OnSelectionChanged="Calendar1_SelectionChanged" CssClass="calendar1" NextPrevStyle-CssClass="calheader">
        </asp:Calendar>
</asp:Content>

