table 52108 "12E Posted EPIC Pay Batch Line"
{
    Caption = '12E Posted EPIC Payments Batch Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Account Type"; enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(15; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            FieldClass = FlowField;
            CalcFormula = lookup("12E Pstd EPIC Pay Batch Header"."Batch Date" where("Batch No." = field("Batch No.")));
        }
        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
    }
    keys
    {
        key(PK; "Batch No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Batch No.", "Line No.")
        {

        }
    }
}
