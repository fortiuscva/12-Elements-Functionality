tableextension 52118 "12E Job Queue Entry" extends "Job Queue Entry"
{
    fields
    {
        field(52100; "12E Set Ready When Failed"; Boolean)
        {
            Caption = 'Set Ready When Failed';
            DataClassification = CustomerContent;
        }
        field(52101; "12E Send Failure Notification"; Boolean)
        {
            Caption = 'Send Failure Notification';
            DataClassification = CustomerContent;
        }
        field(52102; "12E Notify All EmailRecipients"; Text[250])
        {
            Caption = 'Notify All EmailRecipients';
            DataClassification = CustomerContent;
        }
    }
}
