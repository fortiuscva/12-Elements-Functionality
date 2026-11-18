page 52178 "12E DDA Account Nos. Mapping"
{
    ApplicationArea = All;
    Caption = 'DDA Account Nos. Mapping';
    PageType = List;
    SourceTable = "12E DDA Account Nos. Mapping";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(DdaAccount; Rec."DDA Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DdaAccount field.', Comment = '%';
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
