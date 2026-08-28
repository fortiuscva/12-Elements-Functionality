codeunit 52130 "12E LMS Manual Reopen"
{
    TableNo = "12E LMS Transaction Header";

    trigger OnRun()
    var
        LMSReleaseMgt: Codeunit "12E LMS Release Mgt.";
    begin
        LMSReleaseMgt.PerformManualReopen(Rec);
    end;

}
