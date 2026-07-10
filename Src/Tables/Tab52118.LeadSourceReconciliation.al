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

        field(7; "Purchased Leads"; Decimal)
        {
            Caption = 'Purchased Leads';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }

        field(8; "Lead Sold Cost"; Decimal)
        {
            Caption = 'Lead Sold Cost';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }

        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Vendor."No."
                where("12E Lead Acq. Vendor No." = field("Lead Provider")));
        }

        field(10; "DW Export DateTime"; DateTime)
        {
            Caption = 'DW Export DateTime';
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