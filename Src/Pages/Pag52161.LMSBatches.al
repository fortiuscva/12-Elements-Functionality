page 52161 "12E LMS Batches"
{
    ApplicationArea = All;
    Caption = 'LMS Batches';
    PageType = List;
    SourceTable = "12E LMS Batch";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

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
                    ToolTip = 'Specifies the value of the DW Load Date field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
                }

                field(Processor; Rec.Processor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processor field.', Comment = '%';
                }

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Code field.', Comment = '%';
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }

                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit Account No. field.', Comment = '%';
                }

                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit Account No. field.', Comment = '%';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }

                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }

                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }

                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Your Reference field.', Comment = '%';
                }

                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                }

                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction field.', Comment = '%';
                }

                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Reference field.', Comment = '%';
                }


                field("Posting Error"; Rec."Posting Error")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Posting Error field.', Comment = '%';
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
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                }

                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Error Message field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Posting)
            {
                Caption = 'Posting';
                Image = Post;

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Post the LMS Batch.';
                    Visible = false;

                    trigger OnAction()
                    var
                        LMSBatchPosting: Codeunit "12E LMS Batch Posting";
                    begin
                        LMSBatchPosting.Post(Rec);
                        CurrPage.Update(false);
                    end;
                }

                action(PreviewBatch)
                {
                    ApplicationArea = All;
                    Caption = 'Preview Batch';
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    Ellipsis = true;
                    ToolTip = 'Preview posting for multiple unprocessed LMS Batch records.';

                    trigger OnAction()
                    var
                        LMSBatch: Record "12E LMS Batch";
                    begin
                        Report.RunModal(
                            Report::"12E LMS Batch Preview Posting",
                            true,
                            false,
                            LMSBatch);

                        CurrPage.Update(false);
                    end;
                }
                action(PostBatch)
                {
                    ApplicationArea = All;
                    Caption = 'Post Batch';
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    Ellipsis = true;
                    ToolTip = 'Post unprocessed LMS Batch records in bulk.';

                    trigger OnAction()
                    var
                        LMSBatch: Record "12E LMS Batch";
                    begin
                        Report.RunModal(Report::"12E LMS Batch Posting", true, false, LMSBatch);
                        CurrPage.Update(false);
                    end;
                }

                action(ReverseRegister)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Register';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reverse the LMS Batch register.';
                    Enabled = Rec.Processed and not Rec.Reversed;

                    trigger OnAction()
                    var
                        LMSReverseMgt: Codeunit "12E LMS Reverse Mgt.";
                    begin
                        LMSReverseMgt.ReverseLMS(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(ShowGLEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Show G/L Entries';
                    Promoted = true;
                    PromotedCategory = Process;
                    Ellipsis = true;
                    Image = LedgerEntries;
                    trigger OnAction()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Reset();
                        GLEntry.SetRange("Document No.", Rec."Document No.");
                        GLEntry.SetRange("Posting Date", DT2Date(Rec."Transaction Date"));
                        Page.RunModal(Page::"General Ledger Entries", GLEntry);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
        if not CompanyMapping.FindFirst() then
            Error('%1 is not mapped to any data source id in 12 elements setup.', CompanyName());

        Rec.FilterGroup(10);
        Rec.SetRange("Datasource ID", CompanyMapping."DataSource ID");
        Rec.FilterGroup(0);
    end;
}