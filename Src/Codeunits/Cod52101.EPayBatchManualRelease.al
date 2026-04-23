codeunit 52101 "12E EPay Batch Manual Release"
{
    TableNo = "12E EPIC Payments Batch Header";

    trigger OnRun()
    var
        ReleaseEPICPayBatchDoc: Codeunit "12E EPICPayBatch Release Mgmt.";
    begin
        ReleaseEPICPayBatchDoc.PerformManualRelease(Rec);
    end;
}
