page 52153 "12E Leads Data by Portfolio"
{
    ApplicationArea = All;
    Caption = 'Lead Source Reconciliation';
    PageType = List;
    SourceTable = "12E Lead Source Reconciliation";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field("Portfolio Name"; Rec."Portfolio Name")
                {
                    ToolTip = 'Specifies the value of the Portfolio Name field.', Comment = '%';
                }
                field("Lead Original Date"; Rec."Lead Original Date")
                {
                    ToolTip = 'Specifies the value of the Lead Original Date field.', Comment = '%';
                }
                field("Lead Provider"; Rec."Lead Provider")
                {
                    ToolTip = 'Specifies the value of the Lead Provider field.', Comment = '%';
                }
                field("Purchased Leads"; Rec."Purchased Leads")
                {
                    ToolTip = 'Specifies the value of the Purchased Leads field.', Comment = '%';
                }
                field("Lead Sold Cost"; Rec."Lead Sold Cost")
                {
                    ToolTip = 'Specifies the value of the Lead Sold Cost field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());
        if CompanyMapping.FindFirst() then
            Rec.SetRange("Portfolio Name", CompanyMapping.Portfolio);
    end;
}
