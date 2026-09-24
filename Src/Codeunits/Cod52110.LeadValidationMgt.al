codeunit 52110 "12E Lead Validation Mgt"
{
    procedure BuildValidationData(var LeadValidationPar: Record "12E Lead Validation Details"; StartDate: Date; EndDate: Date)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        Vendor2: Record Vendor;
        LeadCost: Decimal;
        EntryNo: Integer;
    begin
        EntryNo := 1;

        LeadValidationPar.Reset();
        LeadValidationPar.DeleteAll(true);

        Vendor.Reset();
        Vendor.SetRange("12E Lead Reconciliation", true);

        if Vendor.FindSet() then begin
            repeat
                PurchInvHeader.Reset();
                PurchInvHeader.SetCurrentKey("Buy-from Vendor No.", "Posting Date");
                PurchInvHeader.SetRange("Buy-from Vendor No.", Vendor."No.");
                PurchInvHeader.SetRange("12E Lead Period Start Date", StartDate);
                PurchInvHeader.SetRange("12E Lead Period End Date", EndDate);

                if PurchInvHeader.FindSet() then begin
                    repeat
                        if (PurchInvHeader."12E Lead Period Start Date" <> 0D) and
                           (PurchInvHeader."12E Lead Period End Date" <> 0D) then begin

                            LeadValidationPar.Init();
                            LeadValidationPar."Entry No." := EntryNo;
                            LeadValidationPar."Datasource ID" := GetDataSourceID();
                            LeadValidationPar."Vendor No." := PurchInvHeader."Buy-from Vendor No.";

                            Vendor2.Reset();
                            if Vendor2.Get(PurchInvHeader."Buy-from Vendor No.") then
                                LeadValidationPar."Vendor Name" := Vendor2.Name;

                            LeadValidationPar."Lead Vendor" := Vendor."12E Lead Vendor";

                            LeadCost := GetLeadCostAmount(
                                Vendor."12E Lead Vendor",
                                PurchInvHeader."12E Lead Period Start Date",
                                PurchInvHeader."12E Lead Period End Date");

                            LeadValidationPar."Posting Date" := PurchInvHeader."Posting Date";
                            LeadValidationPar."Posted Purchase Invoice No." := PurchInvHeader."No.";

                            PurchInvHeader.CalcFields(Amount);
                            LeadValidationPar."Invoice Amount" := PurchInvHeader.Amount;

                            Clear(LeadValidationPar."Prior Posting Date");

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

                            LeadValidationPar.Insert(true);

                            EntryNo += 1;
                        end;
                    until PurchInvHeader.Next() = 0;
                end;
            until Vendor.Next() = 0;
        end;
    end;

    local procedure GetLeadCostAmount(LeadProvider: Text[100]; LeadPeriodStartDate: Date; LeadPeriodEndDate: Date): Decimal
    var
        LeadRecon: Record "12E Lead Source Reconciliation";
    begin
        if (LeadPeriodStartDate = 0D) or (LeadPeriodEndDate = 0D) then
            exit(0);

        if LeadPeriodStartDate > LeadPeriodEndDate then
            Error('Lead Period Start Date cannot be later than Lead Period End Date.');

        LeadRecon.Reset();
        LeadRecon.SetRange("Datasource ID", GetDataSourceID());
        LeadRecon.SetRange("Lead Vendor", LeadProvider);
        LeadRecon.SetRange("Lead Original Date", LeadPeriodStartDate, LeadPeriodEndDate);
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