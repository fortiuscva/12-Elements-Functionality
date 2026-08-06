table 52118 "12E Lead Source Reconciliation"
{
    Caption = 'Lead Source Reconciliation Details';
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

        field(4; "Portfolio Name"; Text[100])
        {
            Caption = 'Portfolio';
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

        field(7; "Purchased Leads"; Decimal)
        {
            Caption = 'Purchased Leads';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }

        field(8; "Lead Sold Cost"; Decimal)
        {
            Caption = 'Lead Sold Cost';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(9; "DW Export DateTime"; DateTime)
        {
            Caption = 'DW Export DateTime';
            DataClassification = CustomerContent;
        }

        field(10; "ERP Import DateTime"; DateTime)
        {
            Caption = 'ERP Import DateTime';
            DataClassification = CustomerContent;
        }

        field(11; "ERP Status"; Text[50])
        {
            Caption = 'ERP Status';
            DataClassification = CustomerContent;
        }

        field(12; "ERP Error Msg"; Text[200])
        {
            Caption = 'ERP Error Msg';
            DataClassification = CustomerContent;
        }
        field(13; "Batch ID"; Guid)
        {
            Caption = 'Batch ID';
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