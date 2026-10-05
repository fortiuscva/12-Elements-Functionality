page 52163 "12E LMS Transactions"
{
    ApplicationArea = All;
    Caption = 'LMS Transactions';
    PageType = List;
    SourceTable = "12E LMS Transaction";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PK ID"; Rec."PK ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique PK ID of the LMS transaction.';
                }

                field("Transaction Posting Date"; Rec."Transaction Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Transaction Posting Date';
                    ToolTip = 'Specifies the posting date of the LMS transaction.';
                }

                field("Transaction ID"; Rec."Transaction ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Transaction ID.';
                }

                // field("Transaction Date"; Rec."Transaction Date")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Transaction Date Time';
                //     ToolTip = 'Specifies the date and time of the transaction.';
                // }

                field("Datasource ID"; Rec."Datasource ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Datasource ID.';
                }

                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Loan ID.';
                }

                field("Payment ID"; Rec."Payment ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payment ID.';
                }

                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Batch ID.';
                }

                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the State dimension.';
                }

                field(Store; Rec.Store)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Store dimension.';
                }

                field(Processor; Rec.Processor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Processor dimension.';
                }

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Transaction Code dimension.';
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payment Type.';
                }

                field("Payment Agent"; Rec."Payment Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payment Agent.';
                }

                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Loan Status.';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction amount.';
                }

                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Debit G/L Account No.';
                }

                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Credit G/L Account No.';
                }

                field("ERP Status"; Rec."ERP Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ERP processing status.';
                }

                field("ERP Error Message"; Rec."ERP Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ERP error message.';
                }

                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Register No.';
                }
                field("LMS Transaction Document No."; Rec."LMS Transaction Document No.")
                {
                    ApplicationArea = all;
                }
                field("Posted LMS Trans. Document No."; Rec."Posted LMS Trans. Document No.")
                {
                    ApplicationArea = all;
                }

                field("DW Load Date"; Rec."DW Load Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the transaction was loaded from the data warehouse.';
                }

                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the data warehouse export timestamp.';
                }

                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the transaction was imported into the ERP.';
                }

                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the export batch ID.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.SetRange(Company, CompanyName());
        CompanyMapping.SetFilter("DataSource ID", '<>%1', 0);

        if not CompanyMapping.FindFirst() then
            Error(
                '%1 is not mapped to any data source id in 12 elements setup.',
                CompanyName());

        Rec.FilterGroup(10);
        Rec.SetRange("Datasource ID", CompanyMapping."DataSource ID");
        Rec.FilterGroup(0);
    end;
}