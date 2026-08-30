page 52126 "12E Posted LeadAccrual Subform"
{
    ApplicationArea = All;
    Caption = 'Posted Lead Accrual Subform';
    PageType = ListPart;
    SourceTable = "12E Posted Lead Accrual Line";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lead Accrual No."; Rec."Lead Accrual No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Accrual No. field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Last Posted Purch. Invoice No."; Rec."Last Posted Purch. Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Posted Purchase Invoice No. field.', Comment = '%';
                }
                field("Last PPI Posting Date"; Rec."Last PPI Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Posted Purchase Invoice Posting Date field.', Comment = '%';
                }
                field("Override Last PPI Posting Date"; Rec."Override Last PPI Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Override Last PPI Posting Date field.', Comment = '%';
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual Amount field.', Comment = '%';
                }
                field("Adjust Accrual Amount"; Rec."Adjust Accrual Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Adjust Accrual Amount field.', Comment = '%';
                }
                field("Total Invoiced Amount (Period)"; Rec."Total Invoiced Amount (Period)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Acquisition Costs for this Vendor field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        PurchInvHeader: Record "Purch. Inv. Header";
                    begin
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No.");
                        PurchInvHeader.SetRange("Posting Date", Rec."From Date", Rec."To Date");

                        Page.RunModal(Page::"Posted Purchase Invoices", PurchInvHeader);
                    end;
                }
            }
        }
    }
}
