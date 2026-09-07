report 52108 "12E Delete payroll batch"
{
    Caption = 'Delete payroll batch';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(PayrollBatch; "12E Questco Payroll Batch")
        {
            RequestFilterFields = "Client ID", "Batch ID";
            trigger OnAfterGetRecord()
            begin
                PayrollBatch.Delete(true);
            end;
        }
    }
}
