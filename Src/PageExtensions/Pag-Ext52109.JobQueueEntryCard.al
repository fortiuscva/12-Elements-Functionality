pageextension 52109 "12E Job Queue Entry Card" extends "Job Queue Entry Card"
{
    layout
    {
        addlast(General)
        {
            field("12E Set Ready When Failed"; Rec."12E Set Ready When Failed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Status to Ready on Failure field.', Comment = '%';
            }
            field("12E Send Failure Notification"; Rec."12E Send Failure Notification")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Send Failure Notification field.', Comment = '%';
            }
            field("12E Notify All EmailRecipients"; Rec."12E Notify All EmailRecipients")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Send Job Queue Failure Notification to all the Email Recipients field.', Comment = '%';
            }
        }
    }
}
