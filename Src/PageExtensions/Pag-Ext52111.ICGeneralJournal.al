pageextension 52111 "12E IC General Journal" extends "IC General Journal"
{
    actions
    {
        addlast(Processing)
        {
            action("12E ImportICGeneralJournal")
            {
                ApplicationArea = All;
                Caption = 'Import IC General Journal';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ImportICGenJournal: Report "12E Import IC General Journal";
                begin
                    ImportICGenJournal.SetJournalDefaults(Rec."Journal Template Name", Rec."Journal Batch Name");
                    ImportICGenJournal.RunModal();
                end;
            }
        }
    }
}
