page 52147 "12E Posted Payroll Document"
{
    ApplicationArea = All;
    Caption = 'Posted Payroll Document';
    PageType = Document;
    SourceTable = "12E Posted Payroll Header";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.', Comment = '%';
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period End Date field.', Comment = '%';
                }
                field("Batch Status"; Rec."Batch Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
                field("Created By"; CreatedBy)
                {
                    Caption = 'Created By';
                    ApplicationArea = All;
                }
            }
            part(Lines; "12E Posted Payroll Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    trigger OnOpenPage()
    var
        UserRec: Record User;
    begin
        Clear(CreatedBy);
        CreatedBy := '';
        UserRec.Reset();
        if UserRec.Get(Rec.SystemCreatedBy) then
            CreatedBy := UserRec."User Name";
    end;

    var
        CreatedBy: Code[50];
}
