page 52176 "12E Bank Staging"
{
    ApplicationArea = All;
    Caption = 'Bank Staging';
    PageType = List;
    SourceTable = "12E Bank Staging";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PKID; Rec.PKID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PKID field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field(Portfolio; Rec.Portfolio)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio field.', Comment = '%';
                }
                field(DdaAccount; Rec.DdaAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check No. field.', Comment = '%';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Description field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Balance field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);
        if not CompanyMapping.FindFirst() then
            Error('%1 is not mapped to any portfolio in 12 elements setup.', CompanyName());

        Rec.FilterGroup(10);
        Rec.SetRange("Datasource ID", CompanyMapping."DataSource ID");
        Rec.FilterGroup(0);
    end;
}
