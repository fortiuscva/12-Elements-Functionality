codeunit 52110 "12E Lead Validation Mgt"
{
    procedure BuildValidationData(StartDate: Date; EndDate: Date)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        LeadValidation: Record "12E Lead Validation Entry";
        Vendor: Record Vendor;
        PriorDate: Date;
        LeadCost: Decimal;
    begin
        LeadValidation.DeleteAll();

        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Posting Date", StartDate, EndDate);

        if PurchInvHeader.FindSet() then
            repeat

                PriorDate :=
                    GetPreviousPostingDate(
                        PurchInvHeader."Buy-from Vendor No.",
                        PurchInvHeader."Posting Date");

                LeadCost :=
                    GetLeadCostAmount(
                        PurchInvHeader."Buy-from Vendor No.",
                        PriorDate,
                        PurchInvHeader."Posting Date");

                LeadValidation.Init();

                LeadValidation."Vendor No." :=
                    PurchInvHeader."Buy-from Vendor No.";

                if Vendor.Get(PurchInvHeader."Buy-from Vendor No.") then
                    LeadValidation."Vendor Name" := Vendor.Name;

                LeadValidation."Posting Date" :=
                    PurchInvHeader."Posting Date";

                LeadValidation."Purchase Invoice No." :=
                    PurchInvHeader."No.";

                LeadValidation.Amount :=
                    PurchInvHeader.Amount;

                LeadValidation."Prior Posting Date" :=
                    PriorDate;

                LeadValidation."Lead Cost Amount" :=
                    LeadCost;

                LeadValidation.Difference :=
                    LeadValidation.Amount -
                    LeadValidation."Lead Cost Amount";

                if LeadValidation.Amount <> 0 then
                    LeadValidation."Difference %" :=
                        Round(
                            (LeadValidation.Difference /
                             LeadValidation.Amount) * 100,
                             0.01);

                LeadValidation.Insert();

            until PurchInvHeader.Next() = 0;
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
        PurchInvHeader.SetFilter(
            "Posting Date",
            '..%1',
            CalcDate('<-1D>', CurrentPostingDate));

        if PurchInvHeader.FindLast() then
            exit(PurchInvHeader."Posting Date");

        exit(0D);
    end;

    local procedure GetLeadCostAmount(
        VendorNo: Code[20];
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
        LeadRecon.SetRange("Vendor No.", VendorNo);
        LeadRecon.SetRange(
            "Lead Original Date",
            StartDate,
            CurrentPostingDate);

        LeadRecon.CalcSums("Lead Sold Cost");

        exit(LeadRecon."Lead Sold Cost");
    end;
}