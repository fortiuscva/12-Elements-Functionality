tableextension 52100 "12E Vendor" extends Vendor
{
    fields
    {
        field(50100; "12E Lead Reconciliation"; Boolean)
        {
            Caption = 'Lead Reconciliation ';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "12E Lead Reconciliation" then
                    TestField("12E Lead Vendor");
            end;
        }

        field(50101; "12E Lead Billing Terms"; DateFormula)
        {
            Caption = 'Lead Billing Terms';
            DataClassification = CustomerContent;
        }

        field(50102; "12E Lead Accrual"; Boolean)
        {
            Caption = 'Lead Accrual';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "12E Lead Accrual" then begin
                    TestField("12E Lead Vendor");
                    TestField("12E Lead Credit Account No.");
                    TestField("12E Lead Debit Account No.");
                end;
            end;
        }

        field(50103; "12E Lead Vendor"; Text[100])
        {
            Caption = 'Lead Vendor';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "12E Lead Reconciliation" or "12E Lead Accrual" then
                    TestField("12E Lead Vendor");
            end;
        }
        field(50104; "12E Lead Credit Account No."; Code[20])
        {
            Caption = 'Lead Credit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                if "12E Lead Accrual" then
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
                if "12E Lead Accrual" then
                    TestField("12E Lead Debit Account No.");
            end;
        }
    }
}
