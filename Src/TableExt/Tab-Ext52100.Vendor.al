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
            Caption = 'Lead Acquisition Vendor No.';
            DataClassification = CustomerContent;
        }
    }
}
