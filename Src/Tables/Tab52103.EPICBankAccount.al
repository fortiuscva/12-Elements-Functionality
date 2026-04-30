table 52103 "12E EPIC Bank Account"
{
    Caption = '12E EPIC Bank Account';
    DataClassification = CustomerContent;
    LookupPageId = "12E EPIC Bank Accounts";
    DrillDownPageId = "12E EPIC Bank Accounts";
    DataPerCompany = false;

    fields
    {
        field(1; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';

            DataClassification = CustomerContent;
        }
        field(2; Endpoint; Code[20])
        {
            Caption = 'Endpoint';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(15; "Bal. Account Type"; enum "12E Bal. Account Types")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(20; "Bal. Account No."; Code[20])
        {
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                TestField("Data Source ID");
                CompanyMapping.Reset();
                CompanyMapping.SetRange("DataSource ID", Rec."Data Source ID");
                CompanyMapping.SetFilter(Company, '<>%1', '');
                CompanyMapping.FindLast();
                Case "Bal. Account Type" of
                    "Bal. Account Type"::"G/L Account":
                        begin
                            GLAccount.Reset();
                            GLAccount.ChangeCompany(CompanyMapping.Company);
                            if Page.RunModal(Page::"Chart of Accounts", GLAccount) = Action::LookupOK then
                                Rec."Bal. Account No." := GLAccount."No.";
                        end;
                    "Bal. Account Type"::"Bank Account":
                        begin
                            BankAccount.Reset();
                            BankAccount.ChangeCompany(CompanyMapping.Company);
                            if Page.RunModal(Page::"Bank Account List", BankAccount) = Action::LookupOK then
                                Rec."Bal. Account No." := BankAccount."No.";
                        end;
                end;
            end;

            trigger OnValidate()
            begin
                TestField("Data Source ID");
                CompanyMapping.Reset();
                CompanyMapping.SetRange("DataSource ID", Rec."Data Source ID");
                CompanyMapping.SetFilter(Company, '<>%1', '');
                CompanyMapping.FindLast();
                Case "Bal. Account Type" of
                    "Bal. Account Type"::"G/L Account":
                        begin
                            GLAccount.Reset();
                            GLAccount.ChangeCompany(CompanyMapping.Company);
                            GLAccount.Get("Bal. Account No.");
                        end;
                    "Bal. Account Type"::"Bank Account":
                        begin
                            BankAccount.Reset();
                            BankAccount.ChangeCompany(CompanyMapping.Company);
                            BankAccount.Get("Bal. Account No.");
                        end;
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Data Source ID", Endpoint)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Data Source ID", Endpoint)
        {
        }
    }
    var
        CompanyMapping: Record "12E Company Mapping";
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        CompanyTxt: Text[30];
}
