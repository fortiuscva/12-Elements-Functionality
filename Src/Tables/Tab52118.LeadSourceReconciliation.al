table 52118 "12E Lead Source Reconciliation"
{
    Caption = 'Lead Source Reconciliation';
    DataClassification = CustomerContent;

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

        field(4; "Lead Original Date"; Date)
        {
            Caption = 'Lead Original Date';
            DataClassification = CustomerContent;
        }

        field(5; "Lead Provider"; Text[100])
        {
            Caption = 'Lead Provider';
            DataClassification = CustomerContent;
        }

        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }

        field(7; "Lead Sold Cost"; Decimal)
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

        key(VendorDate; "Vendor No.", "Lead Original Date")
        {
            SumIndexFields = "Lead Sold Cost";
        }
    }
}