report 52104 "12E Loyalty Posting"
{
    ApplicationArea = All;
    Caption = 'Loyalty Posting';
    ProcessingOnly = true;

    dataset
    {
        dataitem(LoyaltyPoints; "12E Loyalty Points")
        {
            RequestFilterFields = "Month End Date";
            DataItemTableView = where(Processed = const(false));

            trigger OnAfterGetRecord()
            begin
                if not TryPostRecord() then
                    HandlePostingError();
            end;
        }
    }

    trigger OnPreReport()
    var
        LoyaltyPreviewContext: Codeunit "12E Loyalty Preview Context";
    begin
        LoyaltyPreviewContext.SetSuppressPreviewEntries(true);

        if not TryPreviewBatch() then begin
            PreviewError := GetLastErrorText();
            LoyaltyPreviewContext.SetSuppressPreviewEntries(false);

            if PreviewError <> '' then
                Error(PreviewError);

        end;

        LoyaltyPreviewContext.SetSuppressPreviewEntries(false);
    end;

    trigger OnPostReport()
    begin
        if ProcessedCount > 0 then
            if GuiAllowed() then
                Message('Loyalty Point(s) posted successfully.');
    end;

    var
        ProcessedCount: Integer;
        PreviewError: Text;

    [TryFunction]
    local procedure TryPreviewBatch()
    var
        LoyaltyPosting: Codeunit "12E Loyalty Posting";
    begin
        LoyaltyPosting.PreviewBatchPosting(LoyaltyPoints);
    end;

    [TryFunction]
    local procedure TryPostRecord()
    var
        LoyaltyPosting: Codeunit "12E Loyalty Posting";
    begin
        LoyaltyPosting.Post(LoyaltyPoints);

        LoyaltyPoints.Get(LoyaltyPoints."PK ID");

        if LoyaltyPoints.Processed then
            ProcessedCount += 1;
    end;

    local procedure HandlePostingError()
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();

        LoyaltyPoints.Get(LoyaltyPoints."PK ID");
        LoyaltyPoints."Posting Error" :=
            CopyStr(ErrorText, 1, MaxStrLen(LoyaltyPoints."Posting Error"));
        LoyaltyPoints.ERPErrorMsg :=
            CopyStr(ErrorText, 1, MaxStrLen(LoyaltyPoints.ERPErrorMsg));
        LoyaltyPoints.Modify(true);
    end;
}