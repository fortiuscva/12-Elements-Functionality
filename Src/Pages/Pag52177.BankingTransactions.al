page 52177 "12E Banking Transactions"
{
    ApplicationArea = All;
    Caption = 'Banking Transactions';
    PageType = List;
    SourceTable = "12E Banking Transaction";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PKID; Rec.PKID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PKID field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field("DDA No."; Rec."DDA No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check No. field.', Comment = '%';
                    Visible = false;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Description field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Balance field.', Comment = '%';
                }
                field("Reconciliation Journal Line No."; Rec."Reconciliation Jnl Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconciliation journal line associated with this Banking PK ID.';
                }

                field("Bank Ledger Entry No."; Rec."Bank Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bank ledger entry associated with this Banking PK ID.';
                }
                field("Processed in Company"; Rec."Processed in Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reconciliation journal line associated with this Processed in Company.';
                }
                field("Last Approved Date & Time"; Rec."Last Approved Date & Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Approved Date & Time field.', Comment = '%';
                    Visible = false;
                }
                field("Last Approved By"; Rec."Last Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Approved By field.', Comment = '%';
                    Visible = false;
                }
                field("Approved for Reconciliation"; Rec."Approved for Reconciliation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approved for Reconciliation field.', Comment = '%';
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Created At';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Modified At';
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ExportBankStaging)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel (Template)';
                Image = ExportToExcel;

                trigger OnAction()
                var
                    BankStagingExcelMgt: Codeunit "12E Bank Staging Excel Mgt.";
                begin
                    BankStagingExcelMgt.ExportBankStaging(Rec);
                end;
            }

            action(ImportBankStaging)
            {
                ApplicationArea = All;
                Caption = 'Import from Excel';
                Image = ImportExcel;

                trigger OnAction()
                var
                    BankStagingExcelMgt: Codeunit "12E Bank Staging Excel Mgt.";
                begin
                    BankStagingExcelMgt.ImportBankStaging();
                    CurrPage.Update(false);
                end;
            }

            action(ApproveForReconciliation)
            {
                ApplicationArea = All;
                Caption = 'Approve for Reconciliation';
                Image = Approve;
                ToolTip = 'Approves selected banking transactions for reconciliation.';

                trigger OnAction()
                var
                    BankingTransaction: Record "12E Banking Transaction";
                begin
                    CurrPage.SetSelectionFilter(BankingTransaction);

                    if BankingTransaction.FindSet(true) then
                        repeat
                            BankingTransaction.Validate("Last Approved Date & Time", CurrentDateTime);
                            BankingTransaction.Validate("Last Approved By", UserId);
                            BankingTransaction.Validate("Approved for Reconciliation", true);

                            BankingTransaction.Modify(true);
                        until BankingTransaction.Next() = 0;

                    CurrPage.Update(false);
                end;

            }

        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ExportBankStaging_Promoted; ExportBankStaging)
                {
                }
                actionref(ImportBankStaging_Promoted; ImportBankStaging)
                {
                }
            }
        }
    }
}
