
report 52109 "12E Create Payroll Documents"
{
    Caption = 'Create Payroll Documents';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = Action::OK then begin
                if (StartDate <> 0D) and
                   (EndDate <> 0D) and
                   (EndDate < StartDate)
                then
                    Error('End Date cannot be earlier than Start Date.');

                if (StartDate <> 0D) or (EndDate <> 0D) then
                    if (StartDate = 0D) or (EndDate = 0D) then
                        Error('Start Date and End Date cannot be blank.');
            end;

            exit(true);
        end;
    }

    trigger OnPreReport()
    var
        PayrollBatchMgmt: Codeunit "12E Payroll Batch Mgmt";
        LoyaltyPreviewContext: Codeunit "12E Suppress Preview Post";
        PreviewError: Text;
    begin
        ValidateDateRange();

        if not TryPreviewPayrollBatches() then begin
            PreviewError := GetLastErrorText();
            LoyaltyPreviewContext.SetSuppressPreviewEntries(false);

            if PreviewError <> '' then
                Error(PreviewError);

        end;

        LoyaltyPreviewContext.SetSuppressPreviewEntries(false);

        PayrollBatchMgmt.CreatePayrollBatches(StartDate, EndDate);
    end;

    var
        StartDate: Date;
        EndDate: Date;

    local procedure ValidateDateRange()
    begin
        if (StartDate <> 0D) or (EndDate <> 0D) then
            if (StartDate = 0D) or (EndDate = 0D) then
                Error('Start Date and End Date cannot be blank.');

        if (StartDate <> 0D) and
           (EndDate <> 0D) and
           (EndDate < StartDate)
        then
            Error('End Date cannot be earlier than Start Date.');
    end;

    [TryFunction]
    local procedure TryPreviewPayrollBatches()
    var
        PayrollBatchMgmt: Codeunit "12E Payroll Batch Mgmt";
        LoyaltyPreviewContext: Codeunit "12E Suppress Preview Post";
    begin
        LoyaltyPreviewContext.SetSuppressPreviewEntries(true);
        PayrollBatchMgmt.PreviewPayrollBatches(StartDate, EndDate);
    end;
}
