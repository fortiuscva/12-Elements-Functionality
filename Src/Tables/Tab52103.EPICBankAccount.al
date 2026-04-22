table 52103 "12E EPIC Bank Account"
{
    Caption = '12E EPIC Bank Account';
    DataClassification = CustomerContent;
    LookupPageId = "12E EPIC Bank Accounts";
    DrillDownPageId = "12E EPIC Bank Accounts";
    DataPerCompany = false;

    fields
    {
        field(1; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            TableRelation = "12E EPIC DataSourceID Map";
            DataClassification = CustomerContent;
        }
        field(5; Endpoint; Code[20])
        {
            Caption = 'Endpoint';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Data Source ID", Endpoint)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Data Source ID", Endpoint)
        {
        }
    }
}
