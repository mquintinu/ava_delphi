unit MateriaCadastro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls,ComObj;

type
  TFormCadastrarMateria = class(TForm)
    PlanoDeFundo: TImage;
    Label4: TLabel;
    BotaoCadastrar: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    ComboBoxProf: TComboBox;
    ComboBoxMateria: TComboBox;
    Label1: TLabel;
    Label5: TLabel;
    RButtonMateriaExist: TRadioButton;
    RButtonMateriaNOTExist: TRadioButton;
    Label3: TLabel;
    Image2: TImage;
    Image1: TImage;
    Label8: TLabel;
    EditNovaMateria: TEdit;
    Label6: TLabel;
    procedure RButtonMateriaExistClick(Sender: TObject);
    procedure BotaoCadastrarClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure RButtonMateriaNOTExistClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label5Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCadastrarMateria: TFormCadastrarMateria;
  //Variavel da Voz
  voz: OleVariant;

  //Variável que recebe o SELECT do ID do Professor
  IDProfessor: String;

implementation

Uses DMbd,AVA,ModoProfessor;
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
//Limpa as Querys
LimparQuery;

  //Faz o SELECT no Banco  para pegar o ID do Professor
  DM.ZQuery1.SQL.Add('Select ID_Prof From Professor where Login_Prof='+
                     Chr(39)+FormLogin.EditUsuario.Text+Chr(39)+';');
                     DM.ZQuery1.Open;
  IDProfessor:= DM.ZQuery1.FieldByName('ID_Prof').AsString;
end;
// ****** FIM SELECT ID_PROFESSOR

procedure SelectNomeProfessor();
begin
    // JOGA O NOME DO PROFESSOR DO COMBOBOX
  //Limpa as Querys
  DM.ZQuery1.Close;
  DM.ZQuery1.SQL.Clear;

  //Faz o SELECT no Banco
  DM.ZQuery1.SQL.Add('Select Nome_Prof From Professor WHERE Login_Prof='
                     +Chr(39)+FormLogin.EditUsuario.Text+Chr(39)+';');
  DM.ZQuery1.Open;


 // Joga o nome do professor no ComboBox
 FormCadastrarMateria.ComboBoxProf.Items.Add(DM.ZQuery1.FieldByName('Nome_Prof').AsString);
 FormCadastrarMateria.ComboBoxProf.Text:=FormCadastrarMateria.ComboBoxProf.Items[0];

 //Trava o ComboBox do Professor
 FormCadastrarMateria.ComboBoxProf.Enabled:=false;
end;

//===============================================================
//===============================================================
//===============================================================
//  AGORA COMEÇA AS PROCEDURES REFERENTES AOS OBJETOS NO FORM.
//===============================================================
//===============================================================
//===============================================================
// <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

// BOTÃO CADASTRAR!
procedure TFormCadastrarMateria.BotaoCadastrarClick(Sender: TObject);
begin

 // Se o COMBOBOX da MATERIA estiver em branco, não deixa prosseguir
 If (RButtonMateriaExist.Checked = False) and
    (RButtonMateriaNOTExist.Checked = False)then
      begin Application.MessageBox('Selecione uma opção!',':: Erro', MB_ICONERROR);
        end
          else
            begin
     //SE SELECIONAR UMA MATÉRIA QUE JÁ EXISTE...
 If (RButtonMateriaExist.Checked = True) and
    (RButtonMateriaNOTExist.Checked = False) then

        //VERIFICA SE NÃO ESTÀ EM BRANCO
        If ComboBoxMateria.Text='' then
           begin Application.MessageBox('Escolha uma matéria!',':: Erro', MB_ICONERROR);
                 ComboBoxMateria.SetFocus;
                 end
                 else begin

// <><><><><><><>><> MATÉRIA JÁ EXISTENTE
//Chama procedimento para pegar o ID do Professor
SelectIdProfessor;

 //Limpa as Querys
 LimparQuery;

 // FAZ O UPDATE, JOGA O ID DO PROFESSOR NA TABELA MATERIA.
 Dm.ZQuery1.SQL.Add('Update Materia Set ID_Prof='+IDProfessor+
                    ' Where Nome_Materia='+CHR(39) +ComboBoxMateria.Text +CHR(39)+';');
                    DM.ZQuery1.ExecSQL;
 Application.MessageBox('Cadastro concluído com sucesso!','::Matéria',Mb_Ok);

     //LIMPA TUDO
     RButtonMateriaExist.Checked:= false;

     ComboBoxMateria.Items.Clear;
     ComboBoxMateria.Text:='';

     ComboBoxProf.Items.Clear;
     ComboBoxProf.Text:='';

