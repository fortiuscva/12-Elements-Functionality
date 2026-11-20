tableextension 52104 "12E Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
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
