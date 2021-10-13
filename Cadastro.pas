unit Cadastro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, jpeg,comObj;

type
  TFormCadastro = class(TForm)
    LabelNome: TLabel;
    LabelSenha: TLabel;
    LabelLogin: TLabel;
    Label4: TLabel;
    EditLogin: TEdit;
    EditSenha: TEdit;
    EditNome: TEdit;
    BotaoCadastrar: TButton;
    Label1: TLabel;
    EditConfSenha: TEdit;
    BotaoCancelar: TButton;
    Image1: TImage;
    RButtonProf: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    RButtonAluno: TRadioButton;
    Image2: TImage;
    procedure BotaoCadastrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
//    procedure CadastroOK();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCadastro: TFormCadastro;
  Voz: OleVariant;

implementation
Uses AVA,DMbd;

{$R *.dfm}
procedure CadastroOK();
begin

end;


procedure TFormCadastro.BotaoCadastrarClick(Sender: TObject);
var NomeUsuario, SenhaProf: string;
begin
//Variável recebe conteúdo do EditNome
NomeUsuario:= Editnome.Text;

//Verifica se há campos em Branco, e mostra msg de Erro.
// Campo NOME em branco
if editNome.Text='' then
   begin  Application.MessageBox('Digite o campo Nome!',':: Erro ::',mb_IconError);
          editNome.SetFocus;
    end else
       //Campo LOGIN em branco
       if editlogin.Text='' then
          begin Application.MessageBox('Digite um Login!',':: Erro ::',mb_IconError);
                EditLogin.SetFocus;
           end else
           //Campo SENHA em branco
           if editsenha.Text='' then
              begin Application.MessageBox('Digite uma Senha!',':: Erro ::',mb_IconError);
                    EditSenha.SetFocus;
                end else
                  //Não selecionar o modo PROFESSOR ou ALUNO
                  if (RButtonProf.Checked = false) and
                      (RButtonAluno.Checked = false) then
                       begin Application.MessageBox('Escolha um modo: ALUNO ou PROFESSOR',
                                                    ':: Erro ::',MB_IconInformation);
                         end else
                           //Campo CONFSENHA em branco
                           if editConfSenha.Text='' then
                           begin Application.MessageBox('Digite a senha novamente!',
                                                        ':: Erro ::',mb_IconError);
                                 EditConfSenha.SetFocus;
                            end else
                              //Senhas diferentes
                              if editConfSenha.Text<>EditSenha.Text then
                              begin Application.MessageBox('A Confirmação de senha não confere.',
                                                           ':: Erro ::',mb_IconError);
                                    EditConfSenha.SetFocus;
                                    EditConfSenha.SelectAll;
                              end else
 // Se nenhum campo estiver em branco...
//Verifica se todos os campos estão preenchidos e se as senhas estão iguais
  if (editNome.Text<>'') and
      (editLogin.text<>'') and
       (editSenha.Text<>'') and
        (editConfSenha.Text<>'') and
         (RButtonAluno.Checked<>False) or
          (RButtonProf.Checked<>False) and
           (editSenha.Text=editConfSenha.Text) then begin
//Caso esteja tudo certo...

//Entra no modo Aluno.
// >>>>>>>>>>>>>>>>>>>> Joga os dados do cadastro no BD
// INSERE NO BD O CADASTRO DOS ALUNOS
//Limpa as Querys
DM.ZQuery1.Close;
DM.ZQuery1.SQL.Clear;

  if (RButtonAluno.Checked = true) then
