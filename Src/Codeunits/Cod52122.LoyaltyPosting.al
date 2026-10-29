
codeunit 52122 "12E Loyalty Posting"
{
    var
        TwelveSetup: Record "12E Setup";
        NoJournalLinesToPostErr: Label 'There are no General Journal Lines to post.';
        NoJournalLinesToPreviewErr: Label 'There are no General Journal Lines to preview.';

    procedure Post(var LoyaltyPoints: Record "12E Loyalty Points")
    var
        PostingError: Text;
    begin
        if LoyaltyPoints.Processed then
            Error('Loyalty Point entry %1 is already processed.', LoyaltyPoints."PK ID");

        if (LoyaltyPoints."Points Earned" = 0) and
           (LoyaltyPoints."Points Expired" = 0)
        then begin
            LoyaltyPoints.Processed := true;
            LoyaltyPoints."Posting Error" := '';
            LoyaltyPoints.ERPErrorMsg := '';
            LoyaltyPoints.Modify(true);
            exit;
        end;

        GetSetup();

        Clear(LoyaltyPoints."Posting Error");
        Clear(LoyaltyPoints.ERPErrorMsg);
        LoyaltyPoints.Modify(true);

        DeleteJournalLines();

        if not TryPostJournal(LoyaltyPoints) then begin
            PostingError := GetLastErrorText();

            // LoyaltyPoints.Get(LoyaltyPoints."PK ID");
            // LoyaltyPoints."Posting Error" :=
            //     CopyStr(PostingError, 1, MaxStrLen(LoyaltyPoints."Posting Error"));
            // LoyaltyPoints.ERPErrorMsg :=
            //     CopyStr(PostingError, 1, MaxStrLen(LoyaltyPoints.ERPErrorMsg));
            // LoyaltyPoints.Modify(true);

            DeleteJournalLines();
            exit;
        end;

        DeleteJournalLines();

        LoyaltyPoints.Get(LoyaltyPoints."PK ID");
        LoyaltyPoints.Processed := true;
        LoyaltyPoints."Posting Error" := '';
        LoyaltyPoints.ERPErrorMsg := '';
        LoyaltyPoints.Modify(true);
    end;

    procedure PreviewPosting(var LoyaltyPoints: Record "12E Loyalty Points")
    begin
        if LoyaltyPoints.Processed then
            Error('Loyalty Point entry %1 is already processed.', LoyaltyPoints."PK ID");

        GetSetup();

        if (LoyaltyPoints."Points Earned" = 0) and
           (LoyaltyPoints."Points Expired" = 0)
        then
            exit;

        DeleteJournalLines();
        CreateJournalLines(LoyaltyPoints);
        Commit();
        PreviewGenJournalLines();
        DeleteJournalLines();
    end;

    procedure PreviewBatchPosting(var LoyaltyPoints: Record "12E Loyalty Points")
    var
        LoyaltyPoint: Record "12E Loyalty Points";
    begin
        GetSetup();

        LoyaltyPoint.CopyFilters(LoyaltyPoints);
        LoyaltyPoint.SetRange(Processed, false);

        if not LoyaltyPoint.FindSet() then
            Error('No unprocessed Loyalty Point entries were found.');

        DeleteJournalLines();

        repeat
            if (LoyaltyPoint."Points Earned" <> 0) or
               (LoyaltyPoint."Points Expired" <> 0)
            then
                CreateJournalLines(LoyaltyPoint);
        until LoyaltyPoint.Next() = 0;

        Commit();

        PreviewGenJournalLines();

        DeleteJournalLines();
    end;

    local procedure GetSetup()
    begin
        TwelveSetup.Get();

        if not TwelveSetup."Enable Loyalty Process" then
            Error('Loyalty Process is not enabled in 12 Elements Setup.');

        TwelveSetup.TestField("Loyalty Jnl. Template");
        TwelveSetup.TestField("Loyalty Jnl. Batch");
        TwelveSetup.TestField("Loyalty Points Earned");
        TwelveSetup.TestField("Deferred Rev Loyalty Pts");
        TwelveSetup.TestField("Loyalty Point Value");
        TwelveSetup.TestField("Loyalty Points Provision");
        TwelveSetup.TestField("Loyalty Points Reserve");
        TwelveSetup.TestField("Loyalty Source Code");
        TwelveSetup.TestField("Loyalty Reason Code");
        TwelveSetup.TestField("Loyalty Document Nos.");
        TwelveSetup.TestField("State Dimension");
        TwelveSetup.TestField("Store Dimension");

        ValidateConfiguredDimension(
            TwelveSetup."State Dimension");

        ValidateConfiguredDimension(
            TwelveSetup."Store Dimension");

        if TwelveSetup."State Dimension" =
           TwelveSetup."Store Dimension"
        then
            Error(
                'State Dimension and Store Dimension must be different.');
    end;

    local procedure ValidateConfiguredDimension(DimensionCode: Code[20])
    var
        Dimension: Record Dimension;
    begin
        if not Dimension.Get(DimensionCode) then
            Error(
                'Dimension %1 does not exist.',
                DimensionCode);

        Dimension.TestField(Blocked, false);
    end;

    local procedure CreateJournalLines(var LoyaltyPoints: Record "12E Loyalty Points")
    var
        NoSeries: Codeunit "No. Series";
        ProvisionAmount: Decimal;
        PointsEarnedValue: Decimal;
        PointsExpiredValue: Decimal;
    begin
        if LoyaltyPoints."Document No." = '' then begin
            LoyaltyPoints."Document No." :=
                NoSeries.GetNextNo(
                    TwelveSetup."Loyalty Document Nos.",
                    WorkDate(),
                    true);
            LoyaltyPoints.Modify(true);
        end;

        if LoyaltyPoints."Points Earned" <> 0 then begin
            PointsEarnedValue :=
                LoyaltyPoints."Points Earned" *
                TwelveSetup."Loyalty Point Value";

            CreateGenJournalLine(
                LoyaltyPoints."Month End Date",
                LoyaltyPoints."Document No.",
                PointsEarnedValue,
                TwelveSetup."Loyalty Points Earned",
                TwelveSetup."Deferred Rev Loyalty Pts",
                LoyaltyPoints.State,
                LoyaltyPoints."Store Name");

            ProvisionAmount :=
                Round(
                    PointsEarnedValue *
                    TwelveSetup."Loyalty Pts. Provision %" / 100,
                    0.01);

            if ProvisionAmount <> 0 then
                CreateGenJournalLine(
                    LoyaltyPoints."Month End Date",
                    LoyaltyPoints."Document No.",
                    ProvisionAmount,
                    TwelveSetup."Loyalty Points Provision",
                    TwelveSetup."Loyalty Points Reserve",
                    LoyaltyPoints.State,
                    LoyaltyPoints."Store Name",
                    StrSubstNo(
                        'Loyalty Points Provision %1%',
                        TwelveSetup."Loyalty Pts. Provision %"));
        end;

        if LoyaltyPoints."Points Expired" <> 0 then begin
            PointsExpiredValue :=
                LoyaltyPoints."Points Expired" *
                TwelveSetup."Loyalty Point Value";

            CreateGenJournalLine(
                LoyaltyPoints."Month End Date",
                LoyaltyPoints."Document No.",
                PointsExpiredValue,
                TwelveSetup."Deferred Rev Loyalty Pts",
                TwelveSetup."Loyalty Points Earned",
                LoyaltyPoints.State,
                LoyaltyPoints."Store Name");

            ProvisionAmount :=
                Round(
                    PointsExpiredValue *
                    TwelveSetup."Loyalty Pts. Provision %" / 100,
                    0.01);

            if ProvisionAmount <> 0 then
                CreateGenJournalLine(
                    LoyaltyPoints."Month End Date",
                    LoyaltyPoints."Document No.",
                    ProvisionAmount,
                    TwelveSetup."Loyalty Points Reserve",
                    TwelveSetup."Loyalty Points Provision",
                    LoyaltyPoints.State,
                    LoyaltyPoints."Store Name",
                    StrSubstNo(
                        'Loyalty Points Provision %1%',
                        TwelveSetup."Loyalty Pts. Provision %"));
        end;
    end;

    local procedure CreateGenJournalLine(
        PostingDate: Date;
        DocumentNo: Code[20];
        Amount: Decimal;
        AccountNo: Code[20];
        BalAccountNo: Code[20];
        StateCode: Code[20];
        StoreCode: Code[20];
        LineDescription: Text[100])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" :=
            TwelveSetup."Loyalty Jnl. Template";
        GenJournalLine."Journal Batch Name" :=
            TwelveSetup."Loyalty Jnl. Batch";
        GenJournalLine."Line No." := GetNextGenJnlLineNo();
        GenJournalLine.Insert(true);

        GenJournalLine.Validate("Posting Date", PostingDate);
        GenJournalLine.Validate("Document No.", DocumentNo);
        GenJournalLine.Validate(
            "Account Type",
            GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", AccountNo);
        GenJournalLine.Validate(
            "Bal. Account Type",
            GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", BalAccountNo);
        GenJournalLine.Validate(Amount, Amount);

        if LineDescription <> '' then
            GenJournalLine.Description :=
                CopyStr(
                    LineDescription,
                    1,
                    MaxStrLen(GenJournalLine.Description));

        SetJnlLineDimension(
            GenJournalLine,
            TwelveSetup."State Dimension",
            StateCode);

        SetJnlLineDimension(
            GenJournalLine,
            TwelveSetup."Store Dimension",
            StoreCode);

        GenJournalLine.Validate(
            "Source Code",
            TwelveSetup."Loyalty Source Code");
        GenJournalLine.Validate(
            "Reason Code",
            TwelveSetup."Loyalty Reason Code");
        GenJournalLine.Modify(true);
    end;

    local procedure CreateGenJournalLine(
        PostingDate: Date;
        DocumentNo: Code[20];
        Amount: Decimal;
        AccountNo: Code[20];
        BalAccountNo: Code[20];
        StateCode: Code[20];
        StoreCode: Code[20])
    begin
        CreateGenJournalLine(
            PostingDate,
            DocumentNo,
            Amount,
            AccountNo,
            BalAccountNo,
            StateCode,
            StoreCode,
            '');
    end;

    [TryFunction]
    local procedure TryPostJournal(LoyaltyPoints: Record "12E Loyalty Points")
    begin
        CreateJournalLines(LoyaltyPoints);
        PostJournal();
    end;

    local procedure PostJournal()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange(
            "Journal Template Name",
            TwelveSetup."Loyalty Jnl. Template");
        GenJournalLine.SetRange(
            "Journal Batch Name",
            TwelveSetup."Loyalty Jnl. Batch");

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
        GenJournalLine.SetRange(
            "Journal Template Name",
            TwelveSetup."Loyalty Jnl. Template");
        GenJournalLine.SetRange(
            "Journal Batch Name",
            TwelveSetup."Loyalty Jnl. Batch");

        if not GenJournalLine.FindFirst() then
            Error(NoJournalLinesToPreviewErr);

        GenJnlPost.Preview(GenJournalLine);
    end;

    local procedure DeleteJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange(
            "Journal Template Name",
            TwelveSetup."Loyalty Jnl. Template");
        GenJournalLine.SetRange(
            "Journal Batch Name",
            TwelveSetup."Loyalty Jnl. Batch");

        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);
    end;

    local procedure GetNextGenJnlLineNo(): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(
            "Journal Template Name",
            TwelveSetup."Loyalty Jnl. Template");
        GenJournalLine.SetRange(
            "Journal Batch Name",
            TwelveSetup."Loyalty Jnl. Batch");

        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000);

        exit(10000);
    end;

    procedure SetJnlLineDimension(
        var GenJnlLine: Record "Gen. Journal Line";
        DimCode: Code[20];
        DimValueCode: Code[20])
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimensionValue: Record "Dimension Value";
    begin
        if DimCode = '' then
            Error('Dimension Code must be configured in 12 Elements Setup.');

        if DimValueCode <> '' then begin
            if not DimensionValue.Get(DimCode, DimValueCode) then
                Error(
                    'Dimension value %1 does not exist for dimension %2.',
                    DimValueCode,
                    DimCode);

            DimensionValue.TestField(Blocked, false);

            if DimensionValue."Dimension Value Type" <>
               DimensionValue."Dimension Value Type"::Standard
            then
                Error(
                    'Dimension value %1 for dimension %2 must be a Standard dimension value.',
                    DimValueCode,
                    DimCode);
        end;

        DimMgt.GetDimensionSet(
            TempDimSetEntry,
            GenJnlLine."Dimension Set ID");

        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        TempDimSetEntry.DeleteAll();
        TempDimSetEntry.Reset();

        if DimValueCode <> '' then begin
            TempDimSetEntry.Init();
            TempDimSetEntry.Validate("Dimension Code", DimCode);
            TempDimSetEntry.Validate(
                "Dimension Value Code",
                DimValueCode);
            TempDimSetEntry.Insert();
        end;

        GenJnlLine."Dimension Set ID" :=
            DimMgt.GetDimensionSetID(TempDimSetEntry);

        DimMgt.UpdateGlobalDimFromDimSetID(
            GenJnlLine."Dimension Set ID",
            GenJnlLine."Shortcut Dimension 1 Code",
            GenJnlLine."Shortcut Dimension 2 Code");
    end;
}
