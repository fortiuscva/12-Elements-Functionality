codeunit 52108 "12E CCD Mgmt"
{
    procedure GetLines(var CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
        CCDQuery: Query "12E CCD Allocation Data";
        TempLocationTotals: Record "Name/Value Buffer" temporary;
        CCDLocationMapping: Record "12E CCD Location Mapping";
        CurrentLineNo: Integer;
        PortfolioHandleTime: Decimal;
        TotalByLocation: Decimal;
        Percentage: Decimal;
        PFCCHours: Decimal;
        TotalHours: Decimal;
    begin
        CCDHeader.TestField("Start Date");
        CCDHeader.TestField("End Date");

        DeleteExistingLines(CCDHeader);

        BuildLocationTotals(CCDHeader, TempLocationTotals);

        PFCCHours := GetPFCCHours(CCDHeader);

        CCDQuery.SetRange(CallDate, CCDHeader."Start Date", CCDHeader."End Date");
        CCDQuery.Open();

        while CCDQuery.Read() do begin
            CurrentLineNo += 10000;

            PortfolioHandleTime := CCDQuery.TotalHandleTime;
            TotalByLocation := GetLocationTotal(TempLocationTotals, CCDQuery.LocationCode);

            Percentage := 0;
            if TotalByLocation <> 0 then
                Percentage := Round((PortfolioHandleTime / TotalByLocation) * 100, 0.00001);

            CCDLocationMapping.Get(CCDQuery.LocationCode);

            case CCDLocationMapping."Processing Type" of
                CCDLocationMapping."Processing Type"::Payroll:
                    TotalHours := PFCCHours;

                CCDLocationMapping."Processing Type"::Vendor:
                    TotalHours := GetVendorHours(CCDQuery.LocationCode, CCDHeader);

                else
                    TotalHours := 0;
            end;

            CCDLine.Init();
            CCDLine."Document No." := CCDHeader."No.";
            CCDLine."Line No." := CurrentLineNo;
            CCDLine."Call Date" := CCDHeader."Start Date";
            CCDLine."Location Code" := CCDQuery.LocationCode;
            CCDLine.Portfolio := CCDQuery.Portfolio;
            CCDLine."Handling Time" := PortfolioHandleTime;
            CCDLine.Percentage := Percentage;
            CCDLine."No. of Hours" := TotalHours;
            CCDLine."Distributed Quantity" :=
                Round((TotalHours * Percentage) / 100, 0.00001);

            CCDLine.Insert();
        end;

        CCDQuery.Close();

        Message('Call Center Distribution Lines generated successfully.');
    end;

    local procedure DeleteExistingLines(CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
    begin
        CCDLine.SetRange("Document No.", CCDHeader."No.");
        CCDLine.DeleteAll();
    end;

    local procedure BuildLocationTotals(
        CCDHeader: Record "12E CCD Header";
        var TempLocationTotals: Record "Name/Value Buffer" temporary)
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

    local procedure GetLocationTotal(
        var TempLocationTotals: Record "Name/Value Buffer" temporary;
        LocationCode: Code[10]): Decimal
    var
        TotalByLocation: Decimal;
    begin
        TempLocationTotals.Reset();
        TempLocationTotals.SetRange(Name, LocationCode);

        if TempLocationTotals.FindFirst() then
            Evaluate(TotalByLocation, TempLocationTotals.Value);

        exit(TotalByLocation);
    end;

    local procedure GetPFCCHours(CCDHeader: Record "12E CCD Header"): Decimal
    var
        QuestcoPayrollTxn: Record "12E Questco Payroll Txn";
        DepartmentCode: Record "12E Department Code";
        PayType: Record "12E Pay Type";
        TotalHours: Decimal;
    begin
        QuestcoPayrollTxn.SetRange("Pay Date", CCDHeader."Start Date", CCDHeader."End Date");

        if QuestcoPayrollTxn.FindSet() then
            repeat
                if not DepartmentCode.Get(QuestcoPayrollTxn.Department) then
                    continue;

                if not DepartmentCode."Contact Center" then
                    continue;

                if not PayType.Get(QuestcoPayrollTxn."Pay Code") then
                    continue;

                if not PayType."Contact Center" then
                    continue;

                if PayType."Do not process for payroll" then
                    continue;

                TotalHours += QuestcoPayrollTxn."Hours Worked";
            until QuestcoPayrollTxn.Next() = 0;

        exit(TotalHours);
    end;

    local procedure GetVendorHours(LocationCode: Code[10]; CCDHeader: Record "12E CCD Header"): Decimal
    var
        CCDLocationMapping: Record "12E CCD Location Mapping";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        TotalHours: Decimal;
    begin
        if not CCDLocationMapping.Get(LocationCode) then
            exit(0);

        CCDLocationMapping.TestField("Vendor No.");

        PurchInvHeader.SetRange("Buy-from Vendor No.", CCDLocationMapping."Vendor No.");
        PurchInvHeader.SetRange("Posting Date", CCDHeader."Start Date", CCDHeader."End Date");

        if PurchInvHeader.FindSet() then
            repeat
                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                PurchInvLine.SetRange(Type, PurchInvLine.Type::"G/L Account");

                if PurchInvLine.FindSet() then
                    repeat
                        TotalHours += PurchInvLine.Quantity;
                    until PurchInvLine.Next() = 0;
            until PurchInvHeader.Next() = 0;

        exit(TotalHours);
    end;
}