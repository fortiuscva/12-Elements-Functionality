table 52145 "12E Bank Mapping"
{
    Caption = 'Bank Mapping';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    LookupPageId = "12E Bank Mapping";
    DrillDownPageId = "12E Bank Mapping";

    fields
    {
        field(1; DdaAccount; Code[20])
        {
            Caption = 'DdaAccount';
            DataClassification = CustomerContent;
        }
        field(2; Company; Text[30])
        {
            Caption = 'Company';
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
        }
        field(3; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
            ValidateTableRelation = false;
            trigger OnLookup()
            var
                BankAccount: Record "Bank Account";
                BankAccountList: Page "Bank Account List";
            begin
                BankAccount.Reset();

                if Company <> '' then
                    if not BankAccount.ChangeCompany(Company) then
                        Error('Unable to access company %1.', Company);

                BankAccountList.LookupMode(true);
                BankAccountList.SetTableView(BankAccount);

                if BankAccountList.RunModal() = Action::LookupOK then begin
                    BankAccountList.GetRecord(BankAccount);

                    "Bank Account No." := BankAccount."No.";
                end;
            end;
        }
        field(4; "Net Change"; Decimal)
        {
            Caption = 'Net Change';
            DataClassification = CustomerContent;
        }
        field(5; Balance; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(6; "Balance at Date"; Decimal)
        {
            Caption = 'Balance at Date';
            DataClassification = CustomerContent;
        }
        field(7; "Bank Account Name"; Code[100])
        {
            CalcFormula = lookup("Bank Account"."Search Name" where("No." = field("Bank Account No.")));
            Caption = 'Bank Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; DdaAccount)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; DdaAccount, Company, "Bank Account No.")
        { }
        fieldgroup(DropDown; DdaAccount, Company, "Bank Account No.")
        { }
    }
}
