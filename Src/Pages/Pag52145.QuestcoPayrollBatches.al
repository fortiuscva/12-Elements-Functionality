page 52145 "12E Questco Payroll Batches"
{
    ApplicationArea = All;
    Caption = 'Questco Payroll Batches';
    PageType = List;
    SourceTable = "12E Questco Payroll Batch";
    SourceTableView = sorting("Client ID", "Batch ID") order(descending);
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PKID; Rec.PKID)
                {
                    ToolTip = 'Specifies the value of the PKID field.', Comment = '%';
                    Visible = false;
                }
                field(DWLoadDate; Rec.DWLoadDate)
                {
                    ToolTip = 'Specifies the value of the DWLoadDate field.', Comment = '%';
                    Visible = false;
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
                    Visible = false;
                }
                field("Pay Group ID"; Rec."Pay Group ID")
                {
                    ToolTip = 'Specifies the value of the Pay Group ID field.', Comment = '%';
                    Visible = false;
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
                    Visible = false;
                }
                field("Deduct Period"; Rec."Deduct Period")
                {
                    ToolTip = 'Specifies the value of the Deduct Period field.', Comment = '%';
                    Visible = false;
                }
                field("CC Processed"; Rec."CC Processed")
                {
                    ToolTip = 'Specifies the value of the CC Processed field.', Comment = '%';
                }
                field("Payroll Processed"; Rec."Payroll Processed")
                {
                    ToolTip = 'Specifies the value of the Payroll Processed field.', Comment = '%';
                }
                field("DW Export Timestamp"; Rec."DW Export Timestamp")
                {
                    ToolTip = 'Specifies the value of the DW Export Timestamp field.', Comment = '%';
                    Visible = false;
                }
                field("ERP Import Timestamp"; Rec."ERP Import Timestamp")
                {
                    ToolTip = 'Specifies the value of the ERP Import Timestamp field.', Comment = '%';
                    Visible = false;
                }
                field("ERP Status"; Rec."ERP Status")
                {
                    ToolTip = 'Specifies the value of the ERP Status field.', Comment = '%';
                    Visible = false;
                }
                field("ERP Error Message"; Rec."ERP Error Message")
                {
                    ToolTip = 'Specifies the value of the ERP Error Message field.', Comment = '%';
                    Visible = false;
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
}
