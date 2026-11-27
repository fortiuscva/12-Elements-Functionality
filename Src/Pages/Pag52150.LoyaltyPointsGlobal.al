page 52150 "12E Loyalty Points Global"
{
    Caption = 'Loyalty Points (Global)';
    Editable = true;
    PageType = List;
    SourceTable = "12E Loyalty Points";
    SourceTableView = sorting("PK ID") order(descending);
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec."Store Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field("Month End Date"; Rec."Month End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Month End Date field.', Comment = '%';
                }
                field("Points Earned"; Rec."Points Earned")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Points Earned field.', Comment = '%';
                }
                field("Points Expired"; Rec."Points Expired")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Points Expired field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field(ERPStatus; Rec.ERPStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ERPStatus field.', Comment = '%';
                }
                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ERPErrorMsg field.', Comment = '%';
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Export Batch ID field.', Comment = '%';
                }
            }
        }
    }
}
