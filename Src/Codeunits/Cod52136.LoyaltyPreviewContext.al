codeunit 52136 "12E Loyalty Preview Context"
{
    SingleInstance = true;

    var
        SuppressPreviewEntries: Boolean;

    procedure SetSuppressPreviewEntries(Suppress: Boolean)
    begin
        SuppressPreviewEntries := Suppress;
    end;

    procedure GetSuppressPreviewEntries(): Boolean
    begin
        exit(SuppressPreviewEntries);
    end;
}