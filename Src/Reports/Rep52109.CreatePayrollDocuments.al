report 52109 "12E Create Payroll Documents"
{
    Caption = 'Create Payroll Documents';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

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
                if StartDate = 0D then
                    Error('Start Date must be specified.');

                if EndDate = 0D then
                    Error('End Date must be specified.');

                if EndDate < StartDate then
                    Error('End Date cannot be earlier than Start Date.');
            end;

            exit(true);
        end;
    }

    trigger OnPreReport()
    var
        PayrollBatchMgmt: Codeunit "12E Payroll Batch Mgmt";
    begin
        PayrollBatchMgmt.CreatePayrollBatches(StartDate, EndDate);
    end;

    var
        StartDate: Date;
        EndDate: Date;
}