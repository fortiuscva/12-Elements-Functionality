report 52128 "12E LMS Batch Preview Posting"
{
    ApplicationArea = All;
    Caption = 'LMS Batch Preview Posting';
    ProcessingOnly = true;

    dataset
    {
        dataitem(LMSBatch; "12E LMS Batch")
        {
            RequestFilterFields = "Transaction Date";
            DataItemTableView = where(Processed = const(false));

            trigger OnPreDataItem()
            var
                LMSBatchPosting: Codeunit "12E LMS Batch Posting";
            begin
                LMSBatchPosting.PreviewBatchPosting(LMSBatch);
                CurrReport.Break();
            end;
        }
    }

}