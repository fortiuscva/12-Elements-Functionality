
pageextension 52114 "Payment Reconciliation Journal" extends "Payment Reconciliation Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("12E Banking PK ID"; Rec."Banking PK ID")
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
        }
        addafter(ImportBankTransactions_Promoted)
        {
            actionref(Import12ECBankingTransactions; "12E Import12ECBankingTransactions")
            { }
        }
    }
}
