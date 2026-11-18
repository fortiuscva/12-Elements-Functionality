
pageextension 52114 "Payment Reconciliation Journal" extends "Payment Reconciliation Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("12E Banking PK ID"; Rec."12E Banking PKID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Banking PK ID associated with this reconciliation line.';
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("12E Import12ECBankingTransactions")
            {
                ApplicationArea = All;
                Caption = 'Import 12EC Banking Transactions';
                Image = Import;
                ToolTip = 'Import selected unprocessed transactions from 12EC Bank Staging.';

                trigger OnAction()
                var
                    BankingTransactionImport: Codeunit "12E Banking Transaction Import";
                begin
                    BankingTransactionImport.ImportBankingTransactions(
                        Rec."Statement Type",
                        Rec."Bank Account No.",
                        Rec."Statement No.");
                end;
            }
            action("12E Show Banking Transactions")
            {
                ApplicationArea = All;
                Caption = 'Show Banking Transactions';
                Image = ShowList;
                ToolTip = 'Show Banking Transactions';
                trigger OnAction()
                var
                    BankTransaction: Record "12E Banking Transaction";
                    BankMapping: Record "12E DDA Mapping";
                begin
                    BankMapping.Reset();
                    BankMapping.SetRange("Company Name", CompanyName);
                    BankMapping.SetRange("Bank Account No.", Rec."Bank Account No.");
                    BankMapping.FindFirst();

                    BankTransaction.Reset();
                    BankTransaction.SetRange("DDA No.", BankMapping."DDA No.");
                    BankTransaction.FindFirst();
                    Page.RunModal(Page::"12E Banking Transactions", BankTransaction);
                end;
            }
        }
        addafter(ImportBankTransactions_Promoted)
        {
            actionref(Import12ECBankingTransactions; "12E Import12ECBankingTransactions")
            { }
            actionref(ShowBankingTransactions; "12E Show Banking Transactions")
            { }
        }
    }
}
