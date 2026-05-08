codeunit 52106 "12E CCD Manual Release"
{
    TableNo = "12E CC Distribution Header";

    trigger OnRun()
    var
        ReleaseCCDDoc: Codeunit "12E CCD Release Mgmt";
    begin
        ReleaseCCDDoc.PerformManualRelease(Rec);
    end;

}
