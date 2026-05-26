pageextension 52100 "12E General Journal" extends "General Journal"
{
    actions
    {
        addlast(Processing)
        {
            action("12E ImportGeneralJournal")
            {
                ApplicationArea = All;
                Caption = 'Import General Journal';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ImportGenJournal: Report "12E FLS Import General Journal";
                begin
                    ImportGenJournal.SetJournalDefaults(Rec."Journal Template Name", Rec."Journal Batch Name");
                    ImportGenJournal.RunModal();
                end;
            }
        }
    }
}
