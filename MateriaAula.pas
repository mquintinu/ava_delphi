unit MateriaAula;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, VisualizarAula, jpeg,ComObj;

type
  TFormGerencAulas = class(TForm)
    PlanoDeFundo: TImage;
    Label4: TLabel;
    ComboBoxNumeroDasAulas: TComboBox;
    EditNomeEditarAula: TEdit;
    EditNomeEditarMateria: TEdit;
    BotaoInserirAula: TButton;
    Label5: TLabel;
    Label6: TLabel;
    EditNomeNovaAula: TEdit;
    Image1: TImage;
    Label8: TLabel;
    ComboBoxMateria: TComboBox;
    Panel1: TPanel;
    BotaoEditarAula: TButton;
    BotaoInsPDF: TButton;
    OpenPDF: TOpenDialog;
    BotaoWord: TButton;
    BotaoSlide: TButton;
    BotaoProva: TButton;
    BotaoVisuAula: TButton;
    OpenWord: TOpenDialog;
    OpenSlide: TOpenDialog;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Image3: TImage;
    Panel2: TPanel;
    ImageEditarOK: TImage;
    Image4: TImage;
    ImageWord: TImage;
    ImageSlide: TImage;
    ImagePDF: TImage;
    ImageProva: TImage;
    Image2: TImage;
    Label7: TLabel;
    procedure BotaoInserirAulaClick(Sender: TObject);
    procedure ComboBoxNumeroDasAulasChange(Sender: TObject);
    procedure BotaoEditarAulaClick(Sender: TObject);
    procedure ImageEditarOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure BotaoInsPDFClick(Sender: TObject);
    procedure BotaoVisuAulaClick(Sender: TObject);
    procedure BotaoSlideClick(Sender: TObject);
    procedure BotaoWordClick(Sender: TObject);
    procedure ImageSlideClick(Sender: TObject);
    procedure ImageWordClick(Sender: TObject);
    procedure ImagePDFClick(Sender: TObject);
    procedure BotaoProvaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure ImageProvaClick(Sender: TObject);
    procedure EditNomeNovaAulaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormGerencAulas: TFormGerencAulas;
  //Variável que recebe o SELECT do ID do Professor
  IDProfessor: String;
  IDMateria  : String;
  IDAula     : String;

  Voz: OleVariant;

implementation
Uses DMbd,AVA,ModoProfessor,Prova;

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
  DM.ZQuery1.SQL.Add('SELECT ID_Materia From Materia Where (ID_Prof='+IDProfessor+ ')'+
                     'and Nome_Materia='+
                     CHR(39)+FormGerencAulas.ComboBoxMateria.Text+CHR(39)+';');
  DM.ZQuery1.Open;
  IDMateria:= DM.ZQuery1.FieldByName('ID_Materia').AsString;
end;
// ****** FIM SELECT ID_MATÉRIA

// ****** PROCEDURE PARA FAZER SELECT DA ID_AULA
procedure SelectIdAula;
begin
//Limpa Query
  LimparQuery;

    //Faz o SELECT no Banco  para pegar o ID da Aula
    DM.ZQuery1.SQL.Add('SELECT ID_Aula From Aula,Professor WHERE ID_Materia='+IDMateria+';');
    DM.ZQuery1.Open;
    IDAula:= DM.ZQuery1.FieldByName('ID_Aula').AsString
end;
// ****** FIM SELECT ID_AULA



//===============================================================
//===============================================================
//===============================================================
//  AGORA COMEÇA AS PROCEDURES REFERENTES AOS OBJETOS NO FORM.
//===============================================================
//===============================================================
//===============================================================
// <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



procedure TFormGerencAulas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormGerencAulas.Hide;
FormProf.Show;
end;



// ==============================================================|
//   AO MOSTRAR O FORM JOGA AS MATÉRIAS NO COMBOBOX.MATERIA      |
// ==============================================================|
procedure TFormGerencAulas.FormShow(Sender: TObject);
begin
//Limpa os ComboBox's
ComboBoxMateria.Items.Clear;
ComboBoxNumeroDasAulas.Items.Clear;

//Chama procedimento para pegar o ID do Professor
SelectIdProfessor;


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

    //>>>> CARREGA AS AULAS NO COMBOBOX.NUMERO.DAS.AULAS
