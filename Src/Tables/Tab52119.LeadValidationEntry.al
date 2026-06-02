table 52119 "12E Lead Validation Entry"
{
    Caption = 'Lead Validation Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }

        field(3; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }

        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(5; "Purchase Invoice No."; Code[20])
        {
            Caption = 'Purchase Invoice No.';
        }

        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }

        field(7; "Prior Posting Date"; Date)
        {
            Caption = 'Prior Posting Date';
        }

        field(8; "Lead Cost Amount"; Decimal)
        {
            Caption = 'Lead Cost Amount';
        }

        field(9; Difference; Decimal)
        {
            Caption = 'Difference';
        }

        field(10; "Difference %"; Decimal)
        {
            Caption = 'Difference %';
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