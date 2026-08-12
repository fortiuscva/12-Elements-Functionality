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
                field("Sales Invoices Exist"; Rec."Sales Invoices Exist")
                {
                    ToolTip = 'Specifies the value of the Sales Invoices Exist field.', Comment = '%';
                    Editable = false;
                }
                field("Posted Sales Invoices Exist"; Rec."Posted Sales Invoices Exist")
                {
                    ToolTip = 'Specifies the value of the Posted Sales Invoices Exist field.', Comment = '%';
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
}
