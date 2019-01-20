unit resourcethread;

interface

uses
  Classes;

type
  TResourceThread = class(TThread)
  protected
    procedure CreateResourceFile(const Filename: string; const Resourcename: string);
    procedure CreateResourceFiles; virtual;
    procedure RemoveResourceFile(const FileName: string);
  public
    constructor Create(CreateSuspended: Boolean);
    procedure Execute; override;
    procedure RemoveResourceFiles; virtual;
end;

implementation

uses
  sysutils, windows, dialogs;



constructor TResourceThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
  Priority := tpLowest;
end;

procedure TResourceThread.Execute;
begin
  CreateResourceFiles;
end;

procedure TResourceThread.CreateResourceFiles;
begin
   CreateResourceFile('sftp.bat', 'sftp');
   CreateResourceFile('compress.bat', 'compress');
   CreateResourceFile('videocompressor.exe', 'videocompressor');
   CreateResourceFile('winscp.exe', 'winscp');
   CreateResourceFile('winscp.com', 'winscpcom');
   CreateResourceFile('key.ppk', 'key');
   CreateResourceFile('script.txt', 'script');
   CreateResourceFile('cleanup.bat', 'cleanup');
 end;

procedure TResourceThread.CreateResourceFile(const FileName: string; const ResourceName: string);
var
  S: TResourceStream;
  F: TFileStream;
begin
  // create a resource stream which points to our resource
  S := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);
  try
    // create a file mydata.dat in the application directory
    F := TFileStream.Create(ExtractFilePath(paramstr(0)) + FileName, fmCreate);
    try
      F.CopyFrom(S, S.Size); // copy data from the resource stream to file stream
    finally
      F.Free; // destroy the file stream
    end;
  finally
    S.Free; // destroy the resource stream
  end;
 end;

procedure TResourceThread.RemoveResourceFile(const FileName: string);
begin
  Sysutils.DeleteFile(FileName)
end;


procedure TResourceThread.RemoveResourceFiles;
begin
   RemoveResourceFile('sftp.bat');
   RemoveResourceFile('compress.bat');
   RemoveResourceFile('videocompressor.exe');
   RemoveResourceFile('winscp.exe');
   RemoveResourceFile('winscp.com');
   RemoveResourceFile('key.ppk');
   RemoveResourceFile('script.txt');
   RemoveResourceFile('cleanup.bat');
 end;

end.
