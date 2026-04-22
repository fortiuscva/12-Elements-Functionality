table 52100 "12E EPIC DataSourceID Map"
{
    Caption = 'EPIC DataSourceID Map';
    LookupPageId = "12E EPIC Data Source Map List";
    DrillDownPageId = "12E EPIC Data Source Map List";
    DataCaptionFields = "Data Source ID", "Company Code";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            TableRelation = "12E EPIC DataSourceID Map";
            DataClassification = CustomerContent;
        }
        field(5; "Company Code"; Text[50])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }
        field(10; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(15; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = Company;
            DataClassification = CustomerContent;
        }

        field(20; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "Data Source ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(EPICDataSource; "Data Source ID", "Company Code")
        {

        }
    }
}
