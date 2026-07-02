report 53001 "12E Import Update GL Account"
{
    UsageCategory = Administration;
    caption = 'GL Account - Import Update';
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

                    field(RowNo; RowNoVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start at row number';
                        ToolTip = 'Start reading data from this row - usually 3';
                    }
                    field(ExportExcelDoc; ExportExcelDocVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export Chart of Accounts';
                        ToolTip = 'If checked, then it will not import.  It will export the chart of accounts file.';
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

        if ExportExcelDocVar then
            RunExportTemplateFile();

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
            RowNoVar := 3;

        FirstRow := RowNoVar;

        //find last row with value in column 1...
        clear(LastRow);
        tempExcelBuf.RESET();
        IF tempExcelBuf.FINDLAST() THEN
            LastRow := tempExcelBuf."Row No.";

        //if data problem...
        IF (FirstRow = 0) OR (LastRow = 0) OR (LastRow < FirstRow) THEN
            ERROR(txtNoDatamsg);

        //confirm before loading...
        IF GUIALLOWED THEN
            IF NOT CONFIRM(STRSUBSTNO(txtPromptmsg, LastRow, FirstRow, LastRow - FirstRow + 1, ServerFileName, SheetName)) THEN
                ERROR(txtStopmsg);


        InsertedRecs := 0;
        ModifiedRecs := 0;
        IF GUIALLOWED THEN
            Window.OPEN('@1@@@@@@@@@@@@@@@@@@@@@@');


        //import lines...
        FOR i := FirstRow TO LastRow DO
            if tempExcelBuf.GET(i, 1) then begin //posting date has value
                if GLAcc.get(TempExcelBuf."Cell Value as Text") then
                    ModifiedRecs += 1
                else begin
                    InsertedRecs += 1;
                    clear(GLAcc);
                    GLacc."No." := TempExcelBuf."Cell Value as Text";
                    GLAcc.insert(true);
                end;

                //no2
                IF tempExcelBuf.GET(i, 2) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then
                        GLAcc.Validate("No. 2", TempExcelBuf."Cell Value as Text");

                //name
                IF tempExcelBuf.GET(i, 3) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then
                        GLAcc.Validate(Name, TempExcelBuf."Cell Value as Text");

                //search
                IF tempExcelBuf.GET(i, 4) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then
                        GLAcc.Validate("Search Name", TempExcelBuf."Cell Value as Text");

                //acc type
                IF tempExcelBuf.GET(i, 5) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Account Type", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Account Type");
                    end;

                //acc sub cat 
                IF tempExcelBuf.GET(i, 6) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Account Category", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Account Category");
                    end;

                //acc sub cat entry
                IF tempExcelBuf.GET(i, 7) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Account Subcategory Entry No.", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Account Subcategory Entry No.");
                    end;


                //inc bal
                IF tempExcelBuf.GET(i, 9) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Income/Balance", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Income/Balance");
                    end;

                //direct post
                IF tempExcelBuf.GET(i, 10) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Direct Posting", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Direct Posting");
                    end;

                //rec account
                IF tempExcelBuf.GET(i, 11) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Reconciliation Account", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Reconciliation Account");
                    end;

                //blocked
                IF tempExcelBuf.GET(i, 12) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc.Blocked, TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate(Blocked);
                    end;

                //gen post type
                IF tempExcelBuf.GET(i, 13) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then begin
                        Evaluate(GLAcc."Gen. Posting Type", TempExcelBuf."Cell Value as Text");
                        GLAcc.Validate("Gen. Posting Type");
                    end;

                //gen prod
                IF tempExcelBuf.GET(i, 14) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then
                        GLAcc.Validate("Gen. Prod. Posting Group", TempExcelBuf."Cell Value as Text");

                //gen bus
                IF tempExcelBuf.GET(i, 15) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then
                        GLAcc.Validate("Gen. Bus. Posting Group", TempExcelBuf."Cell Value as Text");

                //tax gr
                IF tempExcelBuf.GET(i, 16) THEN
                    if TempExcelBuf."Cell Value as Text" <> '' then
                        GLAcc.Validate("Tax Group Code", TempExcelBuf."Cell Value as Text");

                GLAcc.MODIFY();
            end
    end;

    trigger OnPostReport()
    begin
        IF GUIALLOWED THEN
            Window.CLOSE();

        MESSAGE(TxtMessageMsg, LastRow - FirstRow + 1, ModifiedRecs, InsertedRecs);
    end;

    var
        TempExcelBuf: record "Excel Buffer" temporary;
        GLAcc: Record "G/L Account";
        FileMgt: Codeunit "File Management";
        ExportExcelDocVar: boolean;
        Window: Dialog;
        InStr: InStream;
        FirstRow: Integer;
        i: Integer;
        InsertedRecs: Integer;
        ModifiedRecs: Integer;
        RowNoVar: Integer;
        LastRow: Integer;
        FileName: Text;
        ServerFileName: Text;
        SheetName: Text;
        txtExcelFilterMsg: TextConst ENU = 'Excel Files (*.xlsx)|*.xlsx';
        TxtImportMsg: TextConst ENU = 'Import Excel File';
        TxtStopMsg: textconst ENU = 'Import Stopped';
        //TxtIssuesMsg: TextConst ENU = 'Data loaded, but with %1 issue(s):';
        TxtMessageMsg: TextConst ENU = 'Records load:  %1 rows   modified %2   inserted %3';
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
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);   //no.
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);            //no2.
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);   //name
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);            //search name
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);   //account type
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);   //account cat
        tempExcelBuf.AddColumn('*Required', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);   //account subcat entry no
        tempExcelBuf.AddColumn('n/a', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //account subcat desc
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //income bal
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //direct post
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //recon account
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //blocked
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //gen post type
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //gen prod
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //gen bus
        tempExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);    //tax gr

        //second row
        tempExcelBuf.NewRow();
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("No. 2"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION(Name), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Search Name"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Account Type"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Account Category"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Account Subcategory Entry No."), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Account Subcategory Descript."), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Income/Balance"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Direct Posting"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Reconciliation Account"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION(Blocked), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Gen. Posting Type"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Gen. Prod. Posting Group"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Gen. Bus. Posting Group"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
        tempExcelBuf.AddColumn(GLAcc.FIELDCAPTION("Tax Group Code"), FALSE, '', TRUE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);

        GLAcc.reset();
        if glacc.findset() then
            repeat
                GLAcc.CalcFields("Account Subcategory Descript.");

                tempExcelBuf.NewRow();
                tempExcelBuf.AddColumn(format(GLAcc."No."), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."No. 2"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc.Name), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Search Name"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Account Type"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Account Category"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Account Subcategory Entry No."), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Account Subcategory Descript."), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Income/Balance"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Direct Posting"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Reconciliation Account"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc.Blocked), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Gen. Posting Type"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Gen. Prod. Posting Group"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Gen. Bus. Posting Group"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
                tempExcelBuf.AddColumn(format(GLAcc."Tax Group Code"), FALSE, '', FALSE, FALSE, FALSE, '', tempExcelBuf."Cell Type"::Text);
            until (GLAcc.next() = 0);

        tempExcelBuf.CreateNewBook('GLAcc');
        tempExcelBuf.WriteSheet('GLAcc', CompanyName, UserId);
        tempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('GLAccTemplate');
        tempExcelBuf.OpenExcel();
        CurrReport.QUIT();
    end;

}
