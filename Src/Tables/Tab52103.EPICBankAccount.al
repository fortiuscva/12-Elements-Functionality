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
            // TableRelation = "12E Company Mappings"."Data Source ID";
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
        field(15; "Account Type"; enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(20; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const("Allocation Account")) "Allocation Account"
            else
            if ("Account Type" = const(Employee)) Employee;

            DataClassification = CustomerContent;
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
}