//Limpa Query
  LimparQuery;

    //Faz o SELECT no Banco  para pegar o ID das Aulas
    DM.ZQuery1.SQL.Add('Select ID_Aula From Aula,Materia,Professor Where'+
                      '(Materia.ID_Prof='+IDProfessor +' and Professor.ID_Prof='+IDProfessor+
                      ') and (Materia.ID_Materia=Aula.ID_Materia) Order By ID_Aula;');
    DM.ZQuery1.Open;
      //Enquanto não for final da consulta FAÇA  - JOGA NO COMBOBOX AS MATÉRIAS
      while not DM.ZQuery1.Eof do
      begin ComboBoxNumeroDasAulas.Items.Add(DM.ZQuery1.FieldByName('ID_Aula').AsString);
            Dm.ZQuery1.Next;
      end;
end;


// ==============================================================|
// AO SELECIONAR O NÚMERO DA AULA NO COMBOBOX EDITAR <<<<<<<<<<< |
// ==============================================================|
procedure TFormGerencAulas.ComboBoxNumeroDasAulasChange(Sender: TObject);
begin
//Limpa Query
  LimparQuery;

  //SELECT NOME_AULAS (Relacionado ao professor logado)
  DM.ZQuery1.SQL.Add('Select Nome_Aula From Aula Where ID_Aula='+CHR(39)
                      +ComboBoxNumeroDasAulas.Text +CHR(39) +';');
  DM.ZQuery1.Open;

  //JOGA NO EDIT NOME.EDITAR.AULA
  EditNomeEditarAula.Text:=DM.ZQuery1.FieldByName('Nome_Aula').AsString;

//Limpa Query
  LimparQuery;

  DM.ZQuery1.SQL.Add('Select ID_Aula,Nome_Materia From Materia,Aula Where (ID_Aula='+
                     ComboBoxNumeroDasAulas.Text+')' +'and (Materia.ID_Materia=Aula.ID_Materia);');
  DM.ZQuery1.Open;
  //Joga no EditNomeDaMateria
  EditNomeEditarMateria.Text:=Dm.ZQuery1.FieldByName('Nome_Materia').AsString;
end;






procedure TFormGerencAulas.EditNomeNovaAulaKeyPress(Sender: TObject;
  var Key: Char);
begin
if key =CHR(39) then
ShowMessage('Caracter Inválido!');
end;

// ==============================================================|
//            AO CLICAR NO BOTÃO EDITAR AULA                     |
// ==============================================================|
procedure TFormGerencAulas.BotaoEditarAulaClick(Sender: TObject);
begin
 if ComboBoxNumeroDasAulas.Text='' then begin
      Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end
    else begin
  ImageEditarOK.Enabled:=true;
  EditNomeEditarAula.Enabled:= True;
  EditNomeEditarAula.SetFocus;
  Label1.Caption:='Novo Nome da Aula';
  end;
end;

// >>>>>>>>>>>>>>>> AO CLICAR NO BOTÃO "EDITAR AULA" [IMAGEM OK-Visto]
procedure TFormGerencAulas.Image2Click(Sender: TObject);
begin
FormGerencAulas.Hide;
FormProf.Show;
end;


procedure TFormGerencAulas.Image3Click(Sender: TObject);
begin
voz:=CreateOleObject('SAPI.SPvoice');
voz.Rate:=1;
voz.speak('Selecione uma matéria que você já leciona.'+
          ' e depois digite um nome para a nova aula que irá inserir.');
end;

procedure TFormGerencAulas.Image4Click(Sender: TObject);
begin
voz.speak('Aqui, você pode editar o nome da aula, e finalizar clicando sobre o botão verde.'+
          ' Você também adiciona documentos de textos e imagens do Word,'+
          ' PÊDÊÉfis, e Slaides do Pauer Point. Além'+
          ' de criar provas da sua aula.');

end;

procedure TFormGerencAulas.ImageEditarOKClick(Sender: TObject);
begin
  if ComboBoxNumeroDasAulas.Text='' then begin
      Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end else begin
  //Limpa Query
  LimparQuery;

  // Faz Update no Banco, troca o antigo nome da aula, pelo novo.
  DM.ZQuery1.SQL.Add('UPDATE Aula SET Nome_Aula='+CHR(39)+EditNomeEditarAula.Text+
                      CHR(39) +'WHERE ID_Aula='+ComboBoxNumeroDasAulas.Text +';');
  DM.ZQuery1.ExecSQL;

  Application.MessageBox('Edição concluída com sucesso!',':: Sucesso',MB_ICONINFORMATION);
  EditNomeEditarAula.Enabled:= False;
  Label1.Caption:='Nome da Aula';
  ImageEditarOK.Visible:= false;
end;
end;



