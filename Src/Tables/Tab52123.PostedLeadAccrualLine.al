table 52123 "12E Posted Lead Accrual Line"
{
    Caption = 'Posted Lead Accrual Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lead Accrual No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "12E Posted Lead Accrual";
            DataClassification = CustomerContent;
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
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

        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = CustomerContent;
        }

        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = CustomerContent;
        }

        field(8; "Last PPI Posting Date"; Date)
        {
            Caption = 'Last Posted Purchase Invoice Posting Date';
            DataClassification = CustomerContent;
        }

        field(9; "Lead Acq. Cost Vendor"; Decimal)
        {
            Caption = 'Total Invoiced Amount (Period)';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }

        field(10; "Accrual Amount"; Decimal)
        {
            Caption = 'Accrual Amount';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }

        field(11; "Adjust Accrual Amount"; Decimal)
        {
            Caption = 'Adjust Accrual Amount';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
        field(12; "Override Last PPI Posting Date"; Date)
        {
            Caption = 'Override Last PPI Posting Date';
            DataClassification = CustomerContent;
        }
        field(15; "Last Posted Purch. Invoice No."; Code[20])
        {
            Caption = 'Last Posted Purchase Invoice No.';
            DataClassification = CustomerContent;
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
