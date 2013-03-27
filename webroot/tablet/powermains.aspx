<%@ Page Title="Home Solar PV and Water Current Report" Language="C#" MasterPageFile="~/tablet/MasterPage.master" %>

<script runat="server">
 string dateformat = "HH:mm";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string sql = "SELECT TOP 60 mainsc AS datavalue, eDate AS DateField, 'x' AS DateField2 FROM dbo.HomeLog  order by eDate DESC";
           DateTime dt = DateTime.Now;
            if (Request.QueryString["o"] != null)
            {
                switch (Request.QueryString["o"].ToString())       
                  {         
                     case "day":
                          sql = "SELECT TOP (100) PERCENT AVG(mainsc) AS datavalue, DATEPART(hh, eDate) AS DateField,  DATEPART(minute, dateadd(minute,(datediff(minute,0,eDate)/15)*15,0)) AS DateField2  FROM dbo.HomeLog WHERE  (DATEPART(dd, eDate) = " + dt.ToString("dd") + ") AND (DATEPART(mm, eDate) = " + dt.ToString("MM") + ") AND (DATEPART(yyyy, eDate) = " + dt.ToString("yyyy") + ") GROUP BY dateadd(minute,(datediff(minute,0,eDate)/15)*15,0), DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
                        break;
                     case "week":

                        sql = "SELECT TOP (100) PERCENT AVG(mainsc) AS datavalue, DATEPART(dd, eDate) AS DateField,  DATEPART(hh, eDate) DateField2  FROM dbo.HomeLog WHERE  eDate >= '" + dt.AddDays(-7).ToString("s") + "' GROUP BY DATEPART(dw, eDate), DATEPART(hh, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
                        break;
                     case "month":
                        sql = "SELECT TOP (100) PERCENT AVG(mainsc) AS datavalue, DATEPART(mm, eDate) AS DateField,  DATEPART(dd, eDate) DateField2  FROM dbo.HomeLog WHERE  eDate >= '" + dt.AddMonths(-1).ToString("s") + "' GROUP BY DATEPART(dw, eDate), DATEPART(dd, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
                        break;
                     case "year":
                        sql = "SELECT TOP (100) PERCENT AVG(mainsc) AS datavalue, DATEPART(yyyy, eDate) AS DateField,  DATEPART(mm, eDate) DateField2  FROM dbo.HomeLog WHERE  eDate >= '" + dt.AddMonths(-1).ToString("s") + "' GROUP BY DATEPART(dw, eDate), DATEPART(mm, eDate), DATEPART(yyyy, eDate)";
                        break;          
                     default:
                        break;
                  }
            }

            SqlDataSource1.SelectCommand = sql;
            System.Data.DataView dv;
            dv = (System.Data.DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
            dv.Sort = "DateField ASC";
            Repeater1.DataSource = dv;
            Repeater1.DataBind();
            dv.Dispose();
           


                
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

    public string FormatDate(string inval, string inval2)
    {
       
        if (Request.QueryString["o"] != null)
        {
            if (Request.QueryString["o"].ToString().Equals("day"))
            {
                return CheckLen(inval) + ":" + CheckLen(inval2);
            }
            if (Request.QueryString["o"].ToString().Equals("week"))
            {
                return CheckLen(inval) + "/" + CheckLen(inval2);
            }
            if (Request.QueryString["o"].ToString().Equals("month"))
            {
                return CheckLen(inval) + "/" + CheckLen(inval2);
            }
            if (Request.QueryString["o"].ToString().Equals("year"))
            {
                return CheckLen(inval) + "/" + CheckLen(inval2);
            }

        }
 if (!inval2.Equals("x"))
        {
            return CheckLen(inval) + ":" + CheckLen(inval2);
        }
        return DateTime.Parse(inval).ToString(dateformat);
        

    }
    public string checkactive(string option)
    {
        if (Request.QueryString["o"] != null)
        {
            if (Request.QueryString["o"].ToString().Equals(option))
            {
                return "txtactive";
            }

        }
        else
        {
            if (option.Equals("hour"))
            {
                return "txtactive";
            }
        }
        
        return "txt";
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
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

          
          
 
 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <asp:Panel id="panel" runat="server">
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart", 'gauge'] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
         ['Hour', 'Amps'],
         <asp:Repeater ID="Repeater1" runat="server" >
  <ItemTemplate>
     
      ['<%# FormatDate(DataBinder.Eval(Container.DataItem, "DateField").ToString(),DataBinder.Eval(Container.DataItem, "DateField2").ToString()) %>', <%# DataBinder.Eval(Container.DataItem, "datavalue") %>],
  </ItemTemplate>
</asp:Repeater>
            ]);

            var options = {
                colors: ['#799458', '#7eb0b9'] ,

                chartArea:{left:60,top:10,width:"80%",height:"70%"}
            };

            var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
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
<asp:Content ID="Content3" ContentPlaceHolderID="titletime" Runat="Server">
<asp:Literal ID="LitDate" runat="server"></asp:Literal>
    </asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="titlename" Runat="Server">
Mains Power Usage
 

      </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <a href="powermains.aspx?o=hour" class="<%= checkactive("hour") %>">Hour</a>
            <a href="powermains.aspx?o=day" class="<%= checkactive("day") %>">Day</a>
            <a href="powermains.aspx?o=week" class="<%= checkactive("week") %>">Week</a>
            <a href="powermains.aspx?o=month" class="<%= checkactive("month") %>">Month</a>
            <a href="powermains.aspx?o=year" class="<%= checkactive("year") %>">Year</a>
 <div id="chart_div" style="width: 100%; height: 520px;"></div>
               
   
</asp:Content>

