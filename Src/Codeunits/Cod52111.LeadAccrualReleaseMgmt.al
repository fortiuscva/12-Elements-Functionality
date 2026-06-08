codeunit 52111 "12E Lead Accrual Release Mgmt"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var LeadAccrual: Record "12E Lead Accrual")
    begin
        // Validation check before release
        CheckForManualRelease(LeadAccrual);

        // Perform the actual release
        PerformManualCheckAndRelease(LeadAccrual);
    end;

    local procedure CheckForManualRelease(var LeadAccrual: Record "12E Lead Accrual")
    begin
        if LeadAccrual.Status = LeadAccrual.Status::Released then
            Error('Lead Accrual document %1 is already Released.', LeadAccrual."No.");
    end;

    local procedure PerformManualCheckAndRelease(var LeadAccrual: Record "12E Lead Accrual")
    begin
        if LeadAccrual.Status <> LeadAccrual.Status::Open then
            Error('Only Open Lead Accrual documents can be released. Document %1 skipped.', LeadAccrual."No.");

        LeadAccrual.Status := LeadAccrual.Status::Released;
        LeadAccrual.Modify(true);
    end;

    procedure PerformManualReopen(var LeadAccrual: Record "12E Lead Accrual")
    begin
        // Validation before reopening
        CheckReopenStatus(LeadAccrual);

        // Perform the actual reopen
        Reopen(LeadAccrual);
    end;

    local procedure CheckReopenStatus(var LeadAccrual: Record "12E Lead Accrual")
    begin
        if LeadAccrual.Status = LeadAccrual.Status::Open then
            Error('Lead Accrual document %1 is already Open.', LeadAccrual."No.");
    end;

    local procedure Reopen(var LeadAccrual: Record "12E Lead Accrual")
    begin
        if LeadAccrual.Status <> LeadAccrual.Status::Released then
            Error('Only Released Lead Accrual documents can be reopened. Document %1 skipped.', LeadAccrual."No.");

        LeadAccrual.Status := LeadAccrual.Status::Open;
        LeadAccrual.Modify(true);
    end;


}
