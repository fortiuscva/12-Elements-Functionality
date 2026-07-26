page 52120 "12E Lead Source Reconciliation"
{
    Caption = 'Lead Source Reconciliation (Global)';
    PageType = List;
    SourceTable = "12E Lead Source Reconciliation";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                }
                field("DW Load Date"; Rec."DW Load Date")
                {
                    ApplicationArea = All;
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                }
                field("Portfolio Name"; Rec."Portfolio Name")
                {
                    ApplicationArea = all;
                }
                field("Lead Original Date"; Rec."Lead Original Date")
                {
                    ApplicationArea = All;
                }
                field("Lead Provider"; Rec."Lead Provider")
                {
                    ApplicationArea = All;
                }
                field("Purchased Leads"; Rec."Purchased Leads")
                {
                    ApplicationArea = All;
                }
                field("Lead Sold Cost"; Rec."Lead Sold Cost")
                {
                    ApplicationArea = All;
                }
                field("DW Export DateTime"; Rec."DW Export DateTime")
                {
                    ToolTip = 'Specifies the value of the DW Export DateTime field.', Comment = '%';
                }
                field("ERP Import DateTime"; Rec."ERP Import DateTime")
                {
                    ToolTip = 'Specifies the value of the ERP Import DateTime field.', Comment = '%';
                }
                field("ERP Status"; Rec."ERP Status")
                {
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                }
                field("ERP Error Msg"; Rec."ERP Error Msg")
                {
                    ToolTip = 'Specifies the value of the ERP Error Msg field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
            }
        }
    }
}