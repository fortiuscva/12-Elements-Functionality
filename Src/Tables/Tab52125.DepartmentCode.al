table 52125 "12E Department Code"
{
    Caption = 'Department Code';
    LookupPageId = "12E Department Codes";
    DrillDownPageId = "12E Department Codes";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Contact Center"; Boolean)
        {
            Caption = 'Contact Center';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description, "Contact Center")
        {

        }
    }
}
