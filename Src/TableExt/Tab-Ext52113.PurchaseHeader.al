tableextension 52113 "12E Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(52100; "12E Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = CustomerContent;
        }
        field(52101; "12E Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(52102; "12E Period Quantity"; Decimal)
        {
            Caption = 'Period Quantity';
            DataClassification = CustomerContent;
        }
    }
}
