page 52111 "12E EPIC Payments"
{
    ApplicationArea = All;
    Caption = 'EPIC Payments';
    PageType = List;
    SourceTable = "12E EPIC Payment";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Data Source ID"; Rec."Data Source ID")
                {
                    ToolTip = 'Specifies the value of the Data Source ID field.', Comment = '%';
                }
                field("Payments ID"; Rec."Payments ID")
                {
                    ToolTip = 'Specifies the value of the Payments ID field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
                }
                field(Principal; Rec.Principal)
                {
                    ToolTip = 'Specifies the value of the Principal field.', Comment = '%';
                }
                field("Late Fee"; Rec."Late Fee")
                {
                    ToolTip = 'Specifies the value of the Late Fee field.', Comment = '%';
                }
                field("NSF Fee"; Rec."NSF Fee")
                {
                    ToolTip = 'Specifies the value of the NSF Fee field.', Comment = '%';
                }
                field("Return Code"; Rec."Return Code")
                {
                    ToolTip = 'Specifies the value of the Return Code field.', Comment = '%';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Specifies the value of the Return Date field.', Comment = '%';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ToolTip = 'Specifies the value of the Payment Status field.', Comment = '%';
                }
                field(IsDebit; Rec.IsDebit)
                {
                    ToolTip = 'Specifies the value of the IsDebit field.', Comment = '%';
                }
                field("Success Date"; Rec."Success Date")
                {
                    ToolTip = 'Specifies the value of the Success Date field.', Comment = '%';
                }
                field("Is Origination"; Rec."Is Origination")
                {
                    ToolTip = 'Specifies the value of the Is Origination field.', Comment = '%';
                }
                field("Credit Reason"; Rec."Credit Reason")
                {
                    ToolTip = 'Specifies the value of the Credit Reason field.', Comment = '%';
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ToolTip = 'Specifies the value of the Loan ID field.', Comment = '%';
                }
                field("Finance Fee"; Rec."Finance Fee")
                {
                    ToolTip = 'Specifies the value of the Finance Fee field.', Comment = '%';
                }
                field("Fees Amount"; Rec."Fees Amount")
                {
                    ToolTip = 'Specifies the value of the Fees Amount field.', Comment = '%';
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    ToolTip = 'Specifies the value of the Payment Amount field.', Comment = '%';
                }
                field("ACH Endpoint"; Rec."ACH Endpoint")
                {
                    ToolTip = 'Specifies the value of the ACH Endpoint field.', Comment = '%';
                }
                field("Assigned Agent"; Rec."Assigned Agent")
                {
                    ToolTip = 'Specifies the value of the Assigned Agent field.', Comment = '%';
                }
                field("Payment Agent"; Rec."Payment Agent")
                {
                    ToolTip = 'Specifies the value of the Payment Agent field.', Comment = '%';
                }
                field("Authorization Type"; Rec."Authorization Type")
                {
                    ToolTip = 'Specifies the value of the Authorization Type field.', Comment = '%';
                }
                field("Service Fee"; Rec."Service Fee")
                {
                    ToolTip = 'Specifies the value of the Service Fee field.', Comment = '%';
                }
                field("Service Fee Interest"; Rec."Service Fee Interest")
                {
                    ToolTip = 'Specifies the value of the Service Fee Interest field.', Comment = '%';
                }
                field("Origination Fee"; Rec."Origination Fee")
                {
                    ToolTip = 'Specifies the value of the Origination Fee field.', Comment = '%';
                }
                field("Management Fee"; Rec."Management Fee")
                {
                    ToolTip = 'Specifies the value of the Management Fee field.', Comment = '%';
                }
                field("Maintenance Fee"; Rec."Maintenance Fee")
                {
                    ToolTip = 'Specifies the value of the Maintenance Fee field.', Comment = '%';
                }
                field("Is Makeup"; Rec."Is Makeup")
                {
                    ToolTip = 'Specifies the value of the Is Makeup field.', Comment = '%';
                }
                field("Is Additional Payment"; Rec."Is Additional Payment")
                {
                    ToolTip = 'Specifies the value of the Is Additional Payment field.', Comment = '%';
                }
                field("Is Payoff Payment"; Rec."Is Payoff Payment")
                {
                    ToolTip = 'Specifies the value of the Is Payoff Payment field.', Comment = '%';
                }
                field("Debit Card Endpoint Name"; Rec."Debit Card Endpoint Name")
                {
                    ToolTip = 'Specifies the value of the Debit Card Endpoint Name field.', Comment = '%';
                }
                field("RTT Return Code"; Rec."RTT Return Code")
                {
                    ToolTip = 'Specifies the value of the RTT Return Code field.', Comment = '%';
                }
            }
        }
    }
}
