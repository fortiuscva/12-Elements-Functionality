table 52147 "12E Intg. RoleCenter"
{
    Caption = '12E Integration Role Center';
    DataClassification = CustomerContent;

    fields
    {

        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; "CCD Documents"; Integer)
        {
            Caption = 'CCD Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E CCD Header");
        }

        field(3; "Posted CCD Documents"; Integer)
        {
            Caption = 'Posted CCD Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E Posted CCD Header");
        }
        field(4; "Payroll Documents"; Integer)
        {
            Caption = 'Payroll Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E Payroll Batch Header");
        }
        field(5; "Posted Payroll Documents"; Integer)
        {
            Caption = 'Posted Payroll Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E Posted Payroll Header");
        }
        field(6; "LMS Transaction Documents"; Integer)
        {
            Caption = 'LMS Transaction Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E LMS Transaction Header");
        }
        field(7; "Posted LMS Transc Documents"; Integer)
        {
            Caption = 'Posted LMS Transaction Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E Posted LMS Trans. Header");
        }
        field(8; "Loyalty Points"; Integer)
        {
            Caption = 'Loyalty Points';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E Loyalty Points" where("G/L Register No." = const(0)));
        }

        field(9; "Posted Loyalty Points"; Integer)
        {
            Caption = 'Posted Loyalty Points';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E Loyalty Points" where("G/L Register No." = filter(<> 0)));
        }
        field(10; "LMS Batches"; Integer)
        {
            Caption = 'LMS Batches (Not Posted)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E LMS Batch" where("G/L Register No." = const(0)));
        }

        field(11; "Posted LMS Batches"; Integer)
        {
            Caption = 'LMS Batches (Posted)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("12E LMS Batch" where("G/L Register No." = filter(<> 0)));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
