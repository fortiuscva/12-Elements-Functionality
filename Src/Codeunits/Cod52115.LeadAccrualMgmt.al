codeunit 52115 "12E Lead Accrual Mgmt"
{
    TableNo = "12E Lead Accrual";
    trigger OnRun()
    var
        LeadAccLineLcl: Record "12E Lead Accrual Line";
        VendorLcl: Record Vendor;
        LastPostingDate: Date;
    begin
        DeleteAllExistingLeadAccrualLines(Rec);
        VendorLcl.Reset();
        VendorLcl.SetRange("12E Lead Accrual Vendor", true);
        if VendorLcl.FindSet() then begin
            repeat
                // if PostedPurchaseInvoiceExists(VendorLcl."No.", Rec."From Date", Rec."To Date") then begin
                Clear(LastPostingDate);
                LastPostingDate := 0D;
                LeadAccLineLcl.Init();
                LeadAccLineLcl."Lead Accrual No." := Rec."No.";
                LeadAccLineLcl."Line No." := GetNextLineNo(Rec);
                LeadAccLineLcl.Insert(true);
                LeadAccLineLcl.Validate("Vendor No.", VendorLcl."No.");
                LeadAccLineLcl.Validate("Vendor Name", VendorLcl.Name);
                LastPostingDate := GetLastPostingDate(VendorLcl."No.");
                LeadAccLineLcl.Validate("Last PPI Posting Date", LastPostingDate);
                LeadAccLineLcl.Validate("Lead Acq. Cost Vendor", GetLeadAcqCostsForThisVendor(VendorLcl."No.", LastPostingDate));
                LeadAccLineLcl.Validate("Accrual Amount", GetAccrualAmountsForThisVendor(VendorLcl."No.", Rec."From Date", Rec."To Date"));
                LeadAccLineLcl.Modify(true);
            // end;
            until VendorLcl.Next() = 0;
        end;
    end;

    local procedure DeleteAllExistingLeadAccrualLines(LeadAccHeader: Record "12E Lead Accrual")
    begin
        LeadAccLineGbl.Reset();
        LeadAccLineGbl.SetRange("Lead Accrual No.", LeadAccHeader."No.");
        if LeadAccLineGbl.Count > 0 then
            LeadAccLineGbl.DeleteAll(true);
    end;

    local procedure PostedPurchaseInvoiceExists(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Boolean
    var
    begin
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeaderGbl.SetRange("Posting Date", StartDate, EndDate);
        if PurchInvHeaderGbl.FindLast() then
            exit(true);
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

    local procedure GetLastPostingDate(VendorNo: Code[20]): Date
    begin
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        if PurchInvHeaderGbl.FindLast() then
            exit(PurchInvHeaderGbl."Posting Date");

        exit(0D);
    end;

    local procedure GetLeadAcqCostsForThisVendor(VendorNo: Code[20]; LastPostingDate: Date): Decimal
    var
        StartDate: Date;
        EndDate: Date;
        LeadAcquisition: Record "12E Lead Validation Entry";
        LeadAcqCost: Decimal;
    begin
        Clear(LeadAcqCost);
        LeadAcqCost := 0.0;
        StartDate := CalcDate('<+1D>', LastPostingDate);
        EndDate := CalcDate('<CM>', LastPostingDate);
        LeadAcquisition.Reset();
        LeadAcquisition.SetRange("Posting Date", StartDate, EndDate);
        if LeadAcquisition.FindSet() then begin
            repeat
                LeadAcqCost += LeadAcquisition."Lead Cost Amount";
            until LeadAcquisition.Next() = 0;
        end;

        exit(LeadAcqCost);
    end;

    local procedure GetAccrualAmountsForThisVendor(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        AccrualAmount: Decimal;
    begin
        Clear(AccrualAmount);
        AccrualAmount := 0;
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeaderGbl.SetRange("Posting Date", StartDate, EndDate);
        if PurchInvHeaderGbl.FindSet() then begin
            repeat
                AccrualAmount += PurchInvHeaderGbl.Amount;
            until PurchInvHeaderGbl.Next() = 0;
        end;

        exit(AccrualAmount);
    end;

    var
        VendorGbl: Record Vendor;
        PurchInvHeaderGbl: Record "Purch. Inv. Header";
        LeadAccLineGbl: Record "12E Lead Accrual Line";


}