table 52141 "12E Posted LMS Trans. Header"
{
    Caption = 'Posted LMS Transaction Header';
    DataClassification = CustomerContent;
    LookupPageId = "12E Posted LMS Trans. Document";
    DrillDownPageId = "12E Posted LMS Trans. Document";

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

        field(11; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
        }

        field(12; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(13; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
        }

        field(14; Reversed; Boolean)
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