// ==============================================================|
//            AO CLICAR NO BOTÃO INSERIR AULA                    |
// ==============================================================|
procedure TFormGerencAulas.BotaoInserirAulaClick(Sender: TObject);
var NomeDaAula: String;
begin
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 // **** Se o EDIT do NOME estiver em branco, não deixa prosseguir
 if EditNomeNovaAula.Text='' then
    begin Application.MessageBox('Digite um nome para a aula!',':: Erro', MB_ICONERROR);
          EditNomeNovaAula.SetFocus;
    end
     else begin
  // ** SE NÃO
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

//Limpa Query
  LimparQuery;

 //INSERE A AULA NO BANCO
 DM.ZQuery1.SQL.Add('Insert into Aula (Nome_Aula) Values'+
                                    ('(:Nome_NovaAula);'));
 DM.ZQuery1.ParamByName('Nome_NovaAula').AsString:=EditNomeNovaAula.Text;
 NomeDaAula:=Dm.ZQuery1.ParamByName('Nome_NovaAula').AsString;
 DM.ZQuery1.ExecSQL;

    //Chama procedimento para pegar o ID da Matéria
    SelectIdMateria;

      //Limpa Query
      LimparQuery;

        //Joga o ID da Materia na Tabela Aula
        DM.ZQuery1.SQL.Add('Update Aula Set ID_Materia='+IDMateria+
                           ' Where Nome_Aula='+CHR(39) +EditNomeNovaAula.Text +CHR(39) +';');
        DM.ZQuery1.ExecSQL;

  //Chama procedimento para pegar o ID da Aula
  SelectIdMateria;

   //Limpa Query
   LimparQuery;
     // AUMENTA O NUMERO DE QUANTIDADE DE AULAS DA MATÉRIA
     DM.ZQuery1.SQL.Add('UPDATE Materia SET QtdAulas = (QtdAulas+1)'+
                         'WHERE ID_Materia=' +IDMateria +';');
     DM.ZQuery1.ExecSQL;

 // ### Bkp De Código
 //DM.ZQuery1.ParamByName('DataAtual').AsDate:= StrToDate(FormatDateTime('dd/mm/yyyy',Now));



  // CADASTRO CONCLUÍDO
  Application.MessageBox('Aula cadastrada com sucesso!',':: Sucesso',MB_ICONINFORMATION+MB_OK);
  LimparQuery;
  EditNomeNovaAula.Text:='';
  //Atualiza o form
  Application.ProcessMessages;
FormGerencAulas.Hide;
FormGerencAulas.Show;

    end;
  end;


 //===========Inserir PowerPoint
procedure TFormGerencAulas.BotaoSlideClick(Sender: TObject);
var DiretorioSLIDE,SelectDirSLIDE: String;

