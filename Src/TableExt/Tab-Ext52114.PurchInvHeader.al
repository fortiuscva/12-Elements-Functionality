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
        field(52103; "12E CCD Exists"; Boolean)
        {
            Caption = 'CCD Exists';
            FieldClass = FlowField;
            CalcFormula = Exist("12E CCD Header" where("Invoice No." = field("No.")));
        }
        field(52104; "12E Posted CCD Exists"; Boolean)
        {
            Caption = 'Posted CCD Exists';
            FieldClass = FlowField;
            CalcFormula = Exist("12E Posted CCD Line" where("Invoice No." = field("No.")));
        }
    }
}
