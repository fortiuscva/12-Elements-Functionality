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
    var
        CCDLocationMapping: Record "12E CCD Location Mapping";
    begin
        CCDLocationMapping.Reset();
        CCDLocationMapping.SetRange("Location Code", Rec."Location Code");
        CCDLocationMapping.SetRange("Processing Type", CCDLocationMapping."Processing Type"::Vendor);

        if CCDLocationMapping.FindFirst() then
            CCDLocationMapping.TestField("Vendor No.");
    end;
}
