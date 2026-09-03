page 52169 "12E Posted LMS Trans.Documents"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "12E Posted LMS Trans. Header";
    Caption = 'Posted LMS Transaction Documents';
    Editable = false;
    CardPageId = "12E Posted LMS Trans. Document";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                }

                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                }


                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }

                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }

                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
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
            action(ReverseRegister)
            {
                ApplicationArea = All;
                Caption = 'Reverse Register';
                Ellipsis = true;
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Reverse the LMS Transaction register.';
                Enabled = not Rec.Reversed;

                trigger OnAction()
                var
                    LMSReverseMgt: Codeunit "12E LMS Trans. Reverse Mgt.";
                begin
                    LMSReverseMgt.ReverseLMS(rec);
                    CurrPage.Update(false);
                end;
            }
        }

        area(Navigation)
        {
            action(GLEntries)
            {
                ApplicationArea = All;
                Caption = 'G/L Entries';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.SetRange("Document No.", Rec."No.");
                    GLEntry.SetRange("Posting Date", Rec."Transaction Date");

                    if Rec."Source Code" <> '' then
                        GLEntry.SetRange("Source Code", Rec."Source Code");

                    Page.Run(Page::"General Ledger Entries", GLEntry);
                end;
            }
        }
    }
}