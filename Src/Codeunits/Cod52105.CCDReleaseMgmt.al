codeunit 52105 "12E CCD Release Mgmt"
{
    TableNo = "12E CC Distribution Header";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var CCDHeader: Record "12E CC Distribution Header")
    begin
        // Validation check before release
        CheckForManualRelease(CCDHeader);

        // Perform the actual release
        PerformManualCheckAndRelease(CCDHeader);
    end;

    local procedure CheckForManualRelease(var CCDHeader: Record "12E CC Distribution Header")
    begin
        if CCDHeader.Status = CCDHeader.Status::Released then
            Error('Call Center Distribution document %1 is already Released.', CCDHeader."No.");
    end;

    local procedure PerformManualCheckAndRelease(var CCDHeader: Record "12E CC Distribution Header")
    begin
        if CCDHeader.Status <> CCDHeader.Status::Open then
            Error('Only Open Call Center Distribution documents can be released. Document %1 skipped.', CCDHeader."No.");

        CCDHeader.Status := CCDHeader.Status::Released;
        CCDHeader.Modify(true);
    end;

    procedure PerformManualReopen(var CCDHeader: Record "12E CC Distribution Header")
    begin
        // Validation before reopening
        CheckReopenStatus(CCDHeader);

        // Perform the actual reopen
        Reopen(CCDHeader);
    end;

    local procedure CheckReopenStatus(var CCDHeader: Record "12E CC Distribution Header")
    begin
        if CCDHeader.Status = CCDHeader.Status::Open then
            Error('Call Center Distribution document %1 is already Open.', CCDHeader."No.");
    end;

    local procedure Reopen(var CCDHeader: Record "12E CC Distribution Header")
    begin
        if CCDHeader.Status <> CCDHeader.Status::Released then
            Error('Only Released Call Center Distribution documents can be reopened. Document %1 skipped.', CCDHeader."No.");

        CCDHeader.Status := CCDHeader.Status::Open;
        CCDHeader.Modify(true);
    end;

}
