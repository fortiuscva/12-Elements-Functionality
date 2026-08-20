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
            RequestFilterFields = "PK ID", Portfolio, "Month End Date", Processed, "Document No.";

            trigger OnAfterGetRecord()
            var
                LoyaltyPosting: Codeunit "12E Loyalty Posting";
                PostingError: Text;
            begin
                Clear(PostingError);

                if not TryPostLoyaltyPoint(LoyaltyPoints, PostingError) then begin
                    LoyaltyPoints."Posting Error" :=
                        CopyStr(PostingError, 1, MaxStrLen(LoyaltyPoints."Posting Error"));

                    LoyaltyPoints.ERPErrorMsg :=
                        CopyStr(PostingError, 1, MaxStrLen(LoyaltyPoints.ERPErrorMsg));

                    LoyaltyPoints.Modify(true);
                end;
            end;
        }
    }

    local procedure TryPostLoyaltyPoint(var LoyaltyPoints: Record "12E Loyalty Points"; var PostingError: Text): Boolean
    var
        LoyaltyPosting: Codeunit "12E Loyalty Posting";
    begin
        if not TryPost(LoyaltyPosting, LoyaltyPoints) then begin
            PostingError := GetLastErrorText();
            exit(false);
        end;

        exit(true);
    end;

    [TryFunction]
    local procedure TryPost(var LoyaltyPosting: Codeunit "12E Loyalty Posting"; var LoyaltyPoints: Record "12E Loyalty Points")
    begin
        LoyaltyPosting.PostRecord(LoyaltyPoints);
    end;
}