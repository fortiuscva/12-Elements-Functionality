page 52115 "12E CCD Loc. Mapping Details"
{
    ApplicationArea = All;
    Caption = 'CCD Location Mapping Details';
    PageType = List;
    SourceTable = "12E CCD Location Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
                field("Processing Type"; Rec."Processing Type")
                {
                    ToolTip = 'Specifies the value of the Processing Type field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckForMandatoryFields();
        exit(true);
    end;

    local procedure CheckForMandatoryFields()
    var
        CCDLocationMap: Record "12E CCD Location Mapping";
    begin
        CCDLocationMap.Reset();
        CCDLocationMap.SetRange("Processing Type", CCDLocationMap."Processing Type"::Vendor);
        CCDLocationMap.SetRange("Vendor No.", '');
        if CCDLocationMap.FindLast() then
            Error('Vendor No. cannot be blank for %1 location code because it is of processing type vendor', CCDLocationMap."Location Code");
    end;
}
