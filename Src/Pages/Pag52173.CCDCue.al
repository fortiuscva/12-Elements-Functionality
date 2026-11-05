page 52173 "12E CCD Cue"
{
    ApplicationArea = All;
    Caption = 'CCD Activities';
    PageType = CardPart;
    SourceTable = "12E CCD Cue";

    layout
    {
        area(Content)
        {
            cuegroup(General)
            {
                Caption = 'General';

                /*field("Primary Key"; Rec."Primary Key")
                {
                    ToolTip = 'Specifies the value of the Primary Key field.', Comment = '%';
                }*/
                field("CCD Documents"; Rec."CCD Documents")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "12E CCD Details";
                    ToolTip = 'Specifies the value of the CCD Account field.', Comment = '%';
                }
                field("Posted CCD Documents"; Rec."Posted CCD Documents")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "12E Posted CCD Details";
                    ToolTip = 'Specifies the value of the Posted CCD Account field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get('12E CCD Cue') then begin
            Rec.Init();
            Rec."Primary Key" := '12E CCD Cue';
            Rec.Insert();
        end;

        Rec.CalcFields("CCD Documents", "Posted CCD Documents");
    end;
}
