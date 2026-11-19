table 52145 "12E DDA Mapping"
{
    Caption = 'DDA Mapping';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    LookupPageId = "12E DDA Mapping";
    DrillDownPageId = "12E DDA Mapping";

    fields
    {
        field(1; "DDA No."; Code[20])
        {
            Caption = 'DDA No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
        }
        field(3; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
            ValidateTableRelation = false;
            // trigger OnLookup()
            // var
            //     BankAccount: Record "Bank Account";
            //     BankAccountList: Page "Bank Account List";
            // begin
            //     BankAccount.Reset();

            //     if Company <> '' then
            //         if not BankAccount.ChangeCompany(Company) then
            //             Error('Unable to access company %1.', Company);

            //     BankAccountList.LookupMode(true);
            //     BankAccountList.SetTableView(BankAccount);

            //     if BankAccountList.RunModal() = Action::LookupOK then begin
            //         BankAccountList.GetRecord(BankAccount);

            //         "Bank Account No." := BankAccount."No.";
            //         "Bank Account Name" := BankAccount.Name;
            //     end;
            // end;
        }
        field(4; "Net Change"; Decimal)
        {
            CalcFormula = sum("12E Banking Transaction".Amount where("DDA No." = field("DDA No."),
                                                            "Transaction Date" = field("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Balance; Decimal)
        {
            CalcFormula = sum("12E Banking Transaction".Amount where("DDA No." = field("DDA No.")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Balance at Date"; Decimal)
        {
            CalcFormula = sum("12E Banking Transaction".Amount where("DDA No." = field("DDA No."),
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
        key(PK; "DDA No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "DDA No.", "Company Name", "Bank Account No.")
        { }
        fieldgroup(DropDown; "DDA No.", "Company Name", "Bank Account No.")
        { }
    }


    trigger OnModify()
    var
        UserSetup: Record "User Setup";
        BankStaging: Record "12E Banking Transaction";
        MappingModErrLbl: Label 'Mapping cannot be modified because one or more processed banking transactions exist for this DDA No. %1', Comment = '%1 = DDA No.';
    begin
        if (xRec."Company Name" = "Company Name") and
           (xRec."DDA No." = "DDA No.") and
           (xRec."Bank Account No." = "Bank Account No.")
        then
            exit;

        if UserSetup.Get(UserId()) then
            if UserSetup."12E Allow Bank Mapping Mod." then
                exit;

        BankStaging.Reset();
        BankStaging.SetRange("DDA No.", xRec."DDA No.");

        if BankStaging.FindSet() then begin
            repeat
                if ((BankStaging."Reconciliation Jnl Line No." <> 0) or (BankStaging."Bank Ledger Entry No." <> 0)) then
                    Error(MappingModErrLbl, xRec."DDA No.");
            until BankStaging.Next() = 0;
        end;
    end;

}
