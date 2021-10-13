unit Materia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, pngimage,AVA,ComObj ;

type
  TFormMateria = class(TForm)
    PlanoDeFundo: TImage;
    TimerMateria: TTimer;
    LabelNomeAluno: TLabel;
    BotaoSair: TButton;
    ComboBoxMateria: TComboBox;
    ComboBoxAula: TComboBox;
    Image1: TImage;
    BotaoVisuAula: TButton;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Image2: TImage;
    procedure TimerMateriaTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BotaoSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxMateriaChange(Sender: TObject);
    procedure BotaoVisuAulaClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMateria: TFormMateria;

implementation
Uses DMbd,MateriaAula,VisuAluno;

{$R *.dfm}
//===============================================================
//===============================================================
//  PROCEDURES CRIADAS NA MÃO
//===============================================================
//===============================================================
// <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

// ****** PROCEDURE PARA LIMPAR A QUERY
procedure LimparQuery();
begin
//Limpa as Querys
DM.ZQuery1.Close;
DM.ZQuery1.SQL.Clear;
end;
// ****** FIM LIMPAR QUERY

// ****** PROCEDURE PARA FAZER SELECT DA ID_MATÉRIA
procedure SelectIdMateria();
begin
//Limpa Query
  LimparQuery;

  //Faz o SELECT no Banco  para pegar o ID da Matéria
  DM.ZQuery1.SQL.Add('Select Id_Materia from Materia Where Nome_Materia='+CHR(39)+
                      FormMateria.ComboBoxMateria.Text +CHR(39)+';');
  DM.ZQuery1.Open;
  IDMateria:= DM.ZQuery1.FieldByName('ID_Materia').AsString;

  LimparQuery;
end;
// ****** FIM SELECT ID_MATÉRIA

// ==============================================================|
//   FAZER O FORM APARECER LENTAMENTE                            |
// ==============================================================|
procedure TFormMateria.TimerMateriaTimer(Sender: TObject);
begin
    FormMateria.AlphaBlendValue:=FormMateria.AlphaBlendValue+3  ;
    if formMateria.AlphaBlendValue = 255 then
    begin TimerMateria.enabled := false;
    end;
end;

// ==============================================================|
//   BOTÃO SAIR                                                  |
// ==============================================================|
procedure TFormMateria.BotaoSairClick(Sender: TObject);
begin
if Application.MessageBox('Deseja sair da aplicação?','Sair',mb_YesNo+Mb_IconQuestion)=id_yes then
Application.Terminate else
  begin FormMateria.Close;
        FormLogin.Show;
  end;
end;

// ==============================================================|
//   AO CRIAR O FORM, DOU BOAS-VINDAS AO ALUNO                   |
// ==============================================================|
procedure TFormMateria.BotaoVisuAulaClick(Sender: TObject);
begin
if (ComboBoxAula.Text='') or (ComboBoxMateria.Text='') then
    begin
    Application.MessageBox('Nenhuma aula selecionada.',':: Erro',MB_ICONERROR);
    end
    else begin
    FormMateria.Hide;
    FormVisuAulaAluno.Show;
end;
end;



procedure TFormMateria.ComboBoxMateriaChange(Sender: TObject);
begin
ComboBoxAula.Items.Clear;
// ==============================================================|
//   DEPOIS JOGO AS AULAS QUE EXISTEM NA MATERIA SELECIONADA     |
// ==============================================================|
//Limpa as Queys
LimparQuery;

  //Chama procedimento para pegar o ID da Matéria
  SelectIdMateria;


DM.ZQuery1.SQL.Add('Select Nome_Aula From Aula,materia where (Materia.Id_Materia=Aula.Id_Materia)'+
                   'and (Aula.Id_Materia='+IDMateria+');');
DM.ZQuery1.Open;

    //Enquanto não for final da consulta FAÇA  - JOGA NO COMBOBOX AS AULAS
    while not DM.ZQuery1.Eof do
    begin ComboBoxAula.Items.Add(DM.ZQuery1.FieldByName('Nome_Aula').AsString);
          Dm.ZQuery1.Next;
    end;
      //**Ao carregar os itens no ComboBox, setFocus no primeiro Item.
      ComboBoxAula.Text:=ComboBoxAula.Items[0];
end;

procedure TFormMateria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ComboBoxMateria.Items.Clear;
ComboBoxMateria.Text:='';

ComboBoxAula.Items.Clear;
ComboBoxAula.Text:='';
end;

procedure TFormMateria.FormCreate(Sender: TObject);
var Hd : THandle; //variavel pra deixar o FormRedondo
//NomeALunoSql: String;
begin
//Limpa as Querys
LimparQuery;

// MSG DE BOAS-VINDAS AO PROFESSOR
DM.ZQuery1.SQL.Add('Select Nome_Aluno FROM Aluno WHERE Login_aluno='
                   +Chr(39)+FormLogin.EditUsuario.Text+Chr(39)+';');
DM.ZQuery1.Open;
LabelNomeAluno.Caption:=Dm.ZQuery1.FieldByName('Nome_Aluno').AsString;

// ==============================================================|
//   AO CRIAR O FORM, DEIXO ELE REDONDO                          |
// ==============================================================|
//CreateEllipticRgn(ponto_inicial_horizontal(-) ,ponto_inicial_vertical(|) ,largura,altura)
Hd := CreateEllipticRgn(0,10,610,580);
SetWindowRgn(Handle,Hd,True);
end;

procedure TFormMateria.FormShow(Sender: TObject);
begin
                                                                                                                                                // ==============================================================|
//   NO "SHOW" DO FORM, JOGO OS NOMES DAS MATERIAS NO COMBOBOX   |
// ==============================================================|

ComboBoxMateria.Items.Clear;
ComboBoxAula.Items.Clear;
//Limpar as Querys
LimparQuery;

DM.ZQuery1.SQL.Add('Select Nome_Materia From Materia order by Id_materia;');
Dm.ZQuery1.Open;

    //Enquanto não for final da consulta FAÇA  - JOGA NO COMBOBOX AS MATÉRIAS
    while not DM.ZQuery1.Eof do
    begin ComboBoxMateria.Items.Add(DM.ZQuery1.FieldByName('Nome_Materia').AsString);
          Dm.ZQuery1.Next;
    end;
      //**Ao carregar os itens no ComboBox, setFocus no primeiro Item.
//      ComboBoxMateria.Text:=ComboBoxMateria.Items[0];
      ComboBoxAula.Text:='';
end;




procedure TFormMateria.Image2Click(Sender: TObject);
begin
 //Fala Mensagem de Boas-vindas
  voz:=CreateOleObject('SAPI.SpVoice');
  voz.Rate:=-1;
  voz.speak('Seja bem-vindo:'+LabelNomeAluno.Caption+
            ' Selecione a matéria e a aula que deseja, assitir. Tenha uma boa aula!!');

end;

end.

