codeunit 52102 "12E EPAY Batch Manual Reopen"
{
    TableNo = "12E EPIC Payments Batch Header";

    trigger OnRun()
    var
        ReleaseEPICPayBatchDoc: Codeunit "12E EPICPayBatch Release Mgmt.";
    begin
        ReleaseEPICPayBatchDoc.PerformManualReopen(Rec);
    end;

}
