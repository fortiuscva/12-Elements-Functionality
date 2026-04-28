page 52100 "12E Company Mappings"
{
    ApplicationArea = All;
    Caption = 'Company Mappings';
    PageType = List;
    SourceTable = "12E Company Mappings";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field("Data Source ID"; Rec."Data Source ID")
                {
                    ToolTip = 'Specifies the value of the Data Source ID field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
}
