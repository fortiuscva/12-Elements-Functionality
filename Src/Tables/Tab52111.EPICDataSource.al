table 52111 "12E EPIC DataSource"
{
    Caption = '12E EPIC DataSource';
    LookupPageId = "12E EPIC DataSources";
    DrillDownPageId = "12E EPIC DataSources";
    DataCaptionFields = "DataSource ID", DBA;
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "DataSource ID"; Integer)
        {
            Caption = 'EPIC DataSource ID';
        }
        field(5; DBA; Text[100])
        {
            Caption = 'DBA';
        }
        field(10; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "DataSource ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "DataSource ID", DBA)
        {

        }
    }
}
