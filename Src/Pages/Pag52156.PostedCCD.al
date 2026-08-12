page 52156 "12E Posted CCD"
{
    ApplicationArea = All;
    Caption = 'Posted Contact Center Distribution';
    PageType = Document;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "12E Posted CCD Header";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Payroll Batch ID"; Rec."Payroll Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                    Editable = false;
                }
                field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                    Editable = false;
                }
            }
            part(Lines; "12E Posted CCD Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(CreateSalesInvoices)
            {
                ApplicationArea = All;
                Caption = 'Create Sales Invoices';
                Image = CreateDocument;
                ToolTip = 'Create Sales Invoices for Posted CCDs that have not yet been invoiced.';

                trigger OnAction()
                var
                    CreateCCDSalesInvoices: Report "12E Create CCD Sales Invoices";
                begin
                    CreateCCDSalesInvoices.RunModal();
                end;
            }
        }
    }
}
