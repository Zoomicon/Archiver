//Version: 19Jun2001

unit RemoteInterface;

interface

type
 TRemoteInterface=class //methods throw exceptions for errors
  procedure login(host,port,user,password:string);virtual;abstract;
  procedure logout;virtual;abstract;
  //function list:String;virtual;abstract;
  function folderExists(remoteFolder:string):boolean;virtual;abstract;
  procedure createFolder(folder:string);virtual;abstract;
  procedure upload(localFilename,remoteFilename:string);virtual;abstract;
  procedure download(localFilename,remoteFilename:string);virtual;abstract;
 end;

implementation

end.