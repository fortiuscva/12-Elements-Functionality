codeunit 52137 "12E Bank Staging Excel Mgt."
{
    procedure ExportBankStaging(var BankStaging: Record "12E Bank Staging")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text;
    begin
        SheetName := 'Bank Staging';

        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        AddExcelHeader(TempExcelBuffer);

        if BankStaging.FindSet() then
            repeat
                TempExcelBuffer.NewRow();

                //TempExcelBuffer.AddColumn(BankStaging.PKID, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BankStaging."Datasource ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BankStaging.Portfolio, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BankStaging.DdaAccount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BankStaging."Transaction Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(BankStaging."Check No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BankStaging."Transaction Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BankStaging.Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(BankStaging."Current Balance", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            //TempExcelBuffer.AddColumn(BankStaging."Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            until BankStaging.Next() = 0;

        TempExcelBuffer.CreateNewBook(SheetName);
        TempExcelBuffer.WriteSheet(SheetName, CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Bank Staging');
        TempExcelBuffer.OpenExcel();
    end;

    procedure ImportBankStaging()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Setup: Record "12E Setup";
        CompanyMapping: Record "12E Company Mapping";
        BankStaging: Record "12E Bank Staging";
        NoSeries: Codeunit "No. Series";
        ExcelInStream: InStream;
        FileName: Text;
        SheetName: Text;
        RowNo: Integer;
        LastRowNo: Integer;
        ImportedCount: Integer;
        DatasourceID: Integer;
        TransactionDate: Date;
        Amount: Decimal;
        CurrentBalance: Decimal;
        CellValue: Text;
    begin
        if not Setup.Get() then
            Error('12 Elements Consulting Setup is not configured.');

        if Setup."Banking PK ID" = '' then
            Error('Please configure Banking PK ID No. Series in 12 Elements Consulting Setup.');

        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
        if not CompanyMapping.FindFirst() then
            Error('%1 is not mapped to any portfolio in 12 elements setup.', CompanyName());

        if not UploadIntoStream(
            'Import Banking Staging Excel',
            '',
            'Excel Files (*.xlsx)|*.xlsx',
            FileName,
            ExcelInStream)
        then
            exit;

        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);

        if SheetName = '' then
            Error('No worksheet found in the uploaded Excel file.');

        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        if not TempExcelBuffer.FindLast() then
            Error('The Excel file does not contain any data.');

        LastRowNo := TempExcelBuffer."Row No.";


        for RowNo := 2 to LastRowNo do begin
            CellValue := GetExcelCellValue(TempExcelBuffer, RowNo, 1);

            if CellValue <> '' then begin
                Clear(DatasourceID);
                if not Evaluate(DatasourceID, CellValue) then
                    Error('Invalid Datasource ID in Excel row %1.', RowNo);

                if DatasourceID <> CompanyMapping."DataSource ID" then
                    Error(
                        'Datasource ID in Excel row %1 does not match the mapped Datasource ID for company %2.',
                        RowNo,
                        CompanyName());

                Clear(TransactionDate);
                CellValue := GetExcelCellValue(TempExcelBuffer, RowNo, 4);
                if CellValue <> '' then
                    if not Evaluate(TransactionDate, CellValue) then
                        Error('Invalid Transaction Date in Excel row %1.', RowNo);

                Clear(Amount);
                CellValue := GetExcelCellValue(TempExcelBuffer, RowNo, 7);
                if CellValue <> '' then
                    if not Evaluate(Amount, CellValue) then
                        Error('Invalid Amount in Excel row %1.', RowNo);

                Clear(CurrentBalance);
                CellValue := GetExcelCellValue(TempExcelBuffer, RowNo, 8);
                if CellValue <> '' then
                    if not Evaluate(CurrentBalance, CellValue) then
                        Error('Invalid Current Balance in Excel row %1.', RowNo);

                BankStaging.Init();
                BankStaging."Entry No." := 0;
                BankStaging.PKID :=
                    NoSeries.GetNextNo(Setup."Banking PK ID", WorkDate());

                BankStaging."Datasource ID" := DatasourceID;
                BankStaging.Portfolio :=
                    CopyStr(
                        GetExcelCellValue(TempExcelBuffer, RowNo, 2),
                        1,
                        MaxStrLen(BankStaging.Portfolio));

                BankStaging.DdaAccount :=
                    CopyStr(
                        GetExcelCellValue(TempExcelBuffer, RowNo, 3),
                        1,
                        MaxStrLen(BankStaging.DdaAccount));

                BankStaging."Transaction Date" := TransactionDate;

                BankStaging."Check No." :=
                    CopyStr(
                        GetExcelCellValue(TempExcelBuffer, RowNo, 5),
                        1,
                        MaxStrLen(BankStaging."Check No."));

                BankStaging."Transaction Description" :=
                    CopyStr(
                        GetExcelCellValue(TempExcelBuffer, RowNo, 6),
                        1,
                        MaxStrLen(BankStaging."Transaction Description"));

                BankStaging.Amount := Amount;
                BankStaging."Current Balance" := CurrentBalance;

                BankStaging.Insert(true);
                ImportedCount += 1;
            end;
        end;


        if ImportedCount = 0 then
            Message('No Banking Staging records were imported.')
        else
            Message('%1 Banking Staging records imported successfully.', ImportedCount);
    end;

    local procedure AddExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();
        //TempExcelBuffer.AddColumn('PKID', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Datasource ID', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Portfolio', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Bank Account No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transaction Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Check No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transaction Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Current Balance', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('Entry No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure GetExcelCellValue(
        var TempExcelBuffer: Record "Excel Buffer" temporary;
        RowNo: Integer;
        ColumnNo: Integer): Text
    begin
        if TempExcelBuffer.Get(RowNo, ColumnNo) then
            exit(TempExcelBuffer."Cell Value as Text");

        exit('');
    end;
}