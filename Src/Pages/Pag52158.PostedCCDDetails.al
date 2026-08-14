page 52158 "12E Posted CCD Details"
{
    ApplicationArea = All;
    Caption = 'Posted Contact Center Distributions';
    PageType = List;
    SourceTable = "12E Posted CCD Header";
    CardPageId = "12E Posted CCD";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
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
                }
                field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                }
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
        area(Navigation)
        {
            group(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;

                action("Show Contact Center Detailed Data")
                {
                    ApplicationArea = All;
                    Caption = 'Show Contact Center Detailed Data';
                    Image = Entries;
                    ToolTip = 'Shows the Contact Center Detailed Data related to this CCD document.';

                    trigger OnAction()
                    var
                        CCDDetailedData: Record "12E CCD Detailed Data";
                    begin
                        CCDDetailedData.Reset();
                        CCDDetailedData.SetRange("Location Code", Rec."Location Code");
                        CCDDetailedData.SetRange("Call Date", Rec."Period Start Date", Rec."Period End Date");
                        Page.Run(Page::"12E CCD Data", CCDDetailedData);
                    end;
                }

                action("Show Payroll Batch")
                {
                    ApplicationArea = All;
                    Caption = 'Show Payroll Batch';
                    Image = Entries;
                    ToolTip = 'Shows the Payroll Batch related to this CCD document.';

                    trigger OnAction()
                    var
                        QuestcoPayrollBatch: Record "12E Questco Payroll Batch";
                    begin
                        QuestcoPayrollBatch.Reset();
                        QuestcoPayrollBatch.SetRange("Batch ID", Rec."Payroll Batch ID");
                        Page.Run(Page::"12E QPAY Batches", QuestcoPayrollBatch);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {

                Caption = 'Process';
                actionref(CreateSalesInvoices_Promoted; CreateSalesInvoices)
                {

                }
            }

            group(Category_Category7)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 5.';
                ShowAs = Standard;
                actionref(ShowContactCenterDetailedData_Promoted; "Show Contact Center Detailed Data")
                {
                }
                actionref(ShowPayrollBatch_Promoted; "Show Payroll Batch")
                {
                }
            }
        }
    }
}
