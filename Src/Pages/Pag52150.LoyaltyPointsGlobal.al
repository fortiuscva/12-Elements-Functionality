page 52150 "12E Loyalty Points Global"
{
    ApplicationArea = All;
    Caption = 'Loyalty Points (Global)';
    PageType = List;
    SourceTable = "12E Loyalty Points";
    SourceTableView = sorting("PK ID") order(descending);
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec."Store Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field("Month End Date"; Rec."Month End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month End Date field.', Comment = '%';
                }
                field("Points Earned"; Rec."Points Earned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Points Earned field.', Comment = '%';
                }
                field("Points Expired"; Rec."Points Expired")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Points Expired field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field(ERPStatus; Rec.ERPStatus)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERPStatus field.', Comment = '%';
                }
                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERPErrorMsg field.', Comment = '%';
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Export Batch ID field.', Comment = '%';
                }
            }
        }
    }
}
