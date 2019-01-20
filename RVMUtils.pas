unit RVMUtils;

interface

function IntToAnsiStr(X: Integer; Width: Integer = 0): AnsiString;
procedure ExecNewProcess(ProgramName : ANSIString; wait: Boolean);
function GetOutputFileName(sitenumber: ansistring; subjectnumber: ansistring; counter: integer): ansistring;
function GetPrefix(SiteNumber: ansistring; subjectnumber: ansistring): ansistring;
function  ReadSiteNumberFromFile: ansistring;

implementation

uses Windows, Dialogs, RVMConsts, ANSIStrings;

function GetPrefix(SiteNumber: ansistring; subjectnumber: ansistring): ansistring;
begin
  result := STUDYPREFIX + SiteNumber + '-' + AnsiString(SubjectNumber) + '-01-';
end;

function  ReadSiteNumberFromFile: ansistring;
var
  sitenumberfile : TextFile;
begin
  // Try to open the Test.txt file for writing to

  AssignFile(sitenumberfile, includetrailingbackslash(extractfilepath(paramstr(0))) + 'sitenumber.txt');
  try
    try
      reset(sitenumberfile);
      while not Eof(sitenumberfile) do
      begin
         readln(sitenumberfile, result);
      end;
    except
      ShowMessage('Missing site number file.  Please contact ePharmaSolutions help desk.');
    end;
  finally
     closefile(sitenumberfile);
  end;
end;


function GetOutputFileName(sitenumber: ansistring; subjectnumber: ansistring; counter: integer): ansistring;
begin
  result := GetPrefix(sitenumber, subjectnumber) + inttoansistr(counter + 1) + VIDEOEXT;
end;

function IntToAnsiStr(X: Integer; Width: Integer = 0): AnsiString;
begin
   Str(X: Width, Result);
end;

procedure ExecNewProcess(ProgramName : ANSIString; wait: Boolean);
var
  StartInfo : TStartupInfo;
  ProcInfo : TProcessInformation;
  CreateOK : Boolean;
begin
    { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
  CreateOK := CreateProcess(nil, PWideChar(widestring(ProgramName)), nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
              nil, nil, StartInfo, ProcInfo);
    { check to see if successful }
  if CreateOK then
    begin
        //may or may not be needed. Usually wait for child processes
      if Wait then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end
  else
    begin
      ShowMessage(widestring('Unable to run '+ ProgramName));
     end;
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

end.
