tableextension 52114 "12E Purch. Inv. Header" extends "Purch. Inv. Header"
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
        field(52103; "12E CCD No."; Code[20])
        {
            Caption = 'CCD No.';
            FieldClass = FlowField;
            CalcFormula = lookup("12E CCD Header"."No." where("Invoice No." = field("No.")));
        }
        field(52104; "12E Posted CCD No."; Code[20])
        {
            Caption = 'Posted CCD No.';
            FieldClass = FlowField;
            CalcFormula = lookup("12E Posted CCD Header"."No." where("Invoice No." = field("No.")));
        }
    }
}
