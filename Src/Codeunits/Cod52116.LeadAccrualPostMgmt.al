codeunit 52116 "12E Lead Accrual Post Mgmt"
{
    TableNo = "12E Lead Accrual";

    var
        TwelveSetup: Record "12E Setup";
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';
        DocumentMustBeReleasedErr: Label 'Lead Accrual document %1 must be released before posting.';
        NoAccrualLinesErr: Label 'There are no Lead Accrual Lines to process for document %1.';
        VendorSetupErr: Label 'Lead Accrual Vendor setup is incomplete for Vendor %1.';
        AdjustAccrualAmountErr: Label 'Adjusted Accrual Amount must be specified for Vendor %1.';
        PostingErrorMsg: Label 'Lead Accrual document %1 could not be posted.';

    trigger OnRun()
    var
        FirstLineNo: Integer;
        LastLineNo: Integer;
        PostingError: Text;
    begin
        ValidateBeforePosting(Rec);
        GetSetup();
        Clear(Rec."Posting Error");
        DeleteExistingJournalLines();
        CreateJournalLines(Rec, FirstLineNo, LastLineNo);

        if not TryPostJournal() then begin
            PostingError := GetLastErrorText();
            Rec."Posting Error" := CopyStr(PostingError, 1, MaxStrLen(Rec."Posting Error"));
            Rec.Modify(true);
            DeleteJournalLines(FirstLineNo, LastLineNo);
            Error(PostingErrorMsg, Rec."No.");
        end;

        DeleteJournalLines(FirstLineNo, LastLineNo);
        Rec.Get(Rec."No.");
        TransferToPostedLeadAccrual(Rec);
    end;

    procedure PreviewPost(var LeadAccHeader: Record "12E Lead Accrual")
    var
        FirstLineNo: Integer;
        LastLineNo: Integer;
    begin
        ValidateBeforePreview(LeadAccHeader);
        GetSetup();
        DeleteExistingJournalLines();
        CreateJournalLines(LeadAccHeader, FirstLineNo, LastLineNo);
        Commit();
        PreviewGenJournalLines();
        DeleteJournalLines(FirstLineNo, LastLineNo);
    end;

    local procedure ValidateBeforePosting(var LeadAccHeader: Record "12E Lead Accrual")
    var
        LeadAccLine: Record "12E Lead Accrual Line";
        Vendor: Record Vendor;
    begin
        LeadAccHeader.TestField(Year);
        LeadAccHeader.TestField(Month);

        if LeadAccHeader.Status <> LeadAccHeader.Status::Released then
            Error(DocumentMustBeReleasedErr, LeadAccHeader."No.");

        LeadAccLine.Reset();
        LeadAccLine.SetRange("Lead Accrual No.", LeadAccHeader."No.");

        if not LeadAccLine.FindSet() then
            Error(NoAccrualLinesErr, LeadAccHeader."No.");

        repeat
            LeadAccLine.TestField("Vendor No.");
            LeadAccLine.TestField("Lead Provider");

            if LeadAccLine."Adjust Accrual Amount" = 0 then
                Error(AdjustAccrualAmountErr, LeadAccLine."Vendor No.");

            if not Vendor.Get(LeadAccLine."Vendor No.") then
                Error(VendorSetupErr, LeadAccLine."Vendor No.");

            if not Vendor."12E Lead Accrual Vendor" then
                Error(VendorSetupErr, Vendor."No.");

            if Vendor."12E Lead Acq. Vendor No." = '' then
                Error(VendorSetupErr, Vendor."No.");

            if Vendor."12E Lead Credit Account No." = '' then
                Error(VendorSetupErr, Vendor."No.");

            if Vendor."12E Lead Debit Account No." = '' then
                Error(VendorSetupErr, Vendor."No.");
        until LeadAccLine.Next() = 0;
    end;

    local procedure ValidateBeforePreview(var LeadAccHeader: Record "12E Lead Accrual")
    var
        LeadAccLine: Record "12E Lead Accrual Line";
        Vendor: Record Vendor;
    begin
        LeadAccHeader.TestField(Year);
        LeadAccHeader.TestField(Month);

        LeadAccLine.Reset();
        LeadAccLine.SetRange("Lead Accrual No.", LeadAccHeader."No.");

        if not LeadAccLine.FindSet() then
            Error(NoAccrualLinesErr, LeadAccHeader."No.");

        repeat
            LeadAccLine.TestField("Vendor No.");
            LeadAccLine.TestField("Lead Provider");

            if LeadAccLine."Adjust Accrual Amount" = 0 then
                Error(AdjustAccrualAmountErr, LeadAccLine."Vendor No.");

            if not Vendor.Get(LeadAccLine."Vendor No.") then
                Error(VendorSetupErr, LeadAccLine."Vendor No.");

            if not Vendor."12E Lead Accrual Vendor" then
                Error(VendorSetupErr, Vendor."No.");

            if Vendor."12E Lead Acq. Vendor No." = '' then
                Error(VendorSetupErr, Vendor."No.");

            if Vendor."12E Lead Credit Account No." = '' then
                Error(VendorSetupErr, Vendor."No.");

            if Vendor."12E Lead Debit Account No." = '' then
                Error(VendorSetupErr, Vendor."No.");
        until LeadAccLine.Next() = 0;
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();
        TwelveSetup.TestField("Lead Accrual Jnl. Template");
        TwelveSetup.TestField("Lead Accrual Jnl. Batch");
    end;

    local procedure CreateJournalLines(var LeadAccHeader: Record "12E Lead Accrual"; var FirstLineNo: Integer; var LastLineNo: Integer)
    var
        LeadAccLine: Record "12E Lead Accrual Line";
        NextLineNo: Integer;
        MonthEndDate: Date;
        NextMonthStartDate: Date;
        DescriptionTxt: Text[100];
    begin
        FirstLineNo := 0;
        LastLineNo := 0;

        LeadAccLine.Reset();
        LeadAccLine.SetRange("Lead Accrual No.", LeadAccHeader."No.");

        if LeadAccLine.FindSet() then begin
            NextLineNo := GetNextGenJnlLineNo();
            FirstLineNo := NextLineNo;

            repeat
                MonthEndDate := CalcDate('<CM>', LeadAccLine."To Date");
                NextMonthStartDate := CalcDate('<CM+1D>', LeadAccLine."To Date");

                DescriptionTxt := CopyStr(StrSubstNo('%1-Accrual [%2...%3]', LeadAccLine."Vendor No.", LeadAccLine."From Date", LeadAccLine."To Date"), 1, MaxStrLen(DescriptionTxt));

                CreateGenJournalLine(MonthEndDate, LeadAccHeader."No.", DescriptionTxt, GetVendorLeadCreditAccount(LeadAccLine."Vendor No."), GetVendorLeadDebitAccount(LeadAccLine."Vendor No."), LeadAccLine."Adjust Accrual Amount");

                LastLineNo := NextLineNo;
                NextLineNo += 10000;

                DescriptionTxt := CopyStr(StrSubstNo('%1-Accrual [%2-%3]-Reversal', LeadAccLine."Vendor No.", LeadAccLine."From Date", LeadAccLine."To Date"), 1, MaxStrLen(DescriptionTxt));

                CreateGenJournalLine(NextMonthStartDate, LeadAccHeader."No.", DescriptionTxt, GetVendorLeadDebitAccount(LeadAccLine."Vendor No."), GetVendorLeadCreditAccount(LeadAccLine."Vendor No."), LeadAccLine."Adjust Accrual Amount");

                LastLineNo := NextLineNo;
                NextLineNo += 10000;
            until LeadAccLine.Next() = 0;
        end;
    end;

    local procedure CreateGenJournalLine(PostingDate: Date; DocumentNo: Code[20]; DescriptionTxt: Text[100]; AccountNo: Code[20]; BalAccountNo: Code[20]; Amount: Decimal)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := TwelveSetup."Lead Accrual Jnl. Template";
        GenJournalLine."Journal Batch Name" := TwelveSetup."Lead Accrual Jnl. Batch";
        GenJournalLine."Line No." := GetNextGenJnlLineNo();
        GenJournalLine.Insert(true);
        GenJournalLine.Validate("Posting Date", PostingDate);
        GenJournalLine.Validate("Document No.", DocumentNo);
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", AccountNo);
        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", BalAccountNo);
        GenJournalLine.Validate(Amount, Amount);
        GenJournalLine.Description := DescriptionTxt;
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
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Lead Accrual Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Lead Accrual Jnl. Batch");

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
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Lead Accrual Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Lead Accrual Jnl. Batch");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPreviewErr);

        GenJnlPost.Preview(GenJournalLine);
    end;

    local procedure DeleteJournalLines(FirstLineNo: Integer; LastLineNo: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if (FirstLineNo = 0) or (LastLineNo = 0) then
            exit;

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Lead Accrual Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Lead Accrual Jnl. Batch");
        GenJournalLine.SetRange("Line No.", FirstLineNo, LastLineNo);

        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);
    end;

    local procedure DeleteExistingJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Lead Accrual Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Lead Accrual Jnl. Batch");

        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);
    end;

    local procedure GetNextGenJnlLineNo(): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", TwelveSetup."Lead Accrual Jnl. Template");
        GenJournalLine.SetRange("Journal Batch Name", TwelveSetup."Lead Accrual Jnl. Batch");

        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetVendorLeadCreditAccount(VendorNo: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorNo) then
            exit(Vendor."12E Lead Credit Account No.");

        exit('');
    end;

    local procedure GetVendorLeadDebitAccount(VendorNo: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorNo) then
            exit(Vendor."12E Lead Debit Account No.");

        exit('');
    end;

    local procedure TransferToPostedLeadAccrual(var LeadAccHeader: Record "12E Lead Accrual")
    var
        LeadAccLine: Record "12E Lead Accrual Line";
        PostedLeadAccHeader: Record "12E Posted Lead Accrual";
        PostedLeadAccLine: Record "12E Posted Lead Accrual Line";
    begin
        PostedLeadAccHeader.Init();
        PostedLeadAccHeader.TransferFields(LeadAccHeader, true);
        PostedLeadAccHeader.Insert(true);

        LeadAccLine.Reset();
        LeadAccLine.SetRange("Lead Accrual No.", LeadAccHeader."No.");

        if LeadAccLine.FindSet() then
            repeat
                PostedLeadAccLine.Init();
                PostedLeadAccLine.TransferFields(LeadAccLine, true);
                PostedLeadAccLine.Insert(true);
            until LeadAccLine.Next() = 0;

        LeadAccLine.Reset();
        LeadAccLine.SetRange("Lead Accrual No.", LeadAccHeader."No.");

        if not LeadAccLine.IsEmpty() then
            LeadAccLine.DeleteAll(true);

        LeadAccHeader.Delete(true);
    end;
}