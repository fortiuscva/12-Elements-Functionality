page 52137 "12E Department Codes"
{
    ApplicationArea = All;
    Caption = 'Department Codes';
    PageType = List;
    SourceTable = "12E Department Code";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Contact Center"; Rec."Contact Center")
                {
                    ToolTip = 'Specifies the value of the Contact Center field.', Comment = '%';
                }
            }
        }
    }
}
