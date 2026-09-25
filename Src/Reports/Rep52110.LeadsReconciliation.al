report 52110 "12E Leads Reconciliation"
{
    Caption = 'Leads Reconciliation';
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                Vendor.SetRange("12E Lead Reconciliation", true);
            end;

            trigger OnAfterGetRecord()
            begin
                LeadValidationMgt.BuildValidationData(LeadValidationPar, StartDate, EndDate, Vendor);
            end;
        }
    }

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
                    Error('Start Date must be entered.');

                if EndDate = 0D then
                    Error('End Date must be entered.');

                if EndDate < StartDate then
                    Error('End Date cannot be earlier than Start Date.');
            end;

            exit(true);
        end;
    }

    var
        LeadValidationMgt: Codeunit "12E Lead Validation Mgt";
        LeadValidationPar: Record "12E Lead Validation Details";
        StartDate: Date;
        EndDate: Date;

    procedure SetDateFilters(NewStartDate: Date; NewEndDate: Date)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;
}
