unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, IniFiles,
  Vcl.Menus;

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
    PopupMenu1: TPopupMenu;
    Abrir1: TMenuItem;
    Abrir2: TMenuItem;
    Encerrar1: TMenuItem;
    PopupMenu2: TPopupMenu;
    este1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Abrir1Click(Sender: TObject);
    procedure Encerrar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure este1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  erro: boolean = false;

implementation

{$R *.dfm}

uses uAviso;

procedure TForm1.Abrir1Click(Sender: TObject);
begin
  Form1.Visible := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
  var minutos: integer;
  var txtValor: integer;
begin

    txtValor := StrToInt(Edit1.Text);

    if ((txtValor>120) or (txtValor<1)) then
      begin
        raise Exception.Create('O intervalo deve estar entre 1 e 120 minutos.');
      end else
        begin
            try

            minutos := StrToInt(Edit1.Text)*60000;

            ArqINI := TIniFile.Create('./config.ini');
            ArqINI.WriteString('Config','Time',IntToStr(minutos));
            Timer2.Enabled := False;
            Timer2.Interval := minutos;
            Timer2.Enabled := True;

            if (checkPop.Checked = True) then
              begin
                ArqINI.WriteString('Config','Full','True');
              end else
                begin
                  ArqINI.WriteString('Config','Full','False');
                end;
            finally
              maxtime := strtotime('00:00:00');
              ShowMessage('Informa��es Salvas.');
            end;
        end;


end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TrayIcon1.ShowBalloonHint;
end;

procedure TForm1.Encerrar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.este1Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.Visible:=False;
  Abort;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 maxtime := strtotime('00:00:00');
end;

procedure TForm1.FormShow(Sender: TObject);
  var minutos: string;
  var minutoSalvo: string;
  var popupconfig : string;
  var valor: integer;
begin 
  ArqINI := TIniFile.Create('./config.ini');
  minutoSalvo:= ArqINI.ReadString('Config','Time','90000');
  popupconfig := ArqINI.ReadString('Config', 'Full', 'False');

  
  if not (TrystrToInt(minutoSalvo, valor)) then
    begin
         minutoSalvo := '1800000';
         erro:= True;
         ShowMessage('O arquivo config.ini est� corrompido. Os valores padr�es ser�o aplicados.');
    end;   
  


  if (StrToInt(minutoSalvo)>7200000) then
    begin
      minutoSalvo := IntToStr(1800000);
    end else
      begin
        if ((popupconfig<>'True') and (popupconfig<>'False')) then
          begin
            popupconfig := 'False';
          end;
      end;

        if (popupconfig = 'True') then
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

 if not (erro) then
  begin
    TrayIcon1.ShowBalloonHint;
    maxtime := strtotime('00:00:00');
    Form2.Show;    
  end;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Form1.Visible:=True;
end;

end.
