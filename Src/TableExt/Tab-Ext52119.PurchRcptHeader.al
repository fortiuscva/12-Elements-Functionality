tableextension 52119 "12E Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(52110; "12E Lead Period Start Date"; Date)
        {
            Caption = 'Lead Period Start Date';
            DataClassification = CustomerContent;
        }

        field(52111; "12E Lead Period End Date"; Date)
        {
            Caption = 'Lead Period End Date';
            DataClassification = CustomerContent;
        }
    }
}
