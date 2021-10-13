unit Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, ComCtrls,AVA;

type
  TFormSplash = class(TForm)
    Panel1: TPanel;
    LabelNome: TLabel;
    Label3: TLabel;
    Image1: TImage;
    BarraProgresso: TProgressBar;
    Timer1: TTimer;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSplash: TFormSplash;

implementation


{$R *.dfm}

//TIMER resposável pela interação da BarraDeProgresso e o Label.
procedure TFormSplash.Timer1Timer(Sender: TObject);
begin
// QUANDO ACABAR DE FAZER O PROGRAMA MUDAR O POSITION PARA "+1"
BarraProgresso.Position:=BarraProgresso.Position+50;
Label1.Caption:=IntToStr(BarraProgresso.Position)+'%';
if BarraProgresso.Position=1 then
   Label4.Caption:='Inserindo matéria nova...';
   if BarraProgresso.Position=25 then
      Label4.Caption:='Corrigindo provas...';
      if BarraProgresso.Position=50 then
         Label4.Caption:='Reprovando alunos...';
         if BarraProgresso.Position=75 then
            Label4.Caption:='Entregando diplomas...';
              if BarraProgresso.Position=90 then
                 Label4.Caption:='Iniciando programa...';
end;

end.
