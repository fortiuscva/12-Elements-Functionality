report 53000 "12E FLS Import General Journal"
{
    UsageCategory = Administration;
    caption = 'Import General Journal';
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = true;

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(TemplateName; TemplateNameVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Template Name';
                        ToolTip = 'Load data to this template';
                        trigger Onlookup(var Test: Text): Boolean
                        begin
                            if not GenJournalTemplate.get(TemplateNameVar) then
                                clear(GenJournalTemplate);
                            if page.Runmodal(0, GenJournalTemplate) = Action::LookupOK then
                                TemplateNameVar := GenJournalTemplate.Name;
                        end;
                    }

                    field(BatchName; BatchNameVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Batch Name';
                        ToolTip = 'Loca data to this batch';
                        trigger Onlookup(var Test: Text): Boolean
                        begin
                            GenJournalBatch.Reset();
                            GenJournalBatch.SetRange("Journal Template Name", TemplateNameVar);

                            if BatchNameVar <> '' then
                                if not GenJournalBatch.Get(TemplateNameVar, BatchNameVar) then
                                    Clear(GenJournalBatch);

                            if Page.RunModal(0, GenJournalBatch) = Action::LookupOK then
                                BatchNameVar := GenJournalBatch.Name;
                        end;
                    }
                    field(RowNo; RowNoVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start at row number';
                        ToolTip = 'Start reading data from this row';
                    }

                    field(ExportExcelDoc; ExportExcelDocVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export Template Sample File';
                        ToolTip = 'If checked, then it will not import.  It will export a template file.';
                    }

                }
            }
        }
        trigger onopenpage()
        begin
            ExportExcelDocVar := false;
            clear(serverfilename);
            clear(sheetname);
            IF RowNoVar = 0 THEN
                RowNoVar := 3;
        end;

    }


    trigger OnInitReport()
    begin
        IF RowNoVar = 0 THEN
            RowNoVar := 3;
    end;

    trigger OnPreReport()
    begin
        GeneralLedgerSetup.GET();

        if ExportExcelDocVar then
            RunExportTemplateFile();

        GenJournalTemplate.GET(TemplateNameVar);
        GenJournalTemplate.TESTFIELD(Recurring, FALSE);
        GenJournalBatch.GET(TemplateNameVar, BatchNameVar);

        TempExcelBuf.DeleteAll();

        if not UploadIntoStream(TxtImportmsg, '', txtExcelFiltermsg, ServerFileName, InStr) then
            error(TxtStopmsg);

        //if not fileuploaded or (serverfilename = '') then
        //    error(txtstop);

        SheetName := tempExcelBuf.SelectSheetsNamestream(InStr);
        if SheetName = '' then
            Error(TxtStopmsg);

        tempExcelBuf.OpenBookStream(InStr, SheetName);
        tempExcelBuf.ReadSheet();

        IF RowNoVar = 0 THEN
            RowNoVar := 2;
        FirstRow := RowNoVar;

        //find last row with value in column 1...
        clear(LastRow);
        tempExcelBuf.RESET();
        IF tempExcelBuf.FINDLAST() THEN
            LastRow := tempExcelBuf."Row No.";

        //if data problem...
        IF (FirstRow = 0) OR (LastRow = 0) OR (LastRow < FirstRow) THEN
            ERROR(txtNoDatamsg);

        //check if any rows' document no. is blank or missing...
        Found := FALSE;
        IF GenJournalBatch."No. Series" <> '' THEN
            FOR i := FirstRow TO LastRow DO
                IF NOT tempExcelBuf.GET(i, 3) THEN
                    Found := TRUE
                ELSE
                    IF tempExcelBuf."Cell Value as Text" = '' THEN
                        Found := TRUE;



        //confirm before loading...
        IF GUIALLOWED THEN
            IF NOT CONFIRM(STRSUBSTNO(txtPromptmsg, LastRow, FirstRow, LastRow - FirstRow + 1, ServerFileName, SheetName)) THEN
                ERROR(txtStopmsg);

        IF Found THEN BEGIN
            CLEAR(NoSeries);
            //DocNo := NoSeries.TryGetNextNo(GenJournalBatch."No. Series", GenJournalLine."Posting Date");
            COMMIT();
        END;

        InsertedRecs := 0;
        SkippedRecs := 0;

        IF GUIALLOWED THEN
            Window.OPEN('@1@@@@@@@@@@@@@@@@@@@@@@');

        //get last line no...
        LineNo := 10000;
        GenJournalLine.RESET();
        GenJournalLine.SETRANGE("Journal Template Name", TemplateNameVar);
        GenJournalLine.SETRANGE("Journal Batch Name", BatchNameVar);
        IF GenJournalLine.FINDLAST() THEN
            LineNo := GenJournalLine."Line No." + 10000;

        //import lines...
        FOR i := FirstRow TO LastRow DO

            if tempExcelBuf.GET(i, 1) then begin  //posting date has value
                evaluate(postingdate, tempexcelbuf."Cell Value as Text");

                clear(amount);
                IF tempExcelBuf.GET(i, 6) THEN       //amount must have value
                    IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                        EVALUATE(Amount, tempExcelBuf."Cell Value as Text");

                clear(debitamount);
                IF tempExcelBuf.GET(i, 7) THEN       //amount must have value
                    IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                        EVALUATE(DebitAmount, tempExcelBuf."Cell Value as Text");

                clear(creditamount);
                IF tempExcelBuf.GET(i, 8) THEN       //amount must have value
                    IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                        EVALUATE(creditAmount, tempExcelBuf."Cell Value as Text");

                if (DebitAmount <> 0) and (creditamount <> 0) then
                    error('%1 and %2 cannot both be entered', GenJournalLine.FieldCaption("Debit Amount"), GenJournalLine.FieldCaption("Credit Amount"));

                if (amount <> 0) and ((DebitAmount <> 0) or (creditamount <> 0)) then
                    error('%1 and %2 or %3 cannot all be entered', GenJournalLine.FieldCaption(Amount), GenJournalLine.FieldCaption("Debit Amount"), GenJournalLine.FieldCaption("Credit Amount"));

                if (DebitAmount <> 0) or (creditamount <> 0) or (Amount <> 0) then begin

                    InsertedRecs += 1;

                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE("Journal Template Name", TemplateNameVar);
                    GenJournalLine.VALIDATE("Journal Batch Name", BatchNameVar);
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine.INSERT(TRUE);

                    GenJournalLine."Source Code" := GenJournalTemplate."Source Code";
                    GenJournalLine."Reason Code" := GenJournalBatch."Reason Code";

                    LineNo += 10000;

                    GenJournalLine.VALIDATE("Posting Date", PostingDate);

                    IF (tempExcelBuf.GET(i, 2)) THEN                             //document type
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN BEGIN
                            EVALUATE(GenJournalLine."Document Type", tempExcelBuf."Cell Value as Text");
                            GenJournalLine.VALIDATE("Document Type");
                        END;

                    IF (tempExcelBuf.GET(i, 3)) THEN                            //document no.
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            GenJournalLine.VALIDATE("Document No.", tempExcelBuf."Cell Value as Text");    //if specified

                    IF GenJournalLine."Document No." = '' THEN BEGIN    //let journal have option to create document number
                        IF DocNo = '' THEN
                            IF GenJournalBatch."No. Series" <> '' THEN begin
                                CLEAR(NoSeries);
                                DocNo := NoSeries.GetNextNo(GenJournalBatch."No. Series", GenJournalLine."Posting Date");
                                //commit;
                            end;
                        IF DocNo <> '' THEN
                            GenJournalLine.VALIDATE("Document No.", DocNo);
                    END;

                    IF (tempExcelBuf.GET(i, 4)) THEN                             //account type
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN BEGIN
                            EVALUATE(GenJournalLine."Account Type", tempExcelBuf."Cell Value as Text");
                            GenJournalLine.VALIDATE("Account Type");
                        END;

                    IF (tempExcelBuf.GET(i, 5)) THEN                             //account no.
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            GenJournalLine.VALIDATE("Account No.", tempExcelBuf."Cell Value as Text");

                    if amount <> 0 then
                        GenJournalLine.validate(Amount, amount);

                    if debitamount <> 0 then
                        GenJournalLine.validate("Debit Amount", debitamount);

                    if creditamount <> 0 then
                        GenJournalLine.validate("Credit Amount", creditamount);

                    IF tempExcelBuf.GET(i, 9) THEN                               //description
                        GenJournalLine.Description := COPYSTR(tempExcelBuf."Cell Value as Text", 1, 100);

                    IF tempExcelBuf.GET(i, 10) THEN                               //ext doc no
                        GenJournalLine."External Document No." := COPYSTR(tempExcelBuf."Cell Value as Text", 1, 35);

                    clear(documentdate);
                    IF tempExcelBuf.GET(i, 11) THEN                               //doc date
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            evaluate(Documentdate, tempexcelbuf."Cell Value as Text");
                    if DocumentDate <> 0D then
                        GenJournalLine.validatE("Document Date", documentdate);

                    clear(duedate);
                    IF tempExcelBuf.GET(i, 12) THEN                               //due date
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            evaluate(Duedate, tempexcelbuf."Cell Value as Text");
                    if DueDate <> 0D then
                        GenJournalLine.validatE("Due Date", duedate);

                    IF tempExcelBuf.GET(i, 13) THEN                             //bal account type
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN BEGIN
                            EVALUATE(GenJournalLine."bal. Account Type", tempExcelBuf."Cell Value as Text");
                            GenJournalLine.VALIDATE("bal. Account Type");
                        END;

                    IF (tempExcelBuf.GET(i, 14)) THEN                             //bal account no.
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            GenJournalLine.VALIDATE("bal. Account No.", tempExcelBuf."Cell Value as Text");

                    IF (tempExcelBuf.GET(i, 15)) THEN                             //applies to doc type
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN BEGIN
                            EVALUATE(GenJournalLine."Applies-to Doc. Type", tempExcelBuf."Cell Value as Text");
                            GenJournalLine.VALIDATE("Applies-to Doc. Type");
                        END;

                    IF (tempExcelBuf.GET(i, 16)) THEN                             //applies to doc no
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            GenJournalLine.VALIDATE("Applies-to Doc. No.", tempExcelBuf."Cell Value as Text");

                    IF (tempExcelBuf.GET(i, 17)) THEN                             //system entry
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            evaluate(GenJournalLine."System-Created Entry", tempExcelBuf."Cell Value as Text");

                    IF (tempExcelBuf.GET(i, 18)) THEN                             //system entry
                        IF (tempExcelBuf."Cell Value as Text" <> '') THEN
                            GenJournalLine.validate("reason code", tempExcelBuf."Cell Value as Text");

                    //Add shortcut Dimension Entries, only if specified...
                    FOR j := 1 TO 8 DO
                        IF tempExcelBuf.GET(i, j + 18) THEN
                            IF (tempExcelBuf."Cell Value as Text" <> '') THEN BEGIN
                                DimCode := copystr(tempExcelBuf."Cell Value as Text", 1, 20);
                                CASE j OF
                                    1:
                                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", DimCode);
                                    2:
                                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", DimCode);
                                    ELSE
                                        GenJournalLine.ValidateShortcutDimCode(j, DimCode);
                                END;
                            END;

                    GenJournalLine.MODIFY();

                end
            end;
    end;

    trigger OnPostReport()
    begin
        IF GUIALLOWED THEN
            Window.CLOSE();

        MESSAGE(TxtMessageMsg, LastRow - FirstRow + 1, SkippedRecs, InsertedRecs);



    end;


    var

        TempExcelBuf: record "Excel Buffer" temporary;
        //Dim: Record Dimension;
        //DimValue: Record "Dimension Value";
        GenJournalBatch: record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalTemplate: record "Gen. Journal Template";

        GeneralLedgerSetup: record "General Ledger Setup";
        //DimMgt: codeunit 408;
        NoSeries: codeunit "No. Series";

        FileMgt: Codeunit "File Management";

        ExportExcelDocVar: boolean;
        //FileUploaded: Boolean;
        Found: Boolean;
        TemplateNameVar: Code[10];
        BatchNameVar: code[20];
        DimCode: code[20];
        DocNo: code[20];
        PostingDate: date;
        DocumentDate: date;
        DueDate: date;
        //GLAccNo: code[20];
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        Amount: Decimal;
        //Counter: Integer;
        //TotalRecNo: Integer;
        //RecNo: Integer;
        Window: Dialog;
        InStr: InStream;
        FirstRow: Integer;
        i: Integer;
        InsertedRecs: Integer;

        RowNoVar: Integer;
        j: Integer;
        LastRow: Integer;
        LineNo: integer;
        SkippedRecs: Integer;
        FileName: Text;
        ServerFileName: Text;
        SheetName: Text;
        txtExcelFilterMsg: TextConst ENU = 'Excel Files (*.xlsx)|*.xlsx';
        TxtImportMsg: TextConst ENU = 'Import Excel File';


        TxtStopMsg: textconst ENU = 'Import Stopped';
        //TxtIssuesMsg: TextConst ENU = 'Data loaded, but with %1 issue(s):';
        TxtMessageMsg: TextConst ENU = 'Records load:  %1 rows   skipped %2   inserted %3';
        TxtNoDataMsg: TextConst ENU = 'The file does not appear to contain any data.';
        //TxtCompleteMsg: TextConst ENU = '%1 Item(s) created - first: %2   last: %3';
        //TxtInvalidFormatMsg: TextConst ENU = 'The Excel Format does not appear to be a valid import format.';
        TxtPromptMsg: TextConst ENU = 'There are %1 rows in the Excel document (valid rows start at %2).  Total rows to import are %3.  File name "%4" - (sheet name "%5").  Confirm to proceed.';
        TxtEnterFileMsg: TextConst ENU = 'You must enter a file name.';

    procedure RequestFile()
    begin
        //not used
        //FileName := filemgt.UploadFileSilent('Import File', '');


        //FileMgt.OpenFileDialog('Import File', '', 'Excel Files (*.xlsx)');

        //procedure OpenFileDialog(WindowTitle: Text[50]; DefaultFileName: Text; FilterString: Text): Text
        //procedure UploadFile(WindowTitle: Text[50]; ClientFileName: Text) ServerFileName: Text

        ValidateServerFileName();
        FileName := FileMgt.GetFileName(ServerFileName);
    end;

    procedure ValidateServerFileName()
    begin
        if serverfilename = '' then begin

            FileName := '';
            SheetName := '';
            ERROR(TxtEnterFilemsg);

        end;
    end;

    //procedure FileNameOnAfterValidate()
    //begin
    //    RequestFile();
    //end;

    procedure RunExportTemplateFile()
    begin
        tempExcelBuf.DeleteAll();

        //first row
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Optional', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Optional', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 1', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 2', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 3', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 4', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 5', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 6', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 7', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn('Dimension 8', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);

        //second row
        tempExcelBuf.NewRow();
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Posting Date"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Document Type"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Document No."), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Account Type"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Account No."), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION(Amount), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Debit Amount"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Credit Amount"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("External Document No."), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Document Date"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Due Date"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Bal. Account Type"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Bal. Account No."), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Applies-to Doc. Type"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Applies-to Doc. No."), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("System-Created Entry"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GenJournalLine.FIELDCAPTION("Reason Code"), FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);

        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 1 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 2 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 3 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 4 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 5 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 6 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 7 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GeneralLedgerSetup."Shortcut Dimension 8 Code", FALSE, '', TRUE, FALSE, TRUE, '', tempExcelBuf."Cell Type"::Text);

        tempExcelBuf.CreateNewBook('GenJnl');
        tempExcelBuf.WriteSheet('GenJnl', CompanyName, UserId);
        tempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('GenJnlLoadTemplate');
        tempExcelBuf.OpenExcel();

        CurrReport.QUIT();
    end;

    procedure SetJournalDefaults(NewTemplateName: Code[10]; NewBatchName: Code[20])
    begin
        TemplateNameVar := NewTemplateName;
        BatchNameVar := NewBatchName;
    end;
}
