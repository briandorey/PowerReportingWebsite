<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="utf-8" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server" language="C#">
    System.Data.DataSet dp = new System.Data.DataSet();
    int TotalRows = 0;
    private void Page_Load(object sender, System.EventArgs e)
		{
            Response.ContentType = "application/json";
			Response.ContentEncoding = Encoding.UTF8;
			String sqlstr = "SELECT * FROM HomeLog ORDER BY eDate ASC";
            if (Request.QueryString["now"] != null && Request.QueryString["now"].Length > 0)
            {
                sqlstr = "SELECT TOP 1 * FROM HomeLog ORDER BY eDate DESC";
            }
            if (Request.QueryString["datefrom"] != null && Request.QueryString["datefrom"].Length > 0)
            {
                DateTime dtStart = DateTime.Parse(Request.QueryString["datefrom"].ToString());
               
                sqlstr = "SELECT * FROM HomeLog WHERE eDate > '" + dtStart.ToString("s") + "' ORDER BY eDate ASC";     
            }
            
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString);
            SqlDataAdapter evdb = new SqlDataAdapter(sqlstr, conn);
			evdb.Fill(dp, "HomeLog");
			evdb.Dispose();
            conn.Close();
            conn.Dispose();
        
			
            DataTable articleData = dp.Tables[0];
			TotalRows = dp.Tables[0].Rows.Count;
        
			StringBuilder sb = new StringBuilder();
        
            sb.Append("{\"data\":[" + Environment.NewLine);
            sb.Append("" + Environment.NewLine);
				
            for (int i = 0; i < TotalRows; i++)
            {
                sb.Append("{" + Environment.NewLine);
                sb.Append("\"itemdate\":\"" + DateTime.Parse(articleData.Rows[i]["eDate"].ToString().Trim()).ToString("s") + "\"," + Environment.NewLine);
                sb.Append("\"watertop\":\"" + articleData.Rows[i]["watertop"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"waterbase\":\"" + articleData.Rows[i]["waterbase"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"solartemp\":\"" + articleData.Rows[i]["waterpanel"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"hometemp\":\"" + articleData.Rows[i]["hometemp"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"mainV\":\"" + articleData.Rows[i]["mainsv"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"mainsA\":\"" + articleData.Rows[i]["mainsc"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"SolarA\":\"" + articleData.Rows[i]["solarc"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"BatteryV\":\"" + articleData.Rows[i]["batteryv"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"InverterA\":\"" + articleData.Rows[i]["inverterc"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"DCA\":\"" + articleData.Rows[i]["generalc"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"lightir\":\"" + articleData.Rows[i]["lightir"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"lightfull\":\"" + articleData.Rows[i]["lightfull"].ToString().Trim() + "\"," + Environment.NewLine);
                sb.Append("\"lightlux\":\"" + articleData.Rows[i]["lightlux"].ToString().Trim() + "\"," + Environment.NewLine);
                
                sb.Append("\"Pump\":\"" + articleData.Rows[i]["pumprunning"].ToString().Trim() + "\"" + Environment.NewLine);
                if (i == (TotalRows - 1))
                {
                    sb.Append("}" + Environment.NewLine);
                }
                else
                {
                    sb.Append("}," + Environment.NewLine);
                }
		
            }
            sb.Append("]" + Environment.NewLine);
            sb.Append("}" + Environment.NewLine);
            Response.Write(sb.ToString());			
		}

</script>
