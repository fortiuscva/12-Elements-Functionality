table 52112 "12E CC Distribution Data"
{
    Caption = 'Call Center Distribution Data';
    LookupPageId = "12E CC Distribution Data";
    DrillDownPageId = "12E CC Distribution Data";
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; "CC Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(5; "Location Code"; Code[10])
        {
            Caption = 'Location';
            TableRelation = "12E CC Location Mapping"."Location Code";
            DataClassification = CustomerContent;
        }
        field(7; Portfolio; Text[30])
        {
            Caption = 'Portfolio';
            TableRelation = "12E CC Portfolio Mapping".Portfolio;
            DataClassification = CustomerContent;
        }
        field(9; "Handling Time"; Integer)
        {
            Caption = 'Handle Time';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "CC Date", "Location Code", Portfolio, "Handling Time")
        {

        }
    }
}
