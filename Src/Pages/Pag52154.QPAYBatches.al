page 52154 "12E QPAY Batches"
{
    ApplicationArea = All;
    Caption = 'Questco Payroll Batches';
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
                    ToolTip = 'Specifies the value of the PKID field.', Comment = '%';
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ToolTip = 'Specifies the value of the Pay Date field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                }
                field("Batch Status"; Rec."Batch Status")
                {
                    ToolTip = 'Specifies the value of the Batch Status field.', Comment = '%';
                }
                field("Pay Group ID"; Rec."Pay Group ID")
                {
                    ToolTip = 'Specifies the value of the Pay Group ID field.', Comment = '%';
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.', Comment = '%';
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period End Date field.', Comment = '%';
                }
                field("Weeks Worked"; Rec."Weeks Worked")
                {
                    ToolTip = 'Specifies the value of the Weeks Worked field.', Comment = '%';
                }
                field("CCD No."; Rec."CCD No.")
                {
                    ToolTip = 'Specifies the value of the CC Processed field.', Comment = '%';
                    Editable = false;
                }
                field("Posted CCD No."; Rec."Posted CCD No.")
                {
                    ToolTip = 'Specifies the value of the Posted CCD Exists field.', Comment = '%';
                }

                field("Payroll Processed"; Rec."Payroll Processed")
                {
                    ToolTip = 'Specifies the value of the Payroll Processed field.', Comment = '%';
                    Editable = false;
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
                field("ETL Batch ID"; Rec."ETL Batch ID")
                {
                    ToolTip = 'Specifies the value of the ETL Batch ID field.', Comment = '%';
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Created At';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'Modified At';
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
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
        if CompanyMapping.FindLast() then
            Rec.SetRange("Client ID", CompanyMapping."Client ID");
    end;
}
