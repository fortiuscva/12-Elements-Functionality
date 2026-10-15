report 52108 "12E Delete Posted Payroll Docs"
{
    Caption = 'Delete Posted Payroll Documents';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(PostedPayrollHeader; "12E Posted Payroll Header")
        {
            RequestFilterFields = "Client ID", "Batch ID";
            dataitem(PostedPayrollLine; "12E Posted Payroll Line")
            {
                DataItemLinkReference = PostedPayrollHeader;
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                begin
                    PostedPayrollLine.Delete(true);
                end;
            }
            trigger OnPostDataItem()
            begin
                PostedPayrollHeader.Delete(true);
            end;
        }
    }
}
