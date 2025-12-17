Unit ConsoleFeedback;

interface
  uses
    FeedbackInterface;

  type
    TConsoleFeedback = class(TFeedbackInterface)
    public
      procedure ShowStatus(msg:string); override;
      procedure ShowError(msg:string); override;
    end;

implementation
  uses
    SysUtils;
    //Windows; //add to avoid: [dcc32 Hint] ConsoleFeedback.pas(25): H2443 Inline function 'Beep' has not been expanded because unit 'Winapi.Windows' is not specified in USES list

  procedure TConsoleFeedback.ShowStatus(msg:string);
  begin
   writeln(msg);
  end;

  procedure TConsoleFeedback.ShowError(msg:string);
  begin
   beep;
   writeln('!!! Error: '+msg);
  end;

end.

