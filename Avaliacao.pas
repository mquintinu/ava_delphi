unit Avaliacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, OleCtnrs, jpeg;

type
  TFormAvaliacao = class(TForm)
    PlanoDeFundo: TImage;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ComboBoxMateria: TComboBox;
    ComboBoxAula: TComboBox;
    ComboBoxAluno: TComboBox;
    Image2: TImage;
    Label7: TLabel;
    BotaoVerProva: TButton;
    LabelNota: TLabel;
    ImageOK: TImage;
    OleContainerProva: TOleContainer;
    ComboBoxNota: TComboBox;
    ImageProva: TImage;
    procedure Image2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxMateriaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoVerProvaClick(Sender: TObject);
    procedure ImageOKClick(Sender: TObject);
    procedure ComboBoxAlunoChange(Sender: TObject);
    procedure ComboBoxAulaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAvaliacao: TFormAvaliacao;
  IDProfessor, IDMateria, IDAula, IDAluno: String;
  NomeAula, NomeAluno: String;
  DiretorioP, SelectNota: String;

  Nota: Real;


implementation

uses ModoProfessor,DMbd, AVA;

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

  LimparQuery;
end;
// ****** FIM SELECT ID_PROFESSOR

// ****** PROCEDURE PARA FAZER SELECT DA ID_MATÉRIA
procedure SelectIdMateria();
begin
//Limpa Query
  LimparQuery;

  //Faz o SELECT no Banco  para pegar o ID da Matéria
  DM.ZQuery1.SQL.Add('Select Id_Materia from Materia Where Nome_Materia='+CHR(39)+
                      FormAvaliacao.ComboBoxMateria.Text +CHR(39)+';');
  DM.ZQuery1.Open;
  IDMateria:= DM.ZQuery1.FieldByName('ID_Materia').AsString;

  LimparQuery;
end;
// ****** FIM SELECT ID_MATÉRIA

// ****** PROCEDURE PARA FAZER SELECT DA ID_AULA
procedure SelectIdAula;
begin
  LimparQuery;

  //Faz o SELECT no Banco  para pegar o ID da Aula selecionada.
  DM.ZQuery1.SQL.Add('Select Id_Aula From Aula Where Nome_Aula=' +CHR(39) +NomeAula +CHR(39) +';');
  DM.ZQuery1.Open;
  IDAula:= DM.ZQuery1.FieldByName('Id_Aula').AsString;

  LimparQuery;
end;
 // ****** FIM SELECT ID_AULA

 // ****** PROCEDURE PARA FAZER SELECT DO ID_ALUNO
 procedure SelectIdAluno;
 begin
 LimparQuery;

 //Faz o SELECT no Banco  para pegar o ID do Aluno selecionado.
  DM.ZQuery1.SQL.Add('Select Id_Aluno From Aluno Where Nome_Aluno=' +CHR(39) +NomeAluno +CHR(39) +';');
  DM.ZQuery1.Open;
  IDAluno:= DM.ZQuery1.FieldByName('Id_Aluno').AsString;

  LimparQuery;

 end;
  // ****** FIM SELECT ID_ALUNO

