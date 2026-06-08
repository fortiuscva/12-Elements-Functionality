table 52118 "12E Lead Source Reconciliation"
{
    Caption = 'Lead Source Reconciliation';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "PK ID"; BigInteger)
        {
            Caption = 'PK ID';
            DataClassification = CustomerContent;
        }

        field(2; "DW Load Date"; DateTime)
        {
            Caption = 'DW Load Date';
            DataClassification = CustomerContent;
        }

        field(3; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            DataClassification = CustomerContent;
        }
        field(4; "Portfolio Name"; text[100])
        {
            Caption = 'Portfolio Name';
            DataClassification = CustomerContent;
        }

        field(5; "Lead Original Date"; Date)
        {
            Caption = 'Lead Original Date';
            DataClassification = CustomerContent;
        }

        field(6; "Lead Provider"; Text[100])
        {
            Caption = 'Lead Provider';
            DataClassification = CustomerContent;
        }

        field(7; "Purchased Leads"; Code[20])
        {
            Caption = 'Purchased Leads';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }

        field(8; "Lead Sold Cost"; Decimal)
        {
            Caption = 'Lead Sold Cost';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "PK ID")
        {
            Clustered = true;
        }

    }
}