table 52135 "12E LMS Batch"
{
    Caption = 'LMS Batch';
    DataPerCompany = false;

    fields
    {
        field(1; "PK ID"; Integer)
        {
            Caption = 'PK ID';
        }

        field(2; DWLoadDate; DateTime)
        {
            Caption = 'DW Load Date';
        }

        field(3; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            TableRelation = "12E EPIC DataSource";
        }

        field(4; "Batch ID"; Integer)
        {
            Caption = 'Batch ID';
        }

        field(5; "Payment Type"; Text[50])
        {
            Caption = 'Payment Type';
        }

        field(6; Processor; Text[50])
        {
            Caption = 'Processor';
        }

        field(7; "Transaction Code"; Text[50])
        {
            Caption = 'Transaction Code';
        }

        field(8; "Transaction Date"; DateTime)
        {
            Caption = 'Transaction Date';
        }

        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
        }

        field(10; "Debit Account No."; Code[20])
        {
            Caption = 'Debit Account No.';
            TableRelation = "G/L Account";
        }

        field(11; "Credit Account No."; Code[20])
        {
            Caption = 'Credit Account No.';
            TableRelation = "G/L Account";
        }

        field(12; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(13; "G/L Register No."; Integer)
        {
            Caption = 'G/L Register No.';
        }

        field(14; "Source Code"; Code[10])
        {
            Caption = 'Source Code';

            trigger OnValidate()
            begin
                Rec."Source Code" := 'EPIC';
            end;
        }

        field(15; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }

        field(16; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }

        field(17; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
        }

        field(18; Correction; Boolean)
        {
            Caption = 'Correction';
        }

        field(19; "Payment Reference"; Code[50])
        {
            Caption = 'Payment Reference';
        }

        field(20; "Message to Recipient"; Text[140])
        {
            Caption = 'Message to Recipient';
        }

        field(21; "Payer Information"; Text[50])
        {
            Caption = 'Payer Information';
        }

        field(22; "Transaction Information"; Text[100])
        {
            Caption = 'Transaction Information';
        }

        field(23; Comment; Text[250])
        {
            Caption = 'Comment';
        }

        field(24; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DW Export Timestamp';
        }

        field(25; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERP Import Timestamp';
        }

        field(26; ERPStatus; Text[50])
        {
            Caption = 'ERP Status';
        }

        field(27; ERPErrorMsg; Text[200])
        {
            Caption = 'ERP Error Message';
        }

        field(28; "Export Batch ID"; Guid)
        {
            Caption = 'Export Batch ID';
        }
        field(35; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(36; "Posting Error"; Text[2048])
        {
            Caption = 'Posting Error';
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
        key(PK; "PK ID")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        if xRec.Processed and not xRec.Reversed then
            Error(
                'LMS Batch %1 cannot be modified because it has already been processed and has not been reversed.',
                xRec."Batch ID");
    end;
}