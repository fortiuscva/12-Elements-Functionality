page 52112 "12E EPIC DataSources"
{
    ApplicationArea = All;
    Caption = 'EPIC DataSources';
    PageType = List;
    SourceTable = "12E EPIC DataSource";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DataSource ID"; Rec."DataSource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EPIC DataSource ID field.', Comment = '%';
                }
                field(DBA; Rec.DBA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DBA field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
}
