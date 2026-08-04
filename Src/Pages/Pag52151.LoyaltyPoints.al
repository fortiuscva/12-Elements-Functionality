page 52151 "12E Loyalty Points"
{
    ApplicationArea = All;
    Caption = 'Loyalty Points';
    PageType = List;
    SourceTable = "12E Loyalty Points";
    SourceTableView = sorting(Portfolio, "Month End Date") order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PK ID"; Rec."PK ID")
                {
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec."Store Name")
                {
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field("Month End Date"; Rec."Month End Date")
                {
                    ToolTip = 'Specifies the value of the Month End Date field.', Comment = '%';
                }
                field("Points Earned"; Rec."Points Earned")
                {
                    ToolTip = 'Specifies the value of the Points Earned field.', Comment = '%';
                }
                field("Points Expired"; Rec."Points Expired")
                {
                    ToolTip = 'Specifies the value of the Points Expired field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field(ERPStatus; Rec.ERPStatus)
                {
                    ToolTip = 'Specifies the value of the ERPStatus field.', Comment = '%';
                }
                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ToolTip = 'Specifies the value of the ERPErrorMsg field.', Comment = '%';
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ToolTip = 'Specifies the value of the Export Batch ID field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        CompanyInformation: Record "Company Information";
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyInformation.Get();
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyInformation.Name);
        if CompanyMapping.FindFirst() then
            Rec.SetRange(Portfolio, CompanyMapping.Portfolio);
    end;
}
