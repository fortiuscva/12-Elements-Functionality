codeunit 52103 "12E EPIC Batch GetLines Mgt"
{
    var
        TempBuffer: Record "12E EPIC Temp Buffer" temporary;
        TotalAmount: Decimal;

    procedure GetLines(var BatchHeader: Record "12E EPIC Payments Batch Header")
    var
        Qry: Query "12E EPIC Payment Summary";
        NextLineNo: Integer;
    begin
        DeleteExistingLines(BatchHeader."Batch No.");
        Clear(TempBuffer);
        TotalAmount := 0;
        NextLineNo := 10000;

        Qry.SetRange(SuccessDateFilter,
            CreateDateTime(BatchHeader."Batch Date", 000000T),
            CreateDateTime(BatchHeader."Batch Date", 235959T));

        Qry.Open();

        while Qry.Read() do
            ProcessSummaryRow(Qry);

        Qry.Close();

        InsertBufferToLines(BatchHeader, NextLineNo);

        InsertBalancingLine(BatchHeader, NextLineNo);
    end;


    local procedure DeleteExistingLines(BatchNo: Code[20])
    var
        Line: Record "12E EPIC Payments Batch Line";
    begin
        Line.SetRange("Batch No.", BatchNo);
        Line.DeleteAll();
    end;


    local procedure ProcessSummaryRow(Qry: Query "12E EPIC Payment Summary")
    var
        GLMap: Record "12E EPIC GL Mapping";
    begin
        if not GLMap.Get(Qry.LoanStatus, Qry.DataSourceID) then
            Error(
                'GL Mapping missing for Loan Status %1 and DataSource %2',
                Qry.LoanStatus, Qry.DataSourceID);

        AddToBuffer(Qry.DataSourceID, GLMap."Principal G/L Account No.", Qry.Principal, Qry);
        AddToBuffer(Qry.DataSourceID, GLMap."Late Fee G/L Account No.", Qry.LateFee, Qry);
        AddToBuffer(Qry.DataSourceID, GLMap."NSF Fee G/L Account No.", Qry.NSFFee, Qry);
        AddToBuffer(Qry.DataSourceID, GLMap."Finance Fee G/L Account No.", Qry.FinanceFee, Qry);
    end;


    local procedure AddToBuffer(
        DataSourceID: Integer;
        GLAccount: Code[20];
        Amount: Decimal;
        Qry: Query "12E EPIC Payment Summary")
    begin
        if Amount = 0 then
            exit;

        TempBuffer.Reset();
        TempBuffer.SetRange("Data Source ID", DataSourceID);
        TempBuffer.SetRange("GL Account", GLAccount);
        TempBuffer.SetRange(County, Qry.County);
        TempBuffer.SetRange("Store Code", Qry.StoreCode);

        if TempBuffer.FindFirst() then begin
            TempBuffer.Amount += Amount;
            TempBuffer.Modify();
        end else begin
            TempBuffer.Init();
            TempBuffer."Data Source ID" := DataSourceID;
            TempBuffer."GL Account" := GLAccount;
            TempBuffer.Amount := Amount;
            TempBuffer.County := Qry.County;
            TempBuffer."Store Code" := Qry.StoreCode;
            TempBuffer.Insert();
        end;

        TotalAmount += Amount;
    end;


    local procedure InsertBufferToLines(
        BatchHeader: Record "12E EPIC Payments Batch Header";
        var NextLineNo: Integer)
    var
        Line: Record "12E EPIC Payments Batch Line";
    begin
        if TempBuffer.FindSet() then
            repeat
                Line.Init();
                Line."Batch No." := BatchHeader."Batch No.";
                Line."Line No." := NextLineNo;
                Line."Account Type" := Line."Account Type"::"G/L Account";
                Line."Account No." := TempBuffer."GL Account";
                Line.Amount := TempBuffer.Amount;
                Line."Shortcut Dimension 1 Code" := TempBuffer.County;
                Line."Shortcut Dimension 2 Code" := TempBuffer."Store Code";
                Line.Insert();

                NextLineNo += 10000;
            until TempBuffer.Next() = 0;
    end;


    local procedure InsertBalancingLine(
        BatchHeader: Record "12E EPIC Payments Batch Header";
        var NextLineNo: Integer)
    var
        Setup: Record "12E 12 Elements Setup";
        Line: Record "12E EPIC Payments Batch Line";
    begin
        if TotalAmount = 0 then
            exit;

        Setup.Get();
        Setup.TestField("Balancing G/L Account");

        Line.Init();
        Line."Batch No." := BatchHeader."Batch No.";
        Line."Line No." := NextLineNo;
        Line."Account Type" := Line."Account Type"::"G/L Account";
        Line."Account No." := Setup."Balancing G/L Account";
        Line.Amount := -TotalAmount;
        Line.Insert();

        NextLineNo += 10000;
    end;
}