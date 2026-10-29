codeunit 52136 "12E Suppress Preview Post"
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