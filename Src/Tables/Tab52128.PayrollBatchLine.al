table 52128 "12E Payroll Batch Line"
{
    Caption = '12E Payroll Batch Line';
    DataPerCompany = true;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "12E Payroll Batch Header";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(5; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(6; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(7; "Pay Type Code"; Code[50])
        {
            Caption = 'Pay Type Code';
            TableRelation = "12E Pay Type";
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(9; "Hours Worked"; Decimal)
        {
            Caption = 'Hours Worked';
            DataClassification = CustomerContent;
        }
        field(10; "Hours Units Paid"; Decimal)
        {
            Caption = 'Hours Paid';
            DataClassification = CustomerContent;
        }
        field(11; "Client ID"; Integer)
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }
        field(12; "Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(13; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            FieldClass = FlowField;
            CalcFormula = sum("12E Questco Payroll Txn"."Credit Amount" where("Client ID" = field("Client ID"), "Batch ID" = field("Batch ID"), "Department Code" = field("Department Code"), "G/L Account No." = field("G/L Account No."), "Credit Amount" = filter(> 0)));
        }
        field(14; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            FieldClass = FlowField;
            CalcFormula = sum("12E Questco Payroll Txn"."Debit Amount" where("Client ID" = field("Client ID"), "Batch ID" = field("Batch ID"), "Department Code" = field("Department Code"), "G/L Account No." = field("G/L Account No."), "Debit Amount" = filter(> 0)));
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CalcFormula = lookup("12E Department Code"."Shortcut Dimension 1 Code" where(Code = field("Department Code")));
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }
}
