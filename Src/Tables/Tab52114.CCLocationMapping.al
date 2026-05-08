table 52114 "12E CC Location Mapping"
{
    Caption = 'Call Center Location Mapping';
    LookupPageId = "12E CC Location Mappings";
    DrillDownPageId = "12E CC Location Mappings";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(3; Mapping; Text[30])
        {
            Caption = 'Mapping';
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Location Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Location Code", Mapping)
        {

        }
    }
}
