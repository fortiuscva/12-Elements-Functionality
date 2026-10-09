report 52112 "12E Create Payroll Doc. JQ"
{
    Caption = 'Create Payroll Documents';
    ProcessingOnly = true;
    UsageCategory = None;

    trigger OnPreReport()
    var
        PayrollBatchMgmt: Codeunit "12E Payroll Batch Mgmt";
    begin
        PayrollBatchMgmt.CreatePayrollBatches(0D, 0D);
    end;
}