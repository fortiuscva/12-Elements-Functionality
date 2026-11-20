tableextension 52112 "12E Purchase Line Archive" extends "Purchase Line Archive"
{
    fields
    {
        field(52100; "12E CCD No."; Code[20])
        {
            Caption = 'CCI No.';
            DataClassification = CustomerContent;
        }
        field(52101; "12E CCD Line No."; Integer)
        {
            Caption = 'CCI Line No.';
            DataClassification = CustomerContent;
        }
    }
}
