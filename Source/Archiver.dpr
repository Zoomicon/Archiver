//Archiver utility
//(C)2001-2025 George Birbilis / Zoomicon

{$APPTYPE CONSOLE}

Program Archiver;
 uses
  windows,
  classes,
  SysUtils,
  RemoteInterface in 'RemoteInterface.pas',
  FTPInterface in 'FTPInterface.pas',
  ac_strings in '..\Lib\ac_strings.pas',
  FeedbackInterface in 'FeedbackInterface.pas',
  ConsoleFeedback in 'ConsoleFeedback.pas',
  GuiFeedback in 'GuiFeedback.pas';

{$R *.res}

resourcestring msgSyntax='Parameters: host user password listFile [localBaseFolder [remoteBaseFolder]]';

////////////////////////////////////////////////////////////////////////////////

var
  remote: TRemoteInterface;
  feedback: TFeedbackInterface;
  host, user, password: string;
  remoteBaseFolder: string;
  filelist: TStrings;
  listFile: string;
  apppath: string;

procedure Init;
begin
  apppath := ExtractFilePath(paramStr(0));
  filelist := TStringList.Create;
  {$IFOPT C+}
  feedback := TConsoleFeedback.Create;
  {$ELSE}
  feedback := TGuiFeedback.Create;
  {$ENDIF}
end;

procedure Finish(exitcode:integer);
begin
  feedback.ShowStatus('exiting...');
  remote.Destroy;
  feedback.Destroy;
  halt(exitcode);
end;

procedure ParseCommandLine;
begin
  if (paramCount<4) or (paramCount>6) then
  begin
    feedback.ShowError(msgSyntax);
    Finish(1);
  end;

  host := paramStr(1);
  user := paramStr(2);
  password := paramStr(3);
  listfile := paramStr(4);

  appPath := ExpandFileName(appPath+paramStr(5)); //paramStr returns '' if index is greater than paramCount
  writeln(appPath);

  remoteBaseFolder := paramStr(6); //paramStr returns '' if index is greater than paramCount
end;

procedure LoadFileList;
begin
  filelist.LoadFromFile(listFile);
end;

///////////////////////

function Login:boolean;
begin
  try
    remote := TFTPInterface.Create;
    remote.Login(host,'0'{???},user,password);
    result := true;
  except
    on e:Exception do
    begin
      feedback.ShowError('Failed to login: '+e.message);
      result := false;
    end;
  end;
end;

function fix(filename:string):string;
var len:integer;
begin
  len := length(apppath);

  if startsWith(apppath,filename)
    then result := toEnd(filename,len+1)
    else result := filename;

  convertChars(result,'\','/');
end;

procedure CreateRemoteFolder(folder:String);
var remoteFolder:String;
begin
  remoteFolder := remoteBaseFolder+fix(folder);
  try
    if(remote.folderExists(remoteFolder)) then
      feedback.ShowStatus('Already existing remote folder '+remoteFolder+' for local folder '+folder)
    else
    begin
      remote.createFolder(remoteFolder);
      feedback.ShowStatus('Created remote folder '+remoteFolder+' for local folder '+folder);
    end;
    FileSetAttr(folder,FileGetAttr(folder)-faArchive); //clear archive flag if remote folder created
  except
    feedback.ShowError('Couldn''t create remote folder '+remoteFolder+' for local folder '+folder);
  end;
end;

function getElapsedTime(oldTicks,newTicks:LongWord):LongWord;
begin
  if (oldTicks < newTicks)
    then result := newTicks-oldTicks
    else result := (High(LongWord)-oldTicks)+newTicks;
end;

function getFileSizeInBytes(filename:string):LongWord;
var
  f:file of byte;
begin
  AssignFile(f,filename);
  FileMode := 0;
  Reset(f);
  result := FileSize(f);
  CloseFile(f);
end;

procedure UploadFile(filename:String);
var
  remoteFile:String;
  filesize,oldticks,elapsedTime:LongWord;
begin
  remoteFile := remoteBaseFolder+fix(filename);
  try
    oldticks := getTickCount; //get msec's since Windows started running
    filesize := getFileSizeInBytes(filename);
    feedback.ShowStatus('Uploading '+filename+' to '+remoteFile+
     ' ('+IntToStr(filesize)+' bytes)...');
    remote.upload(filename,remoteFile);
    FileSetAttr(filename,FileGetAttr(filename)-faArchive); //clear archive flag if uploaded
    elapsedTime := getElapsedTime(oldTicks,getTickCount);
    feedback.ShowStatus('...uploaded in '+IntToStr(elapsedTime)+' msec ('+intToStr(round((filesize/elapsedTime)*1000))+' bytes/sec)');
  except
    on e:Exception do
      feedback.ShowError('Uploading failed: '+e.message);
  end;
end;

procedure SyncFileList;
var i, count: integer;
    f: string;
begin
  count := filelist.Count;
  for i := 0 to (count - 1) do
  begin
    f := filelist[i];
    if ((FileGetAttr(f) and faDirectory) = faDirectory)
      then CreateRemoteFolder(f)
      else UploadFile(f);
  end;
end;

procedure Logout;
begin
  try
    remote.Logout;
  except
    on e:Exception do
      feedback.ShowError('Failed at logout: '+e.message);
 end;
end;

begin
  Init;
  ParseCommandLine;

  LoadFileList;

  if not Login then
    Finish(2);

  SyncFileList;

  Logout;
  Finish(0);
end.

