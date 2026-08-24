report 52104 "12E Loyalty Posting"
{
    ApplicationArea = All;
    Caption = 'Loyalty Posting';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(LoyaltyPoints; "12E Loyalty Points")
        {
            RequestFilterFields = "PK ID";
            DataItemTableView = where(Processed = const(false));

            trigger OnAfterGetRecord()
            begin
                if not TryPostRecord() then
                    HandlePostingError();
            end;
        }
    }
    [TryFunction]
    local procedure TryPostRecord()
    var
        LoyaltyPosting: Codeunit "12E Loyalty Posting";
    begin
        LoyaltyPosting.Post(LoyaltyPoints);
    end;

    local procedure HandlePostingError()
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();
        LoyaltyPoints."Posting Error" := CopyStr(ErrorText, 1, MaxStrLen(LoyaltyPoints."Posting Error"));
        LoyaltyPoints.ERPErrorMsg := CopyStr(ErrorText, 1, MaxStrLen(LoyaltyPoints.ERPErrorMsg));
        LoyaltyPoints.Modify(true);
    end;
}