codeunit 52129 "12E LMS Manual Release"
{
    TableNo = "12E LMS Transaction Header";

    trigger OnRun()
    var
        LMSReleaseMgt: Codeunit "12E LMS Release Mgt.";
    begin
        LMSReleaseMgt.PerformManualRelease(Rec);
    end;

}
