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
                }

                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                }
            }

            repeater(General)
            {
                Editable = false;

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Lead Provider"; Rec."Lead Provider")
                {
                    ToolTip = 'Specifies the value of the Lead Provider field.', Comment = '%';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Posted Purchase Invoice No."; Rec."Posted Purchase Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = all;
                }
                field("Prior Posting Date"; Rec."Prior Posting Date")
                {
                    ApplicationArea = All;
                }

                field("Lead Cost Amount"; Rec."Lead Cost Amount")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        LeadSource: Record "12E Lead Source Reconciliation";
                        CompanyMapping: Record "12E Company Mapping";
                        StartDate: Date;
                    begin
                        CompanyMapping.Reset();
                        CompanyMapping.SetRange(Company, CompanyName());

                        if not CompanyMapping.FindFirst() then
                            exit;

                        if Rec."Prior Posting Date" = 0D then
                            StartDate := DMY2Date(1, 1, 1900)
                        else
                            StartDate := CalcDate('<+1D>', Rec."Prior Posting Date");

                        LeadSource.Reset();
                        LeadSource.SetRange("Lead Provider", Rec."Lead Provider");
                        LeadSource.SetRange("Lead Original Date", StartDate, Rec."Posting Date");

                        Page.RunModal(Page::"12E Leads Data by Portfolio", LeadSource);
                    end;
                }

                field(Difference; Rec.Difference)
                {
                    ApplicationArea = All;
                    StyleExpr = DifferenceStyle;
                }

                field("Difference %"; Rec."Difference %")
                {
                    ApplicationArea = All;
                    StyleExpr = DifferenceStyle;
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
                    LeadValidationMgt: Codeunit "12E Lead Validation Mgt";
                begin
                    LeadValidationMgt.BuildValidationData(Rec, StartDate, EndDate);
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
                    LeadSource.SetRange("Lead Provider", Rec."Lead Provider");
                    LeadSource.SetRange("Lead Original Date", GetLeadSourceStartDate(), Rec."Posting Date");

                    Page.Run(Page::"12E Leads Data by Portfolio", LeadSource);
                end;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        DifferenceStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.Difference <> 0 then
            DifferenceStyle := 'Unfavorable'
        else
            DifferenceStyle := '';
    end;

    local procedure GetLeadSourceStartDate(): Date
    begin
        if Rec."Prior Posting Date" = 0D then
            exit(DMY2Date(1, 1, 1900));

        exit(CalcDate('<+1D>', Rec."Prior Posting Date"));
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
    end;
}