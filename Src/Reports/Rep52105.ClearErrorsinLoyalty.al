report 52105 "12E Clear Errors in Loyalty"
{
    Caption = 'Clear Errors in Loyalty';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(LoyaltyPoints; "12E Loyalty Points")
        {
            DataItemTableView = where(Processed = const(false), Reversed = const(false));
            trigger OnAfterGetRecord()
            begin
                LoyaltyPoints.ERPErrorMsg := '';
                LoyaltyPoints."Posting Error" := '';
                LoyaltyPoints.Modify(true);
            end;
        }
    }
}
