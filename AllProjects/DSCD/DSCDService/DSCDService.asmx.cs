using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using System.Data.OracleClient;
using System.Configuration;
using System.Text;

namespace DSCDService
{
	/// <summary>
	/// Summary description for Service1.
	/// </summary>
	/// [WebService(Namespace="http://localhost/QICNServices/")]
	/// 
	[WebService(Namespace="http://localhost/DSCDService/")]
	public class DSCDService : System.Web.Services.WebService
	{
		private string appPath = "/DSCD/home.asp?goUrl=";
		private string GamCode = "";
		private string SoldToCode = "";
		private string UserType = "";
		private string OrgId = "";
		private string StartDt = "";
		private string EndDt = "";
		private string OrgType = "";
		private string View = "";
		private string Category = "";
		private string Window = "";
		private string DaysEarly = "";
		private string DaysLate = "";
		private string MonthlyInd = "";
		private string SummaryType = "";
		private string Current = "";
		private string CompareType = "";

		[WebMethod]
		public string MonthlySummary(string GamAccount, string SoldTo, string Org, string Role, string NetId,
									string GblId)
		{
			string url = "";
			try
			{
				if (Role != null)
				{
					switch (Role)
					{
						case "5":
							this.GamCode = GamAccount;
							break;
						case "10":
							this.GamCode = GamAccount;
							break;
						case "15":
							this.GamCode = GamAccount;
							break;
						case "20":
							this.SoldToCode = SoldTo;
							this.OrgId = Org;
							this.OrgType = "1636";
							break;
						case "25":
							this.GamCode = GamAccount;
							break;
					}
				}
				if (GamCode != "" || SoldToCode != "")
				{
					//Complete setting up criteria
					this.StartDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.EndDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.View = "3";
					this.Category = "2";
					this.Window = "2";
					this.DaysEarly = "3";
					this.DaysLate = "0";
					this.MonthlyInd = "1";
					this.SummaryType = "2";
					this.Current = "C";
					url = MonthlySummaryUrl(GblId,NetId);
				}
				return url;
			}
			catch (Exception ex)
			{
				throw new Exception ("Error in DSCDService.MonthlySummary:" + ex.ToString());
			}
		}

		[WebMethod]
		public string MonthlyPastDueSched(string GamAccount, string SoldTo, string Org, string Role, string NetId,
			string GblId)
		{
			string url = "";
			try
			{
				if (Role != null)
				{
					switch (Role)
					{
						case "5":
							this.GamCode = GamAccount;
							break;
						case "10":
							this.GamCode = GamAccount;
							break;
						case "15":
							this.GamCode = GamAccount;
							break;
						case "20":
							this.SoldToCode = SoldTo;
							this.OrgId = Org;
							this.OrgType = "1636";
							break;
						case "25":
							this.GamCode = GamAccount;
							break;
					}
				}
				if (GamCode != "" || SoldToCode != "")
				{
					//Complete setting up criteria
					this.StartDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.EndDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.View = "3";
					this.Category = "5";
					this.Window = "2";
					this.MonthlyInd = "1";
					this.Current = "C";
					this.CompareType = "1";

					url = MonthlyGeneralUrl(GblId,NetId);
				}
				return url;
			}
			catch (Exception ex)
			{
				throw new Exception ("Error in DSCDService.MonthlySummary:" + ex.ToString());
			}
		}					
		
