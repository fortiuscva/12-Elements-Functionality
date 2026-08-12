codeunit 52109 "12E CCD Post"
{
    procedure Post(var CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
        PostedCCDHeader: Record "12E Posted CCD Header";
        PostedCCDLine: Record "12E Posted CCD Line";
        CCDNo: Code[20];
    begin
        CCDHeader.TestField(Status, CCDHeader.Status::Released);

        CCDNo := CCDHeader."No.";

        CCDLine.Reset();
        CCDLine.SetRange("Document No.", CCDNo);

        if CCDLine.IsEmpty() then
            Error(
                'There are no CCD lines to post for CCD %1.',
                CCDNo);

        PostedCCDHeader.Init();
        PostedCCDHeader.TransferFields(CCDHeader, true);
        PostedCCDHeader.Insert(true);

        if CCDLine.FindSet() then
            repeat
                PostedCCDLine.Init();
                PostedCCDLine.TransferFields(CCDLine, true);
                PostedCCDLine.Insert(true);
            until CCDLine.Next() = 0;

        CCDLine.DeleteAll(true);
        CCDHeader.Delete(true);

        Message(
            'Contact Center Distribution document %1 posted successfully.',
            CCDNo);
    end;
}