codeunit 52113 "12E LeadAccrual Manual Reopen"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    var
        LeadAccrualReleaseMgmt: Codeunit "12E Lead Accrual Release Mgmt";
    begin
        LeadAccrualReleaseMgmt.PerformManualReopen(Rec);
    end;

}
