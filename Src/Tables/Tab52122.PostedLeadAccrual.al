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

        field(2; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = CustomerContent;
        }

        field(3; "To Date"; Date)
        {
            Caption = 'To Date';
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