		[WebMethod]
		public string MonthlyPastDueRequest(string GamAccount, string SoldTo, string Org, string Role, string NetId,
			string GblId)
		{
			string url = "";
			try
			{
				if (Role != null)
				{
					switch (Role)
					{
						case "5":
							this.GamCode = GamAccount;
							break;
						case "10":
							this.GamCode = GamAccount;
							break;
						case "15":
							this.GamCode = GamAccount;
							break;
						case "20":
							this.SoldToCode = SoldTo;
							this.OrgId = Org;
							this.OrgType = "1636";
							break;
						case "25":
							this.GamCode = GamAccount;
							break;
					}
				}
				if (GamCode != "" || SoldToCode != "")
				{
					//Complete setting up criteria
					this.StartDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.EndDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.View = "3";
					this.Category = "5";
					this.Window = "2";
					this.MonthlyInd = "1";
					this.Current = "C";
					this.CompareType = "2";

					url = MonthlyGeneralUrl(GblId,NetId);
				}
				return url;
			}
			catch (Exception ex)
			{
				throw new Exception ("Error in DSCDService.MonthlySummary:" + ex.ToString());
			}
		}

		[WebMethod]
		public string MonthlyOpenSched(string GamAccount, string SoldTo, string Org, string Role, string NetId,
			string GblId)
		{
			string url = "";
			try
			{
				if (Role != null)
				{
					switch (Role)
					{
						case "5":
							this.GamCode = GamAccount;
							break;
						case "10":
							this.GamCode = GamAccount;
							break;
						case "15":
							this.GamCode = GamAccount;
							break;
						case "20":
							this.SoldToCode = SoldTo;
							this.OrgId = Org;
							this.OrgType = "1636";
							break;
						case "25":
							this.GamCode = GamAccount;
							break;
					}
				}
				if (GamCode != "" || SoldToCode != "")
				{
					//Complete setting up criteria
					this.StartDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.EndDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.View = "3";
					this.Category = "6";
					this.Window = "2";
					this.MonthlyInd = "1";
					this.Current = "C";
					this.CompareType = "1";

					url = MonthlyGeneralUrl(GblId,NetId);
				}
				return url;
			}
			catch (Exception ex)
			{
				throw new Exception ("Error in DSCDService.MonthlySummary:" + ex.ToString());
			}
		}	

		[WebMethod]
		public string MonthlyOpenRequest(string GamAccount, string SoldTo, string Org, string Role, string NetId,
			string GblId)
		{
			string url = "";
			try
			{
				if (Role != null)
				{
					switch (Role)
					{
						case "5":
							this.GamCode = GamAccount;
							break;
						case "10":
							this.GamCode = GamAccount;
							break;
						case "15":
							this.GamCode = GamAccount;
							break;
						case "20":
							this.SoldToCode = SoldTo;
							this.OrgId = Org;
							this.OrgType = "1636";
							break;
						case "25":
							this.GamCode = GamAccount;
							break;
					}
				}
				if (GamCode != "" || SoldToCode != "")
				{
					//Complete setting up criteria
					this.StartDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.EndDt = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString();
					this.View = "3";
					this.Category = "6";
					this.Window = "2";
					this.MonthlyInd = "1";
					this.Current = "C";
					this.CompareType = "2";

					url = MonthlyGeneralUrl(GblId,NetId);
				}
				return url;
			}
			catch (Exception ex)
			{
				throw new Exception ("Error in DSCDService.MonthlySummary:" + ex.ToString());
			}
		}	

