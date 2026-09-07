report 52106 "12E Post LMS Transactions"
{
    Caption = 'Post LMS Transactions';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(LMSHeader; "12E LMS Transaction Header")
        {
            RequestFilterFields = "No.", "Transaction Date";

            trigger OnAfterGetRecord()
            var
                LMSPosting: Codeunit "12E LMS Transaction Posting";
            begin
                LMSPosting.SetSuppressSuccessMessage(true);

                if not TryPostTransaction(LMSPosting, LMSHeader) then begin
                    FailedCount += 1;
                    exit;
                end;

                if LMSPosting.IsPostingFailed() then
                    FailedCount += 1
                else
                    PostedCount += 1;
            end;
        }
    }

    var
        PostedCount: Integer;
        FailedCount: Integer;
        BatchPostingErrorMsg: Label 'One or more LMS transaction documents have issues with posting.';

    [TryFunction]
    local procedure TryPostTransaction(var LMSPosting: Codeunit "12E LMS Transaction Posting"; var LMSHeader: Record "12E LMS Transaction Header")
    begin
        LMSPosting.Post(LMSHeader);
    end;

    trigger OnPostReport()
    begin
        if GuiAllowed() then
            ShowResult();
    end;

    local procedure ShowResult()
    begin
        if FailedCount = 0 then begin
            Message('%1 LMS Transaction document(s) posted successfully.', PostedCount);
            exit;
        end;

        Message(BatchPostingErrorMsg);
    end;
}