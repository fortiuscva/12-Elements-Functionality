page 52163 "12E LMS Transactions"
{
    ApplicationArea = All;
    Caption = 'LMS Transactions';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                    ToolTip = 'Specifies the value of the PK ID field.', Comment = '%';
                }
                field("DW Load Date"; Rec."DW Load Date")
                {
                    ToolTip = 'Specifies the value of the DW Load Date field.', Comment = '%';
                }
                field("Datasource ID"; Rec."Datasource ID")
                {
                    ToolTip = 'Specifies the value of the Datasource ID field.', Comment = '%';
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ToolTip = 'Specifies the value of the Loan ID field.', Comment = '%';
                }
                field("Payment ID"; Rec."Payment ID")
                {
                    ToolTip = 'Specifies the value of the Payment ID field.', Comment = '%';
                }
                field("Transaction ID"; Rec."Transaction ID")
                {
                    ToolTip = 'Specifies the value of the Transaction ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
                }
                field("Payment Agent"; Rec."Payment Agent")
                {
                    ToolTip = 'Specifies the value of the Payment Agent field.', Comment = '%';
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ToolTip = 'Specifies the value of the Loan Status field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(Store; Rec.Store)
                {
                    ToolTip = 'Specifies the value of the Store field.', Comment = '%';
                }
                field(Processor; Rec.Processor)
                {
                    ToolTip = 'Specifies the value of the Processor field.', Comment = '%';
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.', Comment = '%';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ToolTip = 'Specifies the value of the Debit Account No. field.', Comment = '%';
                }
                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ToolTip = 'Specifies the value of the Credit Account No. field.', Comment = '%';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ToolTip = 'Specifies the value of the G/L Register No. field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field("ERP Status"; Rec."ERP Status")
                {
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                }
                field("ERP Error Message"; Rec."ERP Error Message")
                {
                    ToolTip = 'Specifies the value of the ERP Error Message field.', Comment = '%';
                }
                field("Export Batch ID"; Rec."Export Batch ID")
                {
                    ToolTip = 'Specifies the value of the Export Batch ID field.', Comment = '%';
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
            Error('%1 is not mapped to any data source id in 12 elements setup.', CompanyName());

        Rec.FilterGroup(10);
        Rec.SetRange("Datasource ID", CompanyMapping."DataSource ID");
        Rec.FilterGroup(0);
    end;
}
