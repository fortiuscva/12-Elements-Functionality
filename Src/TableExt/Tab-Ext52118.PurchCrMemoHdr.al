tableextension 52118 "Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
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
