page 52101 "12E EPIC Payment Types"
{
    ApplicationArea = All;
    Caption = 'EPIC Payment Types';
    PageType = List;
    SourceTable = "12E EPIC Payment Type";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Data Source ID"; Rec."Data Source ID")
                {
                    ToolTip = 'Specifies the value of the Data Source ID field.', Comment = '%';
                }
                field("Payment Type Code"; Rec."Payment Type Code")
                {
                    ToolTip = 'Specifies the value of the Payment Type Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
}