		/// <summary>
		/// Compiles a list of delivery performance measures.  Will then call
		/// getDSCDSixPackSmmry with the appropriate variables.  This acts
		/// as an overloaded method, but cannot be truly overloaded because of
		/// the way the gam portal dynamically creates it's web service interface.
		/// </summary>
		/// <param name="Code" >The code which is being passed in.  GAM Code or BU</param>
		/// <param name="Usertype">Gam Portal type:GAM, BU</param>
		/// <returns >Dataset</returns>
		[WebMethod]
		public DataSet getSixPackSmmryGAM(string GamAccount, string SoldTo, string Org, string Role)
		{
			DataSet ds = null;
			string code = null;
			if (Role != null)
			{
				switch (Role)
				{
					case "5":
						code = GamAccount;
						this.SoldToCode = null;
						this.OrgId = null;
						this.UserType = "GAM";
						break;
					case "10":
						code = GamAccount;
						this.SoldToCode = null;
						this.OrgId = null;
						this.UserType = "GAM";
						break;
					case "15":
						code = GamAccount;
						this.SoldToCode = null;
						this.OrgId = null;
						this.UserType = "GAM";
						break;
					case "20":
						code = SoldTo;
						this.OrgId = Org;
						this.OrgType = "1636";
						this.UserType = "PB";
						break;
					case "25":
						code = GamAccount;
						this.SoldToCode = null;
						this.OrgId = null;
						this.UserType = "GAM";
						break;
				}
			}
			try
			{
				 ds = getDSCDSixPackSmmry(this.OrgId,code,null,this.UserType);
			}
			catch (Exception ex)
			{
				throw new Exception("Failed in DSCDService.getSixPackSmmryGAM. " + ex.ToString());
			}
			return ds;
		}
		/// <summary>
		/// Compile a Summary of Complaints, Complaints Closed and Returns
		/// from DSCD for the Prev Fiscal Yr for a given cutomer acct nbr
		/// broken over quarters with a year total summary.
		/// </summary>
		/// <param name="CustmrAcctOrgId">Customer Account Org Id.  Pass NULL if no value</param>
		/// <param name="CustmrAcct">
		/// Customer Account Base for Purchase By & Ship To's.  Also use for World Wide & GAM 
		/// Accounts (Required value).
		/// </param>
		/// <param name="CustmrAcctSufx">Customer Account Suffix.  Pass NULL if no value</param>
		/// <param name="CstmrAcctNbrType">
		/// Expected Account Number Types:
		///   WW - World Wide Account Number
		///   GAM - GAM Account
		///   PB - Purchase BY Account
		///   ST - Ship To Account
		/// </param>
		/// <returns>Populated Dataset</returns>
		[WebMethod]
		public DataSet getDSCDSixPackSmmry(string CustmrAcctOrgId, string CustmrAcct, string CustmrAcctSufx, string CstmrAcctNbrType) 
		{
			try 
			{
				DataSet dsRept = new DataSet();
				StringBuilder ReptSql = new StringBuilder();
				StringBuilder AcctInlineView = new StringBuilder();

				// validate arguments
				if (CustmrAcct == "") 
					throw new Exception("A Customer Account is a required value.");
				
				AcctInlineView.Append("SELECT /*+ index(ois) push_subq */ ois.fiscal_quarter, ois.request_to_ship_variance ");
				AcctInlineView.Append("  FROM order_item_shipment ois ");
				if ( CstmrAcctNbrType.ToUpper() == "GAM" )
					AcctInlineView.Append(" , gbl_all_cust_purch_by gacpb " );

				AcctInlineView.Append(" WHERE ois.fiscal_year = (SELECT /*+ no_merge */ tyco_year_id - 1 " );
				AcctInlineView.Append("                            FROM date_dmn ");
				AcctInlineView.Append("                           WHERE calendar_dt = TRUNC(SYSDATE) " );
				AcctInlineView.Append("                             AND date_level_id = 1) " );
				if ( CustmrAcctOrgId != null)
				{
					AcctInlineView.Append("AND ois.organization_key_id = (SELECT /*+ no_merge */ organization_key_id ");
					AcctInlineView.Append("                                 FROM organizations_dmn ");
					AcctInlineView.Append("                                WHERE record_status_cde = 'C' ");
					AcctInlineView.Append("                                  AND organization_id = '" + CustmrAcctOrgId + "') ");
				}
                
				switch ( CstmrAcctNbrType.ToUpper() )
				{
					case "WW":
						string strWWBase = null;
						string strWWSufx = null;

						if ( CustmrAcct.Length == 10 )
						{
							strWWBase = CustmrAcct.Substring(1,8);
							strWWSufx = CustmrAcct.Substring(9);
						}
						else
							strWWBase = CustmrAcct;

							AcctInlineView.Append("AND ois.ww_account_nbr_base = '" + strWWBase + "' ");
						if ( strWWSufx != null )
							AcctInlineView.Append("AND ois.ww_account_nbr_suffix = '" + strWWSufx + "' ");

						break;
					case "GAM":
						
						if ( CustmrAcctOrgId != null ) 
							AcctInlineView.Append("AND gacpb.pb_acct_org_id = '" + CustmrAcctOrgId + "' ");

						AcctInlineView.Append("AND gacpb.pb_acct_nbr_base = ois.SOLD_TO_CUSTOMER_ID ");
						AcctInlineView.Append("AND gacpb.pb_gbl_acct_cde = '" + CustmrAcct + "' ");

						break;
					case "PB":
						CustmrAcct = CustmrAcct.PadLeft(8,'0');
						AcctInlineView.Append("AND ois.purchase_by_account_base = '" + CustmrAcct + "' ");

						break;
					case "ST":
						CustmrAcct = CustmrAcct.PadLeft(8,'0');
						AcctInlineView.Append("AND ois.purchase_by_account_base = '" + CustmrAcct + "' ");
						AcctInlineView.Append("AND ois.ship_to_account_suffix = '" + CustmrAcctSufx + "' ");

						break;
					default:
						throw new Exception(CstmrAcctNbrType + " is not a recognized Customer Account Type");
				}

				// build sql
				ReptSql.Append("SELECT 'On Time Percentage' \"Measure\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q1', ot, 0)) \"Q1 Total\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q2', ot, 0)) \"Q2 Total\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q3', ot, 0)) \"Q3 Total\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q4', ot, 0)) \"Q4 Total\", ");
				ReptSql.Append("       ROUND ((SUM(ontimeship) / SUM(ttlship)) * 100, 1) \"Year\" ");
				ReptSql.Append("  FROM (SELECT fiscal_quarter, ROUND ((ontimeship / ttlship) * 100, 1) ot, ontimeship, ttlship ");
				ReptSql.Append("          FROM (SELECT fiscal_quarter, ");
				ReptSql.Append("                       SUM(CASE WHEN request_to_ship_variance BETWEEN -3 AND 0 ");
				ReptSql.Append("                                THEN 1 ");
				ReptSql.Append("                                ELSE 0 ");
				ReptSql.Append("                           END) ontimeship, ");
				ReptSql.Append("                       COUNT (*) ttlship ");
				ReptSql.Append("                    FROM ( ");
				ReptSql.Append( AcctInlineView.ToString() );
				ReptSql.Append("				         ) svbq /* ship variance by qtr */ ");
				ReptSql.Append("                GROUP BY fiscal_quarter)) ");
				ReptSql.Append("UNION ALL ");
				ReptSql.Append("SELECT 'Total Shipments' \"Measure\",  ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q1', ts, 0)) \"Q1 Total\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q2', ts, 0)) \"Q2 Total\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q3', ts, 0)) \"Q3 Total\", ");
				ReptSql.Append("       SUM (DECODE (fiscal_quarter, 'Q4', ts, 0)) \"Q4 Total\", ");
				ReptSql.Append("	   SUM (ts) \"Year\" ");
				ReptSql.Append("  FROM (SELECT fiscal_quarter, ttlship ts ");
				ReptSql.Append("        FROM (SELECT   fiscal_quarter, COUNT (*) ttlship ");
				ReptSql.Append("              FROM ( ");
				ReptSql.Append( AcctInlineView.ToString() );
				ReptSql.Append("				   ) svbq /* ship variance by qtr */ ");
				ReptSql.Append("              GROUP BY fiscal_quarter)) ");

				// fill dataset
				OracleDataAdapter oda;

				oda = new OracleDataAdapter(ReptSql.ToString(), ConfigurationSettings.AppSettings.Get("ConnectString"));
				oda.Fill(dsRept);

				return dsRept;
			}
			catch (Exception ex) 
			{
				throw new Exception("Failed in DSCDService.getDSCDSixPackSmmry. " + ex.ToString());
			}
		}

		public string MonthlySummaryUrl(string GblId,string NetId)
		{
			//CODEGEN: This call is required by the ASP.NET Web Services Designer
			InitializeComponent();
			try
			{
				string id = CreateSession(GblId);

				UpdateSession(NetId,id,this.View,this.Category,this.Window,this.StartDt,this.EndDt,this.DaysEarly,this.DaysLate,
					this.MonthlyInd,this.SummaryType,
					this.Current,this.OrgType, this.OrgId,"","","","",this.OrgId,"",
					this.SoldToCode,"","","","","","","","","",
					"","","","","","","","","","","","","","","",this.GamCode,"");
				string myUrl = "http://" + HttpContext.Current.Request.ServerVariables["Server_Name"];
				int Found = myUrl.IndexOf (".com");
				if (Found < 0)
				{
					myUrl += ".us.tycoelectronics.com";
				}
				myUrl += this.appPath;
				myUrl += "smresults.asp?s=" + id + "&v=" + View + "&c=" + Category + "&w=" + Window + "&mdi=" + MonthlyInd;
				return myUrl;
				//return myUrl;
			}
			catch (Exception ex)
			{
				throw new Exception("Failed in DSCDService.MonthlySummary. " + ex.ToString());
			}
		}
		public string MonthlyGeneralUrl(string GblId, string NetId)
		{
			try
			{
				string id = CreateSession(GblId);

				UpdateSession(NetId,id,this.View,this.Category,this.Window,this.StartDt,this.EndDt,this.DaysEarly,this.DaysLate,
					this.MonthlyInd,this.SummaryType,
					this.Current,this.OrgType, this.OrgId,"","","","",this.OrgId,"",
					this.SoldToCode,"","","","","","","","","",
					"","","",this.CompareType,"","","","","","","","","","","",this.GamCode,"");
				string myUrl = "http://" + HttpContext.Current.Request.ServerVariables["Server_Name"];
				int Found = myUrl.IndexOf (".com");
				if (Found < 0)
				{
					myUrl += ".us.tycoelectronics.com";
				}
				myUrl += this.appPath;
				myUrl += "results.asp?s=" + id + "&v=" + View + "&c=" + Category + "&w=" + Window + "&mdi=" + MonthlyInd;
				return myUrl;
				//return myUrl;
			}
			catch (Exception ex)
			{
				throw new Exception("Failed in DSCDService.MonthlySummary. " + ex.ToString());
			}

		}

