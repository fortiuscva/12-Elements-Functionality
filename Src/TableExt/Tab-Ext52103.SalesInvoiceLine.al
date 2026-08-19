tableextension 52103 "12E Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(52100; "12E CCD No."; Code[20])
        {
            Caption = 'CCD No.';
            TableRelation = "12E Posted CCD Header"."No.";
            DataClassification = CustomerContent;
        }
        field(52101; "12E CCD Line No."; Integer)
        {
            Caption = 'CCD Line No.';
            TableRelation = "12E Posted CCD Line"."Line No." where("Document No." = field("12E CCD No."));
            DataClassification = CustomerContent;
        }
    }
}
