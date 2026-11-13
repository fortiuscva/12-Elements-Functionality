table 52144 "12E Global Setup"
{
    Caption = 'Global Setup';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Manual Banking Entry PK ID's"; Code[20])
        {
            Caption = 'Manual Banking Entry PK ID''s';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}