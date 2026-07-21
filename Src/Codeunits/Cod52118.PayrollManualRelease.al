codeunit 52118 "12E Payroll Manual Release"
{
    TableNo = "12E Payroll Batch Header";

    trigger OnRun()
    var
        ReleasePayrollDoc: Codeunit "12E Payroll Release Mgmt";
    begin
        ReleasePayrollDoc.PerformManualRelease(Rec);
    end;

}
