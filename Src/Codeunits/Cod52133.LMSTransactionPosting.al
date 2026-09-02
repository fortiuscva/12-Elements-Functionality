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
        GLRegisterNo: Integer;
    begin
        ValidateForPosting(LMSHeader);
        GetSetup();
        Clear(LMSHeader."Posting Error");
        Clear(LMSHeader."Error Exists");
        LMSHeader.Modify(true);
        DeleteJournalLines();
        CreateJournalLines(LMSHeader);

        if not TryPostJournal(GLRegisterNo) then begin
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
        LMSHeader.Get(LMSHeader."No.");
        LMSHeader."G/L Register No." := GLRegisterNo;
        LMSHeader."Posting Error" := '';
        LMSHeader."Error Exists" := false;
        LMSHeader.Modify(true);
        UpdatePostingResult(LMSHeader, GLRegisterNo);

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

        if LMSHeader."G/L Register No." <> 0 then
            Error('LMS Transaction %1 is already posted with G/L Register No. %2.', LMSHeader."No.", LMSHeader."G/L Register No.");

        if LMSHeader."Error Exists" then
            Error('LMS Transaction %1 contains errors and cannot be posted.', LMSHeader."No.");

        LMSLine.SetRange("Document No.", LMSHeader."No.");

        if LMSLine.IsEmpty() then
            Error('No LMS Transaction Lines exist for LMS Transaction %1.', LMSHeader."No.");
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();
        TwelveSetup.TestField("LMS Batch Jnl. Template Name");
        TwelveSetup.TestField("LMS Batch Jnl. Batch Name");
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
        GenJournalLine."Journal Template Name" := TwelveSetup."LMS Batch Jnl. Template Name";
        GenJournalLine."Journal Batch Name" := TwelveSetup."LMS Batch Jnl. Batch Name";
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
        GenJournalLine.Modify(true);
    end;

    [TryFunction]
    local procedure TryPostJournal(var GLRegisterNo: Integer)
    begin
        PostJournal(GLRegisterNo);
    end;

    local procedure PostJournal(var GLRegisterNo: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        LastGLRegisterNo: Integer;
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."LMS Batch Jnl. Template Name");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."LMS Batch Jnl. Batch Name");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPostErr);

        LastGLRegisterNo := GetLastGLRegisterNo();
        GenJnlPostBatch.Run(GenJournalLine);
        GLRegisterNo := GetNewGLRegisterNo(LastGLRegisterNo);

        if GLRegisterNo = 0 then
            Error('G/L Register No. was not generated for LMS Transaction %1.', GenJournalLine."Document No.");
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

    local procedure GetLastGLRegisterNo(): Integer
    var
        GLRegister: Record "G/L Register";
    begin
        if GLRegister.FindLast() then
            exit(GLRegister."No.");

        exit(0);
    end;

    local procedure GetNewGLRegisterNo(LastGLRegisterNo: Integer): Integer
    var
        GLRegister: Record "G/L Register";
    begin
        GLRegister.SetFilter("No.", '>%1', LastGLRegisterNo);

        if GLRegister.FindFirst() then
            exit(GLRegister."No.");

        exit(0);
    end;

    local procedure UpdatePostingResult(var LMSHeader: Record "12E LMS Transaction Header"; GLRegisterNo: Integer)
    var
        LMSTransaction: Record "12E LMS Transaction";
        LMSDetail: Record "12E LMS Transaction Details";
    begin
        LMSDetail.SetRange("LMS Document No.", LMSHeader."No.");
        LMSDetail.ModifyAll("G/L Register No.", GLRegisterNo);
        LMSDetail.ModifyAll("Source Code", TwelveSetup."LMS Source Code");
        LMSDetail.ModifyAll("Reason Code", TwelveSetup."LMS Reason Code");
        LMSDetail.ModifyAll("ERP Status", 'Posted');
        LMSDetail.ModifyAll("ERP Error Msg", '');

        LMSTransaction.SetRange("Document No.", LMSHeader."No.");
        LMSTransaction.ModifyAll("G/L Register No.", GLRegisterNo);
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
}