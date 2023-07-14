unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, IniFiles;

type
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    grupo: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    checkPop: TCheckBox;
    Label2: TLabel;
    Button1: TButton;
    lTimer: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  maxtime: real;
  ArqINI: TIniFile;
  Popup: String;

implementation

{$R *.dfm}

uses uAviso;

procedure TForm1.Button1Click(Sender: TObject);
  var minutos: integer;
begin
  try
    minutos := StrToInt(Edit1.Text)*60000;
    ArqINI := TIniFile.Create('./config.ini');
    ArqINI.WriteString('Config','Time',IntToStr(minutos));
    Timer2.Enabled := False;
    Timer2.Interval := minutos;
    Timer2.Enabled := True;
    if checkPop.Checked then
      begin
        ArqINI.WriteString('Config','Full','True');
      end else
        begin
          ArqINI.WriteString('Config','Full','False');
        end;
  finally
    maxtime := strtotime('00:00:00');
    ShowMessage('Informações Salvas.');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TrayIcon1.ShowBalloonHint;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.Visible:=False;
  Abort;
end;

procedure TForm1.FormCreate(Sender: TObject);
  var minutos: string;
  var minutoSalvo: string;
  var popupconfig : string;
begin
  maxtime := strtotime('00:00:00');
  ArqINI := TIniFile.Create('./config.ini');
  minutoSalvo:= ArqINI.ReadString('Config','Time','90000');
  popupconfig := ArqINI.ReadString('Config', 'Full', 'False');

  if popupconfig = 'True' then
    begin
      checkPop.Checked := True;
    end else
      begin
        checkPop.Checked := False;
      end;

  Edit1.Text := FloatToStr(StrToFloat(minutoSalvo)/60000);
  Timer2.Interval := StrToInt(minutoSalvo);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  maxtime := maxtime + strtotime('00:00:01');

  lTimer.Caption := timetostr(maxtime);

  Application.ProcessMessages;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  TrayIcon1.ShowBalloonHint;
  maxtime := strtotime('00:00:00');
  Form2.Show;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Form1.Visible:=True;
end;

end.
