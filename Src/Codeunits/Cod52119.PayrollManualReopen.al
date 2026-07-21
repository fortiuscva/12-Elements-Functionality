codeunit 52119 "12E Payroll Manual Reopen"
{
    TableNo = "12E Payroll Batch Header";

    trigger OnRun()
    var
        ReleasePayrollDoc: Codeunit "12E Payroll Release Mgmt";
    begin
        ReleasePayrollDoc.PerformManualReopen(Rec);
    end;
}
