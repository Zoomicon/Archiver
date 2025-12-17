Unit FTPInterface;

{$DEFINE SUPPORT_SSL}

interface
  uses
    RemoteInterface,
    {$IFDEF SUPPORT_SSL}
    IdSSL,
    IdSSLOpenSSL,
    {$ENDIF}
    IdFTP; //Project Indy's FTP

  type

    TFTPInterface = class(TRemoteInterface)
    protected
      ftp: TIdFTP;
      {$IFDEF SUPPORT_SSL}
      ssl: TIdSSLIOHandlerSocketOpenSSL;
      {$ENDIF}
    public
      constructor Create; virtual;
      destructor Destroy; override;
      //
      procedure Login(host, port, user, password: string); override;
      procedure Logout; override;
      //function List:String; override;
      function FolderExists(remoteFolder: string): boolean; override;
      procedure CreateFolder(remoteFolder: string); override;
      procedure Upload(localFilename, remoteFilename: string); override;
      procedure Download(localFilename, remoteFilename: string); override;
    end;

implementation
  uses
    {$IFDEF SUPPORT_SSL}
    IdExplicitTLSClientServerBase,
    {$ENDIF}
    IdFTPCommon; //for TIdFTPTransferType.ftBinary //Indy-upgrade: was defined in IdFTP unit

  constructor TFTPInterface.Create;
  begin
    inherited;
    ftp := TIdFTP.Create(nil);

    ftp.TransferType  :=  ftBinary;
    ftp.Passive := true; //do not create incoming socket, let the server instead

    {$IFDEF SUPPORT_SSL}
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create(ftp);
    ssl.SSLOptions.SSLVersions := [sslvTLSv1_2];

    ftp.IOHandler := ssl;
    ftp.UseTLS := utUseExplicitTLS; //or utUseRequireTLS
    ftp.AuthCmd := tAuthTLS;        //AUTH TLS command
    ftp.DataPortProtection := ftpdpsPrivate; //encrypt data channel
   {$ENDIF}
  end;

  destructor TFTPInterface.Destroy;
  begin
    inherited;
    ftp.destroy;
  end;

  procedure TFTPInterface.Login(host, port, user, password: string);
  begin
    ftp.Host := host;
    ftp.Username := user; //Indy-upgrade: was "User"
    ftp.Password := password;
    ftp.Connect;
  end;

  procedure TFTPInterface.Logout;
  begin
    ftp.Disconnect; //Indy-upgrade: Quit is now deprecated, just calls Disconnect
  end;

  function TFTPInterface.FolderExists(remoteFolder: string): boolean;
  var
    oldFolder:string;
  begin
    oldFolder := ftp.RetrieveCurrentDir;
    try
      ftp.ChangeDir(remoteFolder);
      ftp.ChangeDir(oldFolder);
      result := true;
    except
      result := false;
    end;
  end;

  procedure TFTPInterface.CreateFolder(remoteFolder: string);
  begin
    ftp.MakeDir(remoteFolder);
  end;

  procedure TFTPInterface.Upload(localFilename, remoteFilename: string);
  begin
    ftp.put(localFilename, remoteFilename);
  end;

  procedure TFTPInterface.Download(localFilename, remoteFilename: string);
  begin
    ftp.get(localFilename, remoteFilename);
  end;

end.

