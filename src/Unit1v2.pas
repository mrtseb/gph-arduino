unit Unit1v2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, OleCtrls, ShockwaveFlashObjects_TLB, tabassoc,
  ComCtrls, CPort;
const
   max=50;
   max_char=72;

type
  TForm1 = class(TForm)

    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Nouveau1: TMenuItem;
    Enregistrersous1: TMenuItem;
    Enregistrer1: TMenuItem;
    Quitter1: TMenuItem;
    Edition1: TMenuItem;
    Ajoutertape1: TMenuItem;
    Supprimertape1: TMenuItem;
    Simulation1: TMenuItem;
    Dmarrer1: TMenuItem;
    Stopper1: TMenuItem;
    Paramtres1: TMenuItem;
    Timer1: TTimer;
    Panel1: TPanel;
    chkA: TCheckBox;
    chkB: TCheckBox;
    chkC: TCheckBox;
    chkD: TCheckBox;
    chkE: TCheckBox;
    chkF: TCheckBox;
    chkH: TCheckBox;
    chkG: TCheckBox;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Ouvrir1: TMenuItem;
    Timer2: TTimer;
    flash1: TShockwaveFlash;
    Associeruneanimationflash1: TMenuItem;
    fscmd: TListBox;
    Memo1: TMemo;
    DetecterleportassociaucableAXE0271: TMenuItem;
    DtecterlecbleUSBPICAXE1: TMenuItem;
    Programmation1: TMenuItem;
    Gnrerunfichierbasic1: TMenuItem;
    ChoisirlePICAXEcible1: TMenuItem;
    ConstruireunfichierbasicPICAXE1: TMenuItem;
    ComPort1: TComPort;
    Timer3: TTimer;
    Memo2: TMemo;
    procedure Quitter1Click(Sender: TObject);
    procedure Ajoutertape1Click(Sender: TObject);
    procedure etapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Supprimertape1Click(Sender: TObject);
    procedure etapeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Nouveau1Click(Sender: TObject);

    procedure etapeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Dmarrer1Click(Sender: TObject);
    procedure Stopper1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Ouvrir1Click(Sender: TObject);
    procedure Enregistrersous1Click(Sender: TObject);
    procedure Enregistrer1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Associeruneanimationflash1Click(Sender: TObject);
    procedure flash1FSCommand(ASender: TObject; const command,
      args: WideString);
    procedure DetecterleportassociaucableAXE0271Click(Sender: TObject);
    procedure DtecterlecbleUSBPICAXE1Click(Sender: TObject);
    procedure ConstruireunfichierbasicPICAXE1Click(Sender: TObject);
    procedure Gnrerunfichierbasic1Click(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure Timer3Timer(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure ChoisirlePICAXEcible1Click(Sender: TObject);
  private
    { D�clarations priv�es }

    input,output:integer;
    pilotage:boolean;
    mini,maxi,frame:integer;
    //tempo:int64;
    dico:TableauAssociatif;
    filename:string;
    ordres:array[0..50] of string;
    tempo:array[0..50] of longint;//compte en ms
    step_count:integer;
    comp_count:integer;
    debut,fin,deltaX,deltaY:integer;
    liens, receptivites:array[0..max,0..max] of string;
    etapes_actives:array[0..max] of integer;
    procedure gerer_ordres(var cmd:string);
    procedure clean;
    procedure redraw;
    function equations(eq:string):string;
    procedure drawlink(d,f:integer);
    procedure save(fn:string);
    function traduit(instr:string;mode:string='cond'):string;
    function clean_instr(instr:string):string;
  public
    { D�clarations publiques }
    ftdi_device: string;
    com_port: string;
    picaxe:string;
  end;

var
  Form1: TForm1;
  flash:string;

implementation

uses Unit2v2, Unit3v2, unit4v2, progr1v2;
{$R *.dfm}
function Split(chaine : String; delimiteur : string) : TStringList;
var
L : TStringList;
begin
  L:=TStringList.create;
  L.text := StringReplace(chaine, delimiteur, #13#10, [rfReplaceAll]);
  Split:=L;
end;


function Tform1.clean_instr(instr:string):string;
var s:string;
    ar:Tstringlist;
begin
   s:=instr;
   if (pos('and',s)<>0) and (pos('or',s)<> 0) then begin
        //instr complexe � scinder
        ar:=split(s,'or');
   end;
   result:=s;
end;
procedure Tform1.gerer_ordres(var cmd:string);
var i,j:integer;
    delta:integer;
begin
if flash='' then exit;



//modume simple allumage

if pos('FEUX1',uppercase(flash)) <> 0  then begin
self.flash1.Loop:=true;
self.flash1.Play;
cmd:=trim(uppercase(cmd));
if pos('F1V',cmd) <> 0 then self.flash1.SetVariable('Feu1','V');
if pos('F1R',cmd) <> 0 then self.flash1.SetVariable('Feu1','R');
if pos('F10',cmd) <> 0 then self.flash1.SetVariable('Feu1','O');
if pos('F2V',cmd) <> 0 then self.flash1.SetVariable('Feu2','V');
if pos('F2R',cmd) <> 0 then self.flash1.SetVariable('Feu2','R');
if pos('F20',cmd) <> 0 then self.flash1.SetVariable('Feu2','O');
if pos('F3V',cmd) <> 0 then self.flash1.SetVariable('Feu3','V');
if pos('F3R',cmd) <> 0 then self.flash1.SetVariable('Feu3','R');
if pos('F30',cmd) <> 0 then self.flash1.SetVariable('Feu3','O');
//flash1.GotoFrame(1);
//flash1.GotoFrame(0);
exit;
end;

if pos('VA_ET_VIENT',uppercase(flash)) <> 0  then begin
self.flash1.Loop:=true;


if dico.EstPresent('inter1') then begin self.flash1.SetVariable('Inter1',dico['inter1']); self.flash1.Play;  end;
if dico.EstPresent('inter0') then begin self.flash1.SetVariable('Inter0',dico['inter0']); self.flash1.Play;  end;
if dico.Keys.Count=0 then
begin
self.flash1.SetVariable('Inter0','0');
self.flash1.Play;
self.flash1.SetVariable('Inter1','0');
self.flash1.Play;
dico['inter0']:='0';
dico['inter1']:='0';
end;

cmd:=trim(uppercase(cmd));
if (cmd='') then exit;
self.flash1.SetVariable('Lampe','0');
self.flash1.Play;
if pos('ALLUMER',cmd) <> 0 then begin self.flash1.setVariable('Lampe','1'); self.flash1.Play;  end;
if pos('ETEINDRE',cmd) <> 0 then begin self.flash1.setVariable('Lampe','0'); self.flash1.Play; end;

exit;
end;

if pos('FONCTION',uppercase(flash)) <> 0  then begin

   self.flash1.Loop:=true;

      if dico.EstPresent('inter') then begin self.flash1.SetVariable('Inter',dico['inter']); self.flash1.Play;  end;
      cmd:=trim(uppercase(cmd));

      if (cmd='') then exit;
      self.flash1.SetVariable('Lampe','0');
      self.flash1.Play;
      if pos('ALLUMER',cmd) <> 0 then begin
         self.flash1.setVariable('Lampe','1');
         self.flash1.Play;

         if (self.picaxe='18M2') and(self.pilotage=true) then self.output:=self.output or $01;
         if (self.picaxe='08M2') and(self.pilotage=true) then self.output:=self.output or $02;


      end else begin
            self.flash1.setVariable('Lampe','0');
            self.flash1.Play;
            if (self.picaxe='18M2') and (self.pilotage=true) then self.output:=self.output and $FE;
            if (self.picaxe='08M2') and (self.pilotage=true) then self.output:=self.output and $FD;

         end;

   exit;
end;
//module ascenseur
  if pos('ASCENSEUR',uppercase(flash)) <> 0  then begin
    for i:=0 to step_count do begin
      cmd:=trim(uppercase(self.ordres[i]));
      if (cmd='') then continue;
      //memo1.lines.Add(cmd);
      delta:=1;
      //delta := (self.tempo div 50) mod 2;

      if pos('MONTER',cmd) <> 0 then
         begin
          self.maxi:=20;
            for j:=0 to step_count do begin
               if pos('niveau1',liens[i,j]) <> 0 then self.maxi:=10;
            end;
          if self.frame<self.maxi then self.frame:=self.frame+delta;
          self.flash1.GotoFrame(self.frame);
         end;
      if pos('DESCENDRE',cmd) <> 0 then
         begin
           self.mini:=0;
           for j:=0 to step_count do begin
             if pos('niveau1',liens[i,j]) <> 0 then self.mini:=10;
           end;
           if self.frame>self.mini then self.frame:=self.frame-delta;
           self.flash1.GotoFrame(self.frame);
       end;
    end;
    self.Update;
  end;


end;

procedure Tform1.save(fn:string);
var f:textfile;
    i,j,k:integer;

begin
     assignfile(f,fn);
     rewrite(f);
     writeln(f,self.step_count-1);
     for i:=0 to self.step_count-1 do begin
       writeln(f,'@');
       for k:=0 to (self.Components[self.comp_count+i] as Tmemo).Lines.Count-1 do
         writeln(f,(self.Components[self.comp_count+i] as Tmemo).Lines[k]);
       writeln(f,'#');
       writeln(f,(self.Components[self.comp_count+i] as Tmemo).Top);
       writeln(f,(self.Components[self.comp_count+i] as Tmemo).Left);

     end;
     for i:=0 to self.step_count-1 do
     for j:=0 to self.step_count-1 do
       writeln(f,liens[i,j]);
     writeln(f,flash);
     closefile(f);
end;

function Tform1.traduit(instr:string;mode:string='cond'):string;
var s:string;
ordre:longword;
begin
s:=uppercase(instr);

if (mode='cond') and (self.picaxe='18M2') then begin
s  := Trim(StringReplace(s,'.', ' and ', [rfReplaceAll, rfIgnoreCase]));
s  := Trim(StringReplace(s,'+', ' or ', [rfReplaceAll, rfIgnoreCase]));
s  := Trim(StringReplace(s,'/INTER1', 'pinC.7=0', [rfReplaceAll]));
s  := Trim(StringReplace(s,'/INTER2', 'pinC.6=0', [rfReplaceAll]));
s  := Trim(StringReplace(s,'INTER1', 'pinC.7=1', [rfReplaceAll]));
s  := Trim(StringReplace(s,'INTER2', 'pinC.6=1', [rfReplaceAll]));
s  := Trim(StringReplace(s,'/INTER', 'pinC.7=0', [rfReplaceAll, rfIgnoreCase]));
s  := Trim(StringReplace(s,'INTER', 'pinC.7=1', [rfReplaceAll, rfIgnoreCase]));
result:=s;
exit;
end;

if (mode='cond') and (self.picaxe='08M2') then begin
s  := Trim(StringReplace(s,'.', ' and ', [rfReplaceAll, rfIgnoreCase]));
s  := Trim(StringReplace(s,'+', ' or ', [rfReplaceAll, rfIgnoreCase]));
s  := Trim(StringReplace(s,'/INTER1', 'pin4=0', [rfReplaceAll]));
s  := Trim(StringReplace(s,'/INTER2', 'pin3=0', [rfReplaceAll]));
s  := Trim(StringReplace(s,'INTER1', 'pin4=1', [rfReplaceAll]));
s  := Trim(StringReplace(s,'INTER2', 'pin3=1', [rfReplaceAll]));
s  := Trim(StringReplace(s,'/INTER', 'pin4=0', [rfReplaceAll, rfIgnoreCase]));
s  := Trim(StringReplace(s,'INTER', 'pin4=1', [rfReplaceAll, rfIgnoreCase]));
result:=s;
exit;
end;

ordre:=0;
if ((mode='ordre') and (self.pilotage=true) and (self.picaxe='18M2')) then begin
  if pos('ALLUMER',s) <>0 then  ordre:= ordre and $01;
  self.ComPort1.WriteStr(inttostr(ordre));
  result:='1';
end;

if ((mode='ordre') and (self.pilotage=true) and (self.picaxe='08M2')) then begin
  if pos('ALLUMER',s) <>0 then  ordre:= ordre and $01;
  self.ComPort1.WriteStr(inttostr(ordre));
  result:='1';
end;

end;

function Tform1.equations(eq:string):string;
var inp,s,add:string;
kk,test:integer;
begin



    s := Trim(eq);

    if self.pilotage=true then
    begin
    //memo1.Clear;
     //memo1.lines.add('pilotage');
    for kk:=0 to dico.keys.Count-1 do begin

      if self.picaxe='18M2' then begin

       if (trim(dico.keys[kk])='inter') and (self.input and 128 =128) then s  := Trim(StringReplace(s,dico.Keys[kk],'1', [rfReplaceAll, rfIgnoreCase]))
       else if (trim(dico.keys[kk])='inter1') and (self.input and 128 = 128) then s  := Trim(StringReplace(s,dico.Keys[kk],'1', [rfReplaceAll, rfIgnoreCase]))
       else if (trim(dico.keys[kk])='inter2') and (self.input and 64 = 64) then s  := Trim(StringReplace(s,dico.Keys[kk],'1', [rfReplaceAll, rfIgnoreCase]))
       else s  := Trim(StringReplace(s,dico.Keys[kk],'0', [rfReplaceAll, rfIgnoreCase]));

       end;

        if self.picaxe='08M2' then begin

       if (trim(dico.keys[kk])='inter') and (self.input and 16 =16) then s  := Trim(StringReplace(s,dico.Keys[kk],'1', [rfReplaceAll, rfIgnoreCase]))
       else if (trim(dico.keys[kk])='inter1') and (self.input and 16 = 16) then s  := Trim(StringReplace(s,dico.Keys[kk],'1', [rfReplaceAll, rfIgnoreCase]))
       else if (trim(dico.keys[kk])='inter2') and (self.input and 8 = 8) then s  := Trim(StringReplace(s,dico.Keys[kk],'1', [rfReplaceAll, rfIgnoreCase]))
       else s  := Trim(StringReplace(s,dico.Keys[kk],'0', [rfReplaceAll, rfIgnoreCase]));

       end;

    end;
    end

    else

    begin

    for kk:=0 to dico.keys.Count-1 do begin
       if pos(dico.Keys[kk],s)<>0  then s  := Trim(StringReplace(s,dico.Keys[kk],trim(dico[dico.Keys[kk]]) , [rfReplaceAll, rfIgnoreCase]));
    end;

    For kk := 65 To max_char do
    begin
    if Tcheckbox(FindComponent('chk'+chr(kk))).Checked then add:='1' else add:='0';
    s  := Trim(StringReplace(s,Chr(kk), add, [rfReplaceAll, rfIgnoreCase]));
    end;

    end;

    s  := Trim(StringReplace(s,'/0', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'/1', '0', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'0.0', '0', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'0.1', '0', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'1.0', '0', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'1.1', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'0+0', '0', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'0+1', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'1+0', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'1+1', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'0~0', '0', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'0~1', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'1~0', '1', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,'1~1', '0', [rfReplaceAll, rfIgnoreCase]));

    equations:=s;
end;
procedure Tform1.redraw;
var i,j:integer;
begin
form1.Refresh;
for i:=0 to step_count-1 do
for j:=0 to step_count-1 do
if liens[i,j]<>'-1' then self.drawlink(i,j);
end;

procedure Tform1.drawlink(d,f:integer);
var haut1,gauche1,haut2,gauche2,milieu:integer;

begin
if d=f then exit;
if d=-1 then exit;
if f=-1 then exit;

if liens[d,f]='-1' then exit;

gauche1:=(self.Components[self.comp_count+d] as Tmemo).Left + (self.Components[self.comp_count+d] as Tmemo).Width div 2;
haut1:=(self.Components[self.comp_count+d] as Tmemo).Top + (self.Components[self.comp_count+d] as Tmemo).Height div 2;

gauche2:=(self.Components[self.comp_count+f] as Tmemo).Left + (self.Components[self.comp_count+f] as Tmemo).Width div 2;
haut2:=(self.Components[self.comp_count+f] as Tmemo).Top + (self.Components[self.comp_count+f] as Tmemo).Height div 2;

milieu:=(haut1+haut2) div 2;

form1.Canvas.MoveTo(gauche1,haut1);
form1.Canvas.LineTo(gauche2,haut1);
form1.Canvas.LineTo(gauche2,milieu);
if (haut1>haut2) then begin
form1.Canvas.LineTo(gauche2-10,milieu+10);
form1.Canvas.MoveTo(gauche2+10,milieu+10);

end else begin
form1.Canvas.LineTo(gauche2-10,milieu-10);
form1.Canvas.MoveTo(gauche2+10,milieu-10);

end;
form1.Canvas.LineTo(gauche2,milieu);
form1.Canvas.LineTo(gauche2,haut2);

form1.Canvas.Textout(gauche2+10,milieu,liens[d,f]);

end;

procedure Tform1.clean;
var i,j:integer;
begin
self.Refresh;
for i:=0 to max do
for j:=0 to max do
self.liens[i,j]:='-1';

if step_count=0 then exit;
repeat
self.Components[self.ComponentCount-1].Destroy;
dec(step_count);
until (self.ComponentCount = self.comp_count);
end;



procedure TForm1.Quitter1Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.Ajoutertape1Click(Sender: TObject);
var txt:Tmemo;
begin
txt:=Tmemo.create(self);
txt.Parent :=self;
txt.Visible:=true;
txt.Color :=clYellow;
txt.Text:='Etape '+inttostr(self.step_count);
if self.step_count=0 then txt.Top:=30 else txt.Top:=30+self.step_count*60;
txt.left:=110;
txt.Height:=40;
txt.Width:=120;
txt.tag:=step_count;
txt.ScrollBars:=ssVertical;
inc(step_count);
txt.OnMouseDown:=etapeMouseDown;
txt.OnDragOver:=etapeDragOver;
txt.OnDragDrop:=etapeDragDrop;
end;

procedure TForm1.etapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//form1.Caption:=inttostr((sender as Tmemo).tag);
(sender as Tmemo).BeginDrag(false);
debut:=(sender as Tmemo).Tag;
deltaX:=(sender as Tmemo).Left;
deltaY:=(sender as Tmemo).Top;
end;

procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
Accept := (Source is Tmemo);

end;

procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
//(source as tmemo).Top := Y-self.deltaY;
//(source as tmemo).Left := X-self.deltaX;
(source as tmemo).Top := Y;
(source as tmemo).Left := X;
self.redraw;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j:integer;
begin
self.pilotage:=false;
form1.picaxe:='08M2';
self.comp_count:=self.ComponentCount;
for i:=0 to self.comp_count do
for j:=0 to self.comp_count do
self.liens[i,j]:='-1';
dico:=TableauAssociatif.Create;
end;

procedure TForm1.Supprimertape1Click(Sender: TObject);
var i,j:integer;
begin
if self.ComponentCount = self.comp_count then exit;
self.Components[self.ComponentCount-1].Destroy;
for i:=0 to self.comp_count do self.liens[i,self.step_count-1]:='-1';
for j:=0 to self.comp_count do self.liens[self.step_count-1,j]:='-1';
dec(self.step_count);
self.redraw;

end;

procedure TForm1.etapeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);

begin
accept:=(source is Tmemo);
end;

procedure TForm1.Nouveau1Click(Sender: TObject);
begin
timer1.Enabled:=false;
self.clean;
self.filename:='';
self.flash1.Visible:=false;
flash:='';
self.fscmd.Clear;
end;



procedure TForm1.etapeDragDrop(Sender, Source: TObject; X, Y: Integer);
var value:string;
begin
debut:=(source as Tmemo).Tag;
fin:=(sender as Tmemo).Tag;
//form1.caption:=inttostr(debut)+'-'+inttostr(fin);
if (debut=fin) then begin
  self.debut:=-1;
  self.fin:=-1;
  exit;
end;
value := InputBox('Test program', 'Entrez la condition de transition de l''etape '+inttostr(debut)+' � l''�tape '+inttostr(fin), liens[debut,fin]);
if value='' then value:='-1';
self.liens[debut,fin]:=value;
self.drawlink(self.debut,self.fin);
self.redraw;
self.debut:=-1;
self.fin:=-1;

end;

procedure TForm1.Dmarrer1Click(Sender: TObject);
var i,j:integer;
begin
self.pilotage:=false;
self.Stopper1Click(self);
self.frame:=0;

memo1.lines.clear;
if step_count=0 then exit;
for i:=0 to step_count do
for j:=0 to step_count do
receptivites[i,j]:='-1';

(self.Components[self.comp_count] as Tmemo).Color:=TColor($3378E4);
timer1.Enabled:=true;
etapes_actives[0]:=1;
for i:=1 to max do etapes_actives[i]:=-1;

end;

procedure TForm1.Stopper1Click(Sender: TObject);
var i,j:integer;
begin
self.flash1.GotoFrame(0);
timer1.Enabled:=false;
for i:=0 to max do begin etapes_actives[i]:=-1; self.tempo[i]:=0;  end;

for i:=0 to step_count-1 do (self.Components[self.comp_count+i] as Tmemo).Color:=clYellow;

for i:=0 to step_count do
for j:=0 to step_count do
receptivites[i,j]:='-1';

end;

procedure TForm1.Timer1Timer(Sender: TObject);

var cond,ord:string;
    i,j,k,kk:integer;
begin

    for i:=0 to step_count do begin
       if etapes_actives[i]=1 then for j:=0 to step_count do begin
          cond:=liens[i,j];
          if cond<>'-1' then begin
             //cond a 1
             if cond='1' then receptivites[i,j]:='1' else receptivites[i,j]:='-1';
             //Receptivites checkbox
             For k := 65 to max_char do
             begin
             If (cond = Chr(k)) Then if Tcheckbox(FindComponent('chk'+chr(k))).Checked  Then receptivites[i, j] := '1' Else receptivites[i, j] := '-1';
             //If (cond = '/'+Chr(k)) Then if Tcheckbox(FindComponent('chk'+chr(k))).Checked  Then receptivites[i, j] := '-1' Else receptivites[i, j] := '1';
             If (Pos('/', cond)<>0) or (Pos('+', cond)<>0) or (Pos('~', cond)<>0) or (Pos('.', cond)<>0) then receptivites[i, j]:=equations(cond);


             for kk:=0 to dico.keys.Count-1 do begin
                 if pos(dico.Keys[kk],cond)<>0  then receptivites[i, j]:=equations(cond);
             end;


             end;
          end;
       end;

       //traiter les receptivites

       //for ii:=0 to step_count do
       For j:=0 to step_count do
       If (etapes_actives[i] = 1) and (trim(receptivites[i, j]) = '1') Then begin

              etapes_actives[i] := -1;
              (self.Components[self.comp_count+i] as Tmemo).Color:=clYellow;
              self.ordres[i]:='';
              self.tempo[i]:=0;

              etapes_actives[j] := 1;
              (self.Components[self.comp_count+j] as Tmemo).Color:=TColor($3378E4);
              self.tempo[j]:=0;
              ord:=Tmemo(self.Components[self.comp_count+j]).Text;
              gerer_ordres(ord);
              //memo1.lines.Add('unset '+inttostr(i)+' set '+inttostr(j)+' '+self.ordres[j]);




       end; //if
       //gerer_ordres();
       self.tempo[i]:=self.tempo[i]+self.Timer1.Interval;
    end;//for
end;

procedure TForm1.Ouvrir1Click(Sender: TObject);
var f:textfile;
s,txt:string;
i,j,cnt:integer;
begin
//memo1.Clear;
timer1.Enabled:=false;
dico.fElems.Clear;
self.fscmd.Clear;
self.OpenDialog1.InitialDir:=GetCurrentDir()+'\GPH\';
self.OpenDialog1.FileName:='*.GPH';
self.OpenDialog1.Filter:='*.GPH';
if self.OpenDialog1.Execute then begin
   if self.OpenDialog1.Filename='*.GPH' then exit;
   //form1.caption:=self.OpenDialog1.FileName;
   self.filename:=self.OpenDialog1.FileName;
   self.clean;
   assignfile(f,self.OpenDialog1.filename);
   reset(f);
   //lit nb etapes
   readln(f,s);
   cnt:=strtoint(trim(s));
   //lit @
   readln(f,s);
   //lit le texte
   readln(f,txt);
   while s<>'#' do begin
       readln(f,s);
       if (s<>'#') then txt:=txt+chr(13)+chr(10)+s;
   end;
   //Ajouter etape 0
   Ajoutertape1Click(sender);
   (self.Components[self.comp_count] as Tmemo).Text:=txt;
   readln(f,s); (self.Components[self.comp_count] as Tmemo).Top:=StrToint(trim(s));
   readln(f,s); (self.Components[self.comp_count] as Tmemo).Left:=StrToint(trim(s));
   //
   for i:=1 to cnt do begin
      readln(f,s);
      readln(f,txt);
      while s<>'#' do begin
       readln(f,s);
       if (s<>'#') then txt:=txt+chr(13)+chr(10)+s;
      end;
      Ajoutertape1Click(sender);
      (self.Components[self.comp_count+i] as Tmemo).Text:=txt;
      readln(f,s); (self.Components[self.comp_count+i] as Tmemo).Top:=StrToint(trim(s));
      readln(f,s); (self.Components[self.comp_count+i] as Tmemo).Left:=StrToint(trim(s));

   end;

   for i:=0 to cnt do
     for j:=0 to cnt do
       begin
         readln(f,s);
         //memo1.Lines.Add(s);
         self.liens[i,j]:=trim(s);
       end;
   readln(f,s);

   flash:=s;

   if flash<>'' then begin
      self.flash1.movie:=GetCurrentDir+chr(92)+s;
      self.flash1.Visible:=true;
      self.flash1.Loop:=false;
      //self.TrackBar1.Max:=self.flash1.TotalFrames-1;
   end else begin
      self.flash1.Visible:=false;
   end;
   closefile(f);
   self.redraw;
 end;//if


end;

procedure TForm1.Enregistrersous1Click(Sender: TObject);
begin
  self.SaveDialog1.InitialDir:=GetCurrentdir+'\GPH\';
  self.SaveDialog1.FileName:='*.GPH';
  self.SaveDialog1.Filter:='*.GPH';
  if self.SaveDialog1.Execute then begin
     self.Save(self.SaveDialog1.FileName);
  end;
end;

procedure TForm1.Enregistrer1Click(Sender: TObject);
var test:integer;
begin
 if self.filename='' then exit;
 if self.filename='*.GPH' then exit;
 self.SaveDialog1.FileName:=self.filename;
  self.SaveDialog1.Filter:='*.GPH';
  //if self.SaveDialog1.Execute then begin
     self.Save(self.FileName);
     test:=MessageDlg('Sauvegarde',mtInformation, mbOKCancel, 0);
  //end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
redraw;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
redraw;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
redraw;
end;

procedure TForm1.Associeruneanimationflash1Click(Sender: TObject);
begin
form2.show;
end;

procedure TForm1.flash1FSCommand(ASender: TObject; const command,
  args: WideString);
  var i:integer;
  begin

//memo1.Lines.Add(command+' '+args);
dico[command]:=args;
fscmd.Clear;
//dico.
  for i:=0 to dico.Keys.Count-1 do
  begin
    fscmd.Items.Add(dico.Keys[i]);
    if trim(dico[dico.Keys[i]]) = '1' then begin
        fscmd.Selected[i] :=true;
    end;
  end;
end;

procedure TForm1.DetecterleportassociaucableAXE0271Click(Sender: TObject);
begin
form3.show;
form3.Edit1.Text:=self.com_port;
end;

procedure TForm1.DtecterlecbleUSBPICAXE1Click(Sender: TObject);
begin
form4.Timer1.Enabled:=true;
form4.show;
end;

procedure TForm1.ConstruireunfichierbasicPICAXE1Click(Sender: TObject);
begin
if self.com_port='' then begin
 ShowMessage('Le port COM n''estpas encore param�tr�, vous pouvez le faire dans le menu param�tres');
 exit;
end;
try
     form1.ComPort1.Open;
except
     on E : Exception do
      ShowMessage(E.ClassName+' une erreur s''est produite avec le message : '+E.Message);
end;

self.Timer3.Enabled:=true;
self.Dmarrer1Click(self);
self.pilotage:=true;
//self.ComPort1.WriteStr('1'+#13#10);
end;

procedure TForm1.Gnrerunfichierbasic1Click(Sender: TObject);
begin
self.Timer3.Enabled:=false;
self.Stopper1Click(self);
self.ComPort1.WriteStr('0'+#13#10);
self.pilotage:=false;
self.output:=0;
self.input:=0;
try
     form1.ComPort1.Close;
   except
     on E : Exception do
      ShowMessage(E.ClassName+' une erreur s''est produite avec le message : '+E.Message);
   end;
end;

procedure TForm1.ComPort1RxChar(Sender: TObject; Count: Integer);
var str:string;
begin
self.ComPort1.ReadStr(Str,count);
form1.Memo2.lines.add(Str);
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var s:string;
begin
self.ComPort1.WriteStr(inttostr(self.output)+#13#10);
s:=self.Memo2.Text;
self.Memo2.Clear;
s:= Trim(StringReplace(s,#13#10, '', [rfReplaceAll, rfIgnoreCase]));
end;

procedure TForm1.Memo2Change(Sender: TObject);
var s:string;
old:integer;
begin
  s:=memo2.text;
  if pos('#',s)<>0 then
  begin
    s  := Trim(StringReplace(s,'#', '', [rfReplaceAll, rfIgnoreCase]));
    s  := Trim(StringReplace(s,#13#10, '', [rfReplaceAll, rfIgnoreCase]));
    if (s<>'') then
    begin
      old:=self.input;
      if (strtoint(s)) <> old then begin
        self.input:=strtoint(s);
        memo1.lines.Add(s);
      end;
    end;
  end;
end;
procedure TForm1.ChoisirlePICAXEcible1Click(Sender: TObject);
begin
self.picaxe := InputBox('PICAXE cible', '08M2 ou 18M2 pour le picaxe', self.picaxe);
end;

end.
