codeunit 52128 "12E Lead Accrual Reverse Mgt."
{
    procedure ReverseLeadAccrual(var PostedLeadAccrual: Record "12E Posted Lead Accrual")
    var
        ReversalEntry: Record "Reversal Entry";
    begin
        CheckReversalPermission();
        PostedLeadAccrual.TestField("G/L Register No.");

        if PostedLeadAccrual.Reversed then
            Error('Lead Accrual document %1 has already been reversed.', PostedLeadAccrual."No.");

        ReversalEntry.ReverseRegister(PostedLeadAccrual."G/L Register No.");
    end;

    local procedure CheckReversalPermission()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        if not UserSetup.Get(UserId) then
            Error('User Setup does not exist for user %1.', UserId);

        if not UserSetup."12E Allow Lead Accr. Reversal" then
            Error('You do not have permission to reverse Lead Accrual entries.');
    end;
}
