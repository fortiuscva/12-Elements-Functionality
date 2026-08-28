table 52136 "12E LMS Transaction"
{
    Caption = 'LMS Transaction';
    DataClassification = CustomerContent;
    DrillDownPageId = "12E LMS Transactions";
    LookupPageId = "12E LMS Transactions";
    DataPerCompany = false;

    fields
    {
        field(1; "PK ID"; Integer)
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
            TableRelation = "12E EPIC DataSource";
        }
        field(4; "Loan ID"; Integer)
        {
            Caption = 'Loan ID';
            DataClassification = CustomerContent;
        }
        field(5; "Payment ID"; Integer)
        {
            Caption = 'Payment ID';
            DataClassification = CustomerContent;
        }
        field(6; "Transaction ID"; Integer)
        {
            Caption = 'Transaction ID';
            DataClassification = CustomerContent;
        }
        field(7; "Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(8; "Payment Type"; Text[50])
        {
            Caption = 'Payment Type';
            DataClassification = CustomerContent;
        }
        field(9; "Payment Agent"; Text[300])
        {
            Caption = 'Payment Agent';
            DataClassification = CustomerContent;
        }
        field(10; "Loan Status"; Text[50])
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(11; State; Code[20])
        {
            Caption = 'State';
            DataClassification = CustomerContent;
        }
        field(12; Store; Code[20])
        {
            Caption = 'Store';
            DataClassification = CustomerContent;
        }
        field(13; Processor; Text[50])
        {
            Caption = 'Processor';
            DataClassification = CustomerContent;
        }
        field(14; "Transaction Code"; Text[50])
        {
            Caption = 'Transaction Code';
            DataClassification = CustomerContent;
        }
        field(15; "Transaction Date"; DateTime)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(16; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(17; "Debit Account No."; Code[20])
        {
            Caption = 'Debit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(18; "Credit Account No."; Code[20])
        {
            Caption = 'Credit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "12E LMS Transaction Header";
        }
        field(20; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Register";
        }
        field(21; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DW Export Timestamp';
            DataClassification = CustomerContent;
        }
        field(22; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERP Import Timestamp';
            DataClassification = CustomerContent;
        }
        field(23; "ERP Status"; Text[50])
        {
            Caption = 'ERP Status';
            DataClassification = CustomerContent;
        }
        field(24; "ERP Error Message"; Text[2048])
        {
            Caption = 'ERP Error Message';
            DataClassification = CustomerContent;
        }
        field(25; "Export Batch ID"; Guid)
        {
            Caption = 'Export Batch ID';
            DataClassification = CustomerContent;
        }
        field(26; "LMS Transaction Details No."; Code[20])
        {
            Caption = 'LMS Transaction Details No.';
            DataClassification = CustomerContent;
            TableRelation = "12E LMS Transaction Details"."LMS Document No.";
        }
        field(27; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
        field(28; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
    }
    keys
    {
        key(PK; "PK ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "PK ID", "Datasource ID", "Payment Type", "Transaction Code", Amount)
        {
        }
        fieldgroup(Brick; "PK ID", "Datasource ID", "Payment Type", "Transaction Code", Amount)
        {
        }
    }
}
