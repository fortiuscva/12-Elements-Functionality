table 52129 "12E Questco Payroll Batch"
{
    Caption = 'Payroll Batch';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; PKID; Integer)
        {
            Caption = 'PKID';
            DataClassification = CustomerContent;
        }
        field(2; DWLoadDate; DateTime)
        {
            Caption = 'DWLoadDate';
            DataClassification = CustomerContent;
        }
        field(3; "Client ID"; Integer)
        {
            Caption = 'Questco Client ID';
            DataClassification = CustomerContent;
        }
        field(4; "Batch ID"; Integer)
        {
            Caption = 'Pay Batch ID';
            DataClassification = CustomerContent;
        }
        field(5; "Pay Date"; Date)
        {
            Caption = 'Pay Date';
            DataClassification = CustomerContent;
        }
        field(6; "Batch Type"; Code[10])
        {
            Caption = 'Pay Batch Type';
            DataClassification = CustomerContent;
        }
        field(7; "Batch Status"; Code[10])
        {
            Caption = 'Batch Status';
            DataClassification = CustomerContent;
        }
        field(8; "Pay Group ID"; Code[10])
        {
            Caption = 'Pay Group ID';
            DataClassification = CustomerContent;
        }
        field(9; "Pay Period Start Date"; Date)
        {
            Caption = 'Pay Period Start Date';
            DataClassification = CustomerContent;
        }
        field(10; "Pay Period End Date"; Date)
        {
            Caption = 'Pay Period End Date';
            DataClassification = CustomerContent;
        }
        field(11; "Weeks Worked"; Decimal)
        {
            Caption = 'Weeks Worked';
            DataClassification = CustomerContent;
        }
        field(12; "Deduct Period"; Decimal)
        {
            Caption = 'Deduct Period';
            DataClassification = CustomerContent;
        }
        field(13; "CCD No."; Code[20])
        {
            Caption = 'CCD No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("12E CCD Header"."No." where("Payroll Batch ID" = field("Batch ID")));
        }

        field(14; "Posted CCD No."; Code[20])
        {
            Caption = 'Posted CCD No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("12E Posted CCD Header"."No." where("Payroll Batch ID" = field("Batch ID")));
        }
        field(15; "DW Export Timestamp"; DateTime)
        {
            Caption = 'DW Export Timestamp';
            DataClassification = CustomerContent;
        }
        field(16; "ERP Import Timestamp"; DateTime)
        {
            Caption = 'ERP Import Timestamp';
            DataClassification = CustomerContent;
        }
        field(17; "ERP Status"; Text[50])
        {
            Caption = 'ERP Status';
            DataClassification = CustomerContent;
        }
        field(18; "ERP Error Message"; Text[250])
        {
            Caption = 'ERP Error Message';
            DataClassification = CustomerContent;
        }
        field(19; "ETL Batch ID"; Guid)
        {
            Caption = 'ETL Batch ID';
            DataClassification = CustomerContent;
        }
        field(20; "Payroll Doc. No."; Code[20])
        {
            Caption = 'Payroll Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("12E Payroll Batch Header"."No." where("Client ID" = field("Client ID"), "Batch ID" = field("Batch ID")));
        }
        field(21; "Posted Payroll Doc. No."; Code[20])
        {
            Caption = 'Posted Payroll Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("12E Posted Payroll Header"."No." where("Client ID" = field("Client ID"), "Batch ID" = field("Batch ID"), Reversed = const(false)));
        }
        field(22; "Posting Error"; Text[2048])
        {
            CalcFormula = lookup("12E Payroll Batch Header"."Posting Error" where("Client ID" = field("Client ID"), "Batch ID" = field("Batch ID")));
            Caption = 'Posting Error Message';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; PKID)
        {
            Clustered = true;
        }
        key(Key2; "Client ID", "Batch ID")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Client ID", "Batch ID", "Batch Type", "Pay Date", "Pay Period Start Date", "Pay Period End Date")
        {

        }
    }
}
