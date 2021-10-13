unit VisuAluno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtnrs, jpeg, pngimage, ExtCtrls;

type
  TFormVisuAulaAluno = class(TForm)
    ImageWord: TImage;
    ImageSlide: TImage;
    ImagePDF: TImage;
    BotaoAvaliacao: TButton;
    OleContainerWord: TOleContainer;
    PlanoDeFundo: TImage;
    Label3: TLabel;
    Label4: TLabel;
    OleContainerSlide: TOleContainer;
    OleContainerPDF: TOleContainer;
    LabelNomeAula: TLabel;
    Label1: TLabel;
    EditCaminho: TEdit;
    BotaoCarregarProva: TButton;
    Label2: TLabel;
    OpenWord: TOpenDialog;
    Label6: TLabel;
    ImagePronto: TImage;
    OleContainerProva: TOleContainer;
    ImagePresenca: TImage;
    LabelPresenca: TLabel;
    procedure ImageWordClick(Sender: TObject);
    procedure ImageSlideClick(Sender: TObject);
    procedure ImagePDFClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoAvaliacaoClick(Sender: TObject);
    procedure BotaoCarregarProvaClick(Sender: TObject);
    procedure ImageProntoClick(Sender: TObject);
    procedure ImagePresencaClick(Sender: TObject);
    procedure LabelPresencaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormVisuAulaAluno: TFormVisuAulaAluno;

  SelectProva, DirPROVA: String;
  CaminhoEdit, SelectAula: String;
  SelectAluno: String;

  SelectAulaINT: Integer;
  SelectAlunoINT: Integer;

implementation

uses DMbd, Materia,MateriaAula, Presenca;

{$R *.dfm}

// ****** PROCEDURE PARA LIMPAR A QUERY
procedure LimparQuery();
begin
  //Limpa as Querys
  DM.ZQuery1.Close;
  DM.ZQuery1.SQL.Clear;
end;
// ****** FIM LIMPAR QUERY


// ****** SELECT PARA PEGAR O ID DA AULA
procedure SelectIDAula();
begin
  LimparQuery;

  Dm.ZQuery1.SQL.Add('Select ID_Aula From Aula where Nome_Aula='+CHR(39)+
                      FormMateria.ComboBoxAula.Text+CHR(39)+';');
  Dm.ZQuery1.Open;
  SelectAula:= Dm.ZQuery1.FieldByName('ID_Aula').AsString;

  SelectAulaINT:=(StrToInt(SelectAula));

  LimparQuery;
end;
// ****** FIM DO SELECT PARA PEGAR O ID DA AULA
{$R *.dfm}

// ****** SELECT PARA PEGAR O ID DO ALUNO
procedure SelectIDAluno;
begin
  LimparQuery;

  DM.ZQuery1.SQL.Add('Select ID_Aluno From Aluno where Nome_Aluno='+CHR(39)
                     +FormMateria.LabelNomeAluno.Caption +CHR(39) +';');
  DM.ZQuery1.Open;
  SelectAluno:= DM.ZQuery1.FieldByName('ID_Aluno').AsString;

  SelectAlunoINT:=(StrToInt(SelectAluno));
  LimparQuery;
end;
// ****** FIM DO SELECT PARA PEGAR O ID DO ALUNO

procedure SelectProvaProf;
begin
  //==== FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUMA PROVA
   //Limpa
   LimparQuery;

   //Chama o SELECT ID
   SelectIDAula;

   DM.ZQuery1.SQL.Add('Select DiretorioPROVA From Aula, Doc_Aula where '+
                      '(Doc_Aula.ID_Aula=Aula.ID_Aula) and'+
                      '(Doc_Aula.ID_aula='+ SelectAula+ ') and'+
                      '(DiretorioPROVA<>'+CHR(39)+CHR(39)+');');
   DM.ZQuery1.Open;
   SelectProva:= DM.ZQuery1.FieldByName('DiretorioPROVA').AsString;
end;


procedure TFormVisuAulaAluno.BotaoAvaliacaoClick(Sender: TObject);
begin

     SelectProvaProf;

    if SelectProva='' then begin
    Application.MessageBox('Nenhum prova cadastrada nessa aula.',':: Erro',MB_ICONERROR);
    end
      else
          begin

          //Chama o SELECT ID
          SelectIDAula;

          DM.ZQuery1.SQL.Add('Select Aula.Id_Aula,DiretorioPROVA From Aula,Doc_Aula '+
                             'Where (Aula.ID_Aula=Doc_Aula.ID_Aula) and '+
          							     '(Aula.ID_aula='+SelectAula+') and'+
            							   '(DiretorioPROVA<>'+CHR(39) +CHR(39) +');');
          DM.ZQuery1.Open;
          SelectProva:= DM.ZQuery1.FieldByName('DIretorioPROVA').AsString;

          //Abre a prova
          OleContainerProva.Visible:=True;
          OleContainerProva.CreateObjectFromFile(SelectProva,True);
          OleContainerProva.DoVerb(0)
          end;



end;

procedure TFormVisuAulaAluno.BotaoCarregarProvaClick(Sender: TObject);
begin
 If OpenWord.Execute then begin
    begin DirPROVA:= OpenWord.FileName;
          EditCaminho.Text:= OpenWord.FileName;
          caminhoEdit:=EditCaminho.Text;
      end;
  end;
end;

procedure TFormVisuAulaAluno.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EditCaminho.Clear;
  FormVisuAulaAluno.Hide;
  FormMateria.Show;
end;

procedure TFormVisuAulaAluno.FormShow(Sender: TObject);
begin
 LabelNomeAula.Caption:=FormMateria.ComboBoxAula.Text;
 ImagePresenca.Visible:=False;
 LabelPresenca.Visible:= False;
end;

procedure TFormVisuAulaAluno.ImagePDFClick(Sender: TObject);
var DirPDF: string;

begin
  //Limpar Query
  LimparQuery;

  DM.ZQuery1.SQL.ADD('Select DiretorioPDF From Doc_Aula,Aula Where '+
                     '(Doc_Aula.Id_Aula=Aula.ID_Aula) and '+
		  			         '(Nome_Aula='+CHR(39)+FormMateria.ComboBoxAula.Text +CHR(39)+') and '+
			  		         '(DiretorioPDF<>'+CHR(39)+CHR(39)+');');
  DM.ZQuery1.Open;
  DirPDF:= DM.ZQuery1.FieldByName('DiretorioPDF').AsString;

    Try
      OleContainerPDF.Visible:=True;
      OleContainerPDF.CreateObjectFromFile(DirPDF,True);
      OleContainerPDF.DoVerb(0)
      Except // SE NÃO HOUVER NENHUM DOCUMENTO EM PDF, MOSTRA MENSAGEM
       Application.MessageBox('Nenhum arquivo em PDF foi encontrado para essa aula.',':: Erro',MB_ICONERROR);
    end;


end;

procedure TFormVisuAulaAluno.ImagePresencaClick(Sender: TObject);
begin
FormVisuAulaAluno.Hide;
FormPresenca.Show;
end;

