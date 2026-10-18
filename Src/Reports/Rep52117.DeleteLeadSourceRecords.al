report 52117 "12E Delete Lead Source Records"
{
    ApplicationArea = All;
    Caption = 'Delete Lead Source Records';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(LeadSourceReconciliation; "12E Lead Source Reconciliation")
        {
            RequestFilterFields = "PK ID", "Portfolio Name", "Lead Original Date";
            trigger OnAfterGetRecord()
            begin
                LeadSourceReconciliation.Delete(true);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
