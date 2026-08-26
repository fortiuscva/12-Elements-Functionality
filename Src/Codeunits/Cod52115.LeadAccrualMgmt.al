codeunit 52115 "12E Lead Accrual Mgmt"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    var
        LeadAccLineLcl: Record "12E Lead Accrual Line";
        VendorLcl: Record Vendor;
        LastPostingDate: Date;
        LastPPIInvoiceNo: Code[20];
    begin
        Rec.ValidateAccrualPeriod();
        ValidateVendorSetup();
        CheckExistingAccrual(Rec);

        DeleteAllExistingLeadAccrualLines(Rec);

        VendorLcl.Reset();
        VendorLcl.SetRange("12E Lead Accrual Vendor", true);
        if VendorLcl.FindSet() then begin
            repeat
                LeadAccLineLcl.Init();
                LeadAccLineLcl."Lead Accrual No." := Rec."No.";
                LeadAccLineLcl."Line No." := GetNextLineNo(Rec);
                LeadAccLineLcl."From Date" := Rec."From Date";
                LeadAccLineLcl."To Date" := Rec."To Date";
                LeadAccLineLcl."Lead Provider" := VendorLcl."12E Lead Acq. Vendor No.";
                LeadAccLineLcl.Insert(true);
                LeadAccLineLcl.Validate("Vendor No.", VendorLcl."No.");

                if PostedPurchaseInvoiceExists(VendorLcl."No.", Rec."From Date", Rec."To Date") then begin
                    Clear(LastPostingDate);
                    Clear(LastPostingDate);
                    Clear(LastPPIInvoiceNo);
                    GetLastPostedPurchaseInvoice(VendorLcl."No.", Rec."From Date", Rec."To Date", LastPostingDate, LastPPIInvoiceNo);
                    LeadAccLineLcl.Validate("Last PPI Posting Date", LastPostingDate);
                    LeadAccLineLcl.Validate("Last Posted Purch. Invoice No.", LastPPIInvoiceNo);
                    LeadAccLineLcl.Validate("Last PPI Posting Date", LastPostingDate);
                    LeadAccLineLcl.Validate("Override Last PPI Posting Date", LastPostingDate);
                    LeadAccLineLcl.Validate("Lead Acq. Cost Vendor", GetLeadAcqCostsForThisVendor(VendorLcl."No.", Rec."From Date", Rec."To Date"));
                    RecalculateAccrualAmount(LeadAccLineLcl);
                    LeadAccLineLcl.Validate("Adjust Accrual Amount", LeadAccLineLcl."Accrual Amount");
                end
                else begin
                    LeadAccLineLcl.Validate("Accrual Amount", GetAccrualAmountsForThisVendor(VendorLcl."12E Lead Acq. Vendor No.", Rec."From Date", Rec."To Date"));
                    LeadAccLineLcl.Validate("Adjust Accrual Amount", LeadAccLineLcl."Accrual Amount");
                end;

                LeadAccLineLcl.Modify(true);
            until VendorLcl.Next() = 0;
        end;
    end;

    procedure ValidateVendorSetup()
    var
        VendorLcl: Record Vendor;
    begin
        VendorLcl.Reset();
        VendorLcl.SetRange("12E Lead Accrual Vendor", true);

        if VendorLcl.IsEmpty() then
            Error('No vendors are configured as Lead Accrual Vendors.');

        if VendorLcl.FindSet() then
            repeat
                VendorLcl.TestField("12E Lead Acq. Vendor No.");
                VendorLcl.TestField("12E Lead Credit Account No.");
                VendorLcl.TestField("12E Lead Debit Account No.");
            until VendorLcl.Next() = 0;
    end;

    local procedure DeleteAllExistingLeadAccrualLines(LeadAccrual: Record "12E Lead Accrual")
    begin
        LeadAccLineGbl.Reset();
        LeadAccLineGbl.SetRange("Lead Accrual No.", LeadAccrual."No.");
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

    local procedure GetNextLineNo(LeadAccrual: Record "12E Lead Accrual"): Integer
    begin
        LeadAccLineGbl.Reset();
        LeadAccLineGbl.SetRange("Lead Accrual No.", LeadAccrual."No.");
        if LeadAccLineGbl.FindLast() then
            exit(LeadAccLineGbl."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetLastPostedPurchaseInvoice(VendorNo: Code[20]; StartDate: Date; EndDate: Date; var PostingDate: Date; var InvoiceNo: Code[20])
    begin
        Clear(PostingDate);
        Clear(InvoiceNo);
        PurchInvHeaderGbl.Reset();
        PurchInvHeaderGbl.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeaderGbl.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeaderGbl.SetRange("Posting Date", StartDate, EndDate);

        if PurchInvHeaderGbl.FindLast() then begin
            PostingDate := PurchInvHeaderGbl."Posting Date";
            InvoiceNo := PurchInvHeaderGbl."No.";
        end;
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
                PurchInvHeaderGbl.CalcFields(Amount);
                LeadAcqCost += PurchInvHeaderGbl.Amount;
            until PurchInvHeaderGbl.Next() = 0;

        exit(LeadAcqCost);
    end;

    procedure GetAccrualAmountsForThisVendor(LeadProvider: Text[100]; StartDate: Date; EndDate: Date): Decimal
    var
        LeadSourceRecon: Record "12E Lead Source Reconciliation";
        AccrualAmount: Decimal;
    begin
        Clear(AccrualAmount);
        LeadSourceRecon.Reset();
        LeadSourceRecon.SetRange("Datasource ID", GetDataSourceID());
        LeadSourceRecon.SetRange("Lead Provider", LeadProvider);
        LeadSourceRecon.SetRange("Lead Original Date", StartDate, EndDate);
        LeadSourceRecon.CalcSums("Lead Sold Cost");

        exit(LeadSourceRecon."Lead Sold Cost");
    end;

    procedure RecalculateAccrualAmount(var LeadAccLine: Record "12E Lead Accrual Line")
    var
        Vendor: Record Vendor;
        StartDate: Date;
        EndDate: Date;
    begin
        if not Vendor.Get(LeadAccLine."Vendor No.") then
            exit;

        if LeadAccLine."Override Last PPI Posting Date" <> 0D then begin
            StartDate := CalcDate('<+1D>', LeadAccLine."Override Last PPI Posting Date");
            EndDate := CalcDate('<CM>', LeadAccLine."Override Last PPI Posting Date");
        end
        else begin
            StartDate := LeadAccLine."From Date";
            EndDate := LeadAccLine."To Date";
        end;

        LeadAccLine.Validate("Accrual Amount", GetAccrualAmountsForThisVendor(Vendor."12E Lead Acq. Vendor No.", StartDate, EndDate));
    end;

    procedure GetDataSourceID(): Integer
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());

        if CompanyMapping.FindLast() then
            exit(CompanyMapping."DataSource ID");

        exit(0);
    end;

    local procedure CheckExistingAccrual(LeadAccrual: Record "12E Lead Accrual")
    var
        ExistingLeadAccrual: Record "12E Lead Accrual";
        PostedLeadAccrual: Record "12E Posted Lead Accrual";
    begin
        ExistingLeadAccrual.Reset();
        ExistingLeadAccrual.SetRange(Year, LeadAccrual.Year);
        ExistingLeadAccrual.SetRange(Month, LeadAccrual.Month);
        ExistingLeadAccrual.SetFilter("No.", '<>%1', LeadAccrual."No.");

        if ExistingLeadAccrual.FindFirst() then
            if not Confirm(ExistingAccrualWarningQst, false, ExistingLeadAccrual."No.") then
                Error('');

        PostedLeadAccrual.Reset();
        PostedLeadAccrual.SetRange(Year, LeadAccrual.Year);
        PostedLeadAccrual.SetRange(Month, LeadAccrual.Month);

        if PostedLeadAccrual.FindFirst() then
            if not Confirm(ExistingPostedAccrualWarningQst, false, PostedLeadAccrual."No.") then
                Error('');
    end;

    var
        PurchInvHeaderGbl: Record "Purch. Inv. Header";
        LeadAccLineGbl: Record "12E Lead Accrual Line";
        ExistingAccrualWarningQst: Label 'A Lead Accrual document %1 already exists for the selected Month and Year. Do you want to continue?';
        ExistingPostedAccrualWarningQst: Label 'A Posted Lead Accrual document %1 already exists for the selected Month and Year. Do you want to continue?';
}