
codeunit 52138 "12E Banking Transaction Import"
{
    procedure ImportBankingTransactions(StatementType: Enum "Bank Acc. Rec. Stmt. Type"; BankAccountNo: Code[20]; StatementNo: Code[20])
    var
        BankStaging: Record "12E Bank Staging";
        BankStagingList: Page "12E Bank Staging";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        NextLineNo: Integer;
        ImportedCount: Integer;
    begin
        if BankAccountNo = '' then
            Error('Bank Account No. is missing from the current Payment Reconciliation Journal.');

        if StatementNo = '' then
            Error('Statement No. is missing from the current Payment Reconciliation Journal.');

        BankStaging.Reset();
        BankStaging.SetRange("Reconciliation Journal Line No.", 0);
        BankStaging.SetRange("Bank Ledger Entry No.", 0);

        BankStagingList.SetTableView(BankStaging);
        BankStagingList.LookupMode(true);

        if BankStagingList.RunModal() <> Action::LookupOK then
            exit;

        BankStagingList.SetSelectionFilter(BankStaging);

        if not BankStaging.FindSet() then
            exit;

        BankAccReconciliationLine.Reset();
        BankAccReconciliationLine.SetRange("Statement Type", StatementType);
        BankAccReconciliationLine.SetRange("Bank Account No.", BankAccountNo);
        BankAccReconciliationLine.SetRange("Statement No.", StatementNo);

        if BankAccReconciliationLine.FindLast() then
            NextLineNo := BankAccReconciliationLine."Statement Line No." + 10000
        else
            NextLineNo := 10000;

        repeat
            BankAccReconciliationLine.Init();
            BankAccReconciliationLine.Validate("Statement Type", StatementType);
            BankAccReconciliationLine.Validate("Bank Account No.", BankAccountNo);
            BankAccReconciliationLine.Validate("Statement No.", StatementNo);
            BankAccReconciliationLine.Validate("Statement Line No.", NextLineNo);
            BankAccReconciliationLine.Validate("Transaction Date", BankStaging."Transaction Date");
            BankAccReconciliationLine.Validate("Document No.", BankStaging."Check No.");
            BankAccReconciliationLine.Validate(
                "Transaction Text",
                CopyStr(BankStaging."Transaction Description", 1, MaxStrLen(BankAccReconciliationLine."Transaction Text")));
            BankAccReconciliationLine.Validate("Statement Amount", BankStaging.Amount);
            BankAccReconciliationLine."Banking PK ID" := BankStaging.PKID;
            BankAccReconciliationLine.Insert(true);

            NextLineNo += 10000;
            ImportedCount += 1;
        until BankStaging.Next() = 0;

        Message('%1 Banking transactions imported successfully.', ImportedCount);
    end;
}
