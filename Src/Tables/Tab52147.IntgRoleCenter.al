table 52147 "12E Intg. RoleCenter"
{
    Caption = '12E Integration Role Center';
    DataClassification = CustomerContent;

    fields
    {

        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; "CCD Documents"; Integer)
        {
            Caption = 'CCD Documents';
            Editable = false;
        }

        field(3; "Posted CCD Documents"; Integer)
        {
            Caption = 'Posted CCD Documents';
            Editable = false;
        }
        field(4; "Payroll Documents"; Integer)
        {
            Caption = 'Payroll Documents';
            Editable = false;
        }
        field(5; "Posted Payroll Documents"; Integer)
        {
            Caption = 'Posted Payroll Documents';
            Editable = false;
        }
        field(6; "LMS Transaction Documents"; Integer)
        {
            Caption = 'LMS Transaction Documents';
            Editable = false;
        }
        field(7; "Posted LMS Transc Documents"; Integer)
        {
            Caption = 'Posted LMS Transaction Documents';
            Editable = false;
        }
        field(8; "Loyalty Points"; Integer)
        {
            Caption = 'Loyalty Points(Not Posted)';
            Editable = false;
        }

        field(9; "Posted Loyalty Points"; Integer)
        {
            Caption = 'Posted Loyalty Points';
            Editable = false;
        }
        field(10; "LMS Batches"; Integer)
        {
            Caption = 'LMS Batches (Not Posted)';
            Editable = false;
        }

        field(11; "Posted LMS Batches"; Integer)
        {
            Caption = 'LMS Batches (Posted)';
            Editable = false;
        }
        field(12; Customer; Integer)
        {
            Caption = 'Customers';
            Editable = false;
            //FieldClass = FlowField;
            // CalcFormula = count("Customer");
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
