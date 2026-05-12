codeunit 52108 "12E CCD Mgmt"
{
    procedure GetLines(var CCDHeader: Record "12E CC Distribution Header")
    var
        CCDLine: Record "12E CC Distribution Line";
        CCDQuery: Query "12E CCD Grouped Data";
        LocationQuery: Query "12E CCD Location Totals";
        TempLocationTotals: Record "Name/Value Buffer" temporary;
        CurrentLineNo: Integer;
        HandleSeconds: Decimal;
        Percentage: Decimal;
        TotalByLocation: Decimal;
    begin
        CCDHeader.TestField("From Date");
        CCDHeader.TestField("To Date");

        DeleteExistingLines(CCDHeader);

        BuildLocationTotals(CCDHeader, TempLocationTotals);

        CCDQuery.SetRange(CCDate, CCDHeader."From Date", CCDHeader."To Date");

        CCDQuery.Open();

        while CCDQuery.Read() do begin
            CurrentLineNo += 10000;

            HandleSeconds := CCDQuery.TotalHandleTime;
            TotalByLocation := GetLocationTotal(TempLocationTotals, CCDQuery.LocationCode);

            Clear(Percentage);

            if TotalByLocation <> 0 then
                Percentage := Round((HandleSeconds / TotalByLocation) * 100, 0.00001);

            CCDLine.Init();
            CCDLine."Document No." := CCDHeader."No.";
            CCDLine."Line No." := CurrentLineNo;
            CCDLine."CCD Date" := CCDQuery.CCDate;
            CCDLine."Location Code" := CCDQuery.LocationCode;
            CCDLine.Portfolio := CCDQuery.Portfolio;
            CCDLine."Handle Time" := HandleSeconds * 1000;
            CCDLine.Percentage := Percentage;
            CCDLine.Insert();
        end;

        CCDQuery.Close();

        Message('CC Distribution Lines generated successfully.');
    end;

    local procedure DeleteExistingLines(CCDHeader: Record "12E CC Distribution Header")
    var
        CCDLine: Record "12E CC Distribution Line";
    begin
        CCDLine.SetRange("Document No.", CCDHeader."No.");
        CCDLine.DeleteAll();
    end;

    local procedure BuildLocationTotals(
        CCDHeader: Record "12E CC Distribution Header";
        var TempLocationTotals: Record "Name/Value Buffer" temporary)
    var
        LocationQuery: Query "12E CCD Location Totals";
    begin
        LocationQuery.SetRange(CCDate, CCDHeader."From Date", CCDHeader."To Date");

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
}