unit filethread;

interface

uses
  Classes;

type
  TFileThread = class(TThread)
  private
    FVideoFiles: TStringList;
    function GetVideoFiles: TStrings;
  protected

    procedure FileSearch(const PathName, FileName : string; const InDir : boolean);
  public
    constructor Create(CreateSuspended: Boolean);
    procedure Execute; override;
    property VideoFiles: TStrings read GetVideoFiles;
    destructor Destroy; override;
  end;

implementation
uses
  sysutils;

destructor TFileThread.Destroy;
begin
  FVideoFiles.Free;
end;

constructor TFileThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := false;
  FVideoFiles := TStringList.create;
  Priority := tpLowest;
end;

function TFileThread.GetVideoFiles: TStrings;
begin
  result := FVideoFiles
end;

procedure TFileThread.Execute;
begin
  FileSearch(ExtractFilePath(ParamStr(0)), '*.mp4', true);
  ReturnValue := 1;
end;

procedure TFileThread.FileSearch(const PathName, FileName : string; const InDir : boolean);
var
  Rec  : TSearchRec;
  Path : string;
begin
  Path := IncludeTrailingBackslash(PathName);
  if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
 try
   repeat
     FVideoFiles.Add(Path + Rec.Name);
   until FindNext(Rec) <> 0;
 finally
   SysUtils.FindClose(Rec);
 end;

 if not InDir then Exit;

 if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
 try
   repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name<>'.') and (Rec.Name<>'..') then
     FileSearch(Path + Rec.Name, FileName, True);
   until FindNext(Rec) <> 0;
 finally
   SysUtils.FindClose(Rec);
 end;
end; //procedure FileSearch


end.
