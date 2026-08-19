table 52100 "12E Company Mapping"
{
    Caption = 'Company Mapping';
    LookupPageId = "12E Company Mappings";
    DrillDownPageId = "12E Company Mappings";
    DataCaptionFields = "Company Code", DBA;
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Company Code"; Code[20])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }
        field(2; "DataSource ID"; Integer)
        {
            Caption = 'DataSource ID';
            TableRelation = "12E EPIC DataSource";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EPICDatasource: Record "12E EPIC DataSource";
            begin
                if (Rec."DataSource ID" <> xRec."DataSource ID") and (Rec."DataSource ID" <> 0) then begin
                    EPICDatasource.Reset();
                    EPICDatasource.Get("DataSource ID");
                    Rec.Validate(DBA, EPICDatasource.DBA);
                end
                else begin
                    Rec.Validate(DBA, '');
                    Rec.Validate(Company, '');
                end;
            end;
        }
        field(3; "Company ID"; Text[50])
        {
            Caption = 'Company ID';
            DataClassification = CustomerContent;
        }
        field(4; "Client ID"; Integer)
        {
            Caption = 'Questco Client ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CompanyMapping: Record "12E Company Mapping";
                CliendIDExistsErr: Label 'Client ID %1 is already attached to Portfolio/Company %2. A Client ID cannot be attached to more than one Portfolio/Company.';
            begin
                if "Client ID" = 0 then
                    exit;

                CompanyMapping.Reset();
                CompanyMapping.SetRange("Client ID", "Client ID");
                CompanyMapping.SetFilter("Company Code", '<>%1', "Company Code");
                if CompanyMapping.FindFirst() then
                    Error(CliendIDExistsErr, "Client ID", CompanyMapping."Company Code");
            end;
        }
        field(5; DBA; Text[100])
        {
            Caption = 'DBA';
            // Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Type of Company"; enum "12E Type of Company")
        {
            Caption = 'Type of Company';
            DataClassification = CustomerContent;
        }
        field(7; Portfolio; Text[50])
        {
            Caption = 'Portfolio';
            DataClassification = CustomerContent;
        }
        field(10; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = Company;
            DataClassification = CustomerContent;
        }
        field(11; "Template Company"; Text[30])
        {
            Caption = 'Template Company';
            TableRelation = Company;
            DataClassification = CustomerContent;
        }
        field(20; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "Company Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Company Code", DBA)
        {

        }
    }
    trigger OnInsert()
    begin
        Rec.Validate("Company ID", LowerCase(Rec."Company Code"));
    end;
}
