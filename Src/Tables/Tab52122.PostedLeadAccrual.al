table 52122 "12E Posted Lead Accrual"
{
    Caption = ' Posted Lead Accrual';
    LookupPageId = "12E Posted Lead Accruals";
    DrillDownPageId = "12E Posted Lead Accruals";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }

        field(2; Year; Integer)
        {
            Caption = 'Year';

        }

        field(3; Month; Enum "12E Accrual Month")
        {
            Caption = 'Month';

        }

        field(4; "From Date"; Date)
        {
            Caption = 'From Date';
            Editable = false;
        }

        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
            Editable = false;
        }

        field(6; Status; Enum "12E EPIC Pay Batch Status")
        {
            Caption = 'Status';
            Editable = false;
        }

        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(8; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Register";
        }

        field(9; Reversed; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "From Date", "To Date")
        {
        }
    }
}
