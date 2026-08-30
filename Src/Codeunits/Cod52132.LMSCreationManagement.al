codeunit 52132 "12E LMS Creation Management"
{
    procedure CreateLMSTransactions()
    var
        DataSourceID: Integer;
    begin
        DataSourceID := GetDataSourceID();
        ValidateCompanyMapping(DataSourceID);
        ValidateTransactions(DataSourceID);
        CreateDocuments(DataSourceID);
    end;

    local procedure GetDataSourceID(): Integer
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);

        if not CompanyMapping.FindFirst() then
            Error('Company %1 is not mapped to a Data Source.', CompanyName());

        exit(CompanyMapping."DataSource ID");
    end;

    local procedure ValidateCompanyMapping(DataSourceID: Integer)
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetRange("DataSource ID", DataSourceID);

        if not CompanyMapping.FindFirst() then
            Error('Data Source %1 is not mapped to company %2.', DataSourceID, CompanyName());

        if CompanyMapping.Blocked then
            Error('Company %1 is blocked for LMS Transaction processing.', CompanyName());
    end;

    local procedure ValidateTransactions(DataSourceID: Integer)
    var
        LMSTransaction: Record "12E LMS Transaction";
    begin
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("ERP Status", '');

        if LMSTransaction.FindSet(true) then
            repeat
                ValidateTransaction(LMSTransaction);
            until LMSTransaction.Next() = 0;
    end;

    local procedure ValidateTransaction(var LMSTransaction: Record "12E LMS Transaction")
    var
        GLAccount: Record "G/L Account";
        AccountNo: Code[20];
    begin
        if LMSTransaction."Transaction Posting Date" = 0D then begin
            MarkTransactionGroupFailed(LMSTransaction, 'Transaction Posting Date is blank.');
            exit;
        end;

        if (LMSTransaction."Debit Account No." = '') and (LMSTransaction."Credit Account No." = '') then begin
            MarkTransactionGroupFailed(LMSTransaction, 'Both Debit Account No. and Credit Account No. are blank.');
            exit;
        end;

        if (LMSTransaction."Debit Account No." <> '') and (LMSTransaction."Credit Account No." <> '') then begin
            MarkTransactionGroupFailed(LMSTransaction, 'Both Debit Account No. and Credit Account No. are populated.');
            exit;
        end;

        AccountNo := GetAccountNo(LMSTransaction);

        if not GLAccount.Get(AccountNo) then begin
            MarkTransactionGroupFailed(LMSTransaction, StrSubstNo('G/L Account %1 does not exist.', AccountNo));
            exit;
        end;

        if GLAccount.Blocked then begin
            MarkTransactionGroupFailed(LMSTransaction, StrSubstNo('G/L Account %1 is blocked.', AccountNo));
            exit;
        end;
    end;

    local procedure MarkTransactionGroupFailed(LMSTransaction: Record "12E LMS Transaction"; ErrorMessage: Text)
    var
        SourceTransaction: Record "12E LMS Transaction";
    begin
        SourceTransaction.SetRange("Datasource ID", LMSTransaction."Datasource ID");
        SourceTransaction.SetRange("Transaction Posting Date", LMSTransaction."Transaction Posting Date");
        SourceTransaction.SetRange("Transaction ID", LMSTransaction."Transaction ID");
        SourceTransaction.SetRange("Payment ID", LMSTransaction."Payment ID");
        SourceTransaction.ModifyAll("ERP Status", 'Failed');
        SourceTransaction.ModifyAll("ERP Error Message", CopyStr(ErrorMessage, 1, MaxStrLen(SourceTransaction."ERP Error Message")));
        SourceTransaction.ModifyAll("ERP Import Timestamp", CurrentDateTime());
    end;

    local procedure CreateDocuments(DataSourceID: Integer)
    var
        LMSDataQuery: Query "12E LMS Transaction Data";
        LMSHeader: Record "12E LMS Transaction Header";
        TransactionDate: Date;
        LineNo: Integer;
    begin
        LMSDataQuery.SetRange(Company, CompanyName());
        LMSDataQuery.SetRange(DatasourceID, DataSourceID);
        LMSDataQuery.Open();

        while LMSDataQuery.Read() do begin
            if TransactionDate <> LMSDataQuery.TransactionPostingDate then begin
                TransactionDate := LMSDataQuery.TransactionPostingDate;
                LMSHeader := CreateHeader(DataSourceID, TransactionDate);
                LineNo := 0;
            end;

            LineNo += 10000;
            CreateLine(LMSHeader, LMSDataQuery, LineNo);
        end;

        LMSDataQuery.Close();

        CreateTransactionDetails(DataSourceID);
    end;

    local procedure CreateHeader(DataSourceID: Integer; TransactionDate: Date): Record "12E LMS Transaction Header"
    var
        LMSHeader: Record "12E LMS Transaction Header";
    begin
        LMSHeader.Init();
        LMSHeader."Datasource ID" := DataSourceID;
        LMSHeader."Transaction Date" := TransactionDate;
        LMSHeader."Error Exists" := false;
        LMSHeader.Status := LMSHeader.Status::Open;
        LMSHeader.Insert(true);
        exit(LMSHeader);
    end;

    local procedure CreateLine(LMSHeader: Record "12E LMS Transaction Header"; LMSDataQuery: Query "12E LMS Transaction Data"; LineNo: Integer)
    var
        LMSLine: Record "12E LMS Transaction Line";
    begin
        LMSLine.Init();
        LMSLine."Document No." := LMSHeader."No.";
        LMSLine."Line No." := LineNo;
        LMSLine."Datasource ID" := LMSHeader."Datasource ID";
        LMSLine."Account No." := GetAccountNo(LMSDataQuery);
        LMSLine.Amount := LMSDataQuery.Amount;
        LMSLine.Insert(true);
    end;

    local procedure CreateTransactionDetails(DataSourceID: Integer)
    var
        LMSTransaction: Record "12E LMS Transaction";
        LMSDetail: Record "12E LMS Transaction Details";
        LMSHeader: Record "12E LMS Transaction Header";
        TransactionDate: Date;
        DocumentNo: Code[20];
        EntryNo: Integer;
    begin
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("ERP Status", '');

        if LMSTransaction.FindSet(true) then
            repeat
                if TransactionDate <> LMSTransaction."Transaction Posting Date" then begin
                    TransactionDate := LMSTransaction."Transaction Posting Date";
                    LMSHeader.Reset();
                    LMSHeader.SetRange("Datasource ID", DataSourceID);
                    LMSHeader.SetRange("Transaction Date", TransactionDate);

                    if not LMSHeader.FindFirst() then
                        Error('LMS Transaction Header does not exist for Transaction Date %1.', TransactionDate);

                    DocumentNo := LMSHeader."No.";
                    EntryNo := 0;
                end;

                EntryNo += 1;
                LMSDetail.Init();
                LMSDetail.TransferFields(LMSTransaction);
                LMSDetail."LMS Document No." := DocumentNo;
                LMSDetail."Entry No." := EntryNo;
                LMSDetail.Insert(true);
                LMSTransaction."ERP Status" := 'Created';
                LMSTransaction."ERP Import Timestamp" := CurrentDateTime();
                LMSTransaction.Modify(true);
            until LMSTransaction.Next() = 0;
    end;

    local procedure GetAccountNo(LMSTransaction: Record "12E LMS Transaction"): Code[20]
    begin
        if LMSTransaction."Debit Account No." <> '' then
            exit(LMSTransaction."Debit Account No.");

        exit(LMSTransaction."Credit Account No.");
    end;

    local procedure GetAccountNo(LMSDataQuery: Query "12E LMS Transaction Data"): Code[20]
    begin
        if LMSDataQuery.DebitAccountNo <> '' then
            exit(LMSDataQuery.DebitAccountNo);

        exit(LMSDataQuery.CreditAccountNo);
    end;
}