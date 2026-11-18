table 52146 "12E Bank Transaction Staging"
{
    Caption = '12EC Bank Transaction Staging';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "12E Banking Transactions";
    LookupPageId = "12E Banking Transactions";

    fields
    {
        field(1; PKID; code[20])
        {
            Caption = 'PKID';
            DataClassification = CustomerContent;
        }
        field(2; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            DataClassification = CustomerContent;
        }
        field(3; Portfolio; Text[50])
        {
            Caption = 'Portfolio';
            DataClassification = CustomerContent;
        }
        field(4; "DDA Account No."; Code[20])
        {
            Caption = 'DDA Account No.';
            DataClassification = CustomerContent;
            TableRelation = "12E DDA Account Nos. Mapping"."DDA Account No.";
            ValidateTableRelation = false;
        }
        field(5; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(6; "Check No."; Code[20])
        {
            Caption = 'Check No.';
            DataClassification = CustomerContent;
        }
        field(7; "Transaction Description"; Text[2048])
        {
            Caption = 'Transaction Description';
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(9; "Current Balance"; Decimal)
        {
            Caption = 'Current Balance';
            DataClassification = CustomerContent;
        }
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(11; "Reconciliation Jnl Line No."; Integer)
        {
            Caption = 'Reconciliation Journal Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Bank Ledger Entry No."; Integer)
        {
            Caption = 'Bank Ledger Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Processed in Company"; Text[30])
        {
            Caption = 'Processed in Company';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Bank Account No."; Code[20])
        {
            CalcFormula = lookup("12E DDA Account Nos. Mapping"."Bank Account No." where("DDA Account No." = field("DDA Account No.")));
            Caption = 'Bank Account No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Company Name"; Text[30])
        {
            CalcFormula = lookup("12E DDA Account Nos. Mapping"."Company Name" where("DDA Account No." = field("DDA Account No.")));
            Caption = 'Company Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "DDA Account No.", "Transaction Date")
        {
            SumIndexFields = Amount;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Datasource ID", Portfolio, "DDA Account No.", "Transaction Date", "Transaction Description", Amount, "Current Balance")
        { }
        fieldgroup(DropDown; "Datasource ID", Portfolio, "DDA Account No.", "Transaction Date", "Transaction Description", Amount, "Current Balance")
        { }
    }
}