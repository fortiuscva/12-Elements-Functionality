page 52108 "12E Posted EPIC Payments Batch"
{
    ApplicationArea = All;
    Caption = '12E Posted EPIC Payments Batch';
    PageType = Document;
    SourceTable = "12E Pstd EPIC Pay Batch Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field.', Comment = '%';
                }
                field("Batch Date"; Rec."Batch Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
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
            part("Posted EPIC Payment Lines"; "12E Pstd EPIC Pay BatchSubform")
            {
                Caption = 'Lines';
                SubPageLink = "Batch No." = field("Batch No.");
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
        UserRec.Get(Rec.SystemCreatedBy);
        CreatedBy := UserRec."User Name";
    end;

    var
        CreatedBy: Code[50];
}
