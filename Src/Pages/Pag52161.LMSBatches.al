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
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }

                field(Processor; Rec.Processor)
                {
                    ApplicationArea = All;
                }

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }

                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                }

                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }

                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                }

                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                }

                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }

                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                }

                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Posting Error"; Rec."Posting Error")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }

                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ApplicationArea = All;
                }

                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ApplicationArea = All;
                }

                field(ERPStatus; Rec.ERPStatus)
                {
                    ApplicationArea = All;
                }

                field(ERPErrorMsg; Rec.ERPErrorMsg)
                {
                    ApplicationArea = All;
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

                    trigger OnAction()
                    var
                        LMSBatchPosting: Codeunit "12E LMS Batch Posting";
                    begin
                        LMSBatchPosting.Post(Rec);
                        CurrPage.Update(false);
                    end;
                }

                action(PreviewPosting)
                {
                    ApplicationArea = All;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Preview the General Ledger Entries that will be created.';

                    trigger OnAction()
                    var
                        LMSBatchPosting: Codeunit "12E LMS Batch Posting";
                    begin
                        LMSBatchPosting.PreviewPosting(Rec);
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
            }
        }

        area(Navigation)
        {
            group(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;

                action(ShowGLEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Show G/L Entries';
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
    begin
        SetDatasourceFilter();
    end;

    local procedure SetDatasourceFilter()
    var
        DatasourceID: Integer;
    begin
        DatasourceID := GetCurrentCompanyDatasourceID();

        Rec.FilterGroup(10);

        if DatasourceID <> 0 then
            Rec.SetRange("Datasource ID", DatasourceID)
        else
            Rec.SetRange("Datasource ID", -1);

        Rec.FilterGroup(0);
    end;

    local procedure GetCurrentCompanyDatasourceID(): Integer
    var
        EPICDataSource: Record "12E EPIC DataSource";
    begin
        EPICDataSource.SetRange(DBA, CompanyName());

        if EPICDataSource.FindFirst() then
            exit(EPICDataSource."DataSource ID");

        exit(0);
    end;
}