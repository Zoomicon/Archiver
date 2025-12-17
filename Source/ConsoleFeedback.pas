//Version: 13Sep2001

Unit ConsoleFeedback;

interface
 uses FeedbackInterface;

type
 TConsoleFeedback=class(TFeedbackInterface)
  public
   procedure ShowStatus(msg:string);override;
   procedure ShowError(msg:string);override;
 end;

implementation
 uses SysUtils;

procedure TConsoleFeedback.ShowStatus;
begin
 writeln(msg);
end;

procedure TConsoleFeedback.ShowError;
begin
 beep;
 writeln('!!! Error: '+msg);
end;

end.