begin
  //Se NAO houver selecionado nenhuma aula
  if ComboBoxNumeroDasAulas.text='' then begin
     Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end
  else
    begin // SE ESTIVER COM A AULA SELECIONADA, CONTINUA...
  //================ FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUM DOCUMENTO INSERIDO
    //Limpa
    LimparQuery;
    Dm.ZQuery1.SQL.Add('Select DiretorioSLIDE From Doc_Aula where (id_aula='
                       +ComboBoxNumeroDasAulas.Text+') and (DiretorioSLIDE<>'+Chr(39)+CHR(39)+');');
    DM.ZQuery1.Open;
    SelectDirSLIDE:= DM.ZQuery1.FieldByName('DiretorioSLIDE').AsString;

       If SelectDirSLIDE='' then begin
       //================ SE NAO HOUVER NENHUM DOCUMENTO, INSERE NORMAL
          If OpenSLIDE.Execute then begin
             DiretorioSLIDE:= OpenSLIDE.FileName;

           //Limpa
           LimparQuery;
          //========= INSERE O DIRETÓRIO DA AULA NO BANCO
          DM.ZQuery1.SQL.Add('Insert into Doc_Aula (DiretorioSLIDE, ID_Aula) Values '+
                                                ('(:DiretorioSLIDE, :NumeroAula);'));
          DM.ZQuery1.ParamByName('DiretorioSLIDE').AsString:=DiretorioSLIDE;
          DM.ZQuery1.ParamByName('NumeroAula').AsString:=ComboBoxNumeroDasAulas.Text;
          Dm.ZQuery1.ExecSQL;

          //=========== CONCLUÍDO
          Application.MessageBox('Documento SLIDE inserido com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
          end;
       end
        else
         begin
          //====== SE JÁ HOUVER, COMEÇA AS VERIFICAÇÕES
          If Application.MessageBox('Já existe um documento SLIDE inserido. Substituir?','Atenção',
                                    mb_YesNo+Mb_IconQuestion)=id_YES then begin
            // SE A RESPOSTA FOR SIM, FAZ O UPDATE
              If OpenSLIDE.Execute then begin
                 DiretorioSLIDE:= OpenSLIDE.FileName;

                 //Limpa
                 LimparQuery;
                 //========= INSERE O DIRETÓRIO DA AULA NO BANCO
                 DM.ZQuery1.SQL.Add('Update Doc_Aula SET DiretorioSLIDE = :UpdateDIR where id_Aula = :NumeroAula');
                 DM.ZQuery1.ParamByName('UpdateDIR').Value:=DiretorioSLIDE;
                 DM.ZQuery1.ParamByName('NumeroAula').Value:=ComboBoxNumeroDasAulas.Text;
                 Dm.ZQuery1.ExecSQL;

                 //======== CONCLUÍDO
                 Application.MessageBox('Documento em Slide inserido com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
              end;
          end
           else
            end;
 end;
end;

procedure TFormGerencAulas.ImageSlideClick(Sender: TObject);
begin
BotaoSlideClick(Sender);
end;


//==============Inserir PDF
procedure TFormGerencAulas.BotaoInsPDFClick(Sender: TObject);
var DiretorioPDF,SelectDirPDF: String;

begin
  //Se NAO houver selecionado nenhuma aula
  if ComboBoxNumeroDasAulas.text='' then begin
     Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end
  else
    begin // SE ESTIVER COM A AULA SELECIONADA, CONTINUA...
  //================ FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUM DOCUMENTO INSERIDO
    //Limpa
    LimparQuery;
    Dm.ZQuery1.SQL.Add('Select DiretorioPDF From Doc_Aula where (id_aula='
                       +ComboBoxNumeroDasAulas.Text+') and (DiretorioPDF<>'+Chr(39)+CHR(39)+');');
    DM.ZQuery1.Open;
    SelectDirPDF:= DM.ZQuery1.FieldByName('DiretorioPDF').AsString;

       If SelectDirPDF='' then begin
       //================ SE NAO HOUVER NENHUM DOCUMENTO, INSERE NORMAL
          If OpenPDF.Execute then begin
             DiretorioPDF:= OpenPDF.FileName;

           //Limpa
           LimparQuery;
          //========= INSERE O DIRETÓRIO DA AULA NO BANCO
          DM.ZQuery1.SQL.Add('Insert into Doc_Aula (DiretorioPDF, ID_Aula) Values '+
                                                ('(:DiretorioPDF, :NumeroAula);'));
          DM.ZQuery1.ParamByName('DiretorioPDF').AsString:=DiretorioPDF;
          DM.ZQuery1.ParamByName('NumeroAula').AsString:=ComboBoxNumeroDasAulas.Text;
          Dm.ZQuery1.ExecSQL;

          //=========== CONCLUÍDO
          Application.MessageBox('Documento em PDF inserido com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
          end;
       end
        else
         begin
          //====== SE JÁ HOUVER, COMEÇA AS VERIFICAÇÕES
          If Application.MessageBox('Já existe um documento PDF inserido. Substituir?','Atenção',
                                    mb_YesNo+Mb_IconQuestion)=id_YES then begin
            // SE A RESPOSTA FOR SIM, FAZ O UPDATE
              If OpenPDF.Execute then begin
                 DiretorioPDF:= OpenPDF.FileName;

                 //Limpa
                 LimparQuery;
                 //========= INSERE O DIRETÓRIO DA AULA NO BANCO
                 DM.ZQuery1.SQL.Add('Update Doc_Aula SET DiretorioPDF = :UpdateDIR where id_Aula = :NumeroAula');
                 DM.ZQuery1.ParamByName('UpdateDIR').Value:=DiretorioPDF;
                 DM.ZQuery1.ParamByName('NumeroAula').Value:=ComboBoxNumeroDasAulas.Text;
                 Dm.ZQuery1.ExecSQL;

                 //======== CONCLUÍDO
                 Application.MessageBox('Documento em PDF inserido com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
              end;
          end
           else
            end;
 end;
end;

procedure TFormGerencAulas.ImagePDFClick(Sender: TObject);
begin
BotaoProvaClick(Sender);
end;


procedure TFormGerencAulas.ImageProvaClick(Sender: TObject);
begin
BotaoProvaClick(Sender);
end;

//===============Inserir Word
procedure TFormGerencAulas.BotaoWordClick(Sender: TObject);
var DiretorioWORD,SelectDirWord: String;

begin
  //Se NAO houver selecionado nenhuma aula
  if ComboBoxNumeroDasAulas.text='' then begin
     Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end
  else
    begin // SE ESTIVER COM A AULA SELECIONADA, CONTINUA...
  //================ FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUM DOCUMENTO INSERIDO
    //Limpa
    LimparQuery;
    Dm.ZQuery1.SQL.Add('Select DiretorioWORD From Doc_Aula where (id_aula='
                       +ComboBoxNumeroDasAulas.Text+') and (DiretorioWORD<>'+Chr(39)+CHR(39)+');');
    DM.ZQuery1.Open;
    SelectDirWord:= DM.ZQuery1.FieldByName('DiretorioWORD').AsString;

       If SelectDirWord='' then begin
       //================ SE NAO HOUVER NENHUM DOCUMENTO, INSERE NORMAL
          If OpenWord.Execute then begin
             DiretorioWORD:= OpenWord.FileName;

           //Limpa
           LimparQuery;
          //========= INSERE O DIRETÓRIO DA AULA NO BANCO
          DM.ZQuery1.SQL.Add('Insert into Doc_Aula (DiretorioWORD, ID_Aula) Values '+
                                                ('(:DiretorioWORD, :NumeroAula);'));
          DM.ZQuery1.ParamByName('DiretorioWORD').AsString:=DiretorioWORD;
          DM.ZQuery1.ParamByName('NumeroAula').AsString:=ComboBoxNumeroDasAulas.Text;
          Dm.ZQuery1.ExecSQL;

          //=========== CONCLUÍDO
          Application.MessageBox('Documento Word inserido com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
          end;
       end
        else
         begin
          //====== SE JÁ HOUVER, COMEÇA AS VERIFICAÇÕES
          If Application.MessageBox('Já existe um documento WORD inserido. Substituir?','Atenção',
                                    mb_YesNo+Mb_IconQuestion)=id_YES then begin
            // SE A RESPOSTA FOR SIM, FAZ O UPDATE
              If OpenWord.Execute then begin
                 DiretorioWORD:= OpenWord.FileName;

                 //Limpa
                 LimparQuery;
                 //========= INSERE O DIRETÓRIO DA AULA NO BANCO
                 DM.ZQuery1.SQL.Add('Update Doc_Aula SET DiretorioWORD = :UpdateDIR where id_Aula = :NumeroAula');
                 DM.ZQuery1.ParamByName('UpdateDIR').Value:=DiretorioWORD;
                 DM.ZQuery1.ParamByName('NumeroAula').Value:=ComboBoxNumeroDasAulas.Text;
                 Dm.ZQuery1.ExecSQL;

                 //======== CONCLUÍDO
                 Application.MessageBox('Documento Word inserido com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
              end;
          end
           else
            end;
 end;
end;


procedure TFormGerencAulas.ImageWordClick(Sender: TObject);
begin
BotaoWordClick(Sender);
end;


//============ PROVA !
procedure TFormGerencAulas.BotaoProvaClick(Sender: TObject);
begin
  //Se NAO houver selecionado nenhuma aula
  if ComboBoxNumeroDasAulas.text='' then begin
     Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end
   else
    begin
      //==== FAZ O SELECT PARA VERIFICAR SE JA EXISTE ALGUMA PROVA
      //Limpa
      LimparQuery;

      Dm.ZQuery1.SQL.Add('Select DiretorioPROVA From Doc_Aula where (id_aula='
                         +FormGerencAulas.ComboBoxNumeroDasAulas.Text+') and (DiretorioPROVA<>'+Chr(39)+CHR(39)+');');
      DM.ZQuery1.Open;
      DirPROVA:= DM.ZQuery1.FieldByName('DiretorioPROVA').AsString;

      If DirPROVA='' then begin
        begin
           //================ SE NAO HOUVER NENHUM DOCUMENTO, INSERE NORMAL
          FormProva:= TFormProva.Create(Application);
          FormGerencAulas.Hide;
          FormProva.Show;
        end;
      end
       else begin
        //====== SE JÁ HOUVER, COMEÇA AS VERIFICAÇÕES
          If Application.MessageBox('Já existe uma prova. Substituir?','Atenção',
                                    mb_YesNo+Mb_IconQuestion)=id_YES then begin
         // SE A RESPOSTA FOR SIM, ABRE O OUTRO FORM
           FormProva:= TFormProva.Create(Application);
           FormGerencAulas.Hide;
           FormProva.Show;
        end;
    end;
    end;
end;


//Visualizar Aula
procedure TFormGerencAulas.BotaoVisuAulaClick(Sender: TObject);
begin
  if ComboBoxNumeroDasAulas.Text='' then begin
     Application.MessageBox('Nenhuma aula selecionada!',':: Erro',MB_ICONERROR);
  end
    else begin
    FormVisuAula:= TFormVisuAula.Create(Application);
    FormVisuAula.Show;
end;
end;



end.


