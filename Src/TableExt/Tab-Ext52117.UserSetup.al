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
    }
}
