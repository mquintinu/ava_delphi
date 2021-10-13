unit VisualizarAula;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, AcroPDFLib_TLB, StdCtrls, pngimage, ExtCtrls, OleCtnrs,ComObj;

type
  TFormVisuAula = class(TForm)
    PlanoDeFundo: TImage;
    Label5: TLabel;
    OleContainerWord: TOleContainer;
    BotaoVerWord: TButton;
    BotaoVerSlide: TButton;
    BotaoVisuPDF: TButton;
    OleContainerSlide: TOleContainer;
    Label7: TLabel;
    Image2: TImage;
    BotaoFazerProva: TButton;
    OleContainerPDF: TOleContainer;
    OleContainerProva: TOleContainer;
    procedure FormShow(Sender: TObject);
    procedure BotaoVerWordClick(Sender: TObject);
    procedure BotaoVerSlideClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image2Click(Sender: TObject);
    procedure BotaoVisuPDFClick(Sender: TObject);
    procedure BotaoFazerProvaClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormVisuAula: TFormVisuAula;
  IDAula: String;

implementation
Uses MateriaAula,Prova,DMbd;

{$R *.dfm}

// ****** PROCEDURE PARA LIMPAR A QUERY
procedure LimparQuery();
begin
//Limpa as Querys
DM.ZQuery1.Close;
DM.ZQuery1.SQL.Clear;
end;
// ****** FIM LIMPAR QUERY


// ****** PROCEDURE PARA FAZER SELECT DA ID_AULA
 procedure SelectIdAula ();
 begin
 //limpar
 LimparQuery;

 Dm.ZQuery1.SQL.Add('Select ID_Aula From Aula Where Id_aula='+
                     FormGerencAulas.ComboBoxNumeroDasAulas.Text+';');
 Dm.ZQuery1.Open;
 IdAula:= DM.ZQuery1.FieldByName('ID_Aula').AsString;

 LimparQuery;
 end;
 // ****** FIM DO SELECT ID_AULA



//===================Ver Documento do Word
procedure TFormVisuAula.BotaoVerWordClick(Sender: TObject);
var DirWORD: string;
begin

  //Limpar Query
  LimparQuery;

  DM.ZQuery1.SQL.ADD('Select DiretorioWord From Doc_Aula,Aula Where '+
                     '(Doc_Aula.Id_Aula=Aula.ID_Aula) and '+
		  			         '(Nome_Aula='+CHR(39)+FormGerencAulas.EditNomeEditarAula.Text +CHR(39)+
                     ') and '+'(DiretorioWord<>'+CHR(39)+CHR(39)+');');
  DM.ZQuery1.Open;
  DirWORD:= DM.ZQuery1.FieldByName('DiretorioWORD').AsString;
    Try
      OleContainerWord.Visible:=True;
      OleContainerWord.CreateObjectFromFile(DirWORD,True);
      OleContainerWord.DoVerb(0)
      Except // SE NÃO HOUVER NENHUM DOCUMENTO DO WORD, MOSTRA MENSAGEM
      Application.MessageBox('Nenhum arquivo do Word encontrado para essa aula.',':: Erro',MB_ICONERROR);
    end;
end;

//=================== Ver PDF
procedure TFormVisuAula.BotaoVisuPDFClick(Sender: TObject);
var DirPDF: string;
begin

  //Limpar Query
  LimparQuery;

  DM.ZQuery1.SQL.ADD('Select DiretorioPDF From Doc_Aula,Aula Where '+
                     '(Doc_Aula.Id_Aula=Aula.ID_Aula) and '+
		  			         '(Nome_Aula='+CHR(39)+FormGerencAulas.EditNomeEditarAula.Text +CHR(39)+
                     ') and '+'(DiretorioPDF<>'+CHR(39)+CHR(39)+');');
  DM.ZQuery1.Open;
  DirPDF:= DM.ZQuery1.FieldByName('DiretorioPDF').AsString;
    Try
      OleContainerPDF.Visible:=True;
      OleContainerPDF.CreateObjectFromFile(DirPDF,True);
      OleContainerPDF.DoVerb(0)
      Except // SE NÃO HOUVER NENHUM DOCUMENTO DO WORD, MOSTRA MENSAGEM
      Application.MessageBox('Nenhum arquivo em PDF encontrado para essa aula.',':: Erro',MB_ICONERROR);
    end;

   {AcroPDF1.Visible:= true;
   FormVisuAula.Align:= alClient;
   AcroPDF1.Align:=alClient;
   AcroPDF1.LoadFile(FormGerencAulas.OpenPDF.FileName);
   ==== ESSE COMANDDOS SERVEM PARA APARECER O PDF NO PRÓPRIO FORMULÁRIO
        MAS PARA POUPAR TEMPO, RESOLVI NÃO UTILIZAR.====}

end;


//====================Ver Slide do Power Point
procedure TFormVisuAula.BotaoFazerProvaClick(Sender: TObject);
begin
 //==== FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUMA PROVA
   //Limpa
   LimparQuery;

   //Chama o SELECT ID
   SelectIDAula;

   DM.ZQuery1.SQL.Add('Select DiretorioPROVA From Aula, Doc_Aula where '+
                      '(Doc_Aula.ID_Aula=Aula.ID_Aula) and'+
                      '(Doc_Aula.ID_aula='+ IDAula+ ') and'+
                      '(DiretorioPROVA<>'+CHR(39)+CHR(39)+');');
   DM.ZQuery1.Open;
   SelectProva:= DM.ZQuery1.FieldByName('DiretorioPROVA').AsString;

    if SelectProva='' then begin
    Application.MessageBox('Nenhum prova cadastrada nessa aula.',':: Erro',MB_ICONERROR);
    end
      else
          begin

          //Chama o SELECT ID
          SelectIDAula;

          DM.ZQuery1.SQL.Add('Select Aula.Id_Aula,DiretorioPROVA From Aula,Doc_Aula '+
                             'Where (Aula.ID_Aula=Doc_Aula.ID_Aula) and '+
          							     '(Aula.ID_aula='+IDAula+') and'+
            							   '(DiretorioPROVA<>'+CHR(39) +CHR(39) +');');
          DM.ZQuery1.Open;
          SelectProva:= DM.ZQuery1.FieldByName('DIretorioPROVA').AsString;

          //Abre a prova
          OleContainerProva.Visible:=True;
          OleContainerProva.CreateObjectFromFile(SelectProva,True);
          OleContainerProva.DoVerb(0)
          end;




end;

procedure TFormVisuAula.BotaoVerSlideClick(Sender: TObject);
var DirSLIDE: string;
begin

  //Limpar Query
  LimparQuery;

  DM.ZQuery1.SQL.ADD('Select DiretorioSLIDE From Doc_Aula,Aula Where '+
                     '(Doc_Aula.Id_Aula=Aula.ID_Aula) and '+
		  			         '(Nome_Aula='+CHR(39)+FormGerencAulas.EditNomeEditarAula.Text +CHR(39)+
                     ') and '+'(DiretorioSLIDE<>'+CHR(39)+CHR(39)+');');
  DM.ZQuery1.Open;
  DirSLIDE:= DM.ZQuery1.FieldByName('DiretorioSLIDE').AsString;
    Try
      OleContainerSlide.Visible:=True;
      OleContainerSlide.CreateObjectFromFile(DirSLIDE,True);
      OleContainerSlide.DoVerb(0)
      Except // SE NÃO HOUVER NENHUM DOCUMENTO DO WORD, MOSTRA MENSAGEM
      Application.MessageBox('Nenhum arquivo do Power Point encontrado para essa aula.',':: Erro',MB_ICONERROR);
    end;
{begin
  Try
   OleContainerSlide.CreateObjectFromFile(FormGerencAulas.OpenSlide.FileName,True);
   OleContainerSlide.DoVerb(0);
  Except // SE NÃO HOUVER NENHUM SLIDE, MOSTRA MENSAGEM
  Application.MessageBox('Nenhum arquivo do Power Point encontrado para essa aula.',':: Erro',MB_ICONERROR);
  End;}
end;


//Ao fechar, destrói e limpa a memória
procedure TFormVisuAula.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FreeAndNil(FormVisuAula);
end;

//Ao Criar, joga o nome da Aula no Label.
procedure TFormVisuAula.FormShow(Sender: TObject);
begin
  Label5.Caption:='Aula '+FormGerencAulas.ComboBoxNumeroDasAulas.Text;
end;

//FECHAR
procedure TFormVisuAula.Image2Click(Sender: TObject);
begin
FormVisuAula.Close;
FormGerencAulas.Show;
end;

end.
