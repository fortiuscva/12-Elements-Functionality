codeunit 52116 "12E Lead Accrual Post Mgmt"
{
    TableNo = "12E Lead Accrual";

    trigger OnRun()
    var
        TwelveSetup: Record "12E Setup";
        FirstLineNo: Integer;
        LastLineNo: Integer;
    begin
        GetSetup(TwelveSetup);

        DeleteExistingJournalLines(
            TwelveSetup."Lead Accrual Jnl. Template",
            TwelveSetup."Lead Accrual Jnl. Batch");

        CreateJournalLines(
            Rec,
            TwelveSetup,
            FirstLineNo,
            LastLineNo);

        PostGenJournalLines(
            TwelveSetup."Lead Accrual Jnl. Template",
            TwelveSetup."Lead Accrual Jnl. Batch");

        TransferToPostedLeadAccrual(Rec);
    end;

    procedure PreviewPost(var LeadAccHeader: Record "12E Lead Accrual")
    var
        TwelveSetup: Record "12E Setup";
        FirstLineNo: Integer;
        LastLineNo: Integer;
    begin
        GetSetup(TwelveSetup);

        CreateJournalLines(LeadAccHeader, TwelveSetup, FirstLineNo, LastLineNo);

        PreviewGenJournalLines(
            TwelveSetup."Lead Accrual Jnl. Template",
            TwelveSetup."Lead Accrual Jnl. Batch");

        DeleteJournalLines(
            TwelveSetup."Lead Accrual Jnl. Template",
            TwelveSetup."Lead Accrual Jnl. Batch",
            FirstLineNo,
            LastLineNo);
    end;

    local procedure GetSetup(var LeadAccSetup: Record "12E Setup")
    begin
        LeadAccSetup.Get();

        if LeadAccSetup."Lead Accrual Jnl. Template" = '' then
            Error(SetupTemplateMissingErr);

        if LeadAccSetup."Lead Accrual Jnl. Batch" = '' then
            Error(SetupBatchMissingErr);
    end;

    local procedure CreateJournalLines(var LeadAccHeader: Record "12E Lead Accrual"; LeadAccSetup: Record "12E Setup"; var FirstLineNo: Integer; var LastLineNo: Integer)
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
            NextLineNo :=
                GetNextGenJnlLineNo(
                    LeadAccSetup."Lead Accrual Jnl. Template",
                    LeadAccSetup."Lead Accrual Jnl. Batch");

            FirstLineNo := NextLineNo;

            repeat
                MonthEndDate :=
                    CalcDate('<CM>', LeadAccLine."To Date");

                NextMonthStartDate :=
                    CalcDate('<CM+1D>', LeadAccLine."To Date");

                DescriptionTxt :=
                    CopyStr(
                        StrSubstNo(
                            '%1-Accrual [%2...%3]',
                            LeadAccLine."Vendor No.",
                            LeadAccLine."From Date",
                            LeadAccLine."To Date"),
                        1,
                        MaxStrLen(DescriptionTxt));

                CreateGenJournalLine(
                    LeadAccSetup."Lead Accrual Jnl. Template",
                    LeadAccSetup."Lead Accrual Jnl. Batch",
                    NextLineNo,
                    MonthEndDate,
                    LeadAccHeader."No.",
                    DescriptionTxt,
                    GetVendorLeadCreditAccount(LeadAccLine."Vendor No."),
                    GetVendorLeadDebitAccount(LeadAccLine."Vendor No."),
                    LeadAccLine."Accrual Amount");

                LastLineNo := NextLineNo;
                NextLineNo += 10000;

                //Reversal

                DescriptionTxt :=
                    CopyStr(
                        StrSubstNo(
                            '%1-Accrual [%2-%3]-Reversal',
                            LeadAccLine."Vendor No.",
                            LeadAccLine."From Date",
                            LeadAccLine."To Date"),
                        1,
                        MaxStrLen(DescriptionTxt));

                CreateGenJournalLine(
                    LeadAccSetup."Lead Accrual Jnl. Template",
                    LeadAccSetup."Lead Accrual Jnl. Batch",
                    NextLineNo,
                    NextMonthStartDate,
                    LeadAccHeader."No.",
                    DescriptionTxt,
                    GetVendorLeadDebitAccount(LeadAccLine."Vendor No."),
                    GetVendorLeadCreditAccount(LeadAccLine."Vendor No."),
                    LeadAccLine."Accrual Amount");

                LastLineNo := NextLineNo;
                NextLineNo += 10000;
            until LeadAccLine.Next() = 0;
        end;
    end;

    local procedure PreviewGenJournalLines(TemplateName: Code[10]; BatchName: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        RecVar: Variant;
        CodeunitVar: Variant;
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateName);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);

        if GenJnlLine.FindFirst() then begin
            RecVar := GenJnlLine;
            CodeunitVar := GenJnlPostLine;
            GenJnlPostPreview.Preview(RecVar, CodeunitVar);
        end else
            Error(NoJournalLinesToPreviewErr);
    end;

    local procedure DeleteJournalLines(TemplateName: Code[10]; BatchName: Code[10]; FirstLineNo: Integer; LastLineNo: Integer)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if (FirstLineNo = 0) or (LastLineNo = 0) then
            exit;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateName);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        GenJnlLine.SetRange("Line No.", FirstLineNo, LastLineNo);

        if not GenJnlLine.IsEmpty() then
            GenJnlLine.DeleteAll(true);
    end;

    local procedure GetNextGenJnlLineNo(TemplateName: Code[10]; BatchName: Code[10]): Integer
    var
        GenJnlLineLcl: Record "Gen. Journal Line";
    begin
        GenJnlLineLcl.Reset();
        GenJnlLineLcl.SetRange("Journal Template Name", TemplateName);
        GenJnlLineLcl.SetRange("Journal Batch Name", BatchName);
        if GenJnlLineLcl.FindLast() then
            exit(GenJnlLineLcl."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure CreateGenJournalLine(TemplateName: Code[10]; BatchName: Code[10]; LineNo: Integer; PostingDate: Date; DocumentNo: Code[20]; DescriptionTxt: Text[100]; AccountNo: Code[20]; BalAccountNo: Code[20]; AmountDec: Decimal)
    var
        GenJnlLineLcl: Record "Gen. Journal Line";
    begin
        GenJnlLineLcl.Init();
        GenJnlLineLcl."Journal Template Name" := TemplateName;
        GenJnlLineLcl."Journal Batch Name" := BatchName;
        GenJnlLineLcl."Line No." := LineNo;
        GenJnlLineLcl.Insert(true);

        GenJnlLineLcl.Validate("Posting Date", PostingDate);
        GenJnlLineLcl.Validate("Document No.", DocumentNo);
        GenJnlLineLcl.Validate("Account Type", GenJnlLineLcl."Account Type"::"G/L Account");
        GenJnlLineLcl.Validate("Account No.", AccountNo);
        GenJnlLineLcl.Validate("Bal. Account Type", GenJnlLineLcl."Bal. Account Type"::"G/L Account");
        GenJnlLineLcl.Validate("Bal. Account No.", BalAccountNo);
        GenJnlLineLcl.Validate(Amount, AmountDec);
        GenJnlLineLcl.Description := DescriptionTxt;
        GenJnlLineLcl.Modify(true);
    end;

    local procedure GetVendorLeadCreditAccount(VendorNo: Code[20]): Code[20]
    var
        VendorLcl: Record Vendor;
    begin
        if VendorLcl.Get(VendorNo) then
            exit(VendorLcl."12E Lead Credit Account No.");
        exit('');
    end;

    local procedure GetVendorLeadDebitAccount(VendorNo: Code[20]): Code[20]
    var
        VendorLcl: Record Vendor;
    begin
        if VendorLcl.Get(VendorNo) then
            exit(VendorLcl."12E Lead Debit Account No.");
        exit('');
    end;

    local procedure PostGenJournalLines(TemplateName: Code[10]; BatchName: Code[10])
    var
        GenJnlLineLcl: Record "Gen. Journal Line";
        GenJnlPostBatchLcl: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJnlLineLcl.Reset();
        GenJnlLineLcl.SetRange("Journal Template Name", TemplateName);
        GenJnlLineLcl.SetRange("Journal Batch Name", BatchName);
        if GenJnlLineLcl.FindFirst() then
            GenJnlPostBatchLcl.Run(GenJnlLineLcl)
        else
            Error(NoJournalLinesToPostErr);
    end;

    local procedure TransferToPostedLeadAccrual(LeadAccHeader: Record "12E Lead Accrual")
    var
        LeadAccLineLcl: Record "12E Lead Accrual Line";
        PostedLeadAccHeaderLcl: Record "12E Posted Lead Accrual";
        PostedLeadAccLineLcl: Record "12E Posted Lead Accrual Line";
    begin
        PostedLeadAccHeaderLcl.Init();
        PostedLeadAccHeaderLcl.TransferFields(LeadAccHeader, true);
        PostedLeadAccHeaderLcl.Insert(true);

        LeadAccLineLcl.Reset();
        LeadAccLineLcl.SetRange("Lead Accrual No.", LeadAccHeader."No.");
        if LeadAccLineLcl.FindSet() then
            repeat
                PostedLeadAccLineLcl.Init();
                PostedLeadAccLineLcl.TransferFields(LeadAccLineLcl, true);
                PostedLeadAccLineLcl.Insert(true);
            until LeadAccLineLcl.Next() = 0;

        LeadAccLineLcl.Reset();
        LeadAccLineLcl.SetRange("Lead Accrual No.", LeadAccHeader."No.");
        if not LeadAccLineLcl.IsEmpty() then
            LeadAccLineLcl.DeleteAll(true);

        LeadAccHeader.Delete(true);
    end;

    local procedure DeleteExistingJournalLines(TemplateName: Code[10]; BatchName: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", TemplateName);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);

        if not GenJnlLine.IsEmpty() then
            GenJnlLine.DeleteAll(true);
    end;

    var
        SetupTemplateMissingErr: Label 'Lead Accrual Journal Template must be specified in the 12 Elements Setup.';
        SetupBatchMissingErr: Label 'Lead Accrual Journal Batch must be specified in the 12 Elements Setup.';
        NoJournalLinesToPreviewErr: Label 'There are no lead accrual lines to preview. Create lines before running preview.';
        NoJournalLinesToPostErr: Label 'There are no journal lines to post.';
}