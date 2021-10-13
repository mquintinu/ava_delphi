unit AVA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, jpeg, ExtCtrls,
  ComObj, ImgList, pngimage, Buttons, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWExtCtrls, ActnList;

type
  TFormLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BotaoEntrar: TButton;
    LabelRecSenha: TLabel;
    BotaoCadastro: TButton;
    EditUsuario: TEdit;
    Audio: TImage;
    PlanoDeFundo: TImage;
    EditSenha: TEdit;
    Timer1: TTimer;
    BotaoSair: TButton;
    ActionList1: TActionList;
    AcaoSair: TAction;
    EditHora: TEdit;
    TimerHoraAtual: TTimer;
    Image1: TImage;
    AcaoSairForms: TAction;
    EditData: TEdit;
    Entrar: TAction;
    procedure AudioClick(Sender: TObject);
    procedure BotaoCadastroClick(Sender: TObject);
    procedure LabelRecSenhaClick(Sender: TObject);
    procedure LabelRecSenhaMouseEnter(Sender: TObject);
    procedure LabelRecSenhaMouseLeave(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AcaoSairExecute(Sender: TObject);
    procedure TimerHoraAtualTimer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure AcaoSairFormsExecute(Sender: TObject);
    procedure EntrarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;
//Variável do Narrador
  voz :OleVariant;
implementation

uses Cadastro,Materia,ModoProfessor,DMbd;

{$R *.dfm}
// Clica no botão CADASTRAR e abre formulário de Cadastro
procedure TFormLogin.BotaoCadastroClick(Sender: TObject);
begin
FormCadastro.show;
end;

// ==============================================================|
//            AO CLICAR NO "ENTRAR"                              |
// ==============================================================|
procedure TFormLogin.EntrarExecute(Sender: TObject);
//==VERIFICAÇÃO DOS CAMPOS
  begin
        //Se USUÁRIO estiver em branco, mostra MSG
        if (Editusuario.Text='') then
            begin Application.MessageBox('Preencha o Campo "Usuário"!','ERRO',MB_IconError);
            end else
            //Se SENHA estiver em branco, mostra MSG
            if(EditSenha.Text='') then
               begin Application.MessageBox('Preencha o campo "Senha"!','ERRO',Mb_IconError)
               end else
               // Se nenhum campo estiver em branco...
               if (EditUsuario.Text<>'') and (EditSenha.Text<>'')  then begin

// >>>>>>>>>>>>>>>>>>>> Verifica dados no BD
// VERIFICA SE USUÁRIO EXISTE NO BD
// TABELA ALUNO <<
//Limpa as Querys
DM.ZQuery1.Close;
DM.ZQuery1.SQL.Clear;

//Consultando todos os usuários (From Aluno) no BD,
//e passando por parametro o que foi digitado.
  DM.ZQuery1.SQL.Add('Select * From Aluno WHERE Login_Aluno = :EditLogin '+
                     'AND Senha_Aluno = :EditSenha;');
  DM.ZQuery1.ParamByName('EditLogin').AsString:=EditUsuario.Text;
  DM.ZQuery1.ParamByName('EditSenha').AsString:=EditSenha.Text;
  DM.ZQuery1.Open;

  if (EditUsuario.Text = DM.ZQuery1.FieldByName('Login_Aluno').AsString)
      AND
     (EditSenha.Text = DM.ZQuery1.FieldByName('Senha_Aluno').AsString)
     then
    // Inicia programa - Aula 1
    begin Application.CreateForm(TFormMateria,FormMateria);
          FormLogin.Hide;
          FormMateria.Show;
    end
      else begin
// VERIFICA SE USUÁRIO EXISTE NO BD
// TABELA PROFESSOR <<
//Limpa as Querys
DM.ZQuery1.Close;
DM.ZQuery1.SQL.Clear;

  //Consultando todos os usuários no BD, e passando por parametro o que foi digitado.
  DM.ZQuery1.SQL.Add('Select * From Professor WHERE Login_Prof = :EditLogin '+
                     'AND Senha_Prof = :EditSenha;');
  DM.ZQuery1.ParamByName('EditLogin').AsString:=EditUsuario.Text;
  DM.ZQuery1.ParamByName('EditSenha').AsString:=EditSenha.Text;
  DM.ZQuery1.Open;

  if (EditUsuario.Text = DM.ZQuery1.FieldByName('Login_Prof').AsString)
      AND
     (EditSenha.Text = DM.ZQuery1.FieldByName('Senha_Prof').AsString)
     then
     // Inicia programa - Modo Professor
     begin  Application.CreateForm(TFormProf,FormProf);
            FormLogin.Hide;
            FormProf.Show;
     end

      else
 Application.MessageBox('Usuário ou senha incorreta!','Erro',MB_ICONEXCLAMATION);
  end;
  end;
end;

procedure TFormLogin.Image1Click(Sender: TObject);
begin
voz:=CreateOleObject('SAPI.SpVoice');
voz.Rate:=-1;
voz.speak('São exatamente'+TimeToStr(Now));
end;

//PERDEU SUA SENHA?
procedure TFormLogin.LabelRecSenhaClick(Sender: TObject);
begin
Application.MessageBox('Para recuperar sua senha, contate seu professor.',':: SENHA',
                        mb_IconExclamation+mb_ok);
end;



// PERDEU SUA SENHA? deixa Itálico quando passao mouse.
procedure TFormLogin.LabelRecSenhaMouseEnter(Sender: TObject);
begin
LabelRecSenha.Font.Style:=[fsunderline];
LabelRecSenha.Cursor:=crHandPoint;
end;

// PERDEU SUA SENHA? volta ao normal, quando tira o mouse.
procedure TFormLogin.LabelRecSenhaMouseLeave(Sender: TObject);
begin
LabelRecSenha.Font.Style:=[];
end;

// Procedimento para fazer o Form aparecer lentamente.
procedure TFormLogin.Timer1Timer(Sender: TObject);
begin
FormLogin.AlphaBlendValue:=FormLogin.AlphaBlendValue+2;
    if formLogin.AlphaBlendValue = 254 then
    begin Timer1.enabled := false;
    end;
end;

procedure TFormLogin.TimerHoraAtualTimer(Sender: TObject);
begin
   EditHora.Text := 'Hora: '+TimeToStr(Time);
   EditData.Text := 'Data: '+DateToStr(date);
end;

// Açao SAIR
procedure TFormLogin.AcaoSairExecute(Sender: TObject);
begin
if Application.MessageBox('Deseja realmente sair?','Sair',mb_YesNo+Mb_IconQuestion)=id_yes then
Application.Terminate;
end;

//Áudio de Boas-vindas ao programa
procedure TFormLogin.AcaoSairFormsExecute(Sender: TObject);
begin
if Application.MessageBox('Deseja sair da aplicação?','Sair',mb_YesNo+Mb_IconQuestion)=id_yes then
Application.Terminate else
FormLogin.Show;
end;

procedure TFormLogin.AudioClick(Sender: TObject);
begin
  voz:=CreateOleObject('SAPI.SpVoice');
  voz.Rate:=1;
  voz.speak('Bem-vindo ao Ambiente Virtual de Aprendizado em Informática.'+
            ' Meu nome é Raquel, e irei lhe ajudar a usar este programa.'+
            ' Para iniciar digite seu Usuário e Senha. E clique no botão: ENTRAR.'+
            ' Ou clique no botão: CADASTRAR-SE para ter um Usuário e Senha.');
end;


end.
