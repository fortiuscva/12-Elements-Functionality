page 52115 "12E CC Location Mappings"
{
    ApplicationArea = All;
    Caption = 'Call Center Location Mappings';
    PageType = List;
    SourceTable = "12E CC Location Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Mapping; Rec.Mapping)
                {
                    ToolTip = 'Specifies the value of the Mapping field.', Comment = '%';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
