table 52117 "12E CCD Allocation Details"
{
    Caption = 'CCD Allocation Details';
    LookupPageId = "12E CCD Allocation Details";
    DrillDownPageId = "12E CCD Allocation Details";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "CCD No."; Code[20])
        {
            Caption = 'CCD No.';
            TableRelation = "12E CCD Header";
            DataClassification = CustomerContent;
        }
        field(2; "CCD Location"; Code[10])
        {
            Caption = 'CCD Location';
            TableRelation = "12E CCD Location Mapping";
            DataClassification = CustomerContent;
        }
        field(3; "CCD Location Hours"; Decimal)
        {
            Caption = 'CCD Location Hours';
            DataClassification = CustomerContent;
        }
        field(4; "CCD Start Date"; Date)
        {
            Caption = 'CCD Start Date';
            DataClassification = CustomerContent;
        }
        field(5; "CCD End Date"; Date)
        {
            Caption = 'CCD End Date';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "CCD No.", "CCD Location")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "CCD No.", "CCD Location", "CCD Location Hours")
        {

        }
    }
}