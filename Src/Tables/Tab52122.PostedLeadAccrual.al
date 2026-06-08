table 52122 "12E Posted Lead Accrual"
{
    Caption = ' Posted Lead Accrual';
    LookupPageId = "12E Posted Lead Accruals";
    DrillDownPageId = "12E Posted Lead Accruals";
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = CustomerContent;
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = CustomerContent;
        }
        // field(7; Status; Enum "12E EPIC Pay Batch Status")
        // {
        //     Caption = 'Status';
        //     DataClassification = CustomerContent;
        // }
        // field(9; "No. Series"; Code[20])
        // {
        //     Caption = 'No. Series';
        //     DataClassification = CustomerContent;
        // }
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
