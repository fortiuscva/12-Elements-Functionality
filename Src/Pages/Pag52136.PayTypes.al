page 52136 "12E Pay Types"
{
    ApplicationArea = All;
    Caption = 'Pay Types';
    PageType = List;
    SourceTable = "12E Pay Type";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Pay Type Code"; Rec."Pay Type Code")
                {
                    ToolTip = 'Specifies the value of the Pay Type Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Contact Center"; Rec."Contact Center")
                {
                    ToolTip = 'Specifies the value of the Contact Center field.', Comment = '%';
                }
                field("Do not process for payroll"; Rec."Do not process for payroll")
                {
                    ToolTip = 'Specifies the value of the Do not process for payroll field.', Comment = '%';
                }
            }
        }
    }
}
