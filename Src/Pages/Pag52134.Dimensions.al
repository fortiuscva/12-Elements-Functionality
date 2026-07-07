page 52134 "12E Dimensions"
{
    PageType = API;
    SourceTable = Dimension;
    APIPublisher = 'streamlineinc';
    APIGroup = 'financePBI';
    APIVersion = 'v1.0';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    EntityName = 'dimension';
    EntitySetName = 'dimensions';
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field("code"; Rec.Code) { Caption = 'Code'; }
                field(name; Rec.Name) { Caption = 'Name'; }
                field(blocked; Rec.Blocked) { Caption = 'Blocked'; }
            }
        }
    }
}