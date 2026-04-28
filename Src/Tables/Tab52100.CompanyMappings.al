table 52100 "12E Company Mappings"
{
    Caption = 'Company Mappings';
    LookupPageId = "12E Company Mappings";
    DrillDownPageId = "12E Company Mappings";
    DataCaptionFields = "Company Code", "Company Name";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Company Code"; Code[20])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }
        field(5; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(10; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = Company;
            DataClassification = CustomerContent;
        }
        field(15; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            DataClassification = CustomerContent;
        }

        field(20; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "Company Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Company Code", "Company Name")
        {

        }
    }
}
