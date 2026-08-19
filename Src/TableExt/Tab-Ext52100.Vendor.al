tableextension 52100 "12E Vendor" extends Vendor
{
    fields
    {
        field(50100; "12E Lead Acquisition"; Boolean)
        {
            Caption = 'Lead Acquisition';
            DataClassification = CustomerContent;
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
        }

        field(50103; "12E Lead Acq. Vendor No."; Text[100])
        {
            Caption = 'Lead Provider';
            DataClassification = CustomerContent;
        }
        field(50104; "12E Lead Credit Account No."; Code[20])
        {
            Caption = 'Lead Credit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50105; "12E Lead Debit Account No."; Code[20])
        {
            Caption = 'Lead Debit Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
    }
}
