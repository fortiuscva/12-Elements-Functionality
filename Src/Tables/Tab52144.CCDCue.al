table 52144 "12E CCD Cue"
{
    Caption = 'CCD Cue';
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
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
