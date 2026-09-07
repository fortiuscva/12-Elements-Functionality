codeunit 52126 "12E LMS Batch Posting"
{
    var
        TwelveSetup: Record "12E Setup";
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';
        LMSPostedMsg: Label 'LMS Batch %1 posted successfully.';

    procedure Post(var LMSBatch: Record "12E LMS Batch")
    var
        PostingError: Text;
    begin
        if LMSBatch.Processed then
            Error('LMS Batch entry %1 is already processed.', LMSBatch."PK ID");

        GetSetup();

        Clear(LMSBatch."Posting Error");
        Clear(LMSBatch.ERPErrorMsg);
        LMSBatch.Modify(true);

        DeleteJournalLines();
        CreateJournalLines(LMSBatch);

        if not TryPostJournal() then begin
            PostingError := GetLastErrorText();
            LMSBatch.Get(LMSBatch."PK ID");
            LMSBatch."Posting Error" := CopyStr(PostingError, 1, MaxStrLen(LMSBatch."Posting Error"));
            LMSBatch.ERPErrorMsg := CopyStr(PostingError, 1, MaxStrLen(LMSBatch.ERPErrorMsg));
            LMSBatch.Modify(true);
            DeleteJournalLines();

            if GuiAllowed() then
                Message(PostingError);

            exit;
        end;

        DeleteJournalLines();

        LMSBatch.Get(LMSBatch."PK ID");
        LMSBatch.Processed := true;
        LMSBatch."Posting Error" := '';
        LMSBatch.ERPErrorMsg := '';
        LMSBatch.Modify(true);

        if GuiAllowed() then
            Message(LMSPostedMsg, LMSBatch."PK ID");
    end;

    procedure PreviewPosting(var LMSBatch: Record "12E LMS Batch")
    begin
        if LMSBatch.Processed then
            Error('LMS Batch entry %1 is already processed.', LMSBatch."PK ID");

        GetSetup();
        DeleteJournalLines();
        CreateJournalLines(LMSBatch);
        Commit();
        PreviewGenJournalLines();
        DeleteJournalLines();
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();

        TwelveSetup.TestField("LMS Batch Jnl. Template Name");
        TwelveSetup.TestField("LMS Batch Jnl. Batch Name");
        TwelveSetup.TestField("LMS Batch Document Nos.");
    end;

    local procedure CreateJournalLines(var LMSBatch: Record "12E LMS Batch")
    var
        NoSeries: Codeunit "No. Series";
    begin
        if LMSBatch."Document No." = '' then begin
            LMSBatch."Document No." := NoSeries.GetNextNo(TwelveSetup."LMS Batch Document Nos.", DT2Date(LMSBatch."Transaction Date"), true);
            LMSBatch.Modify(true);
        end;

        CreateGenJournalLine(LMSBatch);
    end;

    local procedure CreateGenJournalLine(var LMSBatch: Record "12E LMS Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := TwelveSetup."LMS Batch Jnl. Template Name";
        GenJournalLine."Journal Batch Name" := TwelveSetup."LMS Batch Jnl. Batch Name";
        GenJournalLine."Line No." := GetNextGenJnlLineNo();
        GenJournalLine.Insert(true);
        GenJournalLine.Validate("Posting Date", DT2Date(LMSBatch."Transaction Date"));
        GenJournalLine.Validate("Document No.", LMSBatch."Document No.");
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", LMSBatch."Debit Account No.");
        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", LMSBatch."Credit Account No.");
        GenJournalLine.Validate(Amount, LMSBatch.Amount);
        GenJournalLine.Validate("Source Code", 'EPIC');
        GenJournalLine.Validate("Your Reference", LMSBatch."Your Reference");
        GenJournalLine.Validate("External Document No.", LMSBatch."External Document No.");
        GenJournalLine.Validate("Reason Code", LMSBatch."Reason Code");
        GenJournalLine.Validate(Correction, LMSBatch.Correction);
        GenJournalLine.Modify(true);
    end;

    [TryFunction]
    local procedure TryPostJournal()
    begin
        PostJournal();
    end;

    local procedure PostJournal()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Batch Jnl. Template Name");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Batch Jnl. Batch Name");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPostErr);

        GenJnlPostBatch.Run(GenJournalLine);
    end;

    local procedure PreviewGenJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Batch Jnl. Template Name");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Batch Jnl. Batch Name");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPreviewErr);

        GenJnlPost.Preview(GenJournalLine);
    end;

    local procedure DeleteJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Batch Jnl. Template Name");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Batch Jnl. Batch Name");

        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);
    end;

    local procedure GetNextGenJnlLineNo(): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Batch Jnl. Template Name");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Batch Jnl. Batch Name");

        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000);

        exit(10000);
    end;
}