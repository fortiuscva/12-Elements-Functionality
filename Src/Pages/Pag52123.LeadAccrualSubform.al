page 52123 "12E Lead Accrual Subform"
{
    ApplicationArea = All;
    Caption = '12E Lead Accrual Subform';
    PageType = ListPart;
    SourceTable = "12E Lead Accrual Line";
    UsageCategory = None;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lead Accrual No."; Rec."Lead Accrual No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Lead Accrual No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Last Posted Purch. Invoice No."; Rec."Last Posted Purch. Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Last Posted Purchase Invoice No. field.', Comment = '%';
                }
                field("Last PPI Posting Date"; Rec."Last PPI Posting Date")
                {
                    ToolTip = 'Specifies the value of the Last Posted Purchase Invoice Posting Date field.', Comment = '%';
                }
                field("Override Last PPI Posting Date"; Rec."Override Last PPI Posting Date")
                {
                    ToolTip = 'Specifies the value of the Override Last PPI Posting Date field.', Comment = '%';
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ToolTip = 'Specifies the value of the Accrual Amount field.', Comment = '%';
                }
                field("Adjust Accrual Amount"; Rec."Adjust Accrual Amount")
                {
                    ToolTip = 'Specifies the value of the Adjust Accrual Amount field.', Comment = '%';
                }
                field("Lead Acq. Cost Vendor"; Rec."Lead Acq. Cost Vendor")
                {
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
