table 52104 "12E Setup"
{
    Caption = 'Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(5; "EPIC Payment Batch Nos."; Code[20])
        {
            Caption = 'EPIC Payment Batch Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(10; "Balancing G/L Account"; Code[20])
        {
            Caption = 'EPIC Balancing G/L Account';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(13; "CCD Nos."; Code[20])
        {
            Caption = 'Call Center Distribution Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(15; "Lead Accrual Nos."; Code[20])
        {
            Caption = 'Lead Accrual Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(20; "Lead Accrual Jnl. Template"; Code[10])
        {
            Caption = 'Lead Accrual Journal Template';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Lead Accrual Jnl. Template" <> xRec."Lead Accrual Jnl. Template" then
                    Validate("Lead Accrual Jnl. Batch", '');
            end;
        }
        field(21; "Lead Accrual Jnl. Batch"; Code[10])
        {
            Caption = 'Lead Accrual Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Lead Accrual Jnl. Template"));
            DataClassification = CustomerContent;
        }
        field(23; "CCD G/L Account No."; Code[20])
        {
            Caption = 'CCD G/L Account No.';
            TableRelation = "G/L Account" where(Blocked = const(false));
            DataClassification = CustomerContent;
        }
        field(25; "Payroll Doc. No's."; Code[20])
        {
            Caption = 'Payroll Document Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(27; "Payroll Offset Account No."; Code[20])
        {
            Caption = 'Payroll Offset Account No.';
            TableRelation = "G/L Account" where(Blocked = const(false));
            DataClassification = CustomerContent;
        }
        field(29; "Payroll Jnl. Template"; Code[10])
        {
            Caption = 'Payroll Journal Template';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Payroll Jnl. Template" <> xRec."Payroll Jnl. Template" then
                    Validate("Payroll Jnl. Batch", '');
            end;
        }
        field(31; "Payroll Jnl. Batch"; Code[10])
        {
            Caption = 'Payroll Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payroll Jnl. Template"));
            DataClassification = CustomerContent;
        }

        field(32; "Loyalty Points Earned"; Code[20])
        {
            Caption = 'Loyalty Points Earned';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(33; "Deferred Rev Loyalty Pts"; Code[20])
        {
            Caption = 'Deferred Rev Loyalty Points';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(34; "Loyalty Points Provision"; Code[20])
        {
            Caption = 'Loyalty Points Provision';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(35; "Loyalty Points Reserve"; Code[20])
        {
            Caption = 'Loyalty Points Reserve';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(36; "Loyalty Source Code"; Code[20])
        {
            Caption = 'Loyalty Source Code';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(37; "Loyalty Reason Code"; Code[20])
        {
            Caption = 'Loyalty Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }
        field(38; "Loyalty Pts. Provision %"; Decimal)
        {
            Caption = 'Loyalty Points Provision %';
            DataClassification = CustomerContent;
        }
        field(39; "Loyalty Document Nos."; Code[20])
        {
            Caption = 'Loyalty Document Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(40; "Enable CCD Process"; Boolean)
        {
            Caption = 'Enable CCD Process';
        }
        field(41; "Process Dialer Tone Invoices"; Boolean)
        {
            Caption = 'Process Dialer Tone Invoices';
            DataClassification = CustomerContent;
        }
        field(42; "Enable Loyalty Process"; Boolean)
        {
            Caption = 'Enable Loyalty Process';
            DataClassification = CustomerContent;
        }
        field(43; "Loyalty Jnl. Template"; Code[10])
        {
            Caption = 'Loyalty Journal Template';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Loyalty Jnl. Template" <> xRec."Loyalty Jnl. Template" then
                    Validate("Loyalty Jnl. Batch", '');
            end;
        }
        field(44; "Loyalty Jnl. Batch"; Code[10])
        {
            Caption = 'Loyalty Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Loyalty Jnl. Template"));
        }
        field(50; "LMS Jnl. Template"; Code[10])
        {
            Caption = 'LMS Jnl. Template';
            TableRelation = "Gen. Journal Template";
        }

        field(51; "LMS Jnl. Batch"; Code[10])
        {
            Caption = 'LMS Jnl. Batch';
            TableRelation = "Gen. Journal Batch".Name
        where("Journal Template Name" = field("LMS Jnl. Template"));
        }

        field(52; "LMS Document Nos."; Code[20])
        {
            Caption = 'LMS Document Nos.';
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
