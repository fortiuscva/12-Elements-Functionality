page 52127 "12E Posted Lead Accruals"
{
    ApplicationArea = All;
    Caption = 'Posted Lead Accruals';
    PageType = List;
    SourceTable = "12E Posted Lead Accrual";
    CardPageId = "12E Posted Lead Accrual";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
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
                    GLEntry.SetRange("Document No.", Rec."No.");
                    Page.RunModal(Page::"General Ledger Entries", GLEntry);
                end;
            }
            group(Posting)
            {
                Caption = 'Posting';
                Image = Post;

                action(ReverseRegister)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Register';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Enabled = not Rec.Reversed;
                    ToolTip = 'Reverse the G/L register associated with this posted Lead Accrual document.';

                    trigger OnAction()
                    var
                        LeadAccrualReverseMgt: Codeunit "12E Lead Accrual Reverse Mgt.";
                    begin
                        if not Confirm(ConfirmReverseRegisterQst) then
                            exit;
                        LeadAccrualReverseMgt.ReverseLeadAccrual(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ShowGLEntries_Promoted; ShowGLEntries)
                {

                }
                actionref(ReverseRegister_Promoted; ReverseRegister)
                { }
            }
        }
    }
    var
        ConfirmReverseRegisterQst: Label 'Do you want to reverse the G/L register associated with this posted Lead Accrual document?';
}