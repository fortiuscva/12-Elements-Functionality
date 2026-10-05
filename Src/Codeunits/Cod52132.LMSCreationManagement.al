codeunit 52132 "12E LMS Creation Management"
{
    var
        CurrentRunFailedTransactions: Record "12E LMS Transaction" temporary;

    procedure CreateLMSTransactions()
    var
        DataSourceID: Integer;
    begin
        CurrentRunFailedTransactions.Reset();
        CurrentRunFailedTransactions.DeleteAll();

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
        LMSTransaction.Reset();
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("LMS Transaction Document No.", '');
        LMSTransaction.SetRange("Posted LMS Trans. Document No.", '');

        if LMSTransaction.FindSet() then
            repeat
                if IsUnprocessedTransaction(LMSTransaction) then
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
        TransactionDate: Date;
        TransactionID: Integer;
        TransactionAmount: Decimal;
        HasTransactions: Boolean;
    begin
        LMSTransaction.Reset();
        LMSTransaction.SetCurrentKey("Datasource ID", "Transaction Posting Date", "Transaction ID", "PK ID");
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("LMS Transaction Document No.", '');
        LMSTransaction.SetRange("Posted LMS Trans. Document No.", '');

        if not LMSTransaction.FindSet() then
            exit;

        TransactionDate := 0D;
        TransactionID := 0;
        TransactionAmount := 0;
        HasTransactions := false;

        repeat
            if IsUnprocessedTransaction(LMSTransaction) and not IsCurrentRunFailed(LMSTransaction) then begin
                CheckDuplicatePaymentBatch(LMSTransaction);

                if IsUnprocessedTransaction(LMSTransaction) and not IsCurrentRunFailed(LMSTransaction) then begin
                    if (TransactionDate <> LMSTransaction."Transaction Posting Date") or (TransactionID <> LMSTransaction."Transaction ID") then begin
                        if HasTransactions then
                            CheckTransactionBalance(DataSourceID, TransactionDate, TransactionID, TransactionAmount, HasTransactions);

                        TransactionDate := LMSTransaction."Transaction Posting Date";
                        TransactionID := LMSTransaction."Transaction ID";
                        TransactionAmount := 0;
                        HasTransactions := false;
                    end;

                    TransactionAmount += GetPostingAmount(LMSTransaction);
                    HasTransactions := true;
                end;
            end;
        until LMSTransaction.Next() = 0;

        if HasTransactions then
            CheckTransactionBalance(DataSourceID, TransactionDate, TransactionID, TransactionAmount, HasTransactions);
    end;

    local procedure CheckDuplicatePaymentBatch(LMSTransaction: Record "12E LMS Transaction")
    var
        OtherTransaction: Record "12E LMS Transaction";
        PaymentID: Integer;
        BatchID: Integer;
        ErrorMessage: Text;
    begin
        if not IsUnprocessedTransaction(LMSTransaction) or IsCurrentRunFailed(LMSTransaction) then
            exit;

        PaymentID := LMSTransaction."Payment ID";
        BatchID := LMSTransaction."Batch ID";

        if PaymentID = 0 then
            exit;

        OtherTransaction.Reset();
        OtherTransaction.SetRange("Datasource ID", LMSTransaction."Datasource ID");
        OtherTransaction.SetRange("Payment ID", PaymentID);
        OtherTransaction.SetFilter("Batch ID", '<>%1', BatchID);

        if OtherTransaction.FindSet() then
            repeat
                if IsUnprocessedTransaction(OtherTransaction) and not IsCurrentRunFailed(OtherTransaction) then begin
                    ErrorMessage := StrSubstNo('Payment ID %1 has another unposted transaction with a different Batch ID. Batch ID %2 and Batch ID %3 cannot be processed together.', PaymentID, BatchID, OtherTransaction."Batch ID");
                    MarkPaymentIDFailed(LMSTransaction."Datasource ID", PaymentID, ErrorMessage);
                    exit;
                end;
            until OtherTransaction.Next() = 0;
    end;

    local procedure MarkPaymentIDFailed(DataSourceID: Integer; PaymentID: Integer; ErrorMessage: Text)
    var
        SourceTransaction: Record "12E LMS Transaction";
    begin
        SourceTransaction.Reset();
        SourceTransaction.SetRange("Datasource ID", DataSourceID);
        SourceTransaction.SetRange("Payment ID", PaymentID);

        if SourceTransaction.FindSet(true) then
            repeat
                if IsUnprocessedTransaction(SourceTransaction) then begin
                    SourceTransaction."ERP Status" := 'FAILED';
                    SourceTransaction."ERP Error Message" := CopyStr(ErrorMessage, 1, MaxStrLen(SourceTransaction."ERP Error Message"));
                    SourceTransaction.Modify();
                    AddCurrentRunFailed(SourceTransaction);
                end;
            until SourceTransaction.Next() = 0;
    end;

    local procedure CheckTransactionBalance(DataSourceID: Integer; TransactionDate: Date; TransactionID: Integer; TransactionAmount: Decimal; HasTransactions: Boolean)
    begin
        if not HasTransactions then
            exit;

        if Round(TransactionAmount, 0.01) = 0 then
            exit;

        MarkTransactionIDFailed(DataSourceID, TransactionDate, TransactionID, StrSubstNo('Transaction ID %1 is out of balance.', TransactionID));
    end;

    local procedure MarkTransactionGroupFailed(LMSTransaction: Record "12E LMS Transaction"; ErrorMessage: Text)
    var
        SourceTransaction: Record "12E LMS Transaction";
    begin
        SourceTransaction.Reset();
        SourceTransaction.SetRange("Datasource ID", LMSTransaction."Datasource ID");
        SourceTransaction.SetRange("Transaction Posting Date", LMSTransaction."Transaction Posting Date");
        SourceTransaction.SetRange("Transaction ID", LMSTransaction."Transaction ID");
        SourceTransaction.SetRange("Payment ID", LMSTransaction."Payment ID");

        if SourceTransaction.FindSet(true) then
            repeat
                if IsUnprocessedTransaction(SourceTransaction) then begin
                    SourceTransaction."ERP Status" := 'FAILED';
                    SourceTransaction."ERP Error Message" := CopyStr(ErrorMessage, 1, MaxStrLen(SourceTransaction."ERP Error Message"));
                    SourceTransaction.Modify();
                    AddCurrentRunFailed(SourceTransaction);
                end;
            until SourceTransaction.Next() = 0;
    end;

    local procedure MarkTransactionIDFailed(DataSourceID: Integer; TransactionDate: Date; TransactionID: Integer; ErrorMessage: Text)
    var
        SourceTransaction: Record "12E LMS Transaction";
    begin
        SourceTransaction.Reset();
        SourceTransaction.SetRange("Datasource ID", DataSourceID);
        SourceTransaction.SetRange("Transaction Posting Date", TransactionDate);
        SourceTransaction.SetRange("Transaction ID", TransactionID);

        if SourceTransaction.FindSet(true) then
            repeat
                if IsUnprocessedTransaction(SourceTransaction) then begin
                    SourceTransaction."ERP Status" := 'FAILED';
                    SourceTransaction."ERP Error Message" := CopyStr(ErrorMessage, 1, MaxStrLen(SourceTransaction."ERP Error Message"));
                    SourceTransaction.Modify();
                    AddCurrentRunFailed(SourceTransaction);
                end;
            until SourceTransaction.Next() = 0;
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

            if HasCurrentRunFailedTransactions(DataSourceID, LMSDataQuery.TransactionPostingDate, LMSDataQuery.State, LMSDataQuery.Store, LMSDataQuery.DebitAccountNo, LMSDataQuery.CreditAccountNo) then
                continue;

            if not HasEligibleTransactionsForDocument(DataSourceID, LMSDataQuery.TransactionPostingDate, LMSDataQuery.State, LMSDataQuery.Store, LMSDataQuery.DebitAccountNo, LMSDataQuery.CreditAccountNo) then
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
    end;

    local procedure HasEligibleTransactionsForDocument(DataSourceID: Integer; TransactionDate: Date; StateCode: Code[20]; StoreCode: Code[20]; DebitAccountNo: Code[20]; CreditAccountNo: Code[20]): Boolean
    var
        LMSTransaction: Record "12E LMS Transaction";
    begin
        LMSTransaction.Reset();
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("Transaction Posting Date", TransactionDate);
        LMSTransaction.SetRange(State, StateCode);
        LMSTransaction.SetRange(Store, StoreCode);
        LMSTransaction.SetRange("Debit Account No.", DebitAccountNo);
        LMSTransaction.SetRange("Credit Account No.", CreditAccountNo);
        LMSTransaction.SetRange("LMS Transaction Document No.", '');
        LMSTransaction.SetRange("Posted LMS Trans. Document No.", '');

        if not LMSTransaction.FindSet() then
            exit(false);

        repeat
            if IsUnprocessedTransaction(LMSTransaction) and not IsCurrentRunFailed(LMSTransaction) then
                exit(true);
        until LMSTransaction.Next() = 0;

        exit(false);
    end;

    local procedure HasCurrentRunFailedTransactions(DataSourceID: Integer; TransactionDate: Date; StateCode: Code[20]; StoreCode: Code[20]; DebitAccountNo: Code[20]; CreditAccountNo: Code[20]): Boolean
    var
        FailedTransaction: Record "12E LMS Transaction" temporary;
    begin
        CurrentRunFailedTransactions.Reset();
        CurrentRunFailedTransactions.SetRange("Datasource ID", DataSourceID);
        CurrentRunFailedTransactions.SetRange("Transaction Posting Date", TransactionDate);
        CurrentRunFailedTransactions.SetRange(State, StateCode);
        CurrentRunFailedTransactions.SetRange(Store, StoreCode);
        CurrentRunFailedTransactions.SetRange("Debit Account No.", DebitAccountNo);
        CurrentRunFailedTransactions.SetRange("Credit Account No.", CreditAccountNo);

        if CurrentRunFailedTransactions.FindFirst() then begin
            FailedTransaction := CurrentRunFailedTransactions;
            exit(true);
        end;

        exit(false);
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
        LMSLine."Shortcut Dimension 1 Code" := LMSDataQuery.State;
        LMSLine."Shortcut Dimension 2 Code" := LMSDataQuery.Store;

        if LMSDataQuery.DebitAccountNo <> '' then begin
            LMSLine."Debit Amount" := LMSDataQuery.Amount;
            LMSLine."Credit Amount" := 0;
        end else begin
            LMSLine."Debit Amount" := 0;
            LMSLine."Credit Amount" := LMSDataQuery.Amount;
        end;

        LMSLine.Insert(true);
        CreateTransactionDetails(LMSHeader."No.", LMSHeader."Datasource ID", LMSDataQuery.TransactionPostingDate, LMSDataQuery.State, LMSDataQuery.Store, LMSDataQuery.DebitAccountNo, LMSDataQuery.CreditAccountNo);
    end;

    local procedure CreateTransactionDetails(DocumentNo: Code[20]; DataSourceID: Integer; TransactionDate: Date; StateCode: Code[20]; StoreCode: Code[20]; DebitAccountNo: Code[20]; CreditAccountNo: Code[20])
    var
        LMSTransaction: Record "12E LMS Transaction";
        LMSDetail: Record "12E LMS Transaction Details";
        EntryNo: Integer;
    begin
        if DocumentNo = '' then
            exit;

        LMSTransaction.Reset();
        LMSTransaction.SetRange("Datasource ID", DataSourceID);
        LMSTransaction.SetRange("Transaction Posting Date", TransactionDate);
        LMSTransaction.SetRange(State, StateCode);
        LMSTransaction.SetRange(Store, StoreCode);
        LMSTransaction.SetRange("Debit Account No.", DebitAccountNo);
        LMSTransaction.SetRange("Credit Account No.", CreditAccountNo);
        LMSTransaction.SetRange("LMS Transaction Document No.", '');

        if not LMSTransaction.FindSet(true) then
            exit;

        EntryNo := GetLastDetailEntryNo(DocumentNo);

        repeat
            if IsUnprocessedTransaction(LMSTransaction) and not IsCurrentRunFailed(LMSTransaction) then begin
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
                LMSDetail."G/L Register No." := LMSTransaction."G/L Register No.";
                LMSDetail."Source Code" := LMSTransaction."Source Code";
                LMSDetail."Reason Code" := LMSTransaction."Reason Code";
                LMSDetail.Insert(true);

                LMSTransaction."ERP Status" := 'PASSED';
                LMSTransaction."ERP Error Message" := '';
                LMSTransaction."ERP Import Timestamp" := CurrentDateTime();
                LMSTransaction.Modify(true);
            end;
        until LMSTransaction.Next() = 0;
    end;

    local procedure GetLastDetailEntryNo(DocumentNo: Code[20]): Integer
    var
        LMSDetail: Record "12E LMS Transaction Details";
    begin
        LMSDetail.Reset();
        LMSDetail.SetRange("LMS Document No.", DocumentNo);

        if LMSDetail.FindLast() then
            exit(LMSDetail."Entry No.");

        exit(0);
    end;

    local procedure AddCurrentRunFailed(LMSTransaction: Record "12E LMS Transaction")
    begin
        CurrentRunFailedTransactions.Reset();
        CurrentRunFailedTransactions.SetRange("PK ID", LMSTransaction."PK ID");

        if CurrentRunFailedTransactions.IsEmpty() then begin
            CurrentRunFailedTransactions := LMSTransaction;
            CurrentRunFailedTransactions.Insert();
        end;
    end;

    local procedure IsCurrentRunFailed(var LMSTransaction: Record "12E LMS Transaction"): Boolean
    begin
        CurrentRunFailedTransactions.Reset();
        CurrentRunFailedTransactions.SetRange("PK ID", LMSTransaction."PK ID");
        exit(not CurrentRunFailedTransactions.IsEmpty());
    end;

    local procedure IsUnprocessedTransaction(var LMSTransaction: Record "12E LMS Transaction"): Boolean
    begin
        LMSTransaction.CalcFields("LMS Transaction Document No.", "Posted LMS Trans. Document No.");
        exit((LMSTransaction."LMS Transaction Document No." = '') and (LMSTransaction."Posted LMS Trans. Document No." = ''));
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