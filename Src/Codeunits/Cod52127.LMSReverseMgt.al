codeunit 52127 "12E LMS Reverse Mgt."
{
    procedure ReverseLMS(var LMSBatch: Record "12E LMS Batch")
    var
        ReversalEntry: Record "Reversal Entry";
    begin
        CheckReversalPermission();
        LMSBatch.TestField("G/L Register No.");

        if LMSBatch.Reversed then
            Error('LMS Batch entry %1 has already been reversed.', LMSBatch."PK ID");

        ReversalEntry.ReverseRegister(LMSBatch."G/L Register No.");
    end;

    local procedure CheckReversalPermission()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        if not UserSetup.Get(UserId) then
            Error('User Setup does not exist for user %1.', UserId);

        if not UserSetup."12E Allow LMS Reversal" then
            Error('You do not have permission to reverse LMS Batch entries.');
    end;
}