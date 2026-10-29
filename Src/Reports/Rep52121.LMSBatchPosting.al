report 52121 "12E LMS Batch Posting"
{
    ApplicationArea = All;
    Caption = 'LMS Batch Posting';
    ProcessingOnly = true;

    dataset
    {
        dataitem(LMSBatch; "12E LMS Batch")
        {
            RequestFilterFields = "Transaction Date";
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
        LoyaltyPreviewContext: Codeunit "12E Suppress Preview Post";
    begin
        LoyaltyPreviewContext.SetSuppressPreviewEntries(true);
        if not TryPreviewBatch() then begin
            PreviewError := GetLastErrorText();
            LoyaltyPreviewContext.SetSuppressPreviewEntries(false);

            if PreviewError <> '' then
                Error(PreviewError);

        end;
    end;

    trigger OnPostReport()
    begin
        if ProcessedCount > 0 then
            if GuiAllowed() then
                Message(LMSBatchPostedMsg, ProcessedCount);
    end;

    var
        ProcessedCount: Integer;
        PreviewError: Text;
        LMSBatchPostedMsg: Label '%1 LMS Batch record(s) posted successfully.';

    [TryFunction]
    local procedure TryPreviewBatch()
    var
        LMSBatchPosting: Codeunit "12E LMS Batch Posting";
    begin
        LMSBatchPosting.PreviewBatchPosting(LMSBatch);
    end;

    [TryFunction]
    local procedure TryPostRecord()
    var
        LMSBatchPosting: Codeunit "12E LMS Batch Posting";
    begin
        LMSBatchPosting.Post(LMSBatch);

        LMSBatch.Get(LMSBatch."PK ID");

        if LMSBatch.Processed then
            ProcessedCount += 1;
    end;

    local procedure HandlePostingError()
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();

        LMSBatch.Get(LMSBatch."PK ID");
        LMSBatch."Posting Error" :=
            CopyStr(ErrorText, 1, MaxStrLen(LMSBatch."Posting Error"));
        LMSBatch.ERPErrorMsg :=
            CopyStr(ErrorText, 1, MaxStrLen(LMSBatch.ERPErrorMsg));
        LMSBatch.ERPStatus := 'FAILED';
        LMSBatch.Modify(true);
    end;
}