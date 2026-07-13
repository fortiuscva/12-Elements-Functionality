page 52121 "12E Lead Validation Details"
{
    PageType = Worksheet;
    SourceTable = "12E Lead Validation Details";
    Caption = 'Lead Validation Details';
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTableTemporary = true;

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
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
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
                }

                field(Difference; Rec.Difference)
                {
                    ApplicationArea = All;
                    StyleExpr = DifferenceStyle;
                }

                field("Difference %"; Rec."Difference %")
                {
                    ApplicationArea = All;
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

                trigger OnAction()
                var
                    LeadValidationMgt: Codeunit "12E Lead Validation Mgt";
                begin
                    LeadValidationMgt.BuildValidationData(StartDate, EndDate);
                    CurrPage.Update(false);
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
}