codeunit 52121 "12E Payroll Batch Post"
{
    var
        TwelveSetup: Record "12E Setup";

        NoLinesToPostErr: Label 'There are no Payroll Batch Lines to post.';
        NoLinesToPreviewErr: Label 'There are no Payroll Batch Lines to preview.';
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';
        PayrollPostedMsg: Label 'Payroll Batch %1 posted successfully.';

    procedure Post(var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
        BatchTotal: Decimal;
    begin
        PayrollBatchHeader.TestField("Batch Status", PayrollBatchHeader."Batch Status"::Released);

        GetSetup();

        PayrollBatchLine.SetRange("Document No.", PayrollBatchHeader."No.");

        if not PayrollBatchLine.FindSet() then
            Error(NoLinesToPostErr);

        DeleteJournalLines();

        CreateJournalLines(PayrollBatchHeader, PayrollBatchLine, BatchTotal);

        CreateBalancingJournalLine(PayrollBatchHeader, BatchTotal);
        PostJournal();

        DeleteJournalLines();

        PayrollBatchHeader."Batch Status" := PayrollBatchHeader."Batch Status"::Processed;
        PayrollBatchHeader.Modify(true);

        Message(PayrollPostedMsg, PayrollBatchHeader."No.");
    end;

    procedure PreviewPosting(var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
        BatchTotal: Decimal;
    begin
        GetSetup();

        PayrollBatchLine.SetRange("Document No.", PayrollBatchHeader."No.");

        if not PayrollBatchLine.FindSet() then
            Error(NoLinesToPreviewErr);

        DeleteJournalLines();

        CreateJournalLines(PayrollBatchHeader, PayrollBatchLine, BatchTotal);

        CreateBalancingJournalLine(PayrollBatchHeader, BatchTotal);

        PreviewGenJournalLines();

        DeleteJournalLines();
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();

        TwelveSetup.TestField("Payroll Jnl. Template");
        TwelveSetup.TestField("Payroll Jnl. Batch");
        TwelveSetup.TestField("Payroll Offset Account No.");
    end;

    local procedure CreateJournalLines(PayrollBatchHeader: Record "12E Payroll Batch Header"; var PayrollBatchLine: Record "12E Payroll Batch Line"; var BatchTotal: Decimal)
    var
        GenJournalLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
    begin
        BatchTotal := 0;

        NextLineNo := GetNextGenJnlLineNo();

        if PayrollBatchLine.FindSet() then
            repeat
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := TwelveSetup."Payroll Jnl. Template";
                GenJournalLine."Journal Batch Name" := TwelveSetup."Payroll Jnl. Batch";
                GenJournalLine."Line No." := NextLineNo;
                GenJournalLine.Insert(true);

                GenJournalLine.Validate("Posting Date", PayrollBatchHeader."Pay Date");
                GenJournalLine.Validate("Document No.", PayrollBatchHeader."No.");
                GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.Validate("Account No.", PayrollBatchLine."G/L Account No.");
                GenJournalLine.Validate(Amount, PayrollBatchLine.Amount);

                GenJournalLine.Modify(true);

                BatchTotal += PayrollBatchLine.Amount;
                NextLineNo += 10000;
            until PayrollBatchLine.Next() = 0;
    end;

    local procedure CreateBalancingJournalLine(PayrollBatchHeader: Record "12E Payroll Batch Header"; BatchTotal: Decimal)
    var
        GenJournalLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        BalanceAmount: Decimal;
    begin
        if BatchTotal = 0 then
            exit;

        if BatchTotal > 0 then
            BalanceAmount := -BatchTotal
        else
            BalanceAmount := Abs(BatchTotal);

        NextLineNo := GetNextGenJnlLineNo();

        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := TwelveSetup."Payroll Jnl. Template";
        GenJournalLine."Journal Batch Name" := TwelveSetup."Payroll Jnl. Batch";
        GenJournalLine."Line No." := NextLineNo;
        GenJournalLine.Insert(true);

        GenJournalLine.Validate("Posting Date", PayrollBatchHeader."Pay Date");
        GenJournalLine.Validate("Document No.", PayrollBatchHeader."No.");
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", TwelveSetup."Payroll Offset Account No.");
        GenJournalLine.Validate(Amount, BalanceAmount);

        GenJournalLine.Modify(true);
    end;

    local procedure PostJournal()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Payroll Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPostErr);

        GenJnlPostBatch.Run(GenJournalLine);
    end;

    local procedure PreviewGenJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        RecVar: Variant;
        CodeunitVar: Variant;
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Payroll Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPreviewErr);

        RecVar := GenJournalLine;
        CodeunitVar := GenJnlPostLine;
        GenJnlPostPreview.Preview(RecVar, CodeunitVar);
    end;

    local procedure DeleteJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Payroll Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");

        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);
    end;

    local procedure GetNextGenJnlLineNo(): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Payroll Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");

        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000);

        exit(10000);
    end;
}