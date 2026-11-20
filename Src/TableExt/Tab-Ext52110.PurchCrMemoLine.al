tableextension 52110 "12E Purch. Cr.Memo Line" extends "Purch. Cr. Memo Line"
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
