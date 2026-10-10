codeunit 52121 "12E Payroll Batch Post"
{
    var
        TwelveSetup: Record "12E Setup";
        NoLinesToPostErr: Label 'There are no Payroll Batch Lines to post.';
        NoLinesToPreviewErr: Label 'There are no Payroll Batch Lines to preview.';
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';
        PayrollPostedMsg: Label 'Payroll Batch %1 posted successfully.';
        DepartmentDimensionCode: Label 'DEPARTMENT', Locked = true;

    procedure Post(var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
        BatchTotal: Decimal;
        PayrollBatchNo: Code[20];
        PostingError: Text;
    begin
        if not Confirm('Do you want to post the payroll document %1?', false, PayrollBatchHeader."No.") then
            exit;

        PayrollBatchHeader.TestField(Status, PayrollBatchHeader.Status::Released);

        GetSetup();

        PayrollBatchLine.SetRange("Document No.", PayrollBatchHeader."No.");

        if not PayrollBatchLine.FindSet() then
            Error(NoLinesToPostErr);

        PayrollBatchNo := PayrollBatchHeader."No.";

        Clear(PayrollBatchHeader."Posting Error");
        Clear(PayrollBatchHeader."G/L Register No.");
        PayrollBatchHeader.Modify(true);

        DeleteJournalLines();


        if not TryPostJournal(PayrollBatchHeader, PayrollBatchLine, BatchTotal) then begin
            PostingError := GetLastErrorText();

            PayrollBatchHeader."Posting Error" := CopyStr(PostingError, 1, MaxStrLen(PayrollBatchHeader."Posting Error"));
            PayrollBatchHeader.Modify(true);

            DeleteJournalLines();
            Message(PostingError);
        end else begin
            DeleteJournalLines();
            PayrollBatchHeader.Get(PayrollBatchHeader."No.");
            TransferToPostedPayroll(PayrollBatchHeader);
            UpdatePayrollBatchAsPassed(PayrollBatchHeader);
            Message(PayrollPostedMsg, PayrollBatchNo);
        end;
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

        Commit();
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
        DimensionManagement: Codeunit DimensionManagement;
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

                PayrollBatchLine.CalcFields("Shortcut Dimension 1 Code");
                PayrollBatchLine.CalcFields("Shortcut Dimension 2 Code");
                // PayrollBatchLine.TestField("Shortcut Dimension 1 Code");
                GenJournalLine.Validate("Shortcut Dimension 1 Code", PayrollBatchLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate("Shortcut Dimension 2 Code", PayrollBatchLine."Shortcut Dimension 2 Code");

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
        BalanceAmount := BatchTotal * -1;

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

    [TryFunction]
    local procedure TryPostJournal(PayrollBatchHeader: Record "12E Payroll Batch Header"; var PayrollBatchLine: Record "12E Payroll Batch Line"; var BatchTotal: Decimal)
    begin
        CreateJournalLines(PayrollBatchHeader, PayrollBatchLine, BatchTotal);
        CreateBalancingJournalLine(PayrollBatchHeader, BatchTotal);
        PostJournal();
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
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Payroll Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPreviewErr);

        GenJnlPost.Preview(GenJournalLine);
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

    local procedure TransferToPostedPayroll(var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatchLine: Record "12E Payroll Batch Line";
        PostedPayrollBatchHeader: Record "12E Posted Payroll Header";
        PostedPayrollBatchLine: Record "12E Posted Payroll Line";
    begin
        PostedPayrollBatchHeader.Init();
        PostedPayrollBatchHeader.TransferFields(PayrollBatchHeader);
        PostedPayrollBatchHeader.Insert(true);

        PayrollBatchLine.Reset();
        PayrollBatchLine.SetRange("Document No.", PayrollBatchHeader."No.");

        if PayrollBatchLine.FindSet() then
            repeat
                PostedPayrollBatchLine.Init();
                PostedPayrollBatchLine.TransferFields(PayrollBatchLine, true);
                PostedPayrollBatchLine.Insert(true);
            until PayrollBatchLine.Next() = 0;

        PayrollBatchHeader.Delete(true);

        if Confirm('Payroll document %1 posted successfully. Do you want to open the posted document?', true, PostedPayrollBatchHeader."No.") then
            Page.Run(Page::"12E Posted Payroll Document", PostedPayrollBatchHeader);
    end;

    local procedure GetGLRegisterNo(PayrollBatchHeader: Record "12E Payroll Batch Header"): Integer
    var
        GLEntry: Record "G/L Entry";
        GLRegister: Record "G/L Register";
        FromEntryNo: Integer;
        ToEntryNo: Integer;
    begin
        GLEntry.Reset();
        GLEntry.SetRange("Document No.", PayrollBatchHeader."No.");
        GLEntry.SetRange("Posting Date", PayrollBatchHeader."Pay Date");
        GLEntry.SetRange("Journal Templ. Name", TwelveSetup."Payroll Jnl. Template");
        GLEntry.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");

        if not GLEntry.FindFirst() then
            exit(0);

        FromEntryNo := GLEntry."Entry No.";

        if GLEntry.FindLast() then
            ToEntryNo := GLEntry."Entry No.";

        GLRegister.Reset();
        GLRegister.SetRange("Journal Templ. Name", TwelveSetup."Payroll Jnl. Template");
        GLRegister.SetRange("Journal Batch Name", TwelveSetup."Payroll Jnl. Batch");
        GLRegister.SetFilter("From Entry No.", '<=%1', FromEntryNo);
        GLRegister.SetFilter("To Entry No.", '>=%1', ToEntryNo);

        if GLRegister.FindFirst() then
            exit(GLRegister."No.");

        exit(0);
    end;

    local procedure UpdatePayrollBatchAsPassed(var PayrollBatchHeader: Record "12E Payroll Batch Header")
    var
        PayrollBatch: Record "12E Questco Payroll Batch";
    begin
        PayrollBatch.SetRange("Payroll Doc. No.", PayrollBatchHeader."No.");
        PayrollBatch.ModifyAll("ERP Status", 'PASSED');
        PayrollBatch.ModifyAll("ERP Error Message", '');
    end;
}