report 52113 "12E Create CCD Documents"
{
    Caption = 'Create CCD Documents';
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
            if (CloseAction = Action::OK) and
               (StartDate <> 0D) and
               (EndDate <> 0D) and
               (EndDate < StartDate)
            then
                Error('End Date cannot be earlier than Start Date.');

            exit(true);
        end;
    }

    trigger OnPreReport()
    var
        CCDMgt: Codeunit "12E CCD Mgmt";
    begin
        if StartDate = 0D then
            StartDate := 00000101D;

        if EndDate = 0D then
            EndDate := 99991231D;

        if EndDate < StartDate then
            Error('End Date cannot be earlier than Start Date.');

        CCDMgt.CreateCCDDocuments(StartDate, EndDate);
    end;

    var
        StartDate: Date;
        EndDate: Date;
}