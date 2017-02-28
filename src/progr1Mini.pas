unit progr1Mini;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, epcWindows, SynEditHighlighter, SynHighlighterGeneral,
  SynEdit, SynMemo;

type
  TfrmProg2 = class(TForm)
    Memo1: TMemo;
    Button2: TButton;
    SynMemo1: TSynMemo;
    SynGeneralSyn1: TSynGeneralSyn;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     procedure savefile(fn:string);


    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  frmProg2: TfrmProg2;

implementation

uses Unit1Mini;

{$R *.dfm}



procedure _ExportEvent(Parent: Cardinal; const Output, Error: string; var AbortProcess: Boolean); stdcall;
var s:string;
begin
  if Parent > 0 then
  begin
    with TfrmProg2(Parent) do
    begin
      if Output > '' then begin
        s:=memo1.Text;
        s:=s+Output;
        memo1.Text:=s;
        update;
      end;
      if Error > '' then
        memo1.Lines.Add(Error);


    end;
  end;
end;

procedure TfrmProg2.savefile(fn:string);
var f:textfile;
    i:integer;
    s:string;
begin
if not fileexists(fn) then exit;
assignfile(f,fn);
rewrite(f);
writeln(f,'#picaxe '+form21.picaxe);
writeln(f,'#no_data');
writeln(f,'');
for i:=0 to self.SynMemo1.Lines.Count-1 do
  begin
    s:=self.SynMemo1.Lines[i];
    writeln(f,s);
  end;
closefile(f);
end;

procedure TfrmProg2.Button2Click(Sender: TObject);
var
    ExitCode: Int64;
    OutPutText: string;
    ErrorText: string;

begin
 savefile(ExtractFileDir(Application.ExeName)+'\basic\prog.bas');
 memo1.lines.Clear;
 self.Button2.Enabled:=false;
 form21.caption:=ExtractFileDir(Application.ExeName)+'\basic\prog.bas';
 epcWindows.CallCmd(
    ExtractFileDir(Application.ExeName)+'\picaxe\',
    'picaxe18m2.exe',
    '-s '+ExtractFileDir(Application.ExeName)+'\basic\prog.bas',
    ExitCode,
    OutPutText,
    ErrorText,
    10,
    Cardinal(Self),
    @_ExportEvent
   );
  self.Button2.Enabled:=true;
end;

procedure TfrmProg2.FormShow(Sender: TObject);
begin
self.Memo1.Clear;
end;

procedure TfrmProg2.Button1Click(Sender: TObject);
var s:string;
 ExitCode: Int64;
    OutPutText: string;
    ErrorText: string;
begin
if form21.com_port='' then
    begin
      ShowMessage('Configurez d''abord le port s�rie associ� au c�ble USB AXE027 dans le menu param�tres');
      exit;
    end;
savefile(ExtractFileDir(Application.ExeName)+'\basic\prog.bas');
 memo1.lines.Clear;
 self.Button1.Enabled:=false;
 //form1.caption:=ExtractFileDir(Application.ExeName)+'\basic\prog.bas';
 s:= '-c'+form21.com_port+' '+ExtractFileDir(Application.ExeName)+'\basic\prog.bas';
 epcWindows.CallCmd(
    ExtractFileDir(Application.ExeName)+'\picaxe\',
    'picaxe18m2.exe',
    s,
    ExitCode,
    OutPutText,
    ErrorText,
    10,
    Cardinal(Self),
    @_ExportEvent
   );
  self.Button1.Enabled:=true;
end;

end.
