codeunit 52112 "12E LeadAccrual Manual Release"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    var
        LeadAccrualReleaseMgmt: Codeunit "12E Lead Accrual Release Mgmt";
    begin
        LeadAccrualReleaseMgmt.PerformManualRelease(Rec);
    end;

}
