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
                        Caption = 'Transaction Date';
                        ToolTip = 'Specifies the Transaction Date for the test transactions.';
                    }

                    field(NumberOfRecords; NumberOfRecords)
                    {
                        ApplicationArea = All;
                        Caption = 'Number of Records';
                        ToolTip = 'Specifies the number of LMS Transaction records to create. Maximum is 10.';
                    }

                    field(DeleteExistingTestData; DeleteExistingTestData)
                    {
                        ApplicationArea = All;
                        Caption = 'Delete Existing Test Data';
                        ToolTip = 'Specifies whether all previously generated test records should be deleted before creating new records.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            DatasourceID := 4;
            StartingDate := DMY2Date(1, 8, 2026);
            NumberOfRecords := 10;
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
        TransactionDateTime: DateTime;
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
        TransactionDateTime := CreateDateTime(StartingDate, 120000T);

        for RecordNo := 1 to NumberOfRecords / 2 do begin
            TransactionAmount := GetTestAmount(RecordNo);
            DebitAccountNo := GetPostingGLAccount((RecordNo - 1) * 2 + 1);
            CreditAccountNo := GetPostingGLAccount((RecordNo - 1) * 2 + 2);

            InsertLMSTransaction(
                PKID,
                TransactionID,
                TransactionDateTime,
                TransactionAmount,
                DebitAccountNo,
                '');
            PKID += 1;

            if RecordNo = NumberOfRecords / 2 then
                TransactionAmount -= 50;

            InsertLMSTransaction(
                PKID,
                TransactionID,
                TransactionDateTime,
                TransactionAmount,
                '',
                CreditAccountNo);
            PKID += 1;
        end;

        Message(
            '%1 LMS Transaction test records were created for Transaction ID %2 and Datasource ID %3. The final debit/credit pair has a %4 imbalance.',
            NumberOfRecords,
            TransactionID,
            DatasourceID,
            50);
    end;

    local procedure InsertLMSTransaction(
        PKID: Integer;
        TransactionID: Integer;
        TransactionDateTime: DateTime;
        TransactionAmount: Decimal;
        DebitAccountNo: Code[20];
        CreditAccountNo: Code[20])
    var
        LMSTransaction: Record "12E LMS Transaction";
    begin
        LMSTransaction.Init();
        LMSTransaction."PK ID" := PKID;
        LMSTransaction."DW Load Date" := TransactionDateTime;
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
        LMSTransaction."Transaction Date" := TransactionDateTime;
        LMSTransaction.Amount := TransactionAmount;
        LMSTransaction."Debit Account No." := DebitAccountNo;
        LMSTransaction."Credit Account No." := CreditAccountNo;
        LMSTransaction."Transaction Posting Date" := StartingDate;
        LMSTransaction.Insert();
    end;

    local procedure DeleteTestData()
    var
        LMSTransaction: Record "12E LMS Transaction";
        DeletedCount: Integer;
    begin
        LMSTransaction.Reset();
        LMSTransaction.SetRange("Payment Agent", 'TEST AGENT');

        DeletedCount := LMSTransaction.Count();

        if DeletedCount > 0 then begin
            LMSTransaction.DeleteAll();
            Message('%1 existing LMS Transaction test records were deleted.', DeletedCount);
        end;
    end;

    local procedure ValidateOptions()
    begin
        if DatasourceID = 0 then
            Error('Datasource ID must be specified.');

        if StartingDate = 0D then
            Error('Transaction Date must be specified.');

        if NumberOfRecords <= 0 then
            Error('Number of Records must be greater than zero.');

        if NumberOfRecords > 10 then
            Error('Number of Records cannot be greater than 10.');

        if NumberOfRecords mod 2 <> 0 then
            Error('Number of Records must be an even number because each transaction requires a debit and credit record.');
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

    local procedure GetTestAmount(RecordNo: Integer): Decimal
    begin
        exit(100 + ((RecordNo * 37) mod 900) + 0.50);
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
        exit('ST01');
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