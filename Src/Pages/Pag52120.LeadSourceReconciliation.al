page 52120 "12E Lead Source Reconciliation"
{
    Caption = 'Lead Source Reconciliation (Global)';
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "12E Lead Source Reconciliation";
    SourceTableView = sorting("PK ID") order(descending);
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
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field("DW Load Date"; Rec."DW Load Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DW Load Date field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field("Portfolio Name"; Rec."Portfolio Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("Lead Original Date"; Rec."Lead Original Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Original Date field.', Comment = '%';
                }
                field("Lead Provider"; Rec."Lead Provider")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Provider field.', Comment = '%';
                }
                field("Purchased Leads"; Rec."Purchased Leads")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchased Leads field.', Comment = '%';
                }
                field("Lead Sold Cost"; Rec."Lead Sold Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Sold Cost field.', Comment = '%';
                }
                field("DW Export DateTime"; Rec."DW Export DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DW Export DateTime field.', Comment = '%';
                }
                field("ERP Import DateTime"; Rec."ERP Import DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Import DateTime field.', Comment = '%';
                }
                field("ERP Status"; Rec."ERP Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                }
                field("ERP Error Msg"; Rec."ERP Error Msg")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Error Msg field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
            }
        }
    }
}