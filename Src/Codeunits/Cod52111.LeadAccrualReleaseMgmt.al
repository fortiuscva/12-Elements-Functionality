codeunit 52111 "12E Lead Accrual Release Mgmt"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var LeadAccrual: Record "12E Lead Accrual")
    begin
        CheckForManualRelease(LeadAccrual);
        ValidateAccrualDocument(LeadAccrual);
        PerformManualCheckAndRelease(LeadAccrual);
    end;

    local procedure CheckForManualRelease(var LeadAccrual: Record "12E Lead Accrual")
    begin
        if LeadAccrual.Status = LeadAccrual.Status::Released then
            Error('Lead Accrual document %1 is already Released.', LeadAccrual."No.");
    end;

    local procedure ValidateAccrualDocument(var LeadAccrual: Record "12E Lead Accrual")
    var
        LeadAccrualMgmt: Codeunit "12E Lead Accrual Mgmt";
    begin
        LeadAccrual.ValidateAccrualPeriod();
        LeadAccrualMgmt.ValidateVendorSetup();
        ValidateAdjustedAccrualAmount(LeadAccrual);
    end;

    local procedure ValidateAdjustedAccrualAmount(var LeadAccrual: Record "12E Lead Accrual")
    var
        LeadAccrualLine: Record "12E Lead Accrual Line";
    begin
        LeadAccrualLine.Reset();
        LeadAccrualLine.SetRange("Lead Accrual No.", LeadAccrual."No.");

        if LeadAccrualLine.IsEmpty() then
            Error('There are no Lead Accrual lines to release for document %1.', LeadAccrual."No.");

        if LeadAccrualLine.FindSet() then
            repeat
                if LeadAccrualLine."Adjust Accrual Amount" = 0 then
                    Error('Adjust Accrual Amount must be specified for Vendor %1 on document %2.', LeadAccrualLine."Vendor No.", LeadAccrual."No.");
            until LeadAccrualLine.Next() = 0;
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
        CheckReopenStatus(LeadAccrual);
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