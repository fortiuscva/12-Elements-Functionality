page 52125 "12E Posted Lead Accrual"
{
    ApplicationArea = All;
    Caption = 'Posted Lead Accrual';
    PageType = Document;
    SourceTable = "12E Posted Lead Accrual";
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
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the lead accrual document.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Created At';
                    Editable = false;
                    ToolTip = 'Specifies when the document was created.';
                }

                field(CreatedBy; CreatedBy)
                {
                    Caption = 'Created By';
                    Editable = false;
                    ToolTip = 'Specifies who created the document.';
                }

                group(AccrualPeriod)
                {
                    Caption = 'Accrual Period';

                    field(Year; Rec.Year)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the year for the accrual period.';
                    }

                    field(Month; Rec.Month)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the month for the accrual period.';
                    }

                    field("From Date"; Rec."From Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the start date of the accrual period.';
                    }

                    field("To Date"; Rec."To Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the end date of the accrual period.';
                    }
                }

                group(PostingDetails)
                {
                    Caption = 'Posting Details';

                    field("G/L Register No."; Rec."G/L Register No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the G/L Register No. associated with the posted lead accrual.';
                    }

                    field(Reversed; Rec.Reversed)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether the posted lead accrual has been reversed.';
                    }
                }
            }

            part(Lines; "12E Posted LeadAccrual Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Lead Accrual No." = field("No.");
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

    trigger OnOpenPage()
    var
        UserRec: Record User;
    begin
        Clear(CreatedBy);
        CreatedBy := '';
        UserRec.Reset();
        if UserRec.Get(Rec.SystemCreatedBy) then
            CreatedBy := UserRec."User Name";
    end;

    var
        CreatedBy: Code[50];
}