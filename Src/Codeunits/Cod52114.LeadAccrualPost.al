codeunit 52114 "12E Lead Accrual Post"
{
    TableNo = "12E Lead Accrual";
    Permissions = tabledata "12E Lead Accrual" = RIMD,
                  tabledata "12E Lead Accrual Line" = RIMD;
    trigger OnRun()
    var
        PostedLeadAccrual: Record "12E Posted Lead Accrual";
        LeadAccrualLine: Record "12E Lead Accrual Line";
        PostedLeadAccrualLine: Record "12E Posted Lead Accrual Line";
    begin
        PostedLeadAccrual.Init();
        PostedLeadAccrual.TransferFields(Rec);
        PostedLeadAccrual."No." := 'P-' + Rec."No.";
        PostedLeadAccrual.Insert(true);

        LeadAccrualLine.Reset();
        LeadAccrualLine.SetRange("Lead Accrual No.", Rec."No.");
        if LeadAccrualLine.FindFirst() then begin
            repeat
                PostedLeadAccrualLine.Init();
                PostedLeadAccrualLine.TransferFields(LeadAccrualLine);
                PostedLeadAccrualLine."Lead Accrual No." := 'P-' + Rec."No.";
                PostedLeadAccrualLine.Insert(true);
            until LeadAccrualLine.Next() = 0;
        end;
        LeadAccrualLine.DeleteAll(true);
        Rec.Delete(true);
    end;
}
