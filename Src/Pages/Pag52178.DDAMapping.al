page 52178 "12E DDA Mapping"
{
    ApplicationArea = All;
    Caption = 'DDA Mapping';
    PageType = List;
    SourceTable = "12E DDA Mapping";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(DdaAccount; Rec."DDA No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DdaAccount field.', Comment = '%';
                }
                field("Last 4 Digits"; Rec."Last 4 Digits")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last 4 Digits field.', Comment = '%';
                }
                field(Company; Rec."Company Name")
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

                        if Rec."Company Name" <> '' then
                            if not BankAccount.ChangeCompany(Rec."Company Name") then
                                Error('Unable to access company %1.', Rec."Company Name");
                        BankAccount.FilterGroup(8);
                        BankAccount.SetFilter(Name, '*' + Rec."Last 4 Digits" + '*');
                        BankAccount.FilterGroup(0);
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
                field("Entity Name"; Rec."Entity Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entity Name field.', Comment = '%';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name field.', Comment = '%';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
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
