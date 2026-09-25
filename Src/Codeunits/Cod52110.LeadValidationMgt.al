codeunit 52110 "12E Lead Validation Mgt"
{
    procedure BuildValidationData(
        var LeadValidationPar: Record "12E Lead Validation Details";
        StartDate: Date;
        EndDate: Date;
        Vendor: Record Vendor)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchHeader: Record "Purchase Header";
        EntryNo: Integer;
    begin
        EntryNo := LeadValidationPar.Count + 1;

        PurchInvHeader.Reset();
        PurchInvHeader.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchInvHeader.SetRange("Buy-from Vendor No.", Vendor."No.");
        PurchInvHeader.SetRange("Posting Date", StartDate, EndDate);

        if PurchInvHeader.FindSet() then
            repeat
                AddPostedInvoiceValidation(
                    LeadValidationPar,
                    PurchInvHeader,
                    Vendor,
                    EntryNo);

                EntryNo += 1;
            until PurchInvHeader.Next() = 0;

        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
        PurchHeader.SetRange("Buy-from Vendor No.", Vendor."No.");
        PurchHeader.SetRange("Posting Date", StartDate, EndDate);

        if PurchHeader.FindSet() then
            repeat
                AddOpenInvoiceValidation(
                    LeadValidationPar,
                    PurchHeader,
                    Vendor,
                    EntryNo);

                EntryNo += 1;
            until PurchHeader.Next() = 0;
    end;

    local procedure AddPostedInvoiceValidation(var LeadValidationPar: Record "12E Lead Validation Details"; PurchInvHeader: Record "Purch. Inv. Header"; Vendor: Record Vendor; EntryNo: Integer)
    var
        LeadCost: Decimal;
    begin
        LeadValidationPar.Init();
        LeadValidationPar."Entry No." := EntryNo;
        LeadValidationPar."Datasource ID" := GetDataSourceID();
        LeadValidationPar."Vendor No." := PurchInvHeader."Buy-from Vendor No.";
        LeadValidationPar."Vendor Name" := Vendor.Name;
        LeadValidationPar."Lead Vendor" := Vendor."12E Lead Vendor";
        LeadValidationPar."Posting Date" := PurchInvHeader."Posting Date";
        LeadValidationPar."Posted Purchase Invoice No." := PurchInvHeader."No.";
        LeadValidationPar."Lead Period Start Date" := PurchInvHeader."12E Lead Period Start Date";
        LeadValidationPar."Lead Period End Date" := PurchInvHeader."12E Lead Period End Date";

        PurchInvHeader.CalcFields(Amount);
        LeadValidationPar."Invoice Amount" := PurchInvHeader.Amount;

        if (PurchInvHeader."12E Lead Period Start Date" <> 0D) and
           (PurchInvHeader."12E Lead Period End Date" <> 0D) then begin

            LeadCost := GetLeadCostAmount(
                Vendor."12E Lead Vendor",
                PurchInvHeader."12E Lead Period Start Date",
                PurchInvHeader."12E Lead Period End Date");

            LeadValidationPar."Lead Cost Amount" := LeadCost;

            LeadValidationPar.Difference :=
                Abs(
                    LeadValidationPar."Invoice Amount" -
                    LeadValidationPar."Lead Cost Amount");

            if LeadValidationPar."Invoice Amount" <> 0 then
                LeadValidationPar."Difference %" :=
                    Round(
                        (LeadValidationPar.Difference /
                        LeadValidationPar."Invoice Amount") * 100,
                        0.01);
        end;

        LeadValidationPar.Insert(true);
    end;

    local procedure AddOpenInvoiceValidation(var LeadValidationPar: Record "12E Lead Validation Details"; PurchHeader: Record "Purchase Header"; Vendor: Record Vendor; EntryNo: Integer)
    var
        LeadCost: Decimal;
    begin
        LeadValidationPar.Init();
        LeadValidationPar."Entry No." := EntryNo;
        LeadValidationPar."Datasource ID" := GetDataSourceID();
        LeadValidationPar."Vendor No." := PurchHeader."Buy-from Vendor No.";
        LeadValidationPar."Vendor Name" := Vendor.Name;
        LeadValidationPar."Lead Vendor" := Vendor."12E Lead Vendor";
        LeadValidationPar."Posting Date" := PurchHeader."Posting Date";
        LeadValidationPar."Invoice No." := PurchHeader."No.";
        LeadValidationPar."Lead Period Start Date" := PurchHeader."12E Lead Period Start Date";
        LeadValidationPar."Lead Period End Date" := PurchHeader."12E Lead Period End Date";

        PurchHeader.CalcFields("Amount Including VAT");
        LeadValidationPar."Invoice Amount" := PurchHeader."Amount Including VAT";

        if (PurchHeader."12E Lead Period Start Date" <> 0D) and
           (PurchHeader."12E Lead Period End Date" <> 0D) then begin

            LeadCost := GetLeadCostAmount(
                Vendor."12E Lead Vendor",
                PurchHeader."12E Lead Period Start Date",
                PurchHeader."12E Lead Period End Date");

            LeadValidationPar."Lead Cost Amount" := LeadCost;

            LeadValidationPar.Difference :=
                Abs(
                    LeadValidationPar."Invoice Amount" -
                    LeadValidationPar."Lead Cost Amount");

            if LeadValidationPar."Invoice Amount" <> 0 then
                LeadValidationPar."Difference %" :=
                    Round(
                        (LeadValidationPar.Difference /
                        LeadValidationPar."Invoice Amount") * 100,
                        0.01);
        end;

        LeadValidationPar.Insert(true);
    end;

    local procedure GetLeadCostAmount(LeadVendor: Text[100]; LeadPeriodStartDate: Date; LeadPeriodEndDate: Date): Decimal
    var
        LeadRecon: Record "12E Lead Source Reconciliation";
    begin
        if (LeadPeriodStartDate = 0D) or
           (LeadPeriodEndDate = 0D) then
            exit(0);

        if LeadPeriodStartDate > LeadPeriodEndDate then
            Error(
                'Lead Period Start Date cannot be later than Lead Period End Date.');

        LeadRecon.Reset();
        LeadRecon.SetRange("Datasource ID", GetDataSourceID());
        LeadRecon.SetRange("Lead Vendor", LeadVendor);
        LeadRecon.SetRange(
            "Lead Original Date",
            LeadPeriodStartDate,
            LeadPeriodEndDate);
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

        exit(0);
    end;
}