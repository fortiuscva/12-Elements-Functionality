
codeunit 52138 "12E Banking Transaction Import"
{
    procedure ImportBankingTransactions(StatementType: Enum "Bank Acc. Rec. Stmt. Type"; BankAccountNo: Code[20]; StatementNo: Code[20])
    var
        BankStaging: Record "12E Banking Transaction";
        BankStagingList: Page "12E Banking Transactions";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankMapping: Record "12E DDA Mapping";
        BankMappingErrLbl: Label 'Bank Mapping does not exist for this Bank Account No. %1';
        NextLineNo: Integer;
        ImportedCount: Integer;
    begin
        if BankAccountNo = '' then
            Error('Bank Account No. is missing from the current Payment Reconciliation Journal.');

        if StatementNo = '' then
            Error('Statement No. is missing from the current Payment Reconciliation Journal.');

        BankMapping.Reset();
        BankMapping.SetRange("Company Name", CompanyName);
        BankMapping.SetRange("Bank Account No.", BankAccountNo);
        BankMapping.FindFirst();

        BankStaging.Reset();
        BankStaging.FilterGroup(10);
        BankStaging.SetRange("DDA No.", BankMapping."DDA No.");
        BankStaging.SetRange("Reconciliation Jnl Line No.", 0);
        BankStaging.SetRange("Bank Ledger Entry No.", 0);
        BankStaging.FilterGroup(0);

        BankStagingList.SetTableView(BankStaging);
        BankStagingList.LookupMode(true);

        if BankStagingList.RunModal() <> Action::LookupOK then
            exit;

        BankStagingList.SetSelectionFilter(BankStaging);

        if not BankStaging.FindSet(true) then
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
            BankAccReconciliationLine."Statement Type" := StatementType;
            BankAccReconciliationLine."Bank Account No." := BankAccountNo;
            BankAccReconciliationLine."Statement No." := StatementNo;
            BankAccReconciliationLine."Statement Line No." := NextLineNo;
            BankAccReconciliationLine.Insert(true);

            BankAccReconciliationLine.Validate("Transaction Date", BankStaging."Transaction Date");
            BankAccReconciliationLine.Validate("Document No.", BankStaging."Check No.");
            BankAccReconciliationLine.Validate("Transaction Text", CopyStr(BankStaging."Transaction Description", 1, MaxStrLen(BankAccReconciliationLine."Transaction Text")));
            BankAccReconciliationLine.Validate("Statement Amount", BankStaging.Amount);
            BankAccReconciliationLine."12E Banking PKID" := BankStaging.PKID;
            BankAccReconciliationLine.Modify(true);

            BankStaging."Reconciliation Jnl Line No." := BankAccReconciliationLine."Statement Line No.";
            BankStaging."Processed in Company" := CompanyName();

            BankStaging.Modify(true);

            NextLineNo += 10000;
            ImportedCount += 1;
        until BankStaging.Next() = 0;

        Message('%1 Banking transactions imported successfully.', ImportedCount);
    end;

    local procedure GetGLAccount(BankAccountNo: Code[20]): Code[20]
    var
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        if not BankAccountPostingGroup.Get(BankAccountNo) then
            exit('');
        exit(BankAccountPostingGroup."G/L Account No.");
    end;

}
