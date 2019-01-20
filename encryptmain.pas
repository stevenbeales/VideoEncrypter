unit encryptmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdActns, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ComCtrls, filethread, encryptresourcethread;


type
  TVideoEncrypterForm = class(TForm)
    LabelSubjectNumber: TLabel;
    LabelSubjectNumberHelp: TLabel;
    EditSubjectNumber: TEdit;
    UploadButton: TButton;
    ProgressBarUpload: TProgressBar;
    GroupBoxVideo: TGroupBox;
    ListBoxVideos: TListBox;
    ActionList1: TActionList;
    ActionUploadFiles: TAction;
    FileOpen1: TFileOpen;
    FileOpen2: TFileOpen;
    FileOpen3: TFileOpen;
    FileOpen4: TFileOpen;
    GroupBox1: TGroupBox;
    ListBoxUSBDrives: TListBox;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionUploadFilesExecute(Sender: TObject);
    procedure ActionUploadFilesUpdate(Sender: TObject);
    procedure ListBoxVideosDblClick(Sender: TObject);
  private
    { Private declarations }
    FVideoFinder: TFileThread;
    FResourceFinder: TEncryptResourceThread;
    FSiteNumber: string;
    procedure ProcessVideos(const droppedFile: ansiString; counter: integer);
    function ValidationFails: boolean;
    procedure EncryptFile(const programName: ansistring);

  public
    { Public declarations }
  end;

var
  VideoEncrypterForm: TVideoEncrypterForm;

implementation

{$R *.dfm}
{$R VideoEncrypt.res}

uses usbdrive, RVMConsts, RVMUtils, uFileInfo;


function TVideoEncrypterForm.ValidationFails: boolean;
begin
  result := false;
  if (editSubjectNumber.Text = '') then
  begin
    Application.MessageBox('Please enter the Subject Number before uploading the video file.', pchar(caption), 0);
    result := true;
  end;

  if not result and (length(editSubjectNumber.Text) <> SUBJECTNUMBERLENGTH)  then
  begin
    Application.MessageBox(pchar(Format('Subject Number must contain %s characters e.g. 00176', [SUBJECTNUMBERLENGTH])), pchar(caption), 0);
    result := true;
  end;

  if not result and (ListBoxUSBDrives.Count = 0) then
  begin
    ShowMessage('Please insert a USB drive.');
    result := true;
  end;
end;


procedure TVideoEncrypterForm.ActionUploadFilesExecute(Sender: TObject);
var
  i: integer;
begin
  screen.Cursor := crhourglass;
  try
    FResourceFinder.Execute;
    if  listboxvideos.Count > 0 then
    begin
      for i:= 0 to pred(listboxvideos.Count) do
      begin
        ProcessVideos(ansistring(listboxvideos.items[i]), i);
        ProgressBarUpload.StepIt;
      end;
    end;
  finally
    screen.Cursor := crdefault;
    Application.MessageBox('All Videos encryted and copied to USB successfully.  Video Encrypter will now close.', pwidechar(caption), 0);
    Application.Terminate;

  end;
end;

procedure TVideoEncrypterForm.ActionUploadFilesUpdate(Sender: TObject);
begin
  if FVideoFinder.Suspended and (ListBoxVideos.Items.count = 0)  then
    ListBoxVideos.Items.AddStrings(FVideoFinder.VideoFiles);
  ActionUploadFiles.Enabled :=
       (length(editSubjectNumber.Text) = SUBJECTNUMBERLENGTH) and (ListBoxVideos.Items.Count > 0);
  ProgressBarUpload.Max := listboxvideos.Count + 1;

end;

procedure TVideoEncrypterForm.EncryptFile(const programName: ansistring);
begin
  ExecNewProcess(programName, true);
end;


procedure TVideoEncrypterForm.ProcessVideos(const droppedFile: ansiString; counter: integer);
var
  outputfile: ansistring;
  usbdrive: ansistring;
  encryptedfile: ansistring;
begin
  if ValidationFails then
    exit;
  ListBoxUSBDrives.Items.Clear;
  GetUSBDrives(ListBoxUSBDrives.items);
  usbdrive := ListBoxUSBDrives.Items[ListBoxUSBDrives.Items.Count-1];
  encryptedfile := droppedfile + '.encrypted';
  outputfile :=  GetOutputFileName(Fsitenumber, editsubjectnumber.text, counter);
  EncryptFile(extractfilepath(ansistring(paramstr(0))) + 'encrypt.bat "' +
    droppedfile + '"');
  CopyFile(PWideChar(widestring(encryptedfile)), PWideChar(widestring(includetrailingbackslash(usbdrive) +
    encryptedfile)), true);

end;

procedure TVideoEncrypterForm.FormActivate(Sender: TObject);
begin
  FVideoFinder.Execute;
  FSiteNumber := ReadSiteNumberFromFile;
  GetUSBDrives(ListBoxUSBDrives.items);
end;

procedure TVideoEncrypterForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FResourceFinder.RemoveResourceFiles;
end;

procedure TVideoEncrypterForm.FormCreate(Sender: TObject);
begin
  FVideoFinder := TFileThread.create(true);
  FResourceFinder := TEncryptResourceThread.create(true);
end;

procedure TVideoEncrypterForm.ListBoxVideosDblClick(Sender: TObject);
var SelectedFile : string;
    Rec          : TSearchRec;
    frInfo       : TfrFileInfo;
begin
  SelectedFile := ListBoxVideos.Items.Strings[ListBoxVideos.ItemIndex];
  if FindFirst(SelectedFile, faAnyFile, Rec) = 0 then
 begin
  frInfo := TfrFileInfo.Create(Self);
  try
    frInfo.lblFile.Caption := SelectedFile;
    frInfo.lblname.Caption := Rec.name;
    frInfo.lblSize.Caption := Format('%d bytes',[Rec.Size]);
    frInfo.lblModified.Caption := DateToStr(Rec.TimeStamp);
    frInfo.lblShortName.Caption := Rec.FindData.cAlternateFileName;
    frInfo.ShowModal;
  finally
    frInfo.Free;
  end;
  System.SysUtils.FindClose(Rec)
 end;
end;

end.
