codeunit 52117 "12E Payroll Release Mgmt"
{
    TableNo = "12E Payroll Batch Header";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var PayrollHeader: Record "12E Payroll Batch Header")
    begin
        // Validation check before release
        CheckForManualRelease(PayrollHeader);

        // Perform the actual release
        PerformManualCheckAndRelease(PayrollHeader);
    end;

    local procedure CheckForManualRelease(var PayrollHeader: Record "12E Payroll Batch Header")
    begin
        if PayrollHeader.Status = PayrollHeader.Status::Released then
            Error('Call Center Distribution document %1 is already Released.', PayrollHeader."No.");
    end;

    local procedure PerformManualCheckAndRelease(var PayrollHeader: Record "12E Payroll Batch Header")
    begin
        if PayrollHeader.Status <> PayrollHeader.Status::Open then
            Error('Only Open Call Center Distribution documents can be released. Document %1 skipped.', PayrollHeader."No.");

        PayrollHeader.Status := PayrollHeader.Status::Released;
        PayrollHeader.Modify(true);
    end;

    procedure PerformManualReopen(var PayrollHeader: Record "12E Payroll Batch Header")
    begin
        // Validation before reopening
        CheckReopenStatus(PayrollHeader);

        // Perform the actual reopen
        Reopen(PayrollHeader);
    end;

    local procedure CheckReopenStatus(var PayrollHeader: Record "12E Payroll Batch Header")
    begin
        if PayrollHeader.Status = PayrollHeader.Status::Open then
            Error('Call Center Distribution document %1 is already Open.', PayrollHeader."No.");
    end;

    local procedure Reopen(var PayrollHeader: Record "12E Payroll Batch Header")
    begin
        if PayrollHeader.Status <> PayrollHeader.Status::Released then
            Error('Only Released Call Center Distribution documents can be reopened. Document %1 skipped.', PayrollHeader."No.");

        PayrollHeader.Status := PayrollHeader.Status::Open;
        PayrollHeader.Modify(true);
    end;

}
