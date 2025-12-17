//Version: 19Jun2001

unit FeedbackInterface;

interface

type
 TFeedbackInterface=class
  procedure ShowStatus(msg:string);virtual;abstract;
  procedure ShowError(msg:string);virtual;abstract;
 end;

implementation

end.