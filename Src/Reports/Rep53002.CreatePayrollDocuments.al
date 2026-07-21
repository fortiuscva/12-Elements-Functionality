report 53002 "12E Create Payroll Documents"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(PayrollBatchHeader; "12E Payroll Batch Header")
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                PayrollBatchMgmt: Codeunit "12E Payroll Batch Mgmt";
            begin
                PayrollBatchMgmt.CreatePayrollDocuments(PayrollBatchHeader);
            end;
        }
    }
}