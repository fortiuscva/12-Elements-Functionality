
report 52130 "12E Create Bank Reconciliation"
{
    Caption = 'Create Bank Reconciliation';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                CreatePaymentReconciliationJournals();
            end;
        }
    }

    trigger OnPreReport()
    begin
        ImportedCount := 0;
    end;

    trigger OnPostReport()
    begin
        Message('%1 banking transactions imported successfully.', ImportedCount);
    end;

    var
        ImportedCount: Integer;

    local procedure CreatePaymentReconciliationJournals()
    var
        BankTransaction: Record "12E Banking Transaction";
        BankAccountNos: List of [Code[20]];
        BankAccountNo: Code[20];
    begin
        BankTransaction.Reset();
        BankTransaction.SetRange("Approved for Reconciliation", true);
        BankTransaction.SetRange("Reconciliation Jnl Line No.", 0);
        BankTransaction.SetRange("Bank Ledger Entry No.", 0);

        if BankTransaction.FindSet() then
            repeat
                BankTransaction.CalcFields("Company Name", "Bank Account No.");

                if (BankTransaction."Company Name" = CompanyName()) and (BankTransaction."Bank Account No." <> '') then
                    if not BankAccountNos.Contains(BankTransaction."Bank Account No.") then
                        BankAccountNos.Add(BankTransaction."Bank Account No.");
            until BankTransaction.Next() = 0;

        foreach BankAccountNo in BankAccountNos do
            CreateReconciliationJournal(BankAccountNo);
    end;

    local procedure CreateReconciliationJournal(BankAccountNo: Code[20])
    var
        BankTransaction: Record "12E Banking Transaction";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        StatementNo: Code[20];
        NextLineNo: Integer;
    begin
        BankAccount.Get(BankAccountNo);
        BankAccount.TestField("Bank Acc. Posting Group");

        BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group");
        BankAccountPostingGroup.TestField("G/L Account No.");

        BankAccReconciliation.Init();
        BankAccReconciliation.Validate("Statement Type", BankAccReconciliation."Statement Type"::"Payment Application");
        BankAccReconciliation.Validate("Bank Account No.", BankAccountNo);
        BankAccReconciliation.Validate("Statement Date", WorkDate());
        BankAccReconciliation.Insert(true);

        StatementNo := BankAccReconciliation."Statement No.";
        NextLineNo := 10000;

        BankTransaction.Reset();
        BankTransaction.SetRange("Approved for Reconciliation", true);
        BankTransaction.SetRange("Reconciliation Jnl Line No.", 0);
        BankTransaction.SetRange("Bank Ledger Entry No.", 0);

        if BankTransaction.FindSet(true) then
            repeat
                BankTransaction.CalcFields("Company Name", "Bank Account No.");

                if (BankTransaction."Company Name" = CompanyName()) and (BankTransaction."Bank Account No." = BankAccountNo) then begin
                    BankAccReconciliationLine.Init();
                    BankAccReconciliationLine.Validate("Statement Type", BankAccReconciliation."Statement Type");
                    BankAccReconciliationLine.Validate("Bank Account No.", BankAccountNo);
                    BankAccReconciliationLine.Validate("Statement No.", StatementNo);
                    BankAccReconciliationLine.Validate("Statement Line No.", NextLineNo);
                    BankAccReconciliationLine.Validate("Account Type", BankAccReconciliationLine."Account Type"::"G/L Account");
                    BankAccReconciliationLine.Validate("Account No.", BankAccountPostingGroup."G/L Account No.");
                    BankAccReconciliationLine.Validate("Transaction Date", BankTransaction."Transaction Date");
                    BankAccReconciliationLine.Validate("Document No.", BankTransaction."Check No.");
                    BankAccReconciliationLine.Validate("Transaction Text", CopyStr(BankTransaction."Transaction Description", 1, MaxStrLen(BankAccReconciliationLine."Transaction Text")));
                    BankAccReconciliationLine.Validate("Statement Amount", BankTransaction.Amount);
                    BankAccReconciliationLine."12E Banking PKID" := BankTransaction.PKID;
                    BankAccReconciliationLine.Insert(true);

                    BankTransaction."Reconciliation Jnl Line No." := NextLineNo;
                    BankTransaction."Processed in Company" := CompanyName();
                    BankTransaction.Modify(true);

                    NextLineNo += 10000;
                    ImportedCount += 1;
                end;
            until BankTransaction.Next() = 0;
    end;
}
