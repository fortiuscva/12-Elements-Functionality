page 52119 "12E CCD Allocation Details"
{
    ApplicationArea = All;
    Caption = '12E CCD Allocation Details';
    PageType = List;
    SourceTable = "12E CCD Allocation Details";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("CCD No."; Rec."CCD No.")
                {
                    ToolTip = 'Specifies the value of the CCD No. field.', Comment = '%';
                }
                field("CCD Location"; Rec."CCD Location")
                {
                    ToolTip = 'Specifies the value of the CCD Location field.', Comment = '%';
                }
                field("CCD Location Hours"; Rec."CCD Location Hours")
                {
                    ToolTip = 'Specifies the value of the CCD Location Hours field.', Comment = '%';
                }
                field("CCD Start Date"; Rec."CCD Start Date")
                {
                    ToolTip = 'Specifies the value of the CCD Start Date field.', Comment = '%';
                }
                field("CCD End date"; Rec."CCD End Date")
                {
                    ToolTip = 'Specifies the value of the CCD End Date field.', Comment = '%';
                }
            }
        }
    }
}
