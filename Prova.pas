unit Prova;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, OleCtnrs, comObj;

type
  TFormProva = class(TForm)
    PlanoDeFundo: TImage;
    OleContainerWord: TOleContainer;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    ImagePronto: TImage;
    EditCaminho: TEdit;
    BotaoCarregarArq: TButton;
    Label4: TLabel;
    Label5: TLabel;
    OpenWord: TOpenDialog;
    Image2: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure BotaoCarregarArqClick(Sender: TObject);
    procedure ImageProntoClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProva: TFormProva;
  DirPROVA,SelectProva,CaminhoEdit: String;
  Voz: OleVariant;

implementation
uses MateriaAula,DMbd;

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


procedure TFormProva.BotaoCarregarArqClick(Sender: TObject);
begin
 If OpenWord.Execute then begin
    begin DirPROVA:= OpenWord.FileName;
          EditCaminho.Text:= OpenWord.FileName;
          caminhoEdit:=EditCaminho.Text;
      end;
  end;
end;


procedure TFormProva.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormGerencAulas.Show;
end;

procedure TFormProva.FormShow(Sender: TObject);
var CaminhoProva: String;
begin
  CaminhoProva:=('C:\Modelo Prova.docx');
  OleContainerWord.Visible:= True;
  OleContainerWord.CreateObjectFromFile(CaminhoProva,True);
  OleContainerWord.DoVerb(0);
  OleContainerWord.Focused;
end;

procedure TFormProva.Image2Click(Sender: TObject);
begin
 //Fala de Ajuda
  voz:=CreateOleObject('SAPI.SpVoice');
  voz.Rate:=1;
  voz.speak('Foi aberto um documento no Word, atrás do programa. Nele você encontra'+
            ' um modelo de prova, para seguir. Edite sua prova, com questões Alternativas e Dissertativas.'+
            ' Ao terminar, salve o documento, carregue-o abaixo e pressione o botão verde.');
end;

procedure TFormProva.ImageProntoClick(Sender: TObject);
begin
 if EditCaminho.Text='' then begin
     Application.MessageBox('Nenhuma prova selecionada!',':: Erro',MB_ICONERROR);
  end
    else begin
  //==== FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUMA PROVA
  //Limpa
  LimparQuery;

   DM.ZQuery1.SQL.Add('Select DiretorioPROVA From Doc_Aula where (id_aula='
                      +FormGerencAulas.ComboBoxNumeroDasAulas.Text+') and (DiretorioPROVA<>'+Chr(39)+CHR(39)+');');
   DM.ZQuery1.Open;
   SelectProva:= DM.ZQuery1.FieldByName('DiretorioPROVA').AsString;

     //====== SE FOR O MESMO CAMINHO, COMEÇA AS VERIFICAÇÕES
     If (SelectProva=CaminhoEdit) and (SelectProva<>'') then begin

          If Application.MessageBox('O caminho é o mesmo do já inserido. Atualizar?','Atenção',
                                    mb_YesNo+Mb_IconQuestion)=id_YES then begin
            //Limpa
            LimparQuery;

            //========= INSERE O DIRETÓRIO DA PROVANO BANCO
            DM.ZQuery1.SQL.Add('Update Doc_Aula SET DiretorioPROVA = :UpdateDIR where id_Aula = :NumeroAula');
            DM.ZQuery1.ParamByName('UpdateDIR').asString:=CaminhoEdit;
            DM.ZQuery1.ParamByName('NumeroAula').Value:=FormGerencAulas.ComboBoxNumeroDasAulas.Text;
            Dm.ZQuery1.ExecSQL;

             //======== CONCLUÍDO
             Application.MessageBox('Prova atualizada com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
              OleContainerWord.Hide;
              OleContainerWord.Close;
              FormProva.Hide;
              FormProva.Close;
              FormGerencAulas.Show;
            exit;
          end
     end
            else begin

      If SelectProva='' then begin
        //================ SE NAO HOUVER NENHUM DOCUMENTO, INSERE NORMAL

        //Limpa
        LimparQuery;


        //========= INSERE O DIRETÓRIO DA AULA NO BANCO
        DM.ZQuery1.SQL.Add('Insert into Doc_Aula (DiretorioPROVA, ID_Aula) Values '+
                                                 ('(:DiretorioPROVA, :NumeroAula);'));
        DM.ZQuery1.ParamByName('DiretorioPROVA').AsString:=CaminhoEdit;
        DM.ZQuery1.ParamByName('NumeroAula').AsString:=FormGerencAulas.ComboBoxNumeroDasAulas.Text;
        DM.ZQuery1.ExecSQL;

        // Mostra Mensagem de que deu certo!
        Application.MessageBox('Prova inserida com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
              OleContainerWord.Hide;
              OleContainerWord.Close;
              FormProva.Hide;
              FormProva.Close;
              FormGerencAulas.Show;
      end

      else begin

      if SelectProva<>CaminhoEdit then begin

           If Application.MessageBox('O caminho é diferente do prova existente. Atualizar?','Atenção',
                                      mb_YesNo+Mb_IconQuestion)=id_YES then begin
            //Limpa
            LimparQuery;

            //========= INSERE O DIRETÓRIO DA PROVANO BANCO
            DM.ZQuery1.SQL.Add('Update Doc_Aula SET DiretorioPROVA = :UpdateDIR where ID_Aula = :NumeroAula'+
                               ' and DiretorioPROVA<>'+CHR(39) +CHR(39)+';');
            DM.ZQuery1.ParamByName('UpdateDIR').asString:=CaminhoEdit;
            DM.ZQuery1.ParamByName('NumeroAula').Value:=FormGerencAulas.ComboBoxNumeroDasAulas.Text;
            Dm.ZQuery1.ExecSQL;

             //======== CONCLUÍDO
             Application.MessageBox('Prova atualizada com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
              OleContainerWord.Hide;
              OleContainerWord.Close;
              FormProva.Hide;
              FormProva.Close;
              FormGerencAulas.Show;
          end
      end;

      end;

    end;
end;
end;

procedure TFormProva.Label4Click(Sender: TObject);
begin

end;

//CONCLUÍDO!
end.


