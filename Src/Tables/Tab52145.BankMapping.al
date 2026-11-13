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
                    "Bank Account Name" := BankAccount.Name;
                end;
            end;
        }
        field(4; "Net Change"; Decimal)
        {
            CalcFormula = sum("12E Bank Staging".Amount where(DdaAccount = field(DdaAccount),
                                                            "Transaction Date" = field("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Balance; Decimal)
        {
            CalcFormula = sum("12E Bank Staging".Amount where(DdaAccount = field(DdaAccount)));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Balance at Date"; Decimal)
        {
            CalcFormula = sum("12E Bank Staging".Amount where(DdaAccount = field(DdaAccount),
                                                            "Transaction Date" = field(upperlimit("Date Filter"))));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;

        }
        field(7; "Bank Account Name"; Text[100])
        {
            Caption = 'Bank Account Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
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


    trigger OnModify()
    var
        UserSetup: Record "User Setup";
        BankStaging: Record "12E Bank Staging";
    begin
        if (xRec.Company = Company) and
           (xRec.DdaAccount = DdaAccount) and
           (xRec."Bank Account No." = "Bank Account No.")
        then
            exit;

        if UserSetup.Get(UserId()) then
            if UserSetup."12E Allow Bank Mapping Mod." then
                exit;

        BankStaging.Reset();
        BankStaging.SetRange(DdaAccount, xRec.DdaAccount);
        BankStaging.SetFilter("Reconciliation Jnl Line No.", '<>%1', 0);
        BankStaging.SetFilter("Bank Ledger Entry No.", '<>%1', 0);

        if BankStaging.FindFirst() then
            Error(
                'Bank Mapping cannot be modified because processed banking transactions exist for DDA Account No. %1. Contact your administrator for permission.',
                xRec.DdaAccount);
    end;

}
