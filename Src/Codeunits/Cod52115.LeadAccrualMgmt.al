codeunit 52115 "12E Lead Accrual Mgmt"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    var
        LeadAccLineLcl: Record "12E Lead Accrual Line";
        VendorLcl: Record Vendor;
        LastPostingDate: Date;
        StartDate: Date;
        EndDate: Date;
    begin
        DeleteAllExistingLeadAccrualLines(Rec);

        VendorLcl.Reset();
        VendorLcl.SetRange("12E Lead Accrual Vendor", true);
        if VendorLcl.FindSet() then begin
            repeat
                LeadAccLineLcl.Init();
                LeadAccLineLcl."Lead Accrual No." := Rec."No.";
                LeadAccLineLcl."Line No." := GetNextLineNo(Rec);
                LeadAccLineLcl.Insert(true);
                LeadAccLineLcl.Validate("Vendor No.", VendorLcl."No.");
                LeadAccLineLcl.Validate("Vendor Name", VendorLcl.Name);

                if PostedPurchaseInvoiceExists(VendorLcl."No.", Rec."From Date", Rec."To Date") then begin
                    Clear(LastPostingDate);
                    LastPostingDate := GetLastPostingDate(VendorLcl."No.", Rec."From Date", Rec."To Date");
                    LeadAccLineLcl.Validate("Last PPI Posting Date", LastPostingDate);
                    LeadAccLineLcl.Validate("Lead Acq. Cost Vendor", GetLeadAcqCostsForThisVendor(VendorLcl."No.", Rec."From Date", Rec."To Date"));

                    StartDate := CalcDate('<+1D>', LastPostingDate);
                    EndDate := CalcDate('<CM>', LastPostingDate);
                    LeadAccLineLcl.Validate("Accrual Amount", GetAccrualAmountsForThisVendor(VendorLcl."12E Lead Acq. Vendor No.", StartDate, EndDate));
                end
                else
                    LeadAccLineLcl.Validate("Accrual Amount", GetAccrualAmountsForThisVendor(VendorLcl."12E Lead Acq. Vendor No.", Rec."From Date", Rec."To Date"));

                LeadAccLineLcl.Modify(true);
            until VendorLcl.Next() = 0;
        end;
    end;

    local procedure DeleteAllExistingLeadAccrualLines(LeadAccHeader: Record "12E Lead Accrual")
    begin
        LeadAccLineGbl.Reset();
        LeadAccLineGbl.SetRange("Lead Accrual No.", LeadAccHeader."No.");
        if not LeadAccLineGbl.IsEmpty() then
            LeadAccLineGbl.DeleteAll(true);
    end;

    local procedure PostedPurchaseInvoiceExists(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Boolean
    begin
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeaderGbl.SetRange("Posting Date", StartDate, EndDate);
        exit(not PurchInvHeaderGbl.IsEmpty());
    end;

    local procedure GetNextLineNo(LeadAccHeader: Record "12E Lead Accrual"): Integer
    begin
        LeadAccLineGbl.Reset();
        LeadAccLineGbl.SetRange("Lead Accrual No.", LeadAccHeader."No.");
        if LeadAccLineGbl.FindLast() then
            exit(LeadAccLineGbl."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetLastPostingDate(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Date
    begin
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeaderGbl.SetRange("Posting Date", StartDate, EndDate);
        if PurchInvHeaderGbl.FindLast() then
            exit(PurchInvHeaderGbl."Posting Date");

        exit(0D);
    end;

    local procedure GetLeadAcqCostsForThisVendor(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        LeadAcqCost: Decimal;
    begin
        Clear(LeadAcqCost);
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeaderGbl.SetRange("Posting Date", StartDate, EndDate);
        if PurchInvHeaderGbl.FindSet() then
            repeat
                LeadAcqCost += PurchInvHeaderGbl.Amount;
            until PurchInvHeaderGbl.Next() = 0;

        exit(LeadAcqCost);
    end;

    local procedure GetAccrualAmountsForThisVendor(LeadProvider: Text[100]; StartDate: Date; EndDate: Date): Decimal
    var
        LeadSourceRecon: Record "12E Lead Source Reconciliation";
        AccrualAmount: Decimal;
    begin
        Clear(AccrualAmount);
        LeadSourceRecon.Reset();
        LeadSourceRecon.SetRange("Lead Provider", LeadProvider);
        LeadSourceRecon.SetRange("Lead Original Date", StartDate, EndDate);
        if LeadSourceRecon.FindSet() then
            repeat
                AccrualAmount += LeadSourceRecon."Lead Sold Cost";
            until LeadSourceRecon.Next() = 0;

        exit(AccrualAmount);
    end;

    var
        PurchInvHeaderGbl: Record "Purch. Inv. Header";
        LeadAccLineGbl: Record "12E Lead Accrual Line";
}