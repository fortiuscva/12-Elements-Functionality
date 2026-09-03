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
                if not TryPostTransaction(LMSPosting, LMSHeader) then begin
                    FailedCount += 1;
                    FailedDocuments += StrSubstNo('%1 - %2', LMSHeader."No.", GetLastErrorText());
                    exit;
                end;

                PostedCount += 1;
            end;
        }
    }

    var
        PostedCount: Integer;
        FailedCount: Integer;
        FailedDocuments: Text;

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

        Message('%1 LMS Transaction document(s) posted successfully.\%2 LMS Transaction document(s) failed.\%3', PostedCount, FailedCount, FailedDocuments);
    end;
}