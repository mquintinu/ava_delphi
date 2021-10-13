unit ModoProfessor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, ComObj;

type
  TFormProf = class(TForm)
    PlanoDeFundo: TImage;
    LabelNomeProf: TLabel;
    Label2: TLabel;
    BotaoMateria: TButton;
    BotaoAula: TButton;
    BotaoAvaliacao: TButton;
    BotaoDesempenho: TButton;
    Image1: TImage;
    Label3: TLabel;
    Audio: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoMateriaClick(Sender: TObject);
    procedure BotaoAulaClick(Sender: TObject);
    procedure AudioClick(Sender: TObject);
    procedure BotaoAvaliacaoClick(Sender: TObject);
    procedure BotaoDesempenhoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProf: TFormProf;
  //Variável do Narrador
  voz :OleVariant;

implementation
Uses DMbd,AVA,MateriaCadastro, MateriaAula, Avaliacao, Resultados;

{$R *.dfm}

//Fechar Form
procedure TFormProf.AudioClick(Sender: TObject);
begin
 //Fala Mensagem de Boas-vindas
voz:=CreateOleObject('SAPI.SpVoice');
voz.Rate:=1;
voz.speak('Seja bem-vindo professor:'+LabelNomeProf.Caption);
end;

procedure TFormProf.BotaoAulaClick(Sender: TObject);
begin
Application.CreateForm(TFormGerencAulas,FormGerencAulas);
FormProf.Hide;
FormGerencAulas.Show;
end;

procedure TFormProf.BotaoAvaliacaoClick(Sender: TObject);
begin
FormProf.Hide;
FormAvaliacao.show;
end;

procedure TFormProf.BotaoMateriaClick(Sender: TObject);
begin
FormProf.Hide;
FormCadastrarMateria.Show;
end;

procedure TFormProf.BotaoDesempenhoClick(Sender: TObject);
begin
FormProf.Hide;
FormResultados.show;
end;

procedure TFormProf.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormLogin.AcaoSairForms.Execute;
end;

procedure TFormProf.FormCreate(Sender: TObject);
begin
// MSG DE BOAS-VINDAS AO PROFESSOR
//Limpa as Querys
DM.ZQuery1.Close;
DM.ZQuery1.SQL.Clear;

//NomeAlunoSql
DM.ZQuery1.SQL.Add('Select Nome_Prof FROM Professor WHERE Login_Prof='
                   +Chr(39)+FormLogin.EditUsuario.Text+Chr(39)+';');
DM.ZQuery1.Open;   //CHR(39) Significa Apóstrofo
LabelNomeProf.Caption:=Dm.ZQuery1.FieldByName('Nome_Prof').AsString;

end;
end.
