program VideoEncrypter;

{$R *.dres}

uses
  Vcl.Forms,
  encryptmain in 'encryptmain.pas' {VideoEncrypterForm},
  filethread in 'filethread.pas',
  encryptresourcethread in 'encryptresourcethread.pas',
  usbdrive in 'usbdrive.pas',
  resourcethread in 'resourcethread.pas',
  RVMUtils in 'RVMUtils.pas',
  RVMConsts in 'RVMConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TVideoEncrypterForm, VideoEncrypterForm);
  Application.Run;
end.
