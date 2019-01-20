unit encryptresourcethread;

interface

uses
  Classes, ResourceThread;

type
  TEncryptResourceThread = class(TResourceThread)
  protected
    procedure CreateResourceFiles; override;
  public
    procedure RemoveResourceFiles; override;
 end;

implementation

uses
  sysutils, windows, dialogs;

procedure TEncryptResourceThread.CreateResourceFiles;
begin
   CreateResourceFile('encrypt.bat', 'encrypt');
end;


procedure TEncryptResourceThread.RemoveResourceFiles;
begin
   RemoveResourceFile('encrypt.bat');
end;

end.