// Se a opção ALUNO estiver selecionada...
// Passa por parâmetros os Edits.Txt aos campos do BD
//Os dois pontos são obrigatórios em passagem por parâmetro
     begin DM.ZQuery1.SQL.Add('Insert into Aluno (Nome_Aluno, Login_Aluno, Senha_Aluno) Values '+
                                              ('(:EditNomeAluno, :EditLoginAluno, :EditSenhaAluno);'));
     DM.ZQuery1.ParamByName('EditNomeAluno').AsString:=EditNome.Text;
     DM.ZQuery1.ParamByName('EditLoginAluno').AsString:=EditLogin.Text;
     DM.ZQuery1.ParamByName('EditSenhaAluno').AsString:=EditSenha.Text;
     DM.ZQuery1.ExecSQL;
 //Mostra Mensagem de Cadastro Concluído
     Application.MessageBox('Cadastro realizado com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
     Application.MessageBox(Pchar('Seja bem-vindo '+NomeUsuario+' !!'),'Sucesso!',mb_OK);

  // Se o Cadastro for concluído, limpa todos os campos
  RButtonProf.Checked:=false;
  RButtonAluno.Checked:= false;
  EditNome.Text:='';
  EditLogin.Text:='';
  EditConfSenha.Text:='';
  EditSenha.Text:='';
  end

  else   // SE NÃO estiver selecionado modo aluno
  //Entra no modo Professor.
 // >>>>>>>>>>>>>>>>>>>> Joga os dados do cadastro no BD
// INSERE NO BD O CADASTRO DOS PROFESSORES

 if (RButtonProf.Checked = true) then
// Se a opção PROFESSOR estiver selecionada...
    begin SenhaProf:= Inputbox(':: Modo Professor','Digite sua senha de professor','');
        //Verifica a senha do Professor, se estiver errada mostra msg de Erro
        if SenhaProf<>'123' then
         begin Application.MessageBox('Senha incorreta!','Erro',mb_IconError);
        end else    // SE NÃO
  begin
  //Limpa as Querys
  DM.ZQuery1.Close;
  DM.ZQuery1.SQL.Clear;
// Passa por parâmetros os Edits.Txt aos campos do BD
         DM.ZQuery1.SQL.Add('Insert into Professor '+
                                 '(Nome_Prof, Login_Prof, Senha_Prof) Values '+
                                ('(:EditNomeProf, :EditLoginProf, :EditSenhaProf);'));
          DM.ZQuery1.ParamByName('EditNomeProf').AsString:=EditNome.Text;
          DM.ZQuery1.ParamByName('EditLoginProf').AsString:=EditLogin.Text;
          DM.ZQuery1.ParamByName('EditSenhaProf').AsString:=EditSenha.Text;
          DM.ZQuery1.ExecSQL;
 //Mostra Mensagem de Cadastro Concluído
        Application.MessageBox('Cadastro realizado com sucesso!',':: Sucesso',MB_IconInformation+mb_OK);
        Application.MessageBox(Pchar('Seja bem-vindo Professor '+NomeUsuario+' !!'),'Sucesso!',mb_OK);

  // Se o Cadastro for concluído, limpa todos os campos
  RButtonProf.Checked:=false;
  RButtonAluno.Checked:= false;
  EditNome.Text:='';
  EditLogin.Text:='';
  EditConfSenha.Text:='';
  EditSenha.Text:='';
   end;
  end;
 end;
end;


procedure TFormCadastro.BotaoCancelarClick(Sender: TObject);
begin
FormCadastro.Close;
end;

procedure TFormCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormLogin.Show;
end;
procedure TFormCadastro.Image2Click(Sender: TObject);
begin
//Fala de Ajuda
  voz:=CreateOleObject('SAPI.SpVoice');
  voz.voz.Rate:=1;
  voz.speak('Digite seu nome completo. O usúario que deseja usar no programa. Duas vezes sua senha. E escolha se você é um aluno ou professor.');
end;

procedure TFormCadastro.Label3Click(Sender: TObject);
begin
  RButtonAluno.Checked:= True;
  RButtonProf.Checked:= False;
end;

procedure TFormCadastro.Label5Click(Sender: TObject);
begin
 RButtonProf.Checked:= True;
 RButtonAluno.Checked:= False;
end;




end.
