table 52141 "12E Posted LMS Trans. Header"
{
    Caption = 'Posted LMS Transaction Header';
    DataClassification = CustomerContent;
    LookupPageId = "12E Posted LMS Transactions";
    DrillDownPageId = "12E Posted LMS Transactions";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }

        field(2; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }

        field(3; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            DataClassification = CustomerContent;
        }

        field(4; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
        }

        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }

        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }

        field(7; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
        }

        field(8; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }

        field(9; "Posted DateTime"; DateTime)
        {
            Caption = 'Posted DateTime';
            DataClassification = CustomerContent;
        }

        field(10; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }

        field(11; "Error Exists"; Boolean)
        {
            Caption = 'Error Exists';
            DataClassification = CustomerContent;
        }

        field(37; Reversed; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }

        key(TransactionDate; "Transaction Date")
        {
        }

        key(Datasource; "Datasource ID", "Transaction Date")
        {
        }

        key(GLRegister; "G/L Register No.")
        {
        }
    }
}