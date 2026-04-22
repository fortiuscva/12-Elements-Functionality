codeunit 52100 "12E EPICPayBatch Release Mgmt."
{
    TableNo = "12E EPIC Payments Batch Header";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    begin
        // Validation check before release
        CheckForManualRelease(EPICPayBatchHeader);

        // Perform the actual release
        PerformManualCheckAndRelease(EPICPayBatchHeader);
    end;

    local procedure CheckForManualRelease(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    begin
        if EPICPayBatchHeader.Status = EPICPayBatchHeader.Status::Released then
            Error('EPIC Payments Batch document %1 is already Released.', EPICPayBatchHeader."Batch No.");
    end;

    local procedure PerformManualCheckAndRelease(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    begin
        if EPICPayBatchHeader.Status <> EPICPayBatchHeader.Status::Open then
            Error('Only Open EPIC Payments Batch documents can be released. Document %1 skipped.', EPICPayBatchHeader."Batch No.");

        EPICPayBatchHeader.Status := EPICPayBatchHeader.Status::Released;
        EPICPayBatchHeader.Modify(true);
    end;

    procedure PerformManualReopen(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    begin
        // Validation before reopening
        CheckReopenStatus(EPICPayBatchHeader);

        // Perform the actual reopen
        Reopen(EPICPayBatchHeader);
    end;

    local procedure CheckReopenStatus(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    begin
        if EPICPayBatchHeader.Status = EPICPayBatchHeader.Status::Open then
            Error('EPIC Payments Batch document %1 is already Open.', EPICPayBatchHeader."Batch No.");
    end;

    local procedure Reopen(var EPICPayBatchHeader: Record "12E EPIC Payments Batch Header")
    begin
        if EPICPayBatchHeader.Status <> EPICPayBatchHeader.Status::Released then
            Error('Only Released EPIC Payments Batch documents can be reopened. Document %1 skipped.', EPICPayBatchHeader."Batch No.");

        EPICPayBatchHeader.Status := EPICPayBatchHeader.Status::Open;
        EPICPayBatchHeader.Modify(true);
    end;



}
