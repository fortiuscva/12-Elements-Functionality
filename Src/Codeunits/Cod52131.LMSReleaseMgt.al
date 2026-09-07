codeunit 52131 "12E LMS Release Mgt."
{
    TableNo = "12E LMS Transaction Header";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    begin
        // Validation check before release
        CheckForManualRelease(LMSTransactionHeader);

        // Perform the actual release
        PerformManualCheckAndRelease(LMSTransactionHeader);
    end;

    local procedure CheckForManualRelease(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    var
        AlreadyReleasedErrorLbl: Label 'LMS Transaction Document %1 is already Released';
    begin
        if LMSTransactionHeader.Status = LMSTransactionHeader.Status::Released then
            Error(StrSubstNo(AlreadyReleasedErrorLbl, LMSTransactionHeader."No."));
    end;

    local procedure PerformManualCheckAndRelease(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    var
        ReleasedDocumentsErrorLbl: Label 'Only Open LMS Transaction Documents can be Released. Document %1 skipped.';
    begin
        if LMSTransactionHeader.Status <> LMSTransactionHeader.Status::Open then
            Error(StrSubstNo(ReleasedDocumentsErrorLbl, LMSTransactionHeader."No."));

        LMSTransactionHeader.Status := LMSTransactionHeader.Status::Released;
        LMSTransactionHeader.Modify(true);
    end;

    procedure PerformManualReopen(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    begin
        // Validation check before reopen
        CheckForManualReopen(LMSTransactionHeader);

        // Perform the actual reopen
        PerformManualCheckAndReopen(LMSTransactionHeader);
    end;

    local procedure CheckForManualReopen(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    var
        AlreadyOpenErrorLbl: Label 'LMS Transaction Document %1 is already Open';
    begin
        if LMSTransactionHeader.Status = LMSTransactionHeader.Status::Open then
            Error(StrSubstNo(AlreadyOpenErrorLbl, LMSTransactionHeader."No."));
    end;

    local procedure PerformManualCheckAndReopen(var LMSTransactionHeader: Record "12E LMS Transaction Header")
    var
        OpenDocumentsErrorLbl: Label 'Only Released LMS Transaction Documents can be reopened. Document %1 skipped.';
    begin
        if LMSTransactionHeader.Status = LMSTransactionHeader.Status::Open then
            Error(StrSubstNo(OpenDocumentsErrorLbl, LMSTransactionHeader."No."));

        LMSTransactionHeader.Status := LMSTransactionHeader.Status::Open;
        LMSTransactionHeader.Modify(true);
    end;
}
