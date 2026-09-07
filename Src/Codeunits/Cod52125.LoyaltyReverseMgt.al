codeunit 52125 "12E Loyalty Reverse Mgt."
{
    procedure ReverseLoyalty(var LoyaltyPoints: Record "12E Loyalty Points")
    var
        ReversalEntry: Record "Reversal Entry";
    begin
        CheckReversalPermission();
        LoyaltyPoints.TestField("G/L Register No.");
        if LoyaltyPoints.Reversed then
            Error('Loyalty Point entry %1 has already been reversed.', LoyaltyPoints."PK ID");
        ReversalEntry.ReverseRegister(LoyaltyPoints."G/L Register No.");
    end;

    local procedure CheckReversalPermission()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        if not UserSetup.Get(UserId) then
            Error('User Setup does not exist for user %1.', UserId);
        if not UserSetup."12E Allow Loyalty Reversal" then
            Error('You do not have permission to reverse Loyalty Points.');
    end;
}