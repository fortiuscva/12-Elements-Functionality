table 52129 "12E Questco Payroll Batch"
{
    Caption = 'Questco Payroll Batch';
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
        field(52103; "CCD No."; Code[20])
        {
            Caption = 'CCD No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("12E CCD Header"."No." where("Payroll Batch ID" = field("Batch ID")));
            Editable = false;
        }

        field(52104; "Posted CCD No."; Code[20])
        {
            Caption = 'Posted CCD No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("12E Posted CCD Header"."No." where("Payroll Batch ID" = field("Batch ID")));
            Editable = false;
        }
        // field(13; "CC Processed"; Boolean)
        // {
        //     Caption = 'CC Processed';
        //     FieldClass = FlowField;
        //     CalcFormula = Exist("12E CCD Line" where("Payroll Batch ID" = field("Batch ID")));
        //     Editable = false;
        // }
        field(14; "Payroll Processed"; Boolean)
        {
            Caption = 'Payroll Processed';
            FieldClass = FlowField;
            CalcFormula = Exist("12E Payroll Batch Header" where("Batch ID" = field("Batch ID")));
            Editable = false;
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
        field(20; "CC Hours"; Decimal)
        {
            Caption = 'Contact Center Hours';
            DataClassification = CustomerContent;
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
