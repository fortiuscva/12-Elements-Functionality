codeunit 52110 "12E Lead Validation Mgt"
{
    procedure BuildValidationData(var LeadValidationPar: Record "12E Lead Validation Details"; StartDate: Date; EndDate: Date)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        Vendor2: Record Vendor;
        PriorDate: Date;
        LeadCost: Decimal;
    begin
        LeadValidationPar.DeleteAll(true);
        Vendor.Reset();
        Vendor.SetRange("12E Lead Acquisition", true);
        if Vendor.FindSet() then begin
            repeat
                PurchInvHeader.Reset();
                PurchInvHeader.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
                PurchInvHeader.SetRange("Buy-from Vendor No.", Vendor."No.");
                PurchInvHeader.SetRange("Posting Date", StartDate, EndDate);
                if PurchInvHeader.FindSet() then begin
                    repeat

                        LeadValidationPar.Init();

                        LeadValidationPar."Entry No." := GetEntryNo();

                        LeadValidationPar."Vendor No." := PurchInvHeader."Buy-from Vendor No.";

                        Vendor2.Reset();
                        if Vendor2.Get(PurchInvHeader."Buy-from Vendor No.") then
                            LeadValidationPar."Vendor Name" := Vendor2.Name;

                        LeadValidationPar."Lead Provider" := Vendor."12E Lead Acq. Vendor No.";

                        PriorDate := GetPreviousPostingDate(
                                             Vendor."No.",
                                              PurchInvHeader."Posting Date");

                        LeadCost := GetLeadCostAmount(
                                    Vendor."12E Lead Acq. Vendor No.",
                                    PriorDate,
                                    PurchInvHeader."Posting Date");

                        LeadValidationPar."Posting Date" := PurchInvHeader."Posting Date";
                        LeadValidationPar."Posted Purchase Invoice No." := PurchInvHeader."No.";
                        PurchInvHeader.CalcFields(Amount);
                        LeadValidationPar."Invoice Amount" := PurchInvHeader.Amount;
                        LeadValidationPar."Prior Posting Date" := PriorDate;
                        LeadValidationPar."Lead Cost Amount" := LeadCost;
                        LeadValidationPar.Difference := Abs(LeadValidationPar."Invoice Amount" - LeadValidationPar."Lead Cost Amount");

                        if LeadValidationPar."Invoice Amount" <> 0 then
                            LeadValidationPar."Difference %" := Round((LeadValidationPar.Difference / LeadValidationPar."Invoice Amount") * 100, 0.01);

                        LeadValidationPar.Insert(true);

                    until PurchInvHeader.Next() = 0;
                end;
            until Vendor.Next() = 0;
        end;
    end;

    local procedure GetPreviousPostingDate(
        VendorNo: Code[20];
        CurrentPostingDate: Date): Date
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchInvHeader.Reset();
        PurchInvHeader.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeader.SetRange("Buy-from Vendor No.", VendorNo);
        PurchInvHeader.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', CurrentPostingDate));
        if PurchInvHeader.FindLast() then
            exit(PurchInvHeader."Posting Date");

        exit(0D);
    end;

    local procedure GetLeadCostAmount(
     LeadProvider: Text[100];
     PriorPostingDate: Date;
     CurrentPostingDate: Date): Decimal
    var
        LeadRecon: Record "12E Lead Source Reconciliation";
        StartDate: Date;
    begin
        if PriorPostingDate = 0D then
            StartDate := DMY2Date(1, 1, 1900)
        else
            StartDate := CalcDate('<+1D>', PriorPostingDate);

        LeadRecon.Reset();
        LeadRecon.SetRange("Datasource ID", GetDataSourceID());
        LeadRecon.SetRange("Lead Provider", LeadProvider);
        LeadRecon.SetRange("Lead Original Date", StartDate, CurrentPostingDate);
        LeadRecon.CalcSums("Lead Sold Cost");

        exit(LeadRecon."Lead Sold Cost");
    end;

    procedure GetDataSourceID(): Integer
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());
        if CompanyMapping.FindLast() then
            exit(CompanyMapping."DataSource ID");
    end;

    local procedure GetEntryNo(): Integer
    var
        LeadValidationLcl: Record "12E Lead Validation Details";
    begin
        LeadValidationLcl.Reset();
        if LeadValidationLcl.FindLast() then
            exit(LeadValidationLcl."Entry No." + 1)
        else
            exit(1);
    end;
}