page 52156 "12E Posted CCD"
{
    ApplicationArea = All;
    Caption = 'Posted Contact Center Distribution';
    PageType = Document;
    InsertAllowed = false;
    // ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "12E Posted CCD Header";
    UsageCategory = None;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    Editable = false;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    Editable = false;
                }

                group(Batch)
                {
                    Caption = 'Batch';

                    field("Payroll Batch ID"; Rec."Payroll Batch ID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                        Editable = false;
                    }

                    field("No. of Hours"; Rec."No. of Hours")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the No. of Hours field.', Comment = '%';
                        Editable = false;
                    }
                }

                group(Period)
                {
                    Caption = 'Period';

                    field("Period Start Date"; Rec."Period Start Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                        Editable = false;
                    }

                    field("Period End Date"; Rec."Period End Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                        Editable = false;
                    }
                }

                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                    Visible = false;
                }

                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Invoice No. field.', Comment = '%';
                    Editable = false;
                    Visible = false;
                }

                field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                    Editable = false;
                    Visible = false;
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Created At';
                    Editable = false;
                    ToolTip = 'Specifies when the document was created.';
                }

                field(CreatedBy; CreatedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    Editable = false;
                    ToolTip = 'Specifies who created the document.';
                }
            }

            part(Lines; "12E Posted CCD Subform")
            {
                ApplicationArea = All;
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
                    CreateConfirmQst: Label 'Do you want to create sales invoices for this posted contact center distribution document?';
                begin
                    if not Confirm(CreateConfirmQst) then
                        exit;

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
                        QuestcoPayrollBatch.FilterGroup := 8;
                        QuestcoPayrollBatch.SetRange("Batch ID", Rec."Payroll Batch ID");
                        QuestcoPayrollBatch.SetRange("Pay Period Start Date", Rec."Period Start Date");
                        QuestcoPayrollBatch.SetRange("Pay Period End Date", Rec."Period End Date");
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
                Caption = 'Navigate';
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

    var
        CreatedBy: Code[50];

    trigger OnAfterGetRecord()
    var
        UserRec: Record User;
    begin
        Clear(CreatedBy);

        if UserRec.Get(Rec.SystemCreatedBy) then
            CreatedBy := UserRec."User Name";
    end;
}