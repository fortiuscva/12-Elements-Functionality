codeunit 52104 "12E EPIC Batch Preview Mgt"
{
    procedure Preview(BatchHeader: Record "12E EPIC Payments Batch Header")
    var
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        BatchLine: Record "12E EPIC Payments Batch Line";
        LineNo: Integer;
        Total: Decimal;
        Count: Integer;
        GenJnlPage: Page "General Journal";
    begin
        LineNo := 10000;

        BatchLine.SetRange("Batch No.", BatchHeader."Batch No.");

        if BatchLine.FindSet() then
            repeat
                TempGenJnlLine.Init();

                TempGenJnlLine."Journal Template Name" := 'GENERAL';
                TempGenJnlLine."Journal Batch Name" := 'DEFAULT';

                TempGenJnlLine."Line No." := LineNo;

                TempGenJnlLine.Validate("Posting Date", BatchLine."Posting Date");
                TempGenJnlLine.Validate("Document Date", BatchLine."Posting Date");

                TempGenJnlLine."Document Type" :=
                    TempGenJnlLine."Document Type"::Payment;

                TempGenJnlLine."Document No." := BatchHeader."Batch No.";

                TempGenJnlLine.Validate("Account Type", BatchLine."Account Type");
                TempGenJnlLine.Validate("Account No.", BatchLine."Account No.");

                TempGenJnlLine.Validate(Amount, BatchLine.Amount);

                TempGenJnlLine.Description :=
                    StrSubstNo('EPIC Batch %1', BatchHeader."Batch No.");

                TempGenJnlLine."Source Code" := 'EPIC';


                TempGenJnlLine.Insert();

                Total += BatchLine.Amount;
                Count += 1;
                LineNo += 10000;
            until BatchLine.Next() = 0;

        if Count = 0 then
            Error('Nothing to preview.');

        Message(
            'Preview Summary\ Entries: %1\ Total: %2',
            Count, Total);

        Page.RunModal(Page::"General Journal", TempGenJnlLine);
    end;
}