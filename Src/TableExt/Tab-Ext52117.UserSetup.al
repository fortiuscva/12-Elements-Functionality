tableextension 52117 "12E User Setup" extends "User Setup"
{
    fields
    {
        field(52100; "12E Allow CCD Invoice Deletion"; Boolean)
        {
            Caption = 'Allow CCD Invoice Deletion';
            DataClassification = CustomerContent;
        }
        field(52101; "12E Allow Pay Doc. Reversal"; Boolean)
        {
            Caption = 'Allow Payroll Document Reversal';
            DataClassification = CustomerContent;
        }
        field(52102; "12E Allow Loyalty Reversal"; Boolean)
        {
            Caption = 'Allow Loyalty Reversal';
            DataClassification = CustomerContent;
        }
        field(52103; "12E Allow LMS Reversal"; Boolean)
        {
            Caption = 'Allow LMS Reversal';
            DataClassification = CustomerContent;
        }
        field(52104; "12E Allow Lead Accr. Reversal"; Boolean)
        {
            Caption = 'Allow Lead Accrual Reversal';
            DataClassification = CustomerContent;
        }
    }
}
