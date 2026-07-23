codeunit 52108 "12E CCD Mgmt"
{
    procedure GetLines(var CCDHeader: Record "12E CCD Header")
    var
        CCDQuery: Query "12E CCD Allocation Data";
        CCDLocationMapping: Record "12E CCD Location Mapping";
        TempLocationTotals: Record "Name/Value Buffer" temporary;
        PortfolioHandleTime: Decimal;
        TotalLocationHandleTime: Decimal;
        AllocationPercentage: Decimal;
    begin
        CCDHeader.TestField("Start Date");
        CCDHeader.TestField("End Date");

        DeleteExistingLines(CCDHeader);

        BuildLocationTotals(CCDHeader, TempLocationTotals);

        CCDQuery.SetRange(CallDate, CCDHeader."Start Date", CCDHeader."End Date");
        CCDQuery.Open();

        while CCDQuery.Read() do begin

            PortfolioHandleTime := CCDQuery.TotalHandleTime;
            TotalLocationHandleTime := GetLocationTotal(TempLocationTotals, CCDQuery.LocationCode);
            AllocationPercentage := 0;

            if TotalLocationHandleTime <> 0 then
                AllocationPercentage := Round((PortfolioHandleTime / TotalLocationHandleTime) * 100, 0.00001);

            if not CCDLocationMapping.Get(CCDQuery.LocationCode) then
                Error('CCD Location Mapping does not exist for Location %1.', CCDQuery.LocationCode);

            case CCDLocationMapping."Processing Type" of
                CCDLocationMapping."Processing Type"::Payroll:
                    CreatePayrollCCDLines(CCDHeader, CCDQuery.LocationCode, CCDQuery.Portfolio, PortfolioHandleTime, AllocationPercentage);

                CCDLocationMapping."Processing Type"::Vendor:
                    CreateVendorCCDLines(CCDHeader, CCDQuery.LocationCode, CCDQuery.Portfolio, PortfolioHandleTime, AllocationPercentage);

                else
                    Error('Processing Type must be specified for Location %1.', CCDQuery.LocationCode);
            end;
        end;

        CCDQuery.Close();

        Message('Call Center Distribution Lines generated successfully.');
    end;

    local procedure CreatePayrollCCDLines(
    CCDHeader: Record "12E CCD Header";
    LocationCode: Code[10];
    Portfolio: Code[20];
    PortfolioHandleTime: Decimal;
    AllocationPercentage: Decimal)
    var
        PayrollBatchSummary: Query "12E Payroll Batch Summary";
        QuestcoPayrollTxn: Record "12E Questco Payroll Txn";
    begin
        PayrollBatchSummary.SetRange(PayDate, CCDHeader."Start Date", CCDHeader."End Date");
        PayrollBatchSummary.Open();

        while PayrollBatchSummary.Read() do begin
            QuestcoPayrollTxn.Reset();
            QuestcoPayrollTxn.SetRange("Batch ID", PayrollBatchSummary.BatchID);
            if QuestcoPayrollTxn.FindFirst() then
                InsertCCDLine(
                    CCDHeader,
                    LocationCode,
                    Portfolio,
                    PortfolioHandleTime,
                    AllocationPercentage,
                    PayrollBatchSummary.TotalHours,
                    PayrollBatchSummary.BatchID,
                    QuestcoPayrollTxn."Pay Period Start Date",
                    QuestcoPayrollTxn."Pay Period End Date",
                    '',
                    0D);

        end;

        PayrollBatchSummary.Close();
    end;

    local procedure CreateVendorCCDLines(
    CCDHeader: Record "12E CCD Header";
    LocationCode: Code[10];
    Portfolio: Code[20];
    PortfolioHandleTime: Decimal;
    AllocationPercentage: Decimal)
    var
        CCDLocationMapping: Record "12E CCD Location Mapping";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        InvoiceHours: Decimal;
    begin
        if not CCDLocationMapping.Get(LocationCode) then
            exit;

        CCDLocationMapping.TestField("Vendor No.");
        PurchInvHeader.SetRange("Buy-from Vendor No.", CCDLocationMapping."Vendor No.");
        PurchInvHeader.SetRange("Posting Date", CCDHeader."Start Date", CCDHeader."End Date");
        if PurchInvHeader.FindSet() then
            repeat
                InvoiceHours := 0;

                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                if PurchInvLine.FindSet() then
                    repeat
                        InvoiceHours += PurchInvLine.Quantity;
                    until PurchInvLine.Next() = 0;

                if InvoiceHours = 0 then
                    continue;

                InsertCCDLine(
                    CCDHeader,
                    LocationCode,
                    Portfolio,
                    PortfolioHandleTime,
                    AllocationPercentage,
                    InvoiceHours,
                    0,
                    0D,
                    0D,
                    PurchInvHeader."No.",
                    PurchInvHeader."Posting Date");

            until PurchInvHeader.Next() = 0;
    end;

    local procedure InsertCCDLine(
    CCDHeader: Record "12E CCD Header";
    LocationCode: Code[10];
    Portfolio: Code[20];
    PortfolioHandleTime: Decimal;
    AllocationPercentage: Decimal;
    Hours: Decimal;
    PayrollBatchID: Integer;
    PayrollStartDate: Date;
    PayrollEndDate: Date;
    PurchaseInvoiceNo: Code[20];
    PurchaseInvoiceDate: Date)
    var
        CCDLine: Record "12E CCD Line";
    begin
        CCDLine.Init();

        CCDLine."Document No." := CCDHeader."No.";
        CCDLine."Line No." := GetNextLineNo(CCDHeader."No.");

        CCDLine."Call Date" := CCDHeader."Start Date";
        CCDLine."Location Code" := LocationCode;
        CCDLine.Portfolio := Portfolio;

        CCDLine."Handling Time" := PortfolioHandleTime;
        CCDLine.Percentage := AllocationPercentage;

        if PayrollBatchID <> 0 then begin
            CCDLine."Payroll Batch ID" := PayrollBatchID;
            CCDLine."Batch Start Date" := PayrollStartDate;
            CCDLine."Batch End Date" := PayrollEndDate;

            CCDLine."Batch or Inv. Hours" := Hours;
            CCDLine."Batch or Inv. Percentage" :=
                Round(Hours * AllocationPercentage / 100, 0.00001);
        end;

        if PurchaseInvoiceNo <> '' then begin
            CCDLine."Invoice No." := PurchaseInvoiceNo;
            CCDLine."Invoice Date" := PurchaseInvoiceDate;

            CCDLine."Batch or Inv. Hours" := Hours;
            CCDLine."Batch or Inv. Percentage" :=
                Round(Hours * AllocationPercentage / 100, 0.00001);
        end;

        CCDLine.Insert(true);
    end;

    local procedure DeleteExistingLines(CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
    begin
        CCDLine.SetRange("Document No.", CCDHeader."No.");
        CCDLine.DeleteAll();
    end;

    local procedure BuildLocationTotals(CCDHeader: Record "12E CCD Header"; var TempLocationTotals: Record "Name/Value Buffer" temporary)
    var
        LocationQuery: Query "12E CCD Location Totals";
    begin
        LocationQuery.SetRange(CallDate, CCDHeader."Start Date", CCDHeader."End Date");
        LocationQuery.Open();

        while LocationQuery.Read() do begin
            TempLocationTotals.Init();
            TempLocationTotals.ID += 1;
            TempLocationTotals.Name := LocationQuery.LocationCode;
            TempLocationTotals.Value := Format(LocationQuery.TotalHandleTime);
            TempLocationTotals.Insert();
        end;

        LocationQuery.Close();
    end;

    local procedure GetLocationTotal(var TempLocationTotals: Record "Name/Value Buffer" temporary; LocationCode: Code[10]): Decimal
    var
        TotalByLocation: Decimal;
    begin
        TempLocationTotals.Reset();
        TempLocationTotals.SetRange(Name, LocationCode);

        if TempLocationTotals.FindFirst() then
            Evaluate(TotalByLocation, TempLocationTotals.Value);

        exit(TotalByLocation);
    end;

    local procedure GetNextLineNo(DocumentNo: Code[20]): Integer
    var
        CCDLine: Record "12E CCD Line";
    begin
        CCDLine.SetRange("Document No.", DocumentNo);

        if CCDLine.FindLast() then
            exit(CCDLine."Line No." + 10000);

        exit(10000);
    end;
}