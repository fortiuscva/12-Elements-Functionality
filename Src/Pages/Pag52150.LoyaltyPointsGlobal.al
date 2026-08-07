page 52150 "12E Loyalty Points Global"
{
    ApplicationArea = All;
    Caption = 'Loyalty Points (Global)';
    PageType = List;
    SourceTable = "12E Loyalty Points";
    SourceTableView = sorting("PK ID") order(descending);
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
                    Visible = false;
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                    Visible = false;
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
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                    Visible = false;
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                    Visible = false;
                }
                field(ERPStatus; Rec.ERPStatus)
                {
                    ToolTip = 'Specifies the value of the ERPStatus field.', Comment = '%';
                    Visible = false;
                }
                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ToolTip = 'Specifies the value of the ERPErrorMsg field.', Comment = '%';
                    Visible = false;
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ToolTip = 'Specifies the value of the Export Batch ID field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}
