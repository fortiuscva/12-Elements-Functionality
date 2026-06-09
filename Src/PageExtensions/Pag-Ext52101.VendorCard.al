pageextension 52101 "12E Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(Receiving)
        {
            group("12E Leads")
            {
                Caption = 'Leads';
                field("12E Lead Acquisition"; Rec."12E Lead Acquisition")
                {
                    ApplicationArea = All;
                }

                field("12E Lead Billing Terms"; Rec."12E Lead Billing Terms")
                {
                    ApplicationArea = All;
                }

                field("12E Lead Accrual Vendor"; Rec."12E Lead Accrual Vendor")
                {
                    ApplicationArea = All;
                }

                field("12E Lead Acquisition Vendor No."; Rec."12E Lead Acq. Vendor No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
