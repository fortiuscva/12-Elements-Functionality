page 52173 "12E Global Setup"
{
    Caption = 'Global Setup';
    PageType = Card;
    SourceTable = "12E Global Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Manual Banking Entry PK ID's"; Rec."Manual Banking Entry PK ID's")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No. Series used for manually generated Banking PK IDs.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}