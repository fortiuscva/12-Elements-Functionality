report 52111 "12E Process LMS Batch"
{
    Caption = 'Process LMS Batch';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = None;

    dataset
    {
        dataitem(LMSBatch; "12E LMS Batch")
        {
            RequestFilterFields = "PK ID";

            trigger OnAfterGetRecord()
            var
                LMSBatchPosting: Codeunit "12E LMS Batch Posting";
            begin
                LMSBatchPosting.Post(LMSBatch);
            end;
        }
    }
}