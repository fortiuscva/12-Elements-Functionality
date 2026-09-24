table 52136 "12E Lead Vendor Lookup"
{
    Caption = 'Lead Vendor Lookup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lead Vendor"; Text[100])
        {
            Caption = 'Lead Vendor';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Lead Vendor")
        {
            Clustered = true;
        }
    }
}
