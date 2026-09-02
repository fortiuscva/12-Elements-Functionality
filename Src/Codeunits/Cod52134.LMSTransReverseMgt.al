codeunit 52134 "12E LMS Trans. Reverse Mgt."
{
    procedure ReverseLMS(var PostedLMSTransaction: Record "12E Posted LMS Trans. Header")
    var
        ReversalEntry: Record "Reversal Entry";
    begin
        CheckReversalPermission();

        PostedLMSTransaction.TestField("G/L Register No.");

        if PostedLMSTransaction.Reversed then
            Error(
                'LMS Transaction entry %1 has already been reversed.',
                PostedLMSTransaction."No.");

        ReversalEntry.ReverseRegister(
            PostedLMSTransaction."G/L Register No.");
    end;

    local procedure CheckReversalPermission()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();

        if not UserSetup.Get(UserId) then
            Error(
                'User Setup does not exist for user %1.',
                UserId);

        if not UserSetup."12E Allow LMS Reversal" then
            Error(
                'You do not have permission to reverse LMS Transaction entries.');
    end;
}