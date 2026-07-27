table 52126 "12E Questco Payroll Txn"
{
    Caption = 'Questco Payroll Transaction';
    LookupPageId = "12E Questco Payroll Txns";
    DrillDownPageId = "12E Questco Payroll Txns";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "PK ID"; Integer)
        {
            Caption = 'PK ID';
            DataClassification = CustomerContent;
        }
        field(2; DWLoadDate; DateTime)
        {
            Caption = 'DWLoadDate';
            DataClassification = CustomerContent;
        }
        field(3; "Client ID"; Integer)
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }
        field(4; "Batch ID"; Integer)
        {
            Caption = 'Batch ID';
            DataClassification = CustomerContent;
        }
        field(5; "Pay Date"; Date)
        {
            Caption = 'Pay Date';
            DataClassification = CustomerContent;
        }
        field(6; "Batch Type"; Code[50])
        {
            Caption = 'Batch Type';
            DataClassification = CustomerContent;
        }
        field(7; "Pay Period Start Date"; Date)
        {
            Caption = 'Pay Period Start Date';
            DataClassification = CustomerContent;
        }
        field(8; "Pay Period End Date"; Date)
        {
            Caption = 'Pay Period End Date';
            DataClassification = CustomerContent;
        }
        field(9; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
        }
        field(10; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(11; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(12; "Pay Type Code"; Code[50])
        {
            Caption = 'Pay Type Code';
            // TableRelation = "12E Pay Type";
            DataClassification = CustomerContent;
        }
        field(13; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(14; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }
        field(15; "Hours Worked"; Decimal)
        {
            Caption = 'Hours Worked';
            DataClassification = CustomerContent;
        }
        field(16; "Hours Units Paid"; Decimal)
        {
            Caption = 'Hours Units Paid';
            DataClassification = CustomerContent;
        }
        field(17; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DWExportTimestamp';
            DataClassification = CustomerContent;
        }
        field(18; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERPImportTimestamp';
            DataClassification = CustomerContent;
        }
        field(19; "ERP Status"; Text[50])
        {
            Caption = 'ERPStatus';
            DataClassification = CustomerContent;
        }
        field(20; "ERP Error Msg"; Text[250])
        {
            Caption = 'ERPErrorMsg';
            DataClassification = CustomerContent;
        }
        field(21; "Export Batch ID"; Guid)
        {
            Caption = 'Export Batch ID';
        }
    }
    keys
    {
        key(PK; "PK ID")
        {
            Clustered = true;
        }
    }
}
