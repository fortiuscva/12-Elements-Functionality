table 52146 "12E Bank Staging"
{
    Caption = 'Bank Staging';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "12E Bank Staging";
    LookupPageId = "12E Bank Staging";

    fields
    {
        field(1; PKID; Integer)
        {
            Caption = 'PKID';
            DataClassification = CustomerContent;
        }
        field(2; "Datasource ID"; Integer)
        {
            Caption = 'Datasource ID';
            DataClassification = CustomerContent;
        }
        field(3; Portfolio; Text[50])
        {
            Caption = 'Portfolio';
            DataClassification = CustomerContent;
        }
        field(4; DdaAccount; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "12E Bank Mapping".DdaAccount;
            ValidateTableRelation = false;
        }
        field(5; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(6; "Check No."; Code[20])
        {
            Caption = 'Check No.';
            DataClassification = CustomerContent;
        }
        field(7; "Transaction Description"; Text[2048])
        {
            Caption = 'Transaction Description';
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(9; "Current Balance"; Decimal)
        {
            Caption = 'Current Balance';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; PKID)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Datasource ID", Portfolio, DdaAccount, "Transaction Date", "Transaction Description", Amount, "Current Balance")
        { }
        fieldgroup(DropDown; "Datasource ID", Portfolio, DdaAccount, "Transaction Date", "Transaction Description", Amount, "Current Balance")
        { }
    }
}
