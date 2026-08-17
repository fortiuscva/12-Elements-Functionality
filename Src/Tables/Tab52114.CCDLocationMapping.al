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
            TableRelation = Location;
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
                if ("Processing Type" = "Processing Type"::Payroll) and ("Vendor No." <> '') then
                    Error(PayrollVendorNoErr);
            end;
        }
        field(9; "Processing Type"; Enum "12E CCD Processing Types")
        {
            Caption = 'Processing Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Processing Type" = "Processing Type"::Payroll then
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
        fieldgroup(DropDown; "Location Code", Blocked, "Vendor No.")
        {

        }
    }
    trigger OnInsert()
    begin
        ValidateProcessingTypeAndVendor();
    end;

    trigger OnModify()
    begin
        ValidateProcessingTypeAndVendor();
    end;

    trigger OnDelete()
    var
        CCDHeader: Record "12E CCD Header";
        PostedCCDHeader: Record "12E Posted CCD Header";
    begin
        CCDHeader.Reset();
        CCDHeader.SetRange("Location Code", Rec."Location Code");
        if not CCDHeader.IsEmpty then
            Error('Cannot delete this location code, because one or more contact center distribution documents exist with this location code');

        PostedCCDHeader.Reset();
        PostedCCDHeader.SetRange("Location Code", Rec."Location Code");
        if not PostedCCDHeader.IsEmpty then
            Error('Cannot delete this location code, because one or more posted contact center distribution documents exist with this location code');
    end;

    local procedure ValidateProcessingTypeAndVendor()
    begin
        case "Processing Type" of
            "Processing Type"::Payroll:
                begin
                    if "Vendor No." <> '' then
                        Error(PayrollVendorNoErr);
                end;

            "Processing Type"::Vendor:
                begin
                    if "Vendor No." = '' then
                        Error(VendorNoErr);
                end;
        end;
    end;

    var
        PayrollVendorNoErr: Label 'Vendor No. must be blank for Payroll processing type.';
        VendorNoErr: Label 'Vendor No. cannot be blank for Vendor processing type.';
}
