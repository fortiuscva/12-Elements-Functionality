table 52102 "12E EPIC Payment Type"
{
    Caption = 'EPIC Payment Type';
    DataClassification = CustomerContent;
    DataCaptionFields = "Data Source ID", "Payment Type Code";
    LookupPageId = "12E EPIC Payment Types";
    DrillDownPageId = "12E EPIC Payment Types";
    DataPerCompany = false;

    fields
    {
        field(1; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            TableRelation = "12E EPIC DataSourceID Map";
            DataClassification = CustomerContent;
        }
        field(5; "Payment Type Code"; Code[20])
        {
            Caption = 'Payment Type Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(15; Blocked; Boolean)
        {
            Caption = 'Blocked ';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Data Source ID", "Payment Type Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Data Source ID", "Payment Type Code")
        {
        }
    }
}
