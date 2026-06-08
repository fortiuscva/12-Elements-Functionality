page 52120 "12E Lead Source Reconciliation"
{
    Caption = 'Lead Source Reconciliation';
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
            }
        }
    }
}