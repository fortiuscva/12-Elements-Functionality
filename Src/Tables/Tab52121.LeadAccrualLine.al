table 52121 "12E Lead Accrual Line"
{
    Caption = 'Lead Accrual Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lead Accrual No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "12E Lead Accrual";
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            Editable = false;
        }

        field(4; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }

        field(5; "Lead Provider"; Text[100])
        {
            Caption = 'Lead Provider';
            Editable = false;
        }

        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
            Editable = false;
        }

        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
            Editable = false;
        }

        field(8; "Last PPI Posting Date"; Date)
        {
            Caption = 'Last PPI Posting Date';
            Editable = false;
        }

        field(9; "Lead Acq. Cost Vendor"; Decimal)
        {
            Caption = 'Lead Acq. Cost Vendor';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }

        field(10; "Accrual Amount"; Decimal)
        {
            Caption = 'Accrual Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }

        field(11; "Adjust Accrual Amount"; Decimal)
        {
            Caption = 'Adjust Accrual Amount';
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(PK; "Lead Accrual No.", "Line No.")
        {
            Clustered = true;
        }

        key(Vendor; "Vendor No.")
        {
        }
    }
}
