report 52114 "12E Create CCD Doc. JQ"
{
    Caption = 'Create CCD Documents';
    ProcessingOnly = true;
    UsageCategory = None;

    trigger OnPreReport()
    var
        CCDMgt: Codeunit "12E CCD Mgmt";
    begin
        CCDMgt.CreateCCDDocuments(0D, 0D);
    end;
}