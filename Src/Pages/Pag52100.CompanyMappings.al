page 52100 "12E Company Mappings"
{
    ApplicationArea = All;
    Caption = 'Company Mappings';
    PageType = List;
    SourceTable = "12E Company Mapping";
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
                field(DBA; Rec.DBA)
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                }
                field("DataSource ID"; Rec."DataSource ID")
                {
                    ToolTip = 'Specifies the value of the DataSource ID field.', Comment = '%';
                }
                field("Company ID"; Rec."Company ID")
                {
                    ToolTip = 'Specifies the value of the Company ID field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Type of Company"; Rec."Type of Company")
                {
                    ToolTip = 'Specifies the value of the Type of Company field.', Comment = '%';
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                }
                field("Template Company"; Rec."Template Company")
                {
                    ToolTip = 'Specifies the value of the Template Company field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
}
