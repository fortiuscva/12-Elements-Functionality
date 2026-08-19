report 52101 "12E Delete CCD Lines"
{
    ApplicationArea = All;
    Caption = 'Delete CCD Lines';
    UsageCategory = None;
    ProcessingOnly = true;
    dataset
    {
        dataitem(CCDLine; "12E CCD Line")
        {
            RequestFilterFields = "Document No.", "Line No.";
            trigger OnAfterGetRecord()
            begin
                CCDLine.Delete(true);
            end;
        }
    }
}
