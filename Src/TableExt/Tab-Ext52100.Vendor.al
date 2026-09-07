tableextension 52100 "12E Vendor" extends Vendor
{
    fields
    {
        field(50100; "12E Lead Acquisition"; Boolean)
        {
            Caption = 'Lead Acquisition';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "12E Lead Acquisition" then
                    TestField("12E Lead Acq. Vendor No.");
            end;
        }

        field(50101; "12E Lead Billing Terms"; DateFormula)
        {
            Caption = 'Lead Billing Terms';
            DataClassification = CustomerContent;
        }

        field(50102; "12E Lead Accrual Vendor"; Boolean)
        {
            Caption = 'Lead Accrual Vendor';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "12E Lead Accrual Vendor" then begin
                    TestField("12E Lead Acq. Vendor No.");
                    TestField("12E Lead Credit Account No.");
                    TestField("12E Lead Debit Account No.");
                end;
            end;
        }

        field(50103; "12E Lead Acq. Vendor No."; Text[100])
        {
            Caption = 'Lead Provider';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "12E Lead Acquisition" or "12E Lead Accrual Vendor" then
                    TestField("12E Lead Acq. Vendor No.");
            end;
        }
        field(50104; "12E Lead Credit Account No."; Code[20])
        {
            Caption = 'Lead Credit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                if "12E Lead Accrual Vendor" then
                    TestField("12E Lead Credit Account No.");
            end;
        }
        field(50105; "12E Lead Debit Account No."; Code[20])
        {
            Caption = 'Lead Debit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                if "12E Lead Accrual Vendor" then
                    TestField("12E Lead Debit Account No.");
            end;
        }
    }
}
