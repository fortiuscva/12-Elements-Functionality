codeunit 52107 "12E CCD Manual Reopen"
{
    TableNo = "12E CCD Header";

    trigger OnRun()
    var
        ReleaseCCDDoc: Codeunit "12E CCD Release Mgmt";
    begin
        ReleaseCCDDoc.PerformManualReopen(Rec);
    end;
}
