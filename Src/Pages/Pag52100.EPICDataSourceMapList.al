page 52100 "12E EPIC Data Source Map List"
{
    ApplicationArea = All;
    Caption = 'EPIC Data Source Mappings';
    PageType = List;
    SourceTable = "12E EPIC DataSourceID Map";
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
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
}
