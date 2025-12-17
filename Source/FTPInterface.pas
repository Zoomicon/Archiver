//Version: 19Jun2001

Unit FTPInterface;

interface
 uses RemoteInterface,
      IdFTP;

type
 TFTPInterface=class(TRemoteInterface)
  protected
   ftp:TIdFTP;
  public
   constructor Create;virtual;
   destructor Destroy;override;
   //
   procedure login(host,port,user,password:string);override;
   procedure logout;override;
   //function list:String;override;
   function folderExists(remoteFolder:string):boolean;override;
   procedure createFolder(remoteFolder:string);override;
   procedure upload(localFilename,remoteFilename:string);override;
   procedure download(localFilename,remoteFilename:string);override;
 end;

implementation

constructor TFTPInterface.Create;
begin
 ftp:=TIdFTP.Create(nil);
 ftp.TransferType := ftBinary;
end;

destructor TFTPInterface.Destroy;
begin
 inherited;
 ftp.destroy;
end;

procedure TFTPInterface.login;
begin
 ftp.Host:=host;
 ftp.user:=user;
 ftp.password:=password;
 ftp.Connect;
end;

procedure TFTPInterface.logout;
begin
 ftp.quit;
end;

function TFTPInterface.folderExists;
var oldFolder:string;
begin
 oldFolder:=ftp.RetrieveCurrentDir;
 try
  ftp.ChangeDir(remoteFolder);
  ftp.ChangeDir(oldFolder);
  result:=true;
 except
  result:=false;
 end;
end;

procedure TFTPInterface.createFolder;
begin
 ftp.MakeDir(remoteFolder);
end;

procedure TFTPInterface.Upload;
begin
 ftp.put(localFilename, remoteFilename);
end;

procedure TFTPInterface.Download;
begin
 ftp.get(localFilename, remoteFilename);
end;

end.

