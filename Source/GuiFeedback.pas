Unit GuiFeedback;

interface
  uses
    FeedbackInterface;

  type
    TGuiFeedback=class(TFeedbackInterface)
    public
      procedure ShowStatus(msg:string); override;
      procedure ShowError(msg:string); override;
    end;

implementation
  uses
    Windows,
    SysUtils;

  procedure TGuiFeedback.ShowStatus(msg:string);
  begin
    //MessageBox(0,pchar(msg),'Ready to upload:',MB_OK);
  end;

  procedure TGuiFeedback.ShowError(msg:string);
  begin
    beep;
    MessageBox(0,pchar(msg),'Error!',MB_OK);
  end;

end.

