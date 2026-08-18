codeunit 52123 "12E Payroll Reverse Mgt."
{

    procedure ReversePayroll(
            var PostedPayrollHeader: Record "12E Posted Payroll Header")
    var
        ReversalEntry: Record "Reversal Entry";
        PayrollBatchHeader: Record "12E Payroll Batch Header";
    begin
        CheckReversalPermission();

        PostedPayrollHeader.TestField("G/L Register No.");

        if PostedPayrollHeader.Reversed then
            Error('Payroll document %1 has already been reversed.',
                PostedPayrollHeader."No.");

        if not Confirm('Do you want to reverse Payroll Document %1 and create a new Payroll Document?', false, PostedPayrollHeader."No.")
        then
            exit;

        ReversalEntry.ReverseRegister(PostedPayrollHeader."G/L Register No.");

        PostedPayrollHeader.Reversed := true;
        PostedPayrollHeader.Modify(true);

        CreatePayrollDocument(PostedPayrollHeader);

        Message(
            'Payroll Document %1 was reversed and new Payroll Document %2 was created.',
            PostedPayrollHeader."No.",
            PayrollBatchHeader."No.");
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

        if not UserSetup."12E Allow Pay Doc. Reversal" then
            Error(
                'You do not have permission to reverse Payroll Documents.');
    end;

    local procedure CreatePayrollDocument(
     PostedPayrollHeader: Record "12E Posted Payroll Header")
    var
        PayrollBatchHeader: Record "12E Payroll Batch Header";
        PostedPayrollLine: Record "12E Posted Payroll Line";
        PayrollBatchLine: Record "12E Payroll Batch Line";
    begin
        PayrollBatchHeader.Init();
        PayrollBatchHeader.TransferFields(PostedPayrollHeader, true);

        PayrollBatchHeader."No." := '';
        PayrollBatchHeader.Status := PayrollBatchHeader.Status::Open;

        Clear(PayrollBatchHeader."G/L Register No.");
        Clear(PayrollBatchHeader."Posting Error");

        PayrollBatchHeader.Insert(true);

        PostedPayrollLine.Reset();
        PostedPayrollLine.SetRange("Document No.", PostedPayrollHeader."No.");
        if PostedPayrollLine.FindSet() then
            repeat
                PayrollBatchLine.Init();
                PayrollBatchLine.TransferFields(PostedPayrollLine, true);
                PayrollBatchLine."Document No." := PayrollBatchHeader."No.";
                PayrollBatchLine.Insert(true);
            until PostedPayrollLine.Next() = 0;
    end;
}