		public string CreateSession(string GblId)
		{
			OracleConnection Conn = new OracleConnection(ConfigurationSettings.AppSettings["ConnectString"]);
			OracleCommand OraCmd = new OracleCommand();

			Conn.Open ();

			OracleParameter iGblId = new OracleParameter ("iGlobalId",GblId);
			OracleParameter SessionId = new OracleParameter("oSessionID",OracleType.VarChar );
			OracleParameter ErrNum = new OracleParameter("oErrorNumber",OracleType.VarChar );
			OracleParameter ErrDesc = new OracleParameter("oErrorDesc",OracleType.VarChar );

			SessionId.Direction = ParameterDirection.Output;
			ErrNum.Direction=ParameterDirection.Output;
			ErrDesc.Direction=ParameterDirection.Output;

			iGblId.Size = 100;
			SessionId.Size = 100;
			ErrNum.Size = 100;
			ErrDesc.Size = 500;

			OraCmd.Connection = Conn;
			OraCmd.CommandText = "scd_source.scdsearch.CreateCurrentSession";
			OraCmd.CommandType = CommandType.StoredProcedure;
			OraCmd.Parameters.Add (iGblId);
			OraCmd.Parameters.Add (SessionId);
			OraCmd.Parameters.Add (ErrNum);
			OraCmd.Parameters.Add (ErrDesc);

			try
			{
				OraCmd.ExecuteNonQuery ();
				return SessionId.Value.ToString() ;
			}

			catch (Exception ex)
			{
				throw new Exception ("Failed in Create Session " + ex.ToString());
			}
		}
		public void UpdateSession(string iAmpId,string iSessionId,string iViewId,string iCategoryId, string iWindowId, string iStartDt,
								string iEndDt, string iDaysEarly, string iDaysLate, string iMonthDailyInd, string iSmryType, string iCurrentHist,
								string iOrgType, string iOrgId, string iCustAcctTypeCde, string iPart, string iPlant, string iLocation,
								string iAcctOrgId, string iShipTo, string iSoldTo, string iWWCust, string iInvOrgId, string iController,
								string iCntlrEmpNbr, string iStkMake, string iTeam, string iProdCde, string iProdLne, string iIBC,
								string iIC, string iMfgCampus, string iMfgBulding, string iComparisonType, string iOpenShpOrder, 
								string iProfitCtr, string iCompetencyBusCde, string iOrgDt, string iSubCompetencyBusCde,
								string iProdMgr, string iLeadTimeType, string iSalesOffice, string iSalesGroup, string iMfgOrgType,
								string iMfgOrgId, string iGamAcct, string iPartKeyID)	
		{
			OracleConnection Conn = new OracleConnection(ConfigurationSettings.AppSettings["ConnectString"]);
			OracleCommand OraCmd = new OracleCommand();

			Conn.Open ();

			OracleParameter AmpId = new OracleParameter ("iAmpID",iAmpId);
			OracleParameter SessionId = new OracleParameter ("iSessionId", iSessionId);
			OracleParameter ViewId = new OracleParameter("iViewId",iViewId);
			OracleParameter CategoryId = new OracleParameter("iCategoryId",iCategoryId );
			OracleParameter WindowId = new OracleParameter("iWindowId",iWindowId );
			OracleParameter StartDt = new OracleParameter("iStartDt",iStartDt );
			OracleParameter EndDt = new OracleParameter("iEndDt",iEndDt );
			OracleParameter DaysEarly = new OracleParameter("iDaysEarly",iDaysEarly );
			OracleParameter DaysLate = new OracleParameter("iDaysLate",iDaysLate );
			OracleParameter MonthDailyInd = new OracleParameter("iMonthDailyInd",iMonthDailyInd );
			OracleParameter SmryType = new OracleParameter("iSmryType",iSmryType );
			OracleParameter CurrentHist = new OracleParameter("iCurrentHist",iCurrentHist );
			OracleParameter OrgType = new OracleParameter("iOrgType",iOrgType );
			OracleParameter OrgId = new OracleParameter("iOrgId",iOrgId );
			OracleParameter CustAcctTypeCde = new OracleParameter("iCustAcctTypeCde",iCustAcctTypeCde );
			OracleParameter Part = new OracleParameter("iPart",iPart );
			OracleParameter Plant = new OracleParameter("iPlant",iPlant );
			OracleParameter Location = new OracleParameter("iLocation",iLocation );
			OracleParameter AcctOrgId = new OracleParameter("iAcctOrgId",iAcctOrgId);
			OracleParameter ShipTo = new OracleParameter("iShipTo",iShipTo );
			OracleParameter SoldTo = new OracleParameter("iSoldTo",iSoldTo );
			OracleParameter WWCust = new OracleParameter("iWWCust",iWWCust );
			OracleParameter InvOrgId = new OracleParameter("iInvOrgId",iInvOrgId );
			OracleParameter Controller = new OracleParameter("iController",iController );
			OracleParameter CntlrEmpNbr = new OracleParameter("iCntlrEmpNbr",iCntlrEmpNbr );
			OracleParameter StkMake = new OracleParameter("iStkMake",iStkMake );
			OracleParameter Team = new OracleParameter("iTeam",iTeam );

			OracleParameter ProdCde = new OracleParameter("iProdCde",iProdCde );
			OracleParameter ProdLne = new OracleParameter("iProdLne",iProdLne );
			OracleParameter IBC = new OracleParameter("iIBC",iIBC );
			OracleParameter IC = new OracleParameter("iIC",iIC );
			OracleParameter MfgCampus = new OracleParameter("iMfgCampus",iMfgCampus);
			OracleParameter MfgBulding = new OracleParameter("iMfgBulding",iMfgBulding);
			OracleParameter ComparisonType = new OracleParameter("iComparisonType",iComparisonType);
			OracleParameter OpenShpOrder = new OracleParameter("iOpenShpOrder",iOpenShpOrder);
			OracleParameter ProfitCtr = new OracleParameter("iProfitCtr",iProfitCtr);
			OracleParameter CompetencyBusCde = new OracleParameter("iCompetencyBusCde",iCompetencyBusCde);
			OracleParameter OrgDt = new OracleParameter("iOrgDt",iOrgDt);
			OracleParameter SubCompetencyBusCde = new OracleParameter("iSubCompetencyBusCde",iSubCompetencyBusCde);
			OracleParameter ProdMgr = new OracleParameter("iProdMgr",iProdMgr);
			OracleParameter LeadTimeType = new OracleParameter("iLeadTimeType",iLeadTimeType);
			OracleParameter SalesOffice = new OracleParameter("iSalesOffice",iSalesOffice);
			OracleParameter SalesGroup = new OracleParameter("iSalesGroup",iSalesGroup);
			OracleParameter MfgOrgType = new OracleParameter("iMfgOrgType",iMfgOrgType);
			OracleParameter MfgOrgId = new OracleParameter("iMfgOrgId",iMfgOrgId);
			OracleParameter GamAcct = new OracleParameter("iGamAcct",iGamAcct);
			OracleParameter PartKeyID = new OracleParameter("iPartKeyID",iPartKeyID);

			OracleParameter ErrNum = new OracleParameter("oErrorNumber",OracleType.VarChar );
			OracleParameter ErrDesc = new OracleParameter("oErrorDesc",OracleType.VarChar );

			ErrNum.Direction=ParameterDirection.Output;
			ErrDesc.Direction=ParameterDirection.Output;

			AmpId.Size = 100;
			SessionId.Size = 100;
			ViewId.Size = 100;
			CategoryId.Size = 100;
			WindowId.Size = 100;
			StartDt.Size = 100;
			EndDt.Size = 100;
			DaysEarly.Size = 100;
			DaysLate.Size = 100;
			MonthDailyInd.Size = 100;
			SmryType.Size = 100;
			CurrentHist.Size = 100;
			OrgType.Size = 100;
			OrgId.Size = 100;
			CustAcctTypeCde.Size = 100;
			Part.Size = 100;
			Plant.Size = 100;
			Location.Size = 100;
			AcctOrgId.Size=100;
			ShipTo.Size = 100;
			SoldTo.Size = 100;
			WWCust.Size = 100;
			InvOrgId.Size = 100;
			Controller.Size = 100;
			CntlrEmpNbr.Size = 100;
			StkMake.Size = 100;
			Team.Size = 100;

			ProdCde.Size = 100;
			ProdLne.Size = 100;
			IBC.Size = 100;
			IC.Size = 100;
			MfgCampus.Size = 100;
			MfgBulding.Size = 100;
			ComparisonType.Size = 100;
			OpenShpOrder.Size = 100;
			ProfitCtr.Size = 100;
			CompetencyBusCde.Size = 100;
			OrgDt.Size = 100;
			SubCompetencyBusCde.Size = 100;
			ProdMgr.Size = 100;
			LeadTimeType.Size = 100;
			SalesOffice.Size = 100;
			SalesGroup.Size = 100;
			MfgOrgType.Size = 100;
			MfgOrgId.Size = 100;
			GamAcct.Size = 100;
			PartKeyID.Size = 100;
			ErrNum.Size = 100;
			ErrDesc.Size = 500;

			OraCmd.Connection = Conn;
			OraCmd.CommandText = "scd_source.scdsearch.UpdateSession";
			OraCmd.CommandType = CommandType.StoredProcedure;

			OraCmd.Parameters.Add (AmpId);
			OraCmd.Parameters.Add(SessionId);
			OraCmd.Parameters.Add (ViewId);
			OraCmd.Parameters.Add (CategoryId);
			OraCmd.Parameters.Add (WindowId);
			OraCmd.Parameters.Add (StartDt);
			OraCmd.Parameters.Add (EndDt);
			OraCmd.Parameters.Add (DaysEarly);
			OraCmd.Parameters.Add (DaysLate);
			OraCmd.Parameters.Add (MonthDailyInd);
			OraCmd.Parameters.Add (SmryType);
			OraCmd.Parameters.Add (CurrentHist);
			OraCmd.Parameters.Add (OrgType);
			OraCmd.Parameters.Add (OrgId);
			OraCmd.Parameters.Add (CustAcctTypeCde);
			OraCmd.Parameters.Add (Part);
			OraCmd.Parameters.Add (Plant);
			OraCmd.Parameters.Add (Location);
			OraCmd.Parameters.Add(AcctOrgId);
			OraCmd.Parameters.Add (ShipTo);
			OraCmd.Parameters.Add (SoldTo);
			OraCmd.Parameters.Add (WWCust);
			OraCmd.Parameters.Add (InvOrgId);
			OraCmd.Parameters.Add (Controller);
			OraCmd.Parameters.Add (CntlrEmpNbr);
			OraCmd.Parameters.Add (StkMake);
			OraCmd.Parameters.Add (Team);

			OraCmd.Parameters.Add (ProdCde);
			OraCmd.Parameters.Add (ProdLne);
			OraCmd.Parameters.Add (IBC);
			OraCmd.Parameters.Add (IC);
			OraCmd.Parameters.Add (MfgCampus);
			OraCmd.Parameters.Add (MfgBulding);
			OraCmd.Parameters.Add (ComparisonType);
			OraCmd.Parameters.Add (OpenShpOrder);
			OraCmd.Parameters.Add (ProfitCtr);
			OraCmd.Parameters.Add (CompetencyBusCde);
			OraCmd.Parameters.Add (OrgDt);
			OraCmd.Parameters.Add (SubCompetencyBusCde);
			OraCmd.Parameters.Add (ProdMgr);
			OraCmd.Parameters.Add (LeadTimeType);
			OraCmd.Parameters.Add (SalesOffice);
			OraCmd.Parameters.Add (SalesGroup);
			OraCmd.Parameters.Add (MfgOrgType);
			OraCmd.Parameters.Add (MfgOrgId);
			OraCmd.Parameters.Add (GamAcct);
			OraCmd.Parameters.Add (PartKeyID);

			OraCmd.Parameters.Add (ErrNum);
			OraCmd.Parameters.Add (ErrDesc);

			try
			{
				OraCmd.ExecuteNonQuery ();
				if (ErrNum.Value.ToString() != "0")
					throw new Exception ("Failed in Update Session " + ErrDesc.Value.ToString());
			}

			catch (Exception ex)
			{
				throw new Exception ("Failed in Create Session " + ex.ToString());
			}

		}





		#region Component Designer generated code
		
		//Required by the Web Services Designer 
		private IContainer components = null;
				
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if(disposing && components != null)
			{
				components.Dispose();
			}
			base.Dispose(disposing);		
		}
		
		#endregion

		// WEB SERVICE EXAMPLE
		// The HelloWorld() example service returns the string Hello World
		// To build, uncomment the following lines then save and build the project
		// To test this web service, press F5

//		[WebMethod]
//		public string HelloWorld()
//		{
//			return "Hello World";
//		}
	}
}
