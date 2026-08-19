table 52114 "12E CCD Location Mapping"
{
    Caption = 'Call Center Location Mapping';
    LookupPageId = "12E CCD Loc. Mapping Details";
    DrillDownPageId = "12E CCD Loc. Mapping Details";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(7; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (("Processing Type" = "Processing Type"::Payroll) and ("Vendor No." <> '')) then
                    Error(PayrollVendorNoErr);
            end;
        }
        field(9; "Processing Type"; Enum "12E CCD Processing Types")
        {
            Caption = 'Processing Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Processing Type" <> xRec."Processing Type" then
                    Clear("Vendor No.");
            end;
        }
    }
    keys
    {
        key(PK; "Location Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Location Code", Blocked, "Processing Type")
        {
        }
        fieldgroup(Brick; "Location Code", Blocked, "Processing Type")
        {
        }
    }
    trigger OnRename()
    begin
        if CheckCCDExists(Rec."Location Code") then
            Error(ChangeCCDLocationErr);

        if CheckPostedCCDExists(Rec."Location Code") then
            Error(ChangePostedCCDLocationErr);
    end;

    trigger OnModify()
    begin
        if CheckCCDExists(Rec."Location Code") then
            Error(ChangeCCDLocationErr);

        if CheckPostedCCDExists(Rec."Location Code") then
            Error(ChangePostedCCDLocationErr);
    end;

    trigger OnDelete()
    begin
        if CheckCCDExists(Rec."Location Code") then
            Error(DeleteCCDLocationErr);

        if CheckPostedCCDExists(Rec."Location Code") then
            Error(DeletePostedCCDLocationErr);
    end;

    local procedure CheckCCDExists(LocationCodePar: Code[10]): Boolean
    var
        CCDHeader: Record "12E CCD Header";
    begin
        Clear(CCDExists);
        CCDExists := false;
        CCDHeader.Reset();
        CCDHeader.SetRange("Location Code", LocationCodePar);
        if not CCDHeader.IsEmpty then
            CCDExists := true;

        exit(CCDExists);
    end;

    local procedure CheckPostedCCDExists(LocationCodePar: Code[10]): Boolean
    var
        PostedCCDHeader: Record "12E Posted CCD Header";
    begin
        Clear(PostedCCDExists);
        PostedCCDExists := false;
        PostedCCDHeader.Reset();
        PostedCCDHeader.SetRange("Location Code", LocationCodePar);
        if not PostedCCDHeader.IsEmpty then
            PostedCCDExists := true;

        exit(PostedCCDExists);
    end;

    var
        CCDExists: Boolean;
        PostedCCDExists: Boolean;
        DeleteCCDLocationErr: Label 'Cannot delete this location code, because one or more contact center distribution documents exist with this location code';
        DeletePostedCCDLocationErr: Label 'Cannot delete this location code, because one or more posted contact center distribution documents exist with this location code';
        ChangeCCDLocationErr: Label 'Cannot change this location code, because one or more contact center distribution documents exist with this location code';
        ChangePostedCCDLocationErr: Label 'Cannot change this location code, because one or more posted contact center distribution documents exist with this location code';
        PayrollVendorNoErr: Label 'Vendor No. must be blank for Payroll processing type.';
}
