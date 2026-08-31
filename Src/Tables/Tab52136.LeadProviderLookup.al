table 52136 "12E Lead Provider Lookup"
{
    Caption = 'Lead Provider Lookup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lead Provider"; Text[100])
        {
            Caption = 'Lead Provider';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Lead Provider")
        {
            Clustered = true;
        }
    }
}
