report 52105 "12E LMS Transaction Test Data"
{
    Caption = 'LMS Transaction Test Data';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                if DeleteExistingTestData then
                    DeleteTestData();

                CreateTestData();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(DatasourceID; DatasourceID)
                    {
                        ApplicationArea = All;
                        Caption = 'Datasource ID';
                        ToolTip = 'Specifies the Datasource ID for the test transactions.';
                    }

                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the starting Transaction Posting Date.';
                    }

                    field(NumberOfRecords; NumberOfRecords)
                    {
                        ApplicationArea = All;
                        Caption = 'Number of Records';
                        ToolTip = 'Specifies the total number of LMS Transaction records to create.';
                    }

                    field(DeleteExistingTestData; DeleteExistingTestData)
                    {
                        ApplicationArea = All;
                        Caption = 'Delete Existing Test Data';
                        ToolTip = 'Specifies whether previously generated test records should be deleted before creating new records.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            DatasourceID := 4;
            StartingDate := DMY2Date(1, 8, 2026);
            NumberOfRecords := 50;
            DeleteExistingTestData := false;
        end;
    }

    var
        DatasourceID: Integer;
        StartingDate: Date;
        NumberOfRecords: Integer;
        DeleteExistingTestData: Boolean;

    local procedure CreateTestData()
    var
        PostingDate: Date;
        TransactionID: Integer;
        PKID: Integer;
        RecordNo: Integer;
        TransactionAmount: Decimal;
        DebitAccountNo: Code[20];
        CreditAccountNo: Code[20];
    begin
        ValidateOptions();
        PKID := GetNextPKID();
        TransactionID := GetNextTransactionID();
        PostingDate := StartingDate;

        for RecordNo := 1 to NumberOfRecords div 2 do begin
            TransactionAmount := GetTestAmount(RecordNo);
            DebitAccountNo := GetPostingGLAccount((RecordNo - 1) * 2 + 1);
            CreditAccountNo := GetPostingGLAccount((RecordNo - 1) * 2 + 2);

            InsertLMSTransaction(PKID, TransactionID, PostingDate, TransactionAmount, DebitAccountNo, '');
            PKID += 1;

            InsertLMSTransaction(PKID, TransactionID, PostingDate, TransactionAmount, '', CreditAccountNo);
            PKID += 1;

            TransactionID += 1;
            PostingDate += 1;
        end;

        Message('%1 LMS Transaction test records were created for Datasource ID %2.', NumberOfRecords, DatasourceID);
    end;

    local procedure InsertLMSTransaction(PKID: Integer; TransactionID: Integer; PostingDate: Date; TransactionAmount: Decimal; DebitAccountNo: Code[20]; CreditAccountNo: Code[20])
    var
        LMSTransaction: Record "12E LMS Transaction";
    begin
        LMSTransaction.Init();
        LMSTransaction."PK ID" := PKID;
        LMSTransaction."DW Load Date" := CreateDateTime(PostingDate, 120000T);
        LMSTransaction."Datasource ID" := DatasourceID;
        LMSTransaction."Loan ID" := 100000 + TransactionID;
        LMSTransaction."Payment ID" := 200000 + TransactionID;
        LMSTransaction."Transaction ID" := TransactionID;
        LMSTransaction."Batch ID" := 300000 + TransactionID;
        LMSTransaction."Payment Type" := GetPaymentType(TransactionID);
        LMSTransaction."Payment Agent" := 'TEST AGENT';
        LMSTransaction."Loan Status" := GetLoanStatus(TransactionID);
        LMSTransaction.State := GetState(TransactionID);
        LMSTransaction.Store := GetStore(TransactionID);
        LMSTransaction.Processor := GetProcessor(TransactionID);
        LMSTransaction."Transaction Code" := GetTransactionCode(TransactionID);
        LMSTransaction."Transaction Date" := CreateDateTime(PostingDate, 120000T);
        LMSTransaction.Amount := TransactionAmount;
        LMSTransaction."Debit Account No." := DebitAccountNo;
        LMSTransaction."Credit Account No." := CreditAccountNo;
        LMSTransaction."Transaction Posting Date" := PostingDate;
        LMSTransaction.Insert();
    end;

    local procedure DeleteTestData()
    var
        LMSTransaction: Record "12E LMS Transaction";
        FromDate: Date;
        ToDate: Date;
        DeletedCount: Integer;
    begin
        FromDate := StartingDate;
        ToDate := CalcDate('<1M>', StartingDate) - 1;

        LMSTransaction.Reset();
        LMSTransaction.SetRange("Datasource ID", DatasourceID);
        LMSTransaction.SetRange("Transaction Posting Date", FromDate, ToDate);
        LMSTransaction.SetRange("Payment Agent", 'TEST AGENT');
        LMSTransaction.SetRange("ERP Status", 'Failed');

        DeletedCount := LMSTransaction.Count();

        if DeletedCount > 0 then
            LMSTransaction.DeleteAll();

        if DeletedCount > 0 then
            Message('%1 existing failed test records were deleted.', DeletedCount);
    end;

    local procedure ValidateOptions()
    begin
        if DatasourceID = 0 then
            Error('Datasource ID must be specified.');

        if StartingDate = 0D then
            Error('Starting Date must be specified.');

        if NumberOfRecords <= 0 then
            Error('Number of Records must be greater than zero.');

        if NumberOfRecords mod 2 <> 0 then
            Error('Number of Records must be an even number because each Transaction ID requires a debit and credit record.');
    end;

    local procedure GetNextPKID(): Integer
    var
        LMSTransaction: Record "12E LMS Transaction";
    begin
        LMSTransaction.Reset();
        if LMSTransaction.FindLast() then
            exit(LMSTransaction."PK ID" + 1);

        exit(1);
    end;

    local procedure GetNextTransactionID(): Integer
    var
        LMSTransaction: Record "12E LMS Transaction";
        HighestTransactionID: Integer;
    begin
        LMSTransaction.Reset();
        if LMSTransaction.FindSet() then
            repeat
                if LMSTransaction."Transaction ID" > HighestTransactionID then
                    HighestTransactionID := LMSTransaction."Transaction ID";
            until LMSTransaction.Next() = 0;

        exit(HighestTransactionID + 1);
    end;

    local procedure GetPostingGLAccount(AccountSequence: Integer): Code[20]
    var
        GLAccount: Record "G/L Account";
        CurrentIndex: Integer;
        TargetIndex: Integer;
    begin
        TargetIndex := ((AccountSequence - 1) mod 10) + 1;

        GLAccount.Reset();
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.SetRange(Blocked, false);
        GLAccount.SetCurrentKey("No.");

        if not GLAccount.FindSet() then
            Error('No unblocked Posting G/L Accounts are available.');

        repeat
            CurrentIndex += 1;

            if CurrentIndex = TargetIndex then
                exit(GLAccount."No.");
        until GLAccount.Next() = 0;

        Error('At least %1 unblocked Posting G/L Accounts are required.', TargetIndex);
    end;

    local procedure GetTestAmount(TransactionID: Integer): Decimal
    begin
        exit(100 + ((TransactionID * 37) mod 900) + 0.50);
    end;

    local procedure GetPaymentType(TransactionID: Integer): Text[50]
    begin
        if TransactionID mod 2 = 0 then
            exit('ACH');

        exit('CREDIT');
    end;

    local procedure GetLoanStatus(TransactionID: Integer): Text[50]
    begin
        case TransactionID mod 3 of
            0:
                exit('ACTIVE');
            1:
                exit('CURRENT');
            2:
                exit('PAID');
        end;
    end;

    local procedure GetState(TransactionID: Integer): Code[20]
    begin
        case TransactionID mod 5 of
            0:
                exit('TX');
            1:
                exit('CA');
            2:
                exit('FL');
            3:
                exit('NY');
            4:
                exit('OH');
        end;
    end;

    local procedure GetStore(TransactionID: Integer): Code[20]
    begin
        exit('STORE' + Format(((TransactionID - 1) mod 10) + 1));
    end;

    local procedure GetProcessor(TransactionID: Integer): Text[50]
    begin
        exit('PROCESSOR ' + Format(((TransactionID - 1) mod 3) + 1));
    end;

    local procedure GetTransactionCode(TransactionID: Integer): Text[50]
    begin
        if TransactionID mod 2 = 0 then
            exit('OFFSET');

        exit('PAYMENT');
    end;
}