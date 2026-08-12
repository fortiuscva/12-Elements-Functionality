pageextension 52107 "12E Purchase Invoice" extends "Purchase Invoice"
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
            }
        }
    }
}
