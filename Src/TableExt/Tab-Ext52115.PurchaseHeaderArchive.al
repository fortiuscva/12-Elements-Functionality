tableextension 52115 "12E Purchase Header Archive" extends "Purchase Header Archive"
{
    fields
    {
        field(52100; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = CustomerContent;
        }
        field(52101; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(52102; "Period Quantity"; Decimal)
        {
            Caption = 'Period Quantity';
            DataClassification = CustomerContent;
        }
    }
}
