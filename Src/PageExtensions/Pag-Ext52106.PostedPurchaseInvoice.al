pageextension 52106 "12E Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Shipping and Payment")
        {
            group("12E Contact Center Distribution")
            {
                Caption = 'Contact Center Distribution [CCD]';

                field("12E Period Start Date"; Rec."12E Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                }
                field("12E Period End Date"; Rec."12E Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                }
                field("12E Period Quantity"; Rec."12E Period Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Quantity field.', Comment = '%';
                }
                field("12E CCD Line Exists"; Rec."12E CCD Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CCD Line Exists field.', Comment = '%';
                }
                field("12E Posted CCD Line Exists"; Rec."12E Posted CCD Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted CCD Line Exists field.', Comment = '%';
                }
            }
        }
    }
}
