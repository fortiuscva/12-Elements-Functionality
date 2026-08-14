report 52103 "12E Delete Posted CCD Records"
{
    ApplicationArea = All;
    Caption = 'Delete Posted CCD Records';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(PostedCCDHeader; "12E Posted CCD Header")
        {
            RequestFilterFields = "No.";
            dataitem(PostedCCDLine; "12E Posted CCD Line")
            {
                DataItemLinkReference = PostedCCDHeader;
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                begin
                    PostedCCDLine.Delete(true);
                end;
            }
            trigger OnPostDataItem()
            begin
                PostedCCDHeader.Delete(true);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
