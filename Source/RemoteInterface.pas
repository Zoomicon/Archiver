unit RemoteInterface;

interface

  type

    IRemoteInterface = interface
      ['{01CC2051-391E-4083-AEB5-9C64457B85CC}']
      //Note: methods throw exceptions for errors
      procedure Login(host, port, user, password: string);
      procedure Logout;
      //function List: String;
      function FolderExists(remoteFolder: string): boolean;
      procedure CreateFolder(folder: string);
      procedure Upload(localFilename, remoteFilename: string);
      procedure Download(localFilename, remoteFilename: string);
    end;

    TRemoteInterface = class(TInterfacedObject, IRemoteInterface)
      procedure Login(host, port, user, password: string); virtual; abstract;
      procedure Logout; virtual; abstract;
      //function List: String; abstract;
      function FolderExists(remoteFolder: string): boolean; virtual; abstract;
      procedure CreateFolder(folder: string); virtual; abstract;
      procedure Upload(localFilename, remoteFilename:string); virtual; abstract;
      procedure Download(localFilename, remoteFilename:string); virtual; abstract;
    end;

implementation

end.
