report 52116 "12E Delete Posted Lead Accrual"
{
    ApplicationArea = All;
    Caption = 'Delete Posted Lead Accruals';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(PostedLeadAccrual; "12E Posted Lead Accrual")
        {
            RequestFilterFields = "No.";
            dataitem(PostedLeadAccrualLine; "12E Posted Lead Accrual Line")
            {
                DataItemLinkReference = PostedLeadAccrual;
                DataItemLink = "Lead Accrual No." = field("No.");
                trigger OnAfterGetRecord()
                begin
                    PostedLeadAccrualLine.Delete(true);
                end;
            }
            trigger OnPostDataItem()
            begin
                PostedLeadAccrual.Delete(true);
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
