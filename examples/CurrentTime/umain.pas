unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, almBase, almDateTime;

type

  { TfmMain }

  TfmMain = class(TForm)
    btTimer: TButton;
    edLocalTime: TLabeledEdit;
    edUTC: TLabeledEdit;
    edTAI: TLabeledEdit;
    edTT: TLabeledEdit;
    edTDB: TLabeledEdit;
    edUT1: TLabeledEdit;
    edUT2: TLabeledEdit;
    edUT0: TLabeledEdit;
    edTCG: TLabeledEdit;
    edTCB: TLabeledEdit;
    lbDST: TLabel;
    edTimeZone: TFloatSpinEdit;
    edDST: TFloatSpinEdit;
    lbTimeZone: TLabel;
    pnLocalConfig: TPanel;
    pnTimeScales: TPanel;
    Timer: TTimer;
    procedure btTimerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerStopTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    ts: TTimeScales;
    LocalTime: TJulianDate;
    procedure DisplayTimeScales;
  end; 

var
  fmMain: TfmMain;

implementation

{$R *.lfm}

{ TfmMain }

procedure TfmMain.FormCreate(Sender: TObject);
begin
  ts:= TTimeScales.Create;
  edTimeZone.Value:= -3;   // Brazil/Sao Paulo timezone
  edDST.Value:= 1;   // We're at Daylight Saving Time on Brazil 2010 Summer!
end;

procedure TfmMain.btTimerClick(Sender: TObject);
begin
  Timer.Enabled:= not Timer.Enabled;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  ts.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  Caption:= Application.Title;
  Timer.Enabled:= True;
end;

procedure TfmMain.TimerStartTimer(Sender: TObject);
begin
  btTimer.Caption:= 'Pause';
end;

procedure TfmMain.TimerStopTimer(Sender: TObject);
begin
  btTimer.Caption:= 'Continue';
end;

procedure TfmMain.TimerTimer(Sender: TObject);
begin
  LocalTime:= DateTimeToJulianDate(Now);
  ts.UTC:= LocalCivilTimeToUTC(LocalTime,edTimeZone.Value,edDST.Value);
  DisplayTimeScales;
end;

procedure TfmMain.DisplayTimeScales;
  function JDFmt(jd: TJulianDate): string;
  var
    floatfmt, dtfmt: string;
  begin
    floatfmt:= '#,##0.00000000';
    dtfmt:= 'yyyy/mm/dd hh:nn:ss.zzz';
    Result:= FormatDateTime(dtfmt,JulianDateToDateTime(jd)) +
             ' -> JD ' + FormatFloat(floatfmt,jd);
  end;
begin
  edLocalTime.Text:= JDFmt(LocalTime);
  edUTC.Text:= JDFmt(ts.UTC);
  edTAI.Text:= JDFmt(ts.TAI);
  edTT.Text:=  JDFmt(ts.TT);
  edTDB.Text:= JDFmt(ts.TDB);
  edTCG.Text:= JDFmt(ts.TCG);
  edTCB.Text:= JDFmt(ts.TCB);
  edUT1.Text:= JDFmt(ts.UT1);
  edUT2.Text:= JDFmt(ts.UT2);
  edUT0.Text:= JDFmt(ts.UT0);
end;



end.
