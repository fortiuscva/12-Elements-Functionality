table 52101 "12E EPIC GL Mapping"
{
    Caption = '12E EPIC GL Mapping';
    LookupPageId = "12E EPIC GL Mapping List";
    DrillDownPageId = "12E EPIC GL Mapping List";
    DataCaptionFields = "Loan Status", "Data Source ID";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Data Source ID"; Integer)
        {
            Caption = 'Data Source ID';
            TableRelation = "12E EPIC DataSource";
            DataClassification = CustomerContent;
        }
        field(2; "Loan Status"; Enum "12E EPIC Posting Loan Status")
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(15; "Principal G/L Account No."; Code[20])
        {
            Caption = 'Principal G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupChartofAccounts(0);
            end;

            trigger OnValidate()
            begin
                ValidateChartofAccounts("Principal G/L Account No.");
            end;
        }
        field(20; "Finance Fee G/L Account No."; Code[20])
        {
            Caption = 'Finance Fee G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupChartofAccounts(1);
            end;

            trigger OnValidate()
            begin
                ValidateChartofAccounts("Finance Fee G/L Account No.");
            end;
        }
        field(25; "NSF Fee G/L Account No."; Code[20])
        {
            Caption = 'NSF Fee G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupChartofAccounts(2);
            end;

            trigger OnValidate()
            begin
                ValidateChartofAccounts("NSF Fee G/L Account No.");
            end;
        }
        field(30; "Late Fee G/L Account No."; Code[20])
        {
            Caption = 'Late Fee G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupChartofAccounts(3);
            end;

            trigger OnValidate()
            begin
                ValidateChartofAccounts("Late Fee G/L Account No.");
            end;
        }
    }
    keys
    {
        key(PK; "Data Source ID", "Loan Status")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Data Source ID", "Loan Status")
        {

        }
    }
    var
        CompanyMapping: Record "12E Company Mapping";
        GLAccount: Record "G/L Account";
        CompanyTxt: Text[30];

    local procedure LookupChartofAccounts(GLType: Option Principal,FinanceFee,NSFFee,LateFee)
    begin
        TestField("Data Source ID");
        CompanyMapping.Reset();
        CompanyMapping.SetRange("DataSource ID", Rec."Data Source ID");
        CompanyMapping.SetFilter(Company, '<>%1', '');
        CompanyMapping.FindLast();
        GLAccount.Reset();
        GLAccount.ChangeCompany(CompanyMapping.Company);
        GLAccount.SetRange(Blocked, false);
        if Page.RunModal(Page::"Chart of Accounts", GLAccount) = Action::LookupOK then begin
            case GLType of
                GLType::Principal:
                    Rec."Principal G/L Account No." := GLAccount."No.";
                GLType::FinanceFee:
                    Rec."Finance Fee G/L Account No." := GLAccount."No.";
                GLType::NSFFee:
                    Rec."NSF Fee G/L Account No." := GLAccount."No.";
                GLType::LateFee:
                    Rec."Late Fee G/L Account No." := GLAccount."No.";
            end;
        end;
    end;

    local procedure ValidateChartofAccounts(GLAccNo: Code[20])
    begin
        TestField("Data Source ID");
        CompanyMapping.Reset();
        CompanyMapping.SetRange("DataSource ID", Rec."Data Source ID");
        CompanyMapping.SetFilter(Company, '<>%1', '');
        CompanyMapping.FindLast();
        GLAccount.Reset();
        GLAccount.ChangeCompany(CompanyMapping.Company);
        GLAccount.Get(GLAccNo);
    end;
}
