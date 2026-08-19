page 52113 "12E CCD Data"
{
    ApplicationArea = All;
    Caption = 'CCD Detailed Data';
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "12E CCD Detailed Data";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field("Call Date"; Rec."Call Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Call Date field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Handling Time"; Rec."Handling Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handling Time field.', Comment = '%';
                }
                field("Allocated Cost"; Rec."Allocated Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allocated Cost field.', Comment = '%';
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
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}
