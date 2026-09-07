codeunit 52132 "12E LMS Creation Management"
{
    procedure CreateLMSTransactions()
    var
        DataSourceID: Integer;
    begin
        DataSourceID := GetDataSourceID();
        ValidateCompanyMapping(DataSourceID);
        ValidateTransactions(DataSourceID);
        ValidateTransactionBalances(DataSourceID);
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
        LMSTransaction.SetRange("LMS Transaction Details No.", '');
        if LMSTransaction.FindSet() then
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

        if LMSTransaction.Amount = 0 then begin
            MarkTransactionGroupFailed(LMSTransaction, 'Amount must not be zero.');
            exit;
        end;

        if (LMSTransaction."Debit Account No." = '') and (LMSTransaction."Credit Account No." = '') then begin
            MarkTransactionGroupFailed(LMSTransaction, 'Either Debit Account No. or Credit Account No. must be populated.');
            exit;
        end;

        if (LMSTransaction."Debit Account No." <> '') and (LMSTransaction."Credit Account No." <> '') then begin
            MarkTransactionGroupFailed(LMSTransaction, 'Both Debit Account No. and Credit Account No. cannot be populated.');
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

    local procedure ValidateTransactionBalances(DataSourceID: Integer)
    var
        LMSTransaction: Record "12E LMS Transaction";
        TransactionID: Integer;
        TransactionAmount: Decimal;
    begin
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("ERP Status", '');
        LMSTransaction.SetRange("LMS Transaction Details No.", '');
        LMSTransaction.SetCurrentKey("Datasource ID", "Transaction ID", "PK ID");

        if not LMSTransaction.FindSet() then
            exit;

        TransactionID := 0;
        TransactionAmount := 0;

        repeat
            if TransactionID <> LMSTransaction."Transaction ID" then begin
                if TransactionID <> 0 then
                    CheckTransactionBalance(LMSTransaction, TransactionID, TransactionAmount);
                TransactionID := LMSTransaction."Transaction ID";
                TransactionAmount := 0;
            end;

            TransactionAmount += GetPostingAmount(LMSTransaction);
        until LMSTransaction.Next() = 0;

        if TransactionID <> 0 then
            CheckTransactionBalance(LMSTransaction, TransactionID, TransactionAmount);
    end;

    local procedure CheckTransactionBalance(LMSTransaction: Record "12E LMS Transaction"; TransactionID: Integer; TransactionAmount: Decimal)
    begin
        if TransactionAmount = 0 then
            exit;

        MarkTransactionIDFailed(LMSTransaction."Datasource ID", TransactionID, StrSubstNo('Transaction ID %1 is not balanced. Total posting amount is %2.', TransactionID, TransactionAmount));
    end;

    local procedure MarkTransactionGroupFailed(LMSTransaction: Record "12E LMS Transaction"; ErrorMessage: Text)
    var
        SourceTransaction: Record "12E LMS Transaction";
    begin
        SourceTransaction.SetRange("Datasource ID", LMSTransaction."Datasource ID");
        SourceTransaction.SetRange("Transaction Posting Date", LMSTransaction."Transaction Posting Date");
        SourceTransaction.SetRange("Transaction ID", LMSTransaction."Transaction ID");
        SourceTransaction.SetRange("Payment ID", LMSTransaction."Payment ID");
        SourceTransaction.SetRange("ERP Status", '');
        SourceTransaction.SetRange("LMS Transaction Details No.", '');
        SourceTransaction.ModifyAll("ERP Status", 'Failed');
        SourceTransaction.ModifyAll("ERP Error Message", CopyStr(ErrorMessage, 1, MaxStrLen(SourceTransaction."ERP Error Message")));
    end;

    local procedure MarkTransactionIDFailed(DataSourceID: Integer; TransactionID: Integer; ErrorMessage: Text)
    var
        SourceTransaction: Record "12E LMS Transaction";
    begin
        SourceTransaction.SetRange("Datasource ID", DataSourceID);
        SourceTransaction.SetRange("Transaction ID", TransactionID);
        SourceTransaction.SetRange("ERP Status", '');
        SourceTransaction.SetRange("LMS Transaction Details No.", '');
        SourceTransaction.ModifyAll("ERP Status", 'Failed');
        SourceTransaction.ModifyAll("ERP Error Message", CopyStr(ErrorMessage, 1, MaxStrLen(SourceTransaction."ERP Error Message")));
    end;

    local procedure CreateDocuments(DataSourceID: Integer)
    var
        LMSDataQuery: Query "12E LMS Transaction Data";
        LMSHeader: Record "12E LMS Transaction Header";
        TransactionDate: Date;
        LineNo: Integer;
        HeaderCreated: Boolean;
    begin
        LMSDataQuery.SetRange(Company, CompanyName());
        LMSDataQuery.SetRange(DatasourceID, DataSourceID);
        LMSDataQuery.Open();

        while LMSDataQuery.Read() do begin
            if LMSDataQuery.TransactionPostingDate = 0D then
                continue;

            if (not HeaderCreated) or (TransactionDate <> LMSDataQuery.TransactionPostingDate) then begin
                TransactionDate := LMSDataQuery.TransactionPostingDate;
                LMSHeader := GetOrCreateHeader(DataSourceID, TransactionDate);
                LineNo := GetLastLineNo(LMSHeader);
                HeaderCreated := true;
            end;

            LineNo += 10000;
            CreateLine(LMSHeader, LMSDataQuery, LineNo);
        end;

        LMSDataQuery.Close();
        CreateTransactionDetails(DataSourceID);
    end;

    local procedure GetOrCreateHeader(DataSourceID: Integer; TransactionDate: Date): Record "12E LMS Transaction Header"
    var
        LMSHeader: Record "12E LMS Transaction Header";
    begin
        LMSHeader.SetRange("Datasource ID", DataSourceID);
        LMSHeader.SetRange("Transaction Date", TransactionDate);

        if LMSHeader.FindFirst() then
            exit(LMSHeader);

        LMSHeader.Init();
        LMSHeader."Datasource ID" := DataSourceID;
        LMSHeader."Transaction Date" := TransactionDate;
        LMSHeader.Status := LMSHeader.Status::Open;
        LMSHeader.Insert(true);
        exit(LMSHeader);
    end;

    local procedure GetLastLineNo(LMSHeader: Record "12E LMS Transaction Header"): Integer
    var
        LMSLine: Record "12E LMS Transaction Line";
    begin
        LMSLine.SetRange("Document No.", LMSHeader."No.");
        if LMSLine.FindLast() then
            exit(LMSLine."Line No.");
        exit(0);
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
        LMSLine.Amount := GetPostingAmount(LMSDataQuery);

        if LMSDataQuery.DebitAccountNo <> '' then begin
            LMSLine."Debit Amount" := LMSDataQuery.Amount;
            LMSLine."Credit Amount" := 0;
        end else begin
            LMSLine."Debit Amount" := 0;
            LMSLine."Credit Amount" := LMSDataQuery.Amount;
        end;

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
        LMSTransaction.SetRange("LMS Transaction Details No.", '');
        LMSTransaction.SetCurrentKey("Datasource ID", "Transaction Posting Date", "PK ID");

        if not LMSTransaction.FindSet(true) then
            exit;

        TransactionDate := 0D;
        DocumentNo := '';
        EntryNo := 0;

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
            LMSDetail."LMS Document No." := DocumentNo;
            LMSDetail."Entry No." := EntryNo;
            LMSDetail."PK ID" := LMSTransaction."PK ID";
            LMSDetail."DW Load Date" := LMSTransaction."DW Load Date";
            LMSDetail."Datasource ID" := LMSTransaction."Datasource ID";
            LMSDetail."Loan ID" := LMSTransaction."Loan ID";
            LMSDetail."Payment ID" := LMSTransaction."Payment ID";
            LMSDetail."Transaction ID" := LMSTransaction."Transaction ID";
            LMSDetail."Batch ID" := LMSTransaction."Batch ID";
            LMSDetail."Payment Type" := LMSTransaction."Payment Type";
            LMSDetail."Payment Agent" := LMSTransaction."Payment Agent";
            LMSDetail."Loan Status" := LMSTransaction."Loan Status";
            LMSDetail.State := LMSTransaction.State;
            LMSDetail.Store := LMSTransaction.Store;
            LMSDetail.Processor := LMSTransaction.Processor;
            LMSDetail."Transaction Code" := LMSTransaction."Transaction Code";
            LMSDetail."Transaction Date" := LMSTransaction."Transaction Date";
            LMSDetail.Amount := LMSTransaction.Amount;
            LMSDetail."Debit Account No." := LMSTransaction."Debit Account No.";
            LMSDetail."Credit Account No." := LMSTransaction."Credit Account No.";
            LMSDetail."Document No." := LMSTransaction."Document No.";
            LMSDetail."G/L Register No." := 0;
            LMSDetail."Source Code" := LMSTransaction."Source Code";
            LMSDetail."Reason Code" := LMSTransaction."Reason Code";
            LMSDetail."ERP Status" := 'Created';
            LMSDetail."ERP Error Msg" := '';
            LMSDetail.Insert(true);

            LMSTransaction."Document No." := DocumentNo;
            LMSTransaction."LMS Transaction Details No." := DocumentNo;
            LMSTransaction."ERP Status" := 'Created';
            LMSTransaction."ERP Error Message" := '';
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

    local procedure GetPostingAmount(LMSTransaction: Record "12E LMS Transaction"): Decimal
    begin
        if LMSTransaction."Debit Account No." <> '' then
            exit(LMSTransaction.Amount);
        if LMSTransaction."Credit Account No." <> '' then
            exit(-LMSTransaction.Amount);
        exit(0);
    end;

    local procedure GetPostingAmount(LMSDataQuery: Query "12E LMS Transaction Data"): Decimal
    begin
        if LMSDataQuery.DebitAccountNo <> '' then
            exit(LMSDataQuery.Amount);
        if LMSDataQuery.CreditAccountNo <> '' then
            exit(-LMSDataQuery.Amount);
        exit(0);
    end;
}