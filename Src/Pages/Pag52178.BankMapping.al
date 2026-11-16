page 52178 "12E Bank Mapping"
{
    ApplicationArea = All;
    Caption = 'Bank Mapping';
    PageType = List;
    SourceTable = "12E Bank Mapping";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(DdaAccount; Rec.DdaAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DdaAccount field.', Comment = '%';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        BankAccount: Record "Bank Account";
                        BankAccountList: Page "Bank Account List";
                    begin
                        BankAccount.Reset();

                        if Rec.Company <> '' then
                            if not BankAccount.ChangeCompany(Rec.Company) then
                                Error('Unable to access company %1.', Rec.Company);

                        BankAccountList.LookupMode(true);
                        BankAccountList.SetTableView(BankAccount);

                        if BankAccountList.RunModal() = Action::LookupOK then begin
                            BankAccountList.GetRecord(BankAccount);

                            Rec."Bank Account No." := BankAccount."No.";
                            Rec."Bank Account Name" := BankAccount.Name;
                        end;
                    end;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bank Account Name field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                field("Balance at Date"; Rec."Balance at Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Balance at Date field.', Comment = '%';
                }
                field("Net Change"; Rec."Net Change")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Change field.', Comment = '%';
                }
            }
        }
    }
}
