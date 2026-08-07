table 52119 "12E Lead Validation Details"
{
    Caption = 'Lead Validation Details';
    DataClassification = CustomerContent;
    LookupPageId = "12E Lead Validation Details";
    DrillDownPageId = "12E Lead Validation Details";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            // AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(2; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            DataClassification = CustomerContent;
        }

        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }

        field(4; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }

        field(5; "Lead Provider"; Text[100])
        {
            Caption = 'Lead Provider';
            DataClassification = CustomerContent;
        }

        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }

        field(7; "Posted Purchase Invoice No."; Code[20])
        {
            Caption = 'Posted Purchase Invoice No.';
            TableRelation = "Purch. Inv. Header";
            DataClassification = CustomerContent;
        }

        field(8; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }

        field(9; "Prior Posting Date"; Date)
        {
            Caption = 'Prior Posting Date';
            DataClassification = CustomerContent;
        }

        field(10; "Lead Cost Amount"; Decimal)
        {
            Caption = 'Lead Cost Amount';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }

        field(11; Difference; Decimal)
        {
            Caption = 'Difference';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }

        field(12; "Difference %"; Decimal)
        {
            Caption = 'Difference %';
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(VendorPostingDate; "Vendor No.", "Posting Date")
        {
        }
    }
}