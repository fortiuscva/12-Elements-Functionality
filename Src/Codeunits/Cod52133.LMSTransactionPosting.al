codeunit 52133 "12E LMS Transaction Posting"
{
    var
        TwelveSetup: Record "12E Setup";
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';
        LMSPostedMsg: Label 'LMS Transaction %1 posted successfully.';

    procedure Post(var LMSHeader: Record "12E LMS Transaction Header")
    var
        PostingError: Text;
    begin
        ValidateForPosting(LMSHeader);
        GetSetup();
        DeleteJournalLines();
        CreateJournalLines(LMSHeader);

        if not TryPostJournal() then begin
            PostingError := GetLastErrorText();
            LMSHeader.Get(LMSHeader."No.");
            LMSHeader."Posting Error" := CopyStr(PostingError, 1, MaxStrLen(LMSHeader."Posting Error"));
            LMSHeader."Error Exists" := true;
            LMSHeader.Modify(true);
            UpdatePostingError(LMSHeader, PostingError);
            DeleteJournalLines();
            if GuiAllowed() then
                Message(PostingError);
            exit;
        end;

        DeleteJournalLines();
        CreatePostedTransaction(LMSHeader);
        UpdatePostingResult(LMSHeader);
        DeleteLMSDocument(LMSHeader);

        if GuiAllowed() then
            Message(LMSPostedMsg, LMSHeader."No.");
    end;

    procedure PreviewPosting(var LMSHeader: Record "12E LMS Transaction Header")
    begin
        ValidateForPosting(LMSHeader);
        GetSetup();
        DeleteJournalLines();
        CreateJournalLines(LMSHeader);
        Commit();
        PreviewGenJournalLines();
        DeleteJournalLines();
    end;

    local procedure ValidateForPosting(var LMSHeader: Record "12E LMS Transaction Header")
    var
        LMSLine: Record "12E LMS Transaction Line";
    begin
        LMSHeader.TestField("No.");
        LMSHeader.TestField("Datasource ID");
        LMSHeader.TestField("Transaction Date");

        if LMSHeader.Status <> LMSHeader.Status::Released then
            Error('LMS Transaction %1 must be Released before posting.', LMSHeader."No.");

        if LMSHeader."Error Exists" then
            Error('LMS Transaction %1 contains errors and cannot be posted.', LMSHeader."No.");

        LMSLine.SetRange("Document No.", LMSHeader."No.");

        if LMSLine.IsEmpty() then
            Error('No LMS Transaction Lines exist for LMS Transaction %1.', LMSHeader."No.");
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();
        TwelveSetup.TestField("LMS Transaction Jnl. Template");
        TwelveSetup.TestField("LMS Transaction Jnl. Batch");
        TwelveSetup.TestField("LMS Source Code");
        TwelveSetup.TestField("LMS Reason Code");
    end;

    local procedure CreateJournalLines(var LMSHeader: Record "12E LMS Transaction Header")
    var
        LMSLine: Record "12E LMS Transaction Line";
    begin
        LMSLine.SetRange("Document No.", LMSHeader."No.");
        LMSLine.SetCurrentKey("Document No.", "Line No.");

        if not LMSLine.FindSet() then
            Error('No LMS Transaction Lines exist for LMS Transaction %1.', LMSHeader."No.");

        repeat
            CreateGenJournalLine(LMSHeader, LMSLine);
        until LMSLine.Next() = 0;
    end;

    local procedure CreateGenJournalLine(LMSHeader: Record "12E LMS Transaction Header"; LMSLine: Record "12E LMS Transaction Line")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := TwelveSetup."LMS Transaction Jnl. Template";
        GenJournalLine."Journal Batch Name" := TwelveSetup."LMS Transaction Jnl. Batch";
        GenJournalLine."Line No." := GetNextGenJnlLineNo();
        GenJournalLine.Insert(true);
        GenJournalLine.Validate("Posting Date", LMSHeader."Transaction Date");
        GenJournalLine.Validate("Document No.", LMSHeader."No.");
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", LMSLine."Account No.");
        GenJournalLine.Validate(Amount, LMSLine.Amount);
        GenJournalLine.Validate("Source Code", TwelveSetup."LMS Source Code");
        GenJournalLine.Validate("Reason Code", TwelveSetup."LMS Reason Code");
        GenJournalLine.Validate("Shortcut Dimension 1 Code", LMSLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate("Shortcut Dimension 2 Code", LMSLine."Shortcut Dimension 2 Code");
        GenJournalLine.Validate("Dimension Set ID", GetDimensionSetID(LMSLine));
        GenJournalLine.Modify(true);
    end;

    local procedure GetDimensionSetID(LMSLine: Record "12E LMS Transaction Line"): Integer
    var
        DimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
    begin
        AddDimensionSetEntry(DimensionSetEntry, LMSLine."Shortcut Dimension 3 Code");
        AddDimensionSetEntry(DimensionSetEntry, LMSLine."Shortcut Dimension 4 Code");
        AddDimensionSetEntry(DimensionSetEntry, LMSLine."Shortcut Dimension 5 Code");
        AddDimensionSetEntry(DimensionSetEntry, LMSLine."Shortcut Dimension 6 Code");
        AddDimensionSetEntry(DimensionSetEntry, LMSLine."Shortcut Dimension 7 Code");
        AddDimensionSetEntry(DimensionSetEntry, LMSLine."Shortcut Dimension 8 Code");

        if DimensionSetEntry.IsEmpty() then
            exit(0);

        exit(DimensionManagement.GetDimensionSetID(DimensionSetEntry));
    end;

    local procedure AddDimensionSetEntry(var DimensionSetEntry: Record "Dimension Set Entry" temporary; DimensionValue: Code[20])
    begin
        if DimensionValue = '' then
            exit;

        DimensionSetEntry.Init();
        DimensionSetEntry."Dimension Code" := GetDimensionCode(DimensionValue);
        DimensionSetEntry."Dimension Value Code" := DimensionValue;
        DimensionSetEntry.Insert();
    end;

    local procedure GetDimensionCode(DimensionValue: Code[20]): Code[20]
    var
        DimensionValueRec: Record "Dimension Value";
    begin
        DimensionValueRec.SetRange(Code, DimensionValue);

        if DimensionValueRec.FindFirst() then
            exit(DimensionValueRec."Dimension Code");

        Error('Dimension Value %1 does not exist.', DimensionValue);
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
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Transaction Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Transaction Jnl. Batch");

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
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Transaction Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Transaction Jnl. Batch");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPreviewErr);

        GenJnlPost.Preview(GenJournalLine);
    end;

    local procedure DeleteJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Transaction Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Transaction Jnl. Batch");

        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);
    end;

    local procedure GetNextGenJnlLineNo(): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Transaction Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Transaction Jnl. Batch");

        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure CreatePostedTransaction(LMSHeader: Record "12E LMS Transaction Header")
    var
        PostedHeader: Record "12E Posted LMS Trans. Header";
        LMSLine: Record "12E LMS Transaction Line";
    begin
        if PostedHeader.Get(LMSHeader."No.") then
            Error('Posted LMS Transaction %1 already exists.', LMSHeader."No.");

        PostedHeader.Init();
        PostedHeader.TransferFields(LMSHeader);
        PostedHeader."Posting Date" := LMSHeader."Transaction Date";
        PostedHeader."Source Code" := TwelveSetup."LMS Source Code";
        PostedHeader."Reason Code" := TwelveSetup."LMS Reason Code";
        PostedHeader.Reversed := false;
        PostedHeader.Insert(true);

        LMSLine.SetRange("Document No.", LMSHeader."No.");
        LMSLine.SetCurrentKey("Document No.", "Line No.");

        if LMSLine.FindSet() then
            repeat
                CreatePostedTransactionLine(LMSLine);
            until LMSLine.Next() = 0;
    end;

    local procedure CreatePostedTransactionLine(LMSLine: Record "12E LMS Transaction Line")
    var
        PostedLine: Record "12E Posted LMS Trans. Line";
    begin
        PostedLine.Init();
        PostedLine.TransferFields(LMSLine);
        PostedLine.Insert(true);
    end;

    local procedure UpdatePostingResult(var LMSHeader: Record "12E LMS Transaction Header")
    var
        LMSTransaction: Record "12E LMS Transaction";
        LMSDetail: Record "12E LMS Transaction Details";
    begin
        LMSDetail.SetRange("LMS Document No.", LMSHeader."No.");
        LMSDetail.ModifyAll("Source Code", TwelveSetup."LMS Source Code");
        LMSDetail.ModifyAll("Reason Code", TwelveSetup."LMS Reason Code");
        LMSDetail.ModifyAll("ERP Status", 'Posted');
        LMSDetail.ModifyAll("ERP Error Msg", '');

        LMSTransaction.SetRange("Document No.", LMSHeader."No.");
        LMSTransaction.ModifyAll("Source Code", TwelveSetup."LMS Source Code");
        LMSTransaction.ModifyAll("Reason Code", TwelveSetup."LMS Reason Code");
        LMSTransaction.ModifyAll("ERP Status", 'Posted');
        LMSTransaction.ModifyAll("ERP Error Message", '');
    end;

    local procedure UpdatePostingError(var LMSHeader: Record "12E LMS Transaction Header"; ErrorMessage: Text)
    var
        LMSTransaction: Record "12E LMS Transaction";
        LMSDetail: Record "12E LMS Transaction Details";
    begin
        LMSDetail.SetRange("LMS Document No.", LMSHeader."No.");
        LMSDetail.ModifyAll("ERP Status", 'Failed');
        LMSDetail.ModifyAll("ERP Error Msg", CopyStr(ErrorMessage, 1, MaxStrLen(LMSDetail."ERP Error Msg")));

        LMSTransaction.SetRange("Document No.", LMSHeader."No.");
        LMSTransaction.ModifyAll("ERP Status", 'Failed');
        LMSTransaction.ModifyAll("ERP Error Message", CopyStr(ErrorMessage, 1, MaxStrLen(LMSTransaction."ERP Error Message")));
    end;

    local procedure DeleteLMSDocument(var LMSHeader: Record "12E LMS Transaction Header")
    begin
        LMSHeader.Delete(true);
    end;
}