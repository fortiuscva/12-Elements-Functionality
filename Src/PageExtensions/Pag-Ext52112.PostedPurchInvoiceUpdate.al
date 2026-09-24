pageextension 52112 "Posted Purch. Invoice - Update" extends "Posted Purch. Invoice - Update"
{
    layout
    {
        addafter(Shipping)
        {
            group("12E Leads")
            {
                Caption = 'Leads';

                field("12E Lead Period Start Date"; Rec."12E Lead Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the lead invoice period.';
                }

                field("12E Lead Period End Date"; Rec."12E Lead Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the lead invoice period.';
                }
            }
        }
    }
}
