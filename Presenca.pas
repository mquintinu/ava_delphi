unit Presenca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, jpeg, StdCtrls;

type
  TFormPresenca = class(TForm)
    PlanoDeFundo: TImage;
    ImagePresenca: TImage;
    Label5: TLabel;
    EditSenha: TEdit;
    EditData: TEdit;
    EditHora: TEdit;
    TimerHoraAtual: TTimer;
    Timer1: TTimer;
    procedure TimerHoraAtualTimer(Sender: TObject);
    procedure ImagePresencaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Voz: OleVariant;
  FormPresenca: TFormPresenca;

  IDAula,IDAluno: String;

implementation

uses VisuAluno,DMbd,AVA,Materia;
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
  IDAula:= Dm.ZQuery1.FieldByName('ID_Aula').AsString;

  LimparQuery;
end;
// ****** FIM DO SELECT PARA PEGAR O ID DA AULA

// ****** SELECT PARA PEGAR O ID DO ALUNO
procedure SelectIDAluno;
begin
  LimparQuery;

  DM.ZQuery1.SQL.Add('Select ID_Aluno From Aluno where Nome_Aluno='+CHR(39)
                     +FormMateria.LabelNomeAluno.Caption +CHR(39) +';');
  DM.ZQuery1.Open;
  IDAluno:= DM.ZQuery1.FieldByName('ID_Aluno').AsString;

  LimparQuery;
end;
// ****** FIM DO SELECT PARA PEGAR O ID DO ALUNO


procedure TFormPresenca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
EditSenha.Text:='';
FormVisuAulaAluno.show;
end;

procedure TFormPresenca.ImagePresencaClick(Sender: TObject);
begin
  //==VERIFICAÇÃO DOS CAMPOS
  //Se SENHA estiver em branco, mostra MSG
  if EditSenha.Text='' then
     begin
      Application.MessageBox('Digite sua senha!','ERRO',Mb_IconError);
     end
      else begin

// >>>>>>>>>>>>>>>>>>>> Verifica dados no BD
// VERIFICA SE USUÁRIO EXISTE NO BD
// TABELA ALUNO <<
//Limpa as Querys
LimparQuery;

//Consultando todos os usuários (From Aluno) no BD,
//e passando por parametro o que foi digitado.
  DM.ZQuery1.SQL.Add('Select * From Aluno WHERE Login_Aluno = :EditLogin '+
                     'AND Senha_Aluno = :EditSenha;');
  DM.ZQuery1.ParamByName('EditLogin').AsString:=FormLogin.EditUsuario.Text;
  DM.ZQuery1.ParamByName('EditSenha').AsString:=EditSenha.Text;
  DM.ZQuery1.Open;

  if (FormLogin.EditUsuario.Text = DM.ZQuery1.FieldByName('Login_Aluno').AsString)
      AND
     (EditSenha.Text = DM.ZQuery1.FieldByName('Senha_Aluno').AsString)
     then begin

       {<><><><>>< AGORA VOU INSERIR O "PRESENTE" NA TABELA DO BANDO <><><><><><}
       LimparQuery;

       SelectIDAula;
       SelectIDAluno;

       DM.ZQuery1.SQL.Add('Update Avaliacao SET Presenca=' +CHR(39) +'PRESENTE' +CHR(39) +
                          'Where ID_Aula=' +IDAula +' and ID_Aluno=' +IDAluno +';');
       DM.ZQuery1.ExecSQL;

       Application.MessageBox('Presença registrada com sucesso!',':: Sucesso', MB_ICONINFORMATION);

       FormPresenca.Close;
       LimparQuery;
        end
          else begin
          Application.MessageBox('Usuário ou senha incorreta!','Erro',MB_ICONEXCLAMATION);
          LimparQuery;
      end;


      end;
end;


procedure TFormPresenca.TimerHoraAtualTimer(Sender: TObject);
begin
  EditHora.Text := 'Hora: '+TimeToStr(Time);
  EditData.Text := 'Data: '+DateToStr(date) +'   -   ';
end;

end.
