page 52154 "12E QPAY Batches"
{
    ApplicationArea = All;
    Caption = 'Payroll Batches';
    PageType = List;
    SourceTable = "12E Questco Payroll Batch";
    SourceTableView = sorting(PKID) order(descending);
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PKID; Rec.PKID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PKID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                }
                field("Batch Status"; Rec."Batch Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
                field("Pay Group ID"; Rec."Pay Group ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Group ID field.', Comment = '%';
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.', Comment = '%';
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period End Date field.', Comment = '%';
                }
                field("Weeks Worked"; Rec."Weeks Worked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weeks Worked field.', Comment = '%';
                    Visible = false;
                }
                field(CCHours; Functions.GetContactCenterHours(Rec."Client ID", Rec."Batch ID", GetDepartmentCode()))
                {
                    ApplicationArea = All;
                    Caption = 'Contact Center Hours';
                }
                field("CCD No."; Rec."CCD No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CC Processed field.', Comment = '%';
                    Editable = false;
                }
                field("Posted CCD No."; Rec."Posted CCD No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted CCD Exists field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Doc. No."; Rec."Payroll Doc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Posted Payroll Doc. No."; Rec."Posted Payroll Doc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Payroll Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                }
                field("ERP Status"; Rec."ERP Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                }
                field("ERP Error Message"; Rec."ERP Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ERP Error Message field.', Comment = '%';
                }
                field("ETL Batch ID"; Rec."ETL Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETL Batch ID field.', Comment = '%';
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Created At';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Modified At';
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ShowTransactions)
            {
                ApplicationArea = All;
                Caption = 'Show Transactions';
                Image = Transactions;
                ShortCutKey = 'Return';
                trigger OnAction()
                var
                    PayrollTxn: Record "12E Questco Payroll Txn";
                begin
                    PayrollTxn.Reset();
                    PayrollTxn.FilterGroup := 8;
                    PayrollTxn.SetRange("Batch ID", Rec."Batch ID");
                    PayrollTxn.SetRange("Pay Period Start Date", Rec."Pay Period Start Date");
                    PayrollTxn.SetRange("Pay Period End Date", Rec."Pay Period End Date");
                    Page.Run(Page::"12E QPAY Transactions", PayrollTxn);
                end;
            }
            action(ShowContactCenterHours)
            {
                ApplicationArea = All;
                Caption = 'Show Contact Center Hours';
                Ellipsis = true;
                Image = ServiceHours;
                trigger OnAction()
                var
                    PayrollTxn: Record "12E Questco Payroll Txn";
                begin
                    PayrollTxn.Reset();
                    PayrollTxn.SetRange("Client ID", Rec."Client ID");
                    PayrollTxn.SetRange("Batch ID", Rec."Batch ID");
                    PayrollTxn.SetRange("Department Code", GetDepartmentCode());
                    PayrollTxn.SetFilter("Hours Worked", '>%1', 0);
                    Page.Run(Page::"12E QPAY Transactions", PayrollTxn);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {

                Caption = 'Process';
                actionref(ShowTransactions_Promoted; ShowTransactions)
                {
                }
                actionref(ShowContactCenterHours_Promoted; ShowContactCenterHours)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        CompanyMapping: Record "12E Company Mapping";
    begin
        CompanyMapping.Reset();
        CompanyMapping.SetRange(Company, CompanyName());
        if CompanyMapping.FindLast() then begin
            Rec.FilterGroup(8);
            Rec.SetRange("Client ID", CompanyMapping."Client ID");
        end;
    end;

    local procedure GetDepartmentCode(): Code[20]
    var
        DepartmentCode: Record "12E Department Code";
    begin
        DepartmentCode.Reset();
        DepartmentCode.SetRange("Contact Center", true);

        if DepartmentCode.FindFirst() then
            exit(DepartmentCode.Code);
    end;


    var
        Functions: Codeunit "12E Functions";
}
