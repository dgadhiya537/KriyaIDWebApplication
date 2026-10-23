using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KriyaID
{
    public partial class AdminConsultations : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadConsultations();
            }
        }

        private void LoadConsultations()
        {
            string status = ddlStatusFilter.SelectedValue;
            string sql = "SELECT * FROM Consultations";

            if (!string.IsNullOrEmpty(status))
            {
                sql += " WHERE Status = @Status";
            }
            sql += " ORDER BY Id DESC";

            DataTable dt = !string.IsNullOrEmpty(status)
                ? DB.GetDataTable(sql, DB.Param("@Status", status))
                : DB.GetDataTable(sql);

            gvConsultations.DataSource = dt;
            gvConsultations.DataBind();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadConsultations();
        }

        protected void gvConsultations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int leadId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SetContacted")
            {
                DB.ExecuteNonQuery("UPDATE Consultations SET Status = 'Contacted' WHERE Id = @Id", DB.Param("@Id", leadId));
                pnlAlert.Visible = true;
                litAlert.Text = "Lead marked as 'Contacted'.";
                LoadConsultations();
            }
            else if (e.CommandName == "SetClosed")
            {
                DB.ExecuteNonQuery("UPDATE Consultations SET Status = 'Closed' WHERE Id = @Id", DB.Param("@Id", leadId));
                pnlAlert.Visible = true;
                litAlert.Text = "Lead marked as 'Closed / Commissioned'.";
                LoadConsultations();
            }
            else if (e.CommandName == "DeleteConsultation")
            {
                DB.ExecuteNonQuery("DELETE FROM Consultations WHERE Id = @Id", DB.Param("@Id", leadId));
                pnlAlert.Visible = true;
                litAlert.Text = "Consultation record deleted.";
                LoadConsultations();
            }
        }

        public string GetLeadStatusBadge(string status)
        {
            switch (status)
            {
                case "New":
                    return "<span class='badge bg-info-subtle text-info border border-info-subtle px-2 py-1'>New Lead</span>";
                case "Contacted":
                    return "<span class='badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1'>Contacted</span>";
                case "Closed":
                    return "<span class='badge bg-success-subtle text-success border border-success-subtle px-2 py-1'>Closed</span>";
                default:
                    return "<span class='badge bg-secondary px-2 py-1'>" + status + "</span>";
            }
        }
    }
}
