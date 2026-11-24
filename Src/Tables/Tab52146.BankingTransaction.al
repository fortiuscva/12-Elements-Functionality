table 52146 "12E Banking Transaction"
{
    Caption = 'Banking Transaction';
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
        field(4; "DDA No."; Code[20])
        {
            Caption = 'DDA No.';
            DataClassification = CustomerContent;
            TableRelation = "12E DDA Mapping"."DDA No.";
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
            TableRelation = "Bank Acc. Reconciliation Line"."Statement Line No.";
        }
        field(12; "Bank Ledger Entry No."; Integer)
        {
            Caption = 'Bank Ledger Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Bank Account Ledger Entry"."Entry No.";
        }
        field(13; "Processed in Company"; Text[30])
        {
            Caption = 'Processed in Company';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Bank Account No."; Code[20])
        {
            CalcFormula = lookup("12E DDA Mapping"."Bank Account No." where("DDA No." = field("DDA No.")));
            Caption = 'Bank Account No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Company Name"; Text[30])
        {
            CalcFormula = lookup("12E DDA Mapping"."Company Name" where("DDA No." = field("DDA No.")));
            Caption = 'Company Name';
            Editable = false;
            FieldClass = FlowField;
        }

        field(16; "Last Approved Date & Time"; DateTime)
        {
            Caption = 'Last Approved Date & Time';
            DataClassification = CustomerContent;
        }
        field(17; "Last Approved By"; Code[50])
        {
            Caption = 'Last Approved By';
            DataClassification = CustomerContent;
        }
        field(18; "Approved for Reconciliation"; Boolean)
        {
            Caption = 'Approved for Reconciliation';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "DDA No.", "Transaction Date")
        {
            SumIndexFields = Amount;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; PKID, "DDA No.", "Transaction Date", "Transaction Description", Amount)
        { }
        fieldgroup(DropDown; PKID, "DDA No.", "Transaction Date", "Transaction Description", Amount)
        { }
    }
}