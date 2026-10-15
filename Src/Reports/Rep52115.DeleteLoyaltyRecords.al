report 52115 "12E Delete Loyalty Records"
{
    ApplicationArea = All;
    Caption = 'Delete Loyalty Records';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(LoyaltyPoints; "12E Loyalty Points")
        {
            RequestFilterFields = "PK ID", "Month End Date";
            trigger OnAfterGetRecord()
            begin
                LoyaltyPoints.Delete(true);
            end;
        }
    }
}
