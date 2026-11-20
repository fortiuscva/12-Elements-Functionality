tableextension 52109 "12E Purch. Inv. Line" extends "Purch. Inv. Line"
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