procedure TFormVisuAulaAluno.ImageProntoClick(Sender: TObject);
begin

   if EditCaminho.Text='' then begin
      Application.MessageBox('Você não carregou nenhuma prova.',':: Erro',MB_ICONERROR);
     end
      else begin
        SelectProvaProf;
          if SelectProva='' then begin
              Application.MessageBox('Não há nenhuma prova inserida para ser respondida.',':: Erro', MB_ICONERROR);
            end
              else begin


    SelectIDAluno;
    SelectIDAula;

    //==== FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUMA PROVA
   //Limpa
   LimparQuery;

   DM.ZQuery1.SQL.Add('Select DIretorioProva from Avaliacao,Aluno,Aula where'+
                      ' Avaliacao.ID_Aluno=ALuno.ID_Aluno'+
                      ' and Avaliacao.ID_aluno='+SelectAluno+
                      ' and Aula.ID_Aula=Avaliacao.ID_Aula'+
                      ' and Avaliacao.ID_Aula='+SelectAula+' ;');
   DM.ZQuery1.Open;
   SelectProva:= DM.ZQuery1.FieldByName('DiretorioPROVA').AsString;

   if SelectProva<>'' then begin
      Application.MessageBox('Já existe uma prova feita desta aula.',':: Erro',MB_ICONERROR);
    end
      else begin

      SelectIDAula;
      SelectIDAluno;
      //Limpa
      LimparQuery;

      DM.ZQuery1.SQL.Add('Insert into Avaliacao (DiretorioProva, ID_Aula, ID_Aluno) Values '+
                                                ('(:DirProva, :IdAula, :IdAluno);'));
                                                //'(' +CHR(39) +EditCaminho.Text +CHR(39) +','
                                               //   +SelectAula +',' +SelectAluno +');');
      DM.ZQuery1.ParamByName('DirProva').AsString:=EditCaminho.Text;
      DM.ZQuery1.ParamByName('IdAula').AsInteger:= SelectAulaINT;
      DM.ZQuery1.ParamByName('IdAluno').AsInteger:= SelectAlunoINT;
      DM.ZQuery1.ExecSQL;

      //=========== CONCLUÍDO
      Application.MessageBox('Prova enviada com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
  end;
      end;

   LabelPresenca.Visible:= True;
   ImagePresenca.Visible:= True;
 end;


end;

procedure TFormVisuAulaAluno.ImageSlideClick(Sender: TObject);
var DirSLIDE: string;

begin
  //Limpar Query
  LimparQuery;

  DM.ZQuery1.SQL.ADD('Select DiretorioSLIDE From Doc_Aula,Aula Where '+
                     '(Doc_Aula.Id_Aula=Aula.ID_Aula) and '+
		  			         '(Nome_Aula='+CHR(39)+FormMateria.ComboBoxAula.Text +CHR(39)+') and '+
			  		         '(DiretorioSLIDE<>'+CHR(39)+CHR(39)+');');
  DM.ZQuery1.Open;
  DirSLIDE:= DM.ZQuery1.FieldByName('DiretorioSLIDE').AsString;

    Try
      OleContainerSlide.Visible:=True;
      OleContainerSlide.CreateObjectFromFile(DirSLIDE,True);
      OleContainerSlide.DoVerb(0)
      Except // SE NÃO HOUVER NENHUM DOCUMENTO DO POWER POINT, MOSTRA MENSAGEM
       Application.MessageBox('Nenhum arquivo do PowerPoint foi encontrado para essa aula.',':: Erro',MB_ICONERROR);
    end;

end;


procedure TFormVisuAulaAluno.ImageWordClick(Sender: TObject);
var DirWord: string;

begin
  //Limpar Query
  LimparQuery;

  DM.ZQuery1.SQL.ADD('Select DiretorioWord From Doc_Aula,Aula Where '+
                     '(Doc_Aula.Id_Aula=Aula.ID_Aula) and '+
		  			         '(Nome_Aula='+CHR(39)+FormMateria.ComboBoxAula.Text +CHR(39)+') and '+
			  		         '(DiretorioWord<>'+CHR(39)+CHR(39)+');');
  DM.ZQuery1.Open;
  DirWORD:= DM.ZQuery1.FieldByName('DiretorioWORD').AsString;
    Try
      OleContainerWord.Visible:=True;
      OleContainerWord.CreateObjectFromFile(DirWord,True);
      OleContainerWord.DoVerb(0)
      Except // SE NÃO HOUVER NENHUM DOCUMENTO DO WORD, MOSTRA MENSAGEM
       Application.MessageBox('Nenhum arquivo do Word encontrado para essa aula.',':: Erro',MB_ICONERROR);
    end;
end;

procedure TFormVisuAulaAluno.LabelPresencaClick(Sender: TObject);
begin
ImageWordClick(Sender);
end;

end.
