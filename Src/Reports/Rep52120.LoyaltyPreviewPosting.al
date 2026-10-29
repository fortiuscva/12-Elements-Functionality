report 52120 "12E Loyalty Preview Posting"
{
    ApplicationArea = All;
    Caption = 'Loyalty Preview Posting';
    ProcessingOnly = true;

    dataset
    {
        dataitem(LoyaltyPoints; "12E Loyalty Points")
        {
            RequestFilterFields = "Month End Date";
            DataItemTableView = where(Processed = const(false));

            trigger OnPreDataItem()
            var
                LoyaltyPosting: Codeunit "12E Loyalty Posting";
            begin
                LoyaltyPosting.PreviewBatchPosting(LoyaltyPoints);
                CurrReport.Break();
            end;
        }
    }
}
