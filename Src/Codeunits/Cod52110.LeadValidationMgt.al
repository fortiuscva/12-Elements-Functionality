codeunit 52110 "12E Lead Validation Mgt"
{
    procedure BuildValidationData(StartDate: Date; EndDate: Date)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        LeadValidation: Record "12E Lead Validation Entry";
        Vendor: Record Vendor;
        Vendor2: Record Vendor;
        PriorDate: Date;
        LeadCost: Decimal;
    begin
        Vendor.Reset();
        Vendor.SetRange("12E Lead Acquisition", true);
        if Vendor.FindSet() then begin
            repeat
                LeadValidation.DeleteAll();

                PurchInvHeader.Reset();
                PurchInvHeader.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
                PurchInvHeader.SetRange("Buy-from Vendor No.", Vendor."No.");
                PurchInvHeader.SetRange("Posting Date", StartDate, EndDate);
                if PurchInvHeader.FindSet() then begin
                    repeat

                        LeadValidation.Init();

                        LeadValidation."Vendor No." := PurchInvHeader."Buy-from Vendor No.";

                        Vendor2.Reset();
                        if Vendor2.Get(PurchInvHeader."Buy-from Vendor No.") then
                            LeadValidation."Vendor Name" := Vendor2.Name;

                        PriorDate := GetPreviousPostingDate(
                                             Vendor."12E Lead Acq. Vendor No.",
                                              PurchInvHeader."Posting Date");

                        LeadCost := GetLeadCostAmount(
                                Vendor."12E Lead Acq. Vendor No.",
                                PriorDate,
                                PurchInvHeader."Posting Date");

                        LeadValidation."Posting Date" := PurchInvHeader."Posting Date";
                        LeadValidation."Purchase Invoice No." := PurchInvHeader."No.";
                        LeadValidation.Amount := PurchInvHeader.Amount;
                        LeadValidation."Prior Posting Date" := PriorDate;
                        LeadValidation."Lead Cost Amount" := LeadCost;
                        LeadValidation.Difference := LeadValidation.Amount - LeadValidation."Lead Cost Amount";

                        if LeadValidation.Amount <> 0 then
                            LeadValidation."Difference %" := Round((LeadValidation.Difference / LeadValidation.Amount) * 100, 0.01);

                        LeadValidation.Insert();

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
        VendorPortfolio: Code[20];
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
        LeadRecon.SetRange("Portfolio Name", VendorPortfolio);
        LeadRecon.SetRange("Lead Original Date", StartDate, CurrentPostingDate);
        LeadRecon.CalcSums("Lead Sold Cost");

        exit(LeadRecon."Lead Sold Cost");
    end;
}