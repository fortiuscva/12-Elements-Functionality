table 52114 "12E CCD Location Mapping"
{
    Caption = 'Call Center Location Mapping';
    LookupPageId = "12E CCD Loc. Mapping Details";
    DrillDownPageId = "12E CCD Loc. Mapping Details";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(7; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
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
        fieldgroup(DropDown; "Location Code", Blocked, "Vendor No.")
        {

        }
    }
}