// <><><><><><><>><> MATÉRIA NOVA
        end
        else begin
           //SE SELECIONAR MATÉRIA NOVA
           If (RButtonMateriaNOTExist.Checked = True) and
              (RButtonMateriaExist.Checked = False) then

                //SE ESTIVER EM BRANCO
                If EditNovaMateria.Text='' then
                 begin Application.MessageBox('Digite um nome para a matéria!',':: Erro', MB_ICONERROR);
                       EditNovaMateria.SetFocus;
                        end
                         else begin

      //Chama procedimento para pegar o ID do Professor
      SelectIdProfessor;

      //Limpa as Querys
      LimparQuery;

 // FAZ O INSERT, JOGA A MATÉRIA na TABELA
 DM.ZQuery1.SQL.Add('Insert Into Materia (ID_Materia, Nome_Materia, QtdAulas, ID_Prof) Values'+
                                        '(NULL,:Nome_NovaMateria,0,:IdProf);');

                   DM.ZQuery1.ParamByName('Nome_NovaMateria').AsString:=EditNovaMateria.Text;
                   DM.ZQuery1.ParamByName('IdProf').AsString:=IDProfessor;
                   DM.ZQuery1.ExecSQL;
                   Application.MessageBox('Cadastro concluído com sucesso!','::Matéria',Mb_Ok);

     //LIMPA TUDO
     RButtonMateriaExist.Checked:= false;

     EditNovaMateria.Text:='';

     ComboBoxProf.Items.Clear;
     ComboBoxProf.Text:='';
      end;
    end;
  end;
end;



//Voltar ao Menu do modo Professor
procedure TFormCadastrarMateria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ComboBoxProf.Clear;
  ComboBoxProf.Text:='';

  ComboBoxMateria.Clear;
  ComboBoxMateria.Text:='';

  EditNovaMateria.Clear;
  EditNovaMateria.Text:='';

  RButtonMateriaExist.Checked:= False;
  RButtonMateriaNOTExist.Checked:= False;

  FormProf.Show;
end;

procedure TFormCadastrarMateria.Image1Click(Sender: TObject);
begin
FormCadastrarMateria.Hide;
FormCadastrarMateria.Close;
FormProf.Show;
end;

procedure TFormCadastrarMateria.Image2Click(Sender: TObject);
begin
  //Fala de Ajuda
  voz:=CreateOleObject('SAPI.SpVoice');
  voz.Rate:=1;
  voz.speak('Aqui, você cadastra qual matéria você irá lecionar. ');
end;

procedure TFormCadastrarMateria.Label3Click(Sender: TObject);
begin
RButtonMateriaNOTExistClick(Sender);
end;

procedure TFormCadastrarMateria.Label5Click(Sender: TObject);
begin
RButtonMateriaExistClick(Sender);
end;

procedure TFormCadastrarMateria.RButtonMateriaExistClick(Sender: TObject);
begin
  EditNovaMateria.enabled:= False;
  RButtonMateriaExist.Checked:= True;
  EditNovaMateria.Text:='';

   // SE A MATÉRIA Já EXISTIR
   if RButtonMateriaExist.Checked = true then

       RbuttonMateriaNOTExist.checked:= false;
       ComboBoxMateria.enabled:= true;

         begin
         //Limpa os ComboBox's
         ComboBoxMateria.Items.Clear;
         ComboBoxProf.Items.Clear;

         //Limpa as Querys
         DM.ZQuery1.Close;
         DM.ZQuery1.SQL.Clear;

  //Faz o SELECT no Banco
  DM.ZQuery1.SQL.Add('Select Nome_Materia From Materia Order by ID_Materia');
  DM.ZQuery1.Open;
  // Joga o Nome das Matérias já existentes no ComboBox
  //Enquanto não for final da consulta FAÇA
  ComboBoxProf.Items.Clear;
  ComboBoxMateria.Items.Clear;
  while not DM.ZQuery1.Eof do
  begin ComboBoxMateria.Items.Add(DM.ZQuery1.FieldByName('Nome_Materia').AsString);
        Dm.ZQuery1.Next;
  end;
  //Ao carregar os itens no ComboBox, setFocus no primeiro Item.
  ComboBoxMateria.Text:=ComboBoxMateria.Items[0];
  ComboBoxMateria.SetFocus;

  //Joga o nome do Professor no ComboBox
  SelectNomeProfessor;
end;
end;

procedure TFormCadastrarMateria.RButtonMateriaNOTExistClick(Sender: TObject);
begin
  RButtonMateriaNOTExist.Checked:= True;
 //Libera e trava os componentes
 {} ComboBoxMateria.Items.Clear;
 {} EditNovaMateria.Enabled:= True;
 {} RbuttonMateriaExist.checked:= False;
 {} ComboBoxMateria.Items.Clear;
 {} ComboBoxMateria.Text:='';
 {} ComboBoxMateria.Enabled:= False;
 {} EditNovaMateria.Enabled:= True;
 {} EditNovaMateria.Text:='Digite o nome da nova matéria';
 {} EditNovaMateria.SetFocus;
 //Liberado e travados os componentes

 //Joga o nome do Professor no ComboBox
  SelectNomeProfessor;
end;

end.
