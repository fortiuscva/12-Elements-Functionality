table 52139 "12E LMS Transaction Details"
{
    Caption = '12E LMS Transaction Details';
    DataClassification = CustomerContent;
    LookupPageId = "12E LMS Transaction Details";
    DrillDownPageId = "12E LMS Transaction Details";

    fields
    {
        field(1; "LMS Document No."; Code[20])
        {
            Caption = 'LMS Document No.';
            TableRelation = "12E LMS Transaction Header";
            DataClassification = CustomerContent;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; "PK ID"; Integer)
        {
            Caption = 'PK ID';
            DataClassification = CustomerContent;
        }
        field(4; "DW Load Date"; DateTime)
        {
            Caption = 'DW Load Date';
            DataClassification = CustomerContent;
        }
        field(5; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            DataClassification = CustomerContent;
            TableRelation = "12E EPIC DataSource";
        }
        field(6; "Loan ID"; Integer)
        {
            Caption = 'Loan ID';
            DataClassification = CustomerContent;
        }
        field(7; "Payment ID"; Integer)
        {
            Caption = 'Payment ID';
            DataClassification = CustomerContent;
        }
        field(8; "Transaction ID"; Integer)
        {
            Caption = 'Transaction ID';
            DataClassification = CustomerContent;
        }
        field(9; "Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(10; "Payment Type"; Text[50])
        {
            Caption = 'Payment Type';
            DataClassification = CustomerContent;
        }
        field(11; "Payment Agent"; Text[300])
        {
            Caption = 'Payment Agent';
            DataClassification = CustomerContent;
        }
        field(12; "Loan Status"; Text[50])
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(13; State; Code[20])
        {
            Caption = 'State';
            DataClassification = CustomerContent;
        }
        field(14; Store; Code[20])
        {
            Caption = 'Store';
            DataClassification = CustomerContent;
        }
        field(15; Processor; Text[50])
        {
            Caption = 'Processor';
            DataClassification = CustomerContent;
        }
        field(16; "Transaction Code"; Text[50])
        {
            Caption = 'Transaction Code';
            DataClassification = CustomerContent;
        }
        field(17; "Transaction Date"; DateTime)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(18; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(19; "Debit Account No."; Code[20])
        {
            Caption = 'Debit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(20; "Credit Account No."; Code[20])
        {
            Caption = 'Credit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(21; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(22; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Register";
        }
        field(23; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(25; "ERP Status"; Text[50])
        {
            Caption = 'ERP Status';
            DataClassification = CustomerContent;
        }
        field(26; "ERP Error Msg"; Text[2048])
        {
            Caption = 'ERP Error Msg';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "LMS Document No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "LMS Document No.", "Entry No.", "PK ID", "Datasource ID", "Payment Type", "Transaction Code", Amount)
        {
        }
        fieldgroup(Brick; "LMS Document No.", "Entry No.", "PK ID", "Datasource ID", "Payment Type", "Transaction Code", Amount)
        {
        }
    }
}
