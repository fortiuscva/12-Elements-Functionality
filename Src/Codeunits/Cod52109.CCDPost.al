codeunit 52109 "12E CCD Post"
{
    procedure Post(var CCDHeader: Record "12E CCD Header")
    var
        CCDLine: Record "12E CCD Line";
        PostedCCDHeader: Record "12E Posted CCD Header";
        PostedCCDLine: Record "12E Posted CCD Line";
        CCDNo: Code[20];
    begin
        if not Confirm(
            'Do you want to post Contact Center Distribution document %1?',
            false,
            CCDHeader."No.")
        then
            exit;

        ValidatePosting(CCDHeader, CCDLine);

        CCDNo := CCDHeader."No.";

        PostedCCDHeader.Init();
        PostedCCDHeader.TransferFields(CCDHeader, true);
        PostedCCDHeader.Insert(true);

        CCDLine.SetRange("Document No.", CCDHeader."No.");
        if CCDLine.FindSet() then begin
            repeat
                PostedCCDLine.Init();
                PostedCCDLine.TransferFields(CCDLine, true);
                PostedCCDLine.Insert(true);
            until CCDLine.Next() = 0;
        end;

        // CCDLine.DeleteAll(true);
        CCDHeader.Delete(true);

        Message(
            'Contact Center Distribution document %1 posted successfully.',
            CCDNo);
    end;

    local procedure ValidatePosting(
        var CCDHeader: Record "12E CCD Header";
        CCDLine: Record "12E CCD Line")
    var
        TwelveSetup: Record "12E Setup";
    begin
        TwelveSetup.Get();

        if not TwelveSetup."Enable CCD Process" then
            Error('CCD Process is not enabled for this company.');

        CCDHeader.TestField(Status, CCDHeader.Status::Released);

        if (CCDHeader."Payroll Batch ID" = 0) and
           (CCDHeader."Invoice No." = '')
        then
            Error(
                'Either Payroll Batch ID or Posted Purchase Invoice No. must be specified for CCD %1.',
                CCDHeader."No.");

        CCDHeader.TestField("Period Start Date");
        CCDHeader.TestField("Period End Date");

        if CCDHeader."Period Start Date" > CCDHeader."Period End Date" then
            Error(
                'Period Start Date %1 cannot be later than Period End Date %2 for CCD %3.',
                CCDHeader."Period Start Date",
                CCDHeader."Period End Date",
                CCDHeader."No.");

        CCDLine.Reset();
        CCDLine.SetRange("Document No.", CCDHeader."No.");

        if CCDLine.IsEmpty() then
            Error(
                'There are no CCD lines to post for CCD %1.',
                CCDHeader."No.");

        CCDLine.SetFilter("Handling Time", '<>0');
        CCDLine.SetRange("Distributed Quantity", 0);

        if CCDLine.FindFirst() then
            Error(
                'Distributed Quantity must be specified when Handling Time is entered for CCD %1, Line %2.',
                CCDHeader."No.",
                CCDLine."Line No.");
    end;
}