unit Resultados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls;

type
  TFormResultados = class(TForm)
    PlanoDeFundo: TImage;
    Label4: TLabel;
    ComboBoxAluno: TComboBox;
    ComboBoxMateria: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    LabelMedia: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label7: TLabel;
    LabelSituacao: TLabel;
    LabelPorcento: TLabel;
    Panel2: TPanel;
    ImageEditarOK: TImage;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel2Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure ImageEditarOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormResultados: TFormResultados;

  IDProfessor, IDMateria: String;
  IDAula, IDAluno:        String;
  NomeMateria, NomeAula:  String;
  NomeAluno, MediaNota:   String;

  Nota, PresencaAluno:           Real;
  QtdPresenca, QtdAulasMateria:  Real;

implementation
Uses DMbd, AVA, ModoProfessor;

{$R *.dfm}

// ****** PROCEDURE PARA LIMPAR A QUERY
procedure LimparQuery();
begin
//Limpa as Querys
  DM.ZQuery1.Close;
  DM.ZQuery1.SQL.Clear;
end;
// ****** FIM LIMPAR QUERY




// ****** PROCEDURE PARA FAZER SELECT DO ID_PROFESSOR
procedure SelectIdProfessor();
begin
//Limpa Query
  LimparQuery;

  //Faz o SELECT no Banco  para pegar o ID do Professor
  DM.ZQuery1.SQL.Add('Select ID_Prof From Professor where Login_Prof='+
                     Chr(39)+FormLogin.EditUsuario.Text+Chr(39)+';');
                     DM.ZQuery1.Open;
  IDProfessor:= DM.ZQuery1.FieldByName('ID_Prof').AsString;

  //Limpa
  LimparQuery;
end;
// ****** FIM SELECT ID_PROFESSOR



// ****** PROCEDURE PARA FAZER SELECT DA ID_MATÉRIA
procedure SelectIdMateria();
begin
//Limpa Query
  LimparQuery;

  //Joga o nome da Matéria para uma variavel
  NomeMateria:=FormResultados.ComboBoxMateria.Text;

  //Faz o SELECT no Banco  para pegar o ID da Matéria
  DM.ZQuery1.SQL.Add('Select Id_Materia from Materia Where Nome_Materia='+CHR(39) +NomeMateria +CHR(39)+';');
  DM.ZQuery1.Open;
  IDMateria:= DM.ZQuery1.FieldByName('ID_Materia').AsString;

  //Limpa
  LimparQuery;
end;
// ****** FIM SELECT ID_MATÉRIA



// ****** PROCEDURE PARA FAZER SELECT DO ID_ALUNO
 procedure SelectIdAluno;
 begin
 LimparQuery;

  //Joga o nome do Aluno para a variavel
 NomeAluno:=FormResultados.ComboBoxAluno.Text;

  //Faz o SELECT no Banco  para pegar o ID do Aluno selecionado.
  DM.ZQuery1.SQL.Add('Select Id_Aluno From Aluno Where Nome_Aluno=' +CHR(39) +NomeAluno +CHR(39) +';');
  DM.ZQuery1.Open;
  IDAluno:= DM.ZQuery1.FieldByName('Id_Aluno').AsString;

  //Limpa
  LimparQuery;
 end;
// ****** FIM SELECT ID_ALUNO


procedure CalculaPresenca;
begin

  if (FormResultados.ComboBoxAluno.Text='') or
     (FormResultados.ComboBoxMateria.Text='')  then begin
       Application.MessageBox('Selecione o Aluno e a Matéria a ser consultada',':: Erro',MB_ICONERROR);
        end
          else begin
 // SELECT ID ALUNO E MATERIA
 SelectIdAluno;
 SelectIdMateria;

  // ==============================================================|
 //   AQUI CALCULO A MÉDIA DO ALUNO EM NOTAS                       |
// ================================================================|
LimparQuery;

  DM.ZQuery1.SQL.Add('Select SUM(NotaProva/QtdAulas) as Nota from Avaliacao,Materia,aula '+
                     'where ID_Aluno=' +IDAluno +' and Materia.ID_Materia=' +IDMateria +' and '+
                     'Materia.ID_Materia=Aula.ID_Materia and Aula.ID_Aula=Avaliacao.ID_AUla;');
  DM.ZQuery1.Open;
  MediaNota:=DM.ZQuery1.FieldByName('Nota').AsString;

      if MediaNota='' then
        MediaNota:='0';
  FormResultados.LabelMedia.Caption:=MediaNota;
  Nota:=StrToFloat(MediaNota);

    // ==============================================================|
   //   PORCENTAGEM DO ALUNO                                        |
  // ==============================================================|
 //   PRIMEIRO VOU CONTAR QUANTAS PRESENÇAS O ALUNO TEM           |
// ==============================================================|
 LimparQuery;
 DM.ZQuery1.SQL.Add('Select Count(Presenca) as NumeroDePresencas From Avaliacao,Aula '+
                    'Where Presenca=' +CHR(39) +'PRESENTE' +CHR(39)+
                    ' and Id_Aluno=' +IDAluno +' and Aula.ID_Materia=' +IDMateria
                   +' and Avaliacao.ID_Aula=Aula.ID_Aula;');
 DM.ZQuery1.Open;
 QtdPresenca:= DM.ZQuery1.FieldByName('NumeroDePresencas').AsInteger;

  // ==============================================================|
 //   BLZA, AGORA VOU CONTAR QUANTAS AULAS TEM A MATÉRIA           |
// ================================================================|
  LimparQuery;
  DM.ZQuery1.SQL.Add('Select QtdAulas From Materia Where Nome_Materia=' +CHR(39) +FormResultados.ComboBoxMateria.Text +CHR(39) +';');
  DM.ZQuery1.Open;
  QtdAulasMateria:= DM.ZQuery1.FieldByName('QtdAulas').AsInteger;

      //SE A MATÉRIA NAO TIVER NENHUMA AULA, MOSTRA A MENSAGEM, SE NAO...
      if QtdAulasMateria=0 then begin
          Application.MessageBox('Essa matéria ainda não possui nenhuma aula!',':: Erro',MB_ICONEXCLAMATION);
           end
              else begin

  // ==============================================================|
 //   AGORA FAÇO O CÁLCULO PARA TER A PORCENTAGEM DO ALUNO         |
// ================================================================|

      if QtdPresenca=0    then
      FormResultados.LabelPorcento.Caption:='0';


  // Quant. Presenca/Quant. de Aulas da matéria
  PresencaAluno:=(QtdPresenca*100)/QtdAulasMateria;
  FormResultados.LabelPorcento.Caption :=(FormatFloat('0.0',PresencaAluno));


  // ==============================================================|
 //       AGORA VOU CONTROLAR O LABEL APROVADO OU REPROVADO!       |
// ================================================================|

  If (PresencaAluno>=75) and (Nota>=7) then begin
      FormResultados.LabelSituacao.Font.Color:=clLime;
      FormResultados.LabelSituacao.Caption:='Aprovado!';
       end else
        begin
          FormResultados.LabelSituacao.Font.Color:=clRed;
          FormResultados.LabelSituacao.Caption:='Reprovado!';

      end;
    end;
  end;
end;


// ON CLOSE
procedure TFormResultados.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ComboBoxAluno.Items.Clear;
ComboBoxAluno.Text:='';

ComboBoxMateria.Items.Clear;
ComboBoxMateria.Text:='';

LabelMedia.Caption:='';
LabelPorcento.Caption:='';
LabelSituacao.Caption:='';

FormResultados.Hide;
FormProf.show;
end;

// ON SHOW
procedure TFormResultados.FormShow(Sender: TObject);
begin

//Limpa os ComboBox's
ComboBoxMateria.Items.Clear;
ComboBoxAluno.Items.Clear;

//Chama procedimento para pegar o ID do Professor
SelectIdProfessor;

// ==============================================================|
//   JOGO AS MASTÉRIAS REFENTES AO PROFESSOR                     |
// ==============================================================|
// SELECT NOME_MATERIA (Relacionado ao professor logado)
  DM.ZQuery1.SQL.Add('Select Nome_Materia From Materia Where ID_Prof='+IDProfessor+';');
  DM.ZQuery1.Open;

    //Enquanto não for final da consulta FAÇA  - JOGA NO COMBOBOX AS MATÉRIAS
    while not DM.ZQuery1.Eof do
    begin ComboBoxMateria.Items.Add(DM.ZQuery1.FieldByName('Nome_Materia').AsString);
          Dm.ZQuery1.Next;
    end;
    //Limpa
    LimparQuery;

 // ==============================================================|
 //  JOGO OS NOMES DOS ALUNOS NO COMBOBOX REFENTE                 |
 // ===============================================================|
  DM.ZQuery1.SQL.Add('Select Nome_Aluno From Aluno;');
  DM.ZQuery1.Open;

    //Enquanto não for final da consulta FAÇA  - JOGA NO COMBOBOX AS AULAS
    while not DM.ZQuery1.Eof do
    begin FormResultados.ComboBoxAluno.Items.Add(Dm.ZQuery1.FieldByName('Nome_Aluno').AsString);
          DM.ZQuery1.Next;
    end;

      //**Ao carregar os itens no ComboBox, setFocus no primeiro Item.
      FormResultados.ComboBoxAluno.Text:=FormResultados.ComboBoxAluno.Items[0];
      LimparQuery;
end;

procedure TFormResultados.ImageEditarOKClick(Sender: TObject);
begin
CalculaPresenca;
end;

procedure TFormResultados.Label6Click(Sender: TObject);
begin
CalculaPresenca;
end;

procedure TFormResultados.Panel2Click(Sender: TObject);
begin
CalculaPresenca;
end;

end.
