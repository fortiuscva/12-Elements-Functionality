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
                    TestField("12E Lead Vendor Name");
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
                    TestField("12E Lead Vendor Name");
                    TestField("12E Leads Accrual Account No.");
                    TestField("12E Leads Expense Account No.");
                end;
            end;
        }

        field(50103; "12E Lead Vendor Name"; Text[100])
        {
            Caption = 'Lead Vendor Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "12E Lead Reconciliation" or "12E Lead Accrual" then
                    TestField("12E Lead Vendor Name");
            end;
        }
        field(50104; "12E Leads Accrual Account No."; Code[20])
        {
            Caption = 'Leads Accrual Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                if "12E Lead Accrual" then
                    TestField("12E Leads Accrual Account No.");
            end;
        }
        field(50105; "12E Leads Expense Account No."; Code[20])
        {
            Caption = 'Leads Expense Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                if "12E Lead Accrual" then
                    TestField("12E Leads Expense Account No.");
            end;
        }
    }
}
