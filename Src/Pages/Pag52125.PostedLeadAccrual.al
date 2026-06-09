page 52125 "12E Posted Lead Accrual"
{
    ApplicationArea = All;
    Caption = 'Posted Lead Accrual';
    PageType = Document;
    SourceTable = "12E Posted Lead Accrual";
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
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                // field(Status; Rec.Status)
                // {
                //     ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                // }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Created At';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(CreatedBy; CreatedBy)
                {
                    Caption = 'Created By';
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
            }
            part(Lines; "12E Posted LeadAccrual Subform")
            {
                Caption = 'Lines';
                ApplicationArea = all;
                SubPageLink = "Lead Accrual No." = field("No.");
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