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
        field(6; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
        }
        field(7; Department; Code[20])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(8; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(9; "Pay Code"; Code[20])
        {
            Caption = 'Pay Code';
            DataClassification = CustomerContent;
        }
        field(10; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(11; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }
        field(12; "Hours Worked"; Decimal)
        {
            Caption = 'Hours Worked';
            DataClassification = CustomerContent;
        }
        field(13; "Hours Paid"; Decimal)
        {
            Caption = 'Hours Paid';
            DataClassification = CustomerContent;
        }
        field(14; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DWExportTimestamp';
            DataClassification = CustomerContent;
        }
        field(15; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERPImportTimestamp';
            DataClassification = CustomerContent;
        }
        field(16; "ERP Status"; Text[50])
        {
            Caption = 'ERPStatus';
            DataClassification = CustomerContent;
        }
        field(17; "ERP Error Msg"; Text[250])
        {
            Caption = 'ERPErrorMsg';
            DataClassification = CustomerContent;
        }
        field(18; "Export Batch ID"; Guid)
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
