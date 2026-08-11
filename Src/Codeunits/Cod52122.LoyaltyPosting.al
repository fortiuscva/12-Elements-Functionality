codeunit 52122 "12E Loyalty Posting"
{
    var
        TwelveSetup: Record "12E Setup";

        NoEntriesToPostErr: Label 'There are no Loyalty Point entries to post.';
        NoEntriesToPreviewErr: Label 'There are no Loyalty Point entries to preview.';
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';
        LoyaltyPostedMsg: Label 'Loyalty Points posted successfully.';

    procedure Post()
    begin
        GetSetup();
        DeleteJournalLines();
        CreateJournalLines();
        PostJournal();
        UpdatePostedRecords();
        DeleteJournalLines();

        Message(LoyaltyPostedMsg);
    end;

    procedure PreviewPosting()
    begin
        GetSetup();
        DeleteJournalLines();
        CreateJournalLines();
        Commit();
        PreviewJournal();

        DeleteJournalLines();
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();

        TwelveSetup.TestField("Payroll Jnl. Template");
        TwelveSetup.TestField("Payroll Jnl. Batch");

        TwelveSetup.TestField("Loyalty Points Earned");
        TwelveSetup.TestField("Deferred Rev Loyalty Pts");
        TwelveSetup.TestField("Provision for Loyalty Points");
        TwelveSetup.TestField("Loyalty Points Reserve");
        TwelveSetup.TestField("Loyalty Source Code");
        TwelveSetup.TestField("Loyalty Reason Code");
        TwelveSetup.TestField("Loyalty Document Nos.");
    end;

    local procedure CreateJournalLines()
    var
        LoyaltyPoints: Record "12E Loyalty Points";
        NoSeries: Codeunit "No. Series";
        ProvisionAmount: Decimal;
    begin
        LoyaltyPoints.Reset();
        LoyaltyPoints.SetRange(Processed, false);

        if not LoyaltyPoints.FindSet() then
            Error(NoEntriesToPostErr);

        repeat
            if LoyaltyPoints."Document No." = '' then begin
                LoyaltyPoints."Document No." :=
                    NoSeries.GetNextNo(TwelveSetup."Loyalty Document Nos.", WorkDate(), true);
                LoyaltyPoints.Modify(true);
            end;

            if LoyaltyPoints."Points Earned" <> 0 then begin

                CreateGenJournalLine(
                    LoyaltyPoints."Month End Date",
                    LoyaltyPoints."Document No.",
                    LoyaltyPoints."Points Earned",
                    TwelveSetup."Loyalty Points Earned",
                    TwelveSetup."Deferred Rev Loyalty Pts");

                ProvisionAmount :=
                    Round(
                        LoyaltyPoints."Points Earned" *
                        TwelveSetup."Loyalty Pts. Provision %" / 100,
                        0.01);

                if ProvisionAmount <> 0 then
                    CreateGenJournalLine(
                        LoyaltyPoints."Month End Date",
                        LoyaltyPoints."Document No.",
                        ProvisionAmount,
                        TwelveSetup."Provision for Loyalty Points",
                        TwelveSetup."Loyalty Points Reserve");
            end;

            if LoyaltyPoints."Points Expired" <> 0 then begin

                CreateGenJournalLine(
                    LoyaltyPoints."Month End Date",
                    LoyaltyPoints."Document No.",
                    LoyaltyPoints."Points Expired",
                    TwelveSetup."Deferred Rev Loyalty Pts",
                    TwelveSetup."Loyalty Points Earned");

                ProvisionAmount :=
                    Round(
                        LoyaltyPoints."Points Expired" *
                        TwelveSetup."Loyalty Pts. Provision %" / 100,
                        0.01);

                if ProvisionAmount <> 0 then
                    CreateGenJournalLine(
                        LoyaltyPoints."Month End Date",
                        LoyaltyPoints."Document No.",
                        ProvisionAmount,
                        TwelveSetup."Loyalty Points Reserve",
                        TwelveSetup."Provision for Loyalty Points");
            end;

        until LoyaltyPoints.Next() = 0;
    end;


    local procedure CreateGenJournalLine(
        PostingDate: Date;
        DocumentNo: Code[20];
        Amount: Decimal;
        AccountNo: Code[20];
        BalAccountNo: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := TwelveSetup."Payroll Jnl. Template";
        GenJournalLine."Journal Batch Name" := TwelveSetup."Payroll Jnl. Batch";
        GenJournalLine."Line No." := GetNextJournalLineNo();
        GenJournalLine.Insert(true);

        GenJournalLine.Validate("Posting Date", PostingDate);
        GenJournalLine.Validate("Document No.", DocumentNo);

        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", AccountNo);
        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", BalAccountNo);
        GenJournalLine.Validate(Amount, Amount);
        GenJournalLine.Validate("Source Code", TwelveSetup."Loyalty Source Code");
        GenJournalLine.Validate("Reason Code", TwelveSetup."Loyalty Reason Code");

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

    local procedure PreviewJournal()
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

    local procedure UpdatePostedRecords()
    var
        LoyaltyPoints: Record "12E Loyalty Points";
        GLEntry: Record "G/L Entry";
        GLRegister: Record "G/L Register";
    begin
        LoyaltyPoints.Reset();
        LoyaltyPoints.SetFilter("Document No.", '<>%1', '');
        LoyaltyPoints.SetRange(Processed, false);

        if not LoyaltyPoints.FindFirst() then
            exit;

        GLEntry.Reset();
        GLEntry.SetRange("Document No.", LoyaltyPoints."Document No.");

        if not GLEntry.FindFirst() then
            Error('No G/L Entries were found for Document No. %1.', LoyaltyPoints."Document No.");

        GLRegister.Reset();
        GLRegister.SetFilter("From Entry No.", '<=%1', GLEntry."Entry No.");
        GLRegister.SetFilter("To Entry No.", '>=%1', GLEntry."Entry No.");

        if not GLRegister.FindFirst() then
            Error(
                'Unable to determine the G/L Register for Document No. %1.',
                LoyaltyPoints."Document No.");

        LoyaltyPoints.ModifyAll("G/L Register No.", Format(GLRegister."No."));

        LoyaltyPoints.ModifyAll(Processed, true);
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

    local procedure GetNextJournalLineNo(): Integer
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
