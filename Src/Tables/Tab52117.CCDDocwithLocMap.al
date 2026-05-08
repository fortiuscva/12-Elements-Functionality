table 52117 "12E CCD Doc with Loc Map"
{
    Caption = 'Call Center Distribution Document with Location Mapping';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "12E CC Distribution Header";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Document No.", "Location Code")
        {

        }
    }
}
