page 52106 "12E EPIC Payments BatchSubform"
{
    ApplicationArea = All;
    Caption = '12E EPIC Payments BatchSubform';
    PageType = ListPart;
    SourceTable = "12E EPIC Payments Batch Line";
    UsageCategory = Lists;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

            }
        }
    }
}
