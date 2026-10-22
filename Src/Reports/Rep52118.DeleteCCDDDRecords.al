report 52118 "12E Delete CCDDD Records"
{
    ApplicationArea = All;
    Caption = 'Delete Other Portfolio Records from CCD Detailed Data';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(CCDDetailedData; "12E CCD Detailed Data")
        {
            DataItemTableView = where(Portfolio = const('Other'));
            trigger OnAfterGetRecord()
            begin
                Counter += 1;
                CCDDetailedData.Delete(true);
            end;
        }
    }
    trigger OnPreReport()
    begin
        Counter := 0;
    end;

    trigger OnPostReport()
    begin
        Message('Deleted %1 Other Portfolio Records', Counter);
    end;

    var
        Counter: Integer;
}
