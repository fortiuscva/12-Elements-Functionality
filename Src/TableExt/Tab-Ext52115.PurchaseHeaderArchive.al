tableextension 52115 "12E Purchase Header Archive" extends "Purchase Header Archive"
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
        field(52110; "12E Lead Period Start Date"; Date)
        {
            Caption = 'Lead Period Start Date';
            DataClassification = CustomerContent;
        }

        field(52111; "12E Lead Period End Date"; Date)
        {
            Caption = 'Lead Period End Date';
            DataClassification = CustomerContent;
        }
    }
}
