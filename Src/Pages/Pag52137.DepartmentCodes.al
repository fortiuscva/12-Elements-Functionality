page 52137 "12E Department Codes"
{
    ApplicationArea = All;
    Caption = 'Departments';
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Contact Center"; Rec."Contact Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Center field.', Comment = '%';
                }
            }
        }
    }
}