// ****** SELECT INSERIR NOTA
procedure InsereNota;
begin
 DM.ZQuery1.SQL.Add('Update Avaliacao SET NotaProva = :NotaDigitada Where '+
                    'ID_Aluno = :IdDoAluno and ID_Aula = :IdDaAula');
 DM.ZQuery1.ParamByName('NotaDigitada').Value:=Nota;
 DM.ZQuery1.ParamByName('IdDoAluno').Value:= IDAluno;
 DM.ZQuery1.ParamByName('IDDaAula').Value:= IDAula;
 DM.ZQuery1.ExecSQL;

 Application.MessageBox('Nota atualizada com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
  end;
    // ****** FIM SELECT INSERIR NOTA


procedure TFormAvaliacao.BotaoVerProvaClick(Sender: TObject);
begin
NomeAula:= ComboBoxAula.Text;
NomeAluno:= ComboBoxAluno.Text;

 if NomeAula='' then begin
    Application.MessageBox('Nenhum aluno selecionado!',':: Erro',MB_ICONERROR);
    end else

      begin
      SelectIdAluno;
      SelectIdAula;

      DM.ZQuery1.SQL.Add('Select DiretorioProva From Avaliacao where Id_ALuno='+IDAluno+
                         ' and Id_aula=' +IDAula +';');
      DM.ZQuery1.Open;
      DiretorioP:= DM.ZQuery1.FieldByName('DiretorioProva').AsString;

      LimparQuery;

        if DiretorioP='' then begin
           Application.MessageBox('Este aluno ainda não fez esta prova!',':: Erro',MB_ICONERROR);
            end else
              begin

              //Abre a prova
                   Try
                     OleContainerProva.Visible:=True;
                     OleContainerProva.CreateObjectFromFile(DiretorioP,True);
                     OleContainerProva.DoVerb(0);

                      ComboBoxNota.Enabled:= True;
                      ComboBoxNota.Visible:= True;
                      ImageOK.Enabled:= True;
                      ImageOK.Visible:= True;
                      LabelNota.Visible:= True;
                      ImageProva.Visible:= False;
                      ComboBoxNota.Text :='0 a 10';

                   Except
                   Application.MessageBox('O caminho da prova não foi encontrado.',':: Erro',MB_ICONERROR);
                   FormAvaliacao.SetFocus;
                   End;
          end;
      end;
end;

procedure TFormAvaliacao.ComboBoxAlunoChange(Sender: TObject);
begin
// Ativa o botão "VER PROVA"
  if (ComboBoxMateria.Text='') or
        (ComboBoxAula.Text='') or
          (ComboBoxAluno.Text='') then begin
          BotaoVerProva.Enabled:= False;
          end else
              begin
              BotaoVerProva.Enabled:=True;
      end;


end;

procedure TFormAvaliacao.ComboBoxAulaChange(Sender: TObject);
begin
// Ativa o botão "VER PROVA"
  if (ComboBoxMateria.Text='') or
        (ComboBoxAula.Text='') or
          (ComboBoxAluno.Text='') then begin
          BotaoVerProva.Enabled:= False;
          end else
              begin
              BotaoVerProva.Enabled:=True;
      end;

end;

procedure TFormAvaliacao.ComboBoxMateriaChange(Sender: TObject);
begin

ComboBoxAula.Items.Clear;

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
    LimparQuery;
      //**Ao carregar os itens no ComboBox, setFocus no primeiro Item.
      ComboBoxAula.Text:=ComboBoxAula.Items[0];

      LimparQuery;

      If ComboBoxAula.Text='' then begin
         ComboBoxAluno.Enabled:= False;
         end else
          ComboBoxAluno.Enabled:= True;


          // Ativa o botão "VER PROVA"
  if (ComboBoxMateria.Text='') or
        (ComboBoxAula.Text='') or
          (ComboBoxAluno.Text='') then begin
          BotaoVerProva.Enabled:= False;
          end else
              begin
              BotaoVerProva.Enabled:=True;
      end;

end;

procedure TFormAvaliacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormProf.Show;
end;

procedure TFormAvaliacao.FormShow(Sender: TObject);
begin
//Limpa os ComboBox's
ComboBoxMateria.Items.Clear;
ComboBoxAula.Items.Clear;
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
      //**Ao carregar os itens no ComboBox, setFocus no primeiro Item.
      ComboBoxMateria.Text:=ComboBoxMateria.Items[0];

      ComboBoxMateriaChange(sender);
      LimparQuery;

// ==============================================================|
//   JOGO OS NOMES DOS ALUNOS NO COMBOBOX REFENTE                |
// ==============================================================|
DM.ZQuery1.SQL.Add('Select Nome_Aluno From Aluno;');
DM.ZQuery1.Open;

    //Enquanto não for final da consulta FAÇA  - JOGA NO COMBOBOX AS AULAS
    while not DM.ZQuery1.Eof do
    begin ComboBoxAluno.Items.Add(Dm.ZQuery1.FieldByName('Nome_Aluno').AsString);
          DM.ZQuery1.Next;
    end;

      //**Ao carregar os itens no ComboBox, setFocus no primeiro Item.
      ComboBoxAluno.Text:=ComboBoxAluno.Items[0];
      LimparQuery;
end;

procedure TFormAvaliacao.Image2Click(Sender: TObject);
begin
FormAvaliacao.Hide;
FormProf.show;
end;

procedure TFormAvaliacao.ImageOKClick(Sender: TObject);
begin

  //Verifica se a nota foi digitada
 if ComboBoxNota.Text='' then begin
    Application.MessageBox('Digite uma nota para a prova!',':: Erro',MB_ICONERROR);
      end
        else  begin

    //==== FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUMA NOTA CADASTRADA
   //Limpa
   LimparQuery;

   DM.ZQuery1.SQL.Add('Select NotaProva From Avaliacao,Aula,Aluno where '+
                      'Aula.Id_Aula=Avaliacao.Id_Aula and '+
        						  'Nome_Aluno=' +CHR(39) +ComboBoxAluno.Text +CHR(39) +' and '+
         						  'Nome_Aula='  +CHR(39) +ComboBoxAula.Text  +CHR(39) +';');
   DM.ZQuery1.Open;
   SelectNota:= DM.ZQuery1.FieldByName('NotaProva').AsString;

   LimparQuery;

   // SE NÃO HOUVER NENHUM NOTA CADASTRADA.
    if SelectNota='' then begin
        SelectIdAula;
        SelectIdAluno;

        //========= INSERE A NOTA NO BANCO
          Try
            Nota:= (StrToFloat(ComboBoxNota.Text));
            LabelNota.Visible:= False;
            ComboBoxNota.Visible:= False;
            ImageOK.Visible:= False;
            ImageProva.Visible:= true;
            InsereNota;
          Except
            Application.MessageBox('Dígito inválido.Digite uma nota de 0 a 10',':: Erro', MB_ICONERROR);
          End;

    end
      else begin
   // SE Já HOUVER UMA NOTA.
    if SelectNota<>'' then begin
      if Application.MessageBox('Você já registrou uma nota para essa prova. Atualizar?.',':: Erro',MB_ICONEXCLAMATION+MB_YESNO)=ID_YES
        then begin

         SelectIdAula;
         SelectIdAluno;

          //========= INSERE A NOTA NO BANCO
          Try
            Nota:= (StrToFloat(ComboBoxNota.Text));
            LabelNota.Visible:= False;
            ComboBoxNota.Visible:= False;
            ImageOK.Visible:= False;
            ImageProva.Visible:= true;
            InsereNota;
          Except
            Application.MessageBox('Dígito inválido.Digite uma nota de 0 a 10',':: Erro', MB_ICONERROR);
          End;
          end;
        end;
      end;
        end;
end;

end.
