unit FeedbackInterface;

interface

  type

    IFeedbackInterface = interface
      ['{AA5ED4B7-BAA7-418C-B1DE-1B82F87F62B2}']
      procedure ShowStatus(msg: string);
      procedure ShowError(msg: string);
    end;

    TFeedbackInterface = class(TInterfacedObject, IFeedbackInterface)
      procedure ShowStatus(msg: string); virtual; abstract;
      procedure ShowError(msg: string); virtual; abstract;
    end;

implementation

end.
