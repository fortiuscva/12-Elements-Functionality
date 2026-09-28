page 52121 "12E Leads Reconciliations"
{
    PageType = Worksheet;
    SourceTable = "12E Lead Validation Details";
    Caption = 'Leads Reconciliations';
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTableTemporary = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Options)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';

                    trigger OnValidate()
                    begin
                        if StartDate = PreviousStartDate then
                            exit;

                        if not Rec.IsEmpty() then begin
                            if not Confirm(DateChangeConfirmQst, false) then begin
                                StartDate := PreviousStartDate;
                                exit;
                            end;

                            Rec.DeleteAll();
                        end;

                        PreviousStartDate := StartDate;
                    end;
                }

                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';

                    trigger OnValidate()
                    begin
                        if EndDate = PreviousEndDate then
                            exit;

                        if not Rec.IsEmpty() then begin
                            if not Confirm(DateChangeConfirmQst, false) then begin
                                EndDate := PreviousEndDate;
                                exit;
                            end;

                            Rec.DeleteAll();
                        end;

                        PreviousEndDate := EndDate;
                    end;
                }
            }

            repeater(General)
            {
                Editable = false;

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }

                field("Lead Vendor"; Rec."Lead Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Vendor field.', Comment = '%';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }

                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Invoice No. field.', Comment = '%';
                }

                field("Posted Purchase Invoice No."; Rec."Posted Purchase Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Purchase Invoice No. field.', Comment = '%';
                }

                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Amount field.', Comment = '%';
                }

                field("Lead Period Start Date"; Rec."Lead Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Period Start Date field.', Comment = '%';
                }

                field("Lead Period End Date"; Rec."Lead Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Period End Date field.', Comment = '%';
                }

                field("Lead Cost Amount"; Rec."Lead Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Cost Amount field.', Comment = '%';

                    trigger OnDrillDown()
                    var
                        LeadSource: Record "12E Lead Source Reconciliation";
                        CompanyMapping: Record "12E Company Mapping";
                    begin
                        CompanyMapping.Reset();
                        CompanyMapping.SetRange(Company, CompanyName());

                        if not CompanyMapping.FindFirst() then
                            exit;

                        LeadSource.Reset();
                        LeadSource.SetRange("Lead Vendor", Rec."Lead Vendor");
                        LeadSource.SetRange(
                            "Lead Original Date",
                            Rec."Lead Period Start Date",
                            Rec."Lead Period End Date");

                        Page.RunModal(Page::"12E Leads Data by Portfolio", LeadSource);
                    end;
                }

                field(Difference; Rec.Difference)
                {
                    ApplicationArea = All;
                    StyleExpr = DifferenceStyle;
                    ToolTip = 'Specifies the value of the Difference field.', Comment = '%';
                }

                field("Difference %"; Rec."Difference %")
                {
                    ApplicationArea = All;
                    StyleExpr = DifferenceStyle;
                    ToolTip = 'Specifies the value of the Difference % field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Get Invoice Data")
            {
                Caption = 'Get Invoice Data';
                ApplicationArea = All;
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LeadsReconciliation: Report "12E Leads Reconciliation";
                begin
                    if StartDate = 0D then
                        Error('Start Date must be entered.');

                    if EndDate = 0D then
                        Error('End Date must be entered.');

                    if EndDate < StartDate then
                        Error('End Date cannot be earlier than Start Date.');

                    LeadsReconciliation.SetDateFilters(StartDate, EndDate);
                    LeadsReconciliation.RunModal();

                    Rec.DeleteAll();
                    LeadsReconciliation.GetValidationData(Rec);

                    PreviousStartDate := StartDate;
                    PreviousEndDate := EndDate;

                    CurrPage.Update(false);
                end;
            }

            action(OpenLeadReconciliationSource)
            {
                ApplicationArea = All;
                Caption = 'Open Lead Reconciliation Source';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LeadSource: Record "12E Lead Source Reconciliation";
                    CompanyMapping: Record "12E Company Mapping";
                begin
                    CompanyMapping.Reset();
                    CompanyMapping.SetRange(Company, CompanyName());

                    if not CompanyMapping.FindFirst() then
                        Error('Data Source ID is not configured for company %1.', CompanyName());

                    LeadSource.Reset();
                    LeadSource.SetRange("Lead Vendor", Rec."Lead Vendor");
                    LeadSource.SetRange(
                        "Lead Original Date",
                        Rec."Lead Period Start Date",
                        Rec."Lead Period End Date");

                    Page.Run(Page::"12E Leads Data by Portfolio", LeadSource);
                end;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        DifferenceStyle: Text;
        DateChangeConfirmQst: Label 'Changing the reconciliation period will delete the existing reconciliation lines. Do you want to continue?';

    trigger OnAfterGetRecord()
    begin
        if Rec.Difference <> 0 then
            DifferenceStyle := 'Unfavorable'
        else
            DifferenceStyle := '';
    end;

    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);

        if not CompanyMapping.FindFirst() then
            Error('%1 is not mapped to any data source id in 12 elements setup.', CompanyName());

        Rec.FilterGroup(10);
        Rec.SetRange("Datasource ID", CompanyMapping."DataSource ID");
        Rec.FilterGroup(0);

        PreviousStartDate := StartDate;
        PreviousEndDate := EndDate;
    end;
}