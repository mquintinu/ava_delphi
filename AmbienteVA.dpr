program AmbienteVA;

uses
  Forms,
  AVA in 'AVA.pas' {FormLogin},
  Cadastro in 'Cadastro.pas' {FormCadastro},
  Materia in 'Materia.pas' {FormMateria},
  Splash in 'Splash.pas' {FormSplash},
  SysUtils,
  DMbd in 'DMbd.pas' {DM: TDataModule},
  ModoProfessor in 'ModoProfessor.pas' {FormProf},
  MateriaCadastro in 'MateriaCadastro.pas' {FormCadastrarMateria},
  MateriaAula in 'MateriaAula.pas' {FormGerencAulas},
  VisualizarAula in 'VisualizarAula.pas' {FormVisuAula},
  Prova in 'Prova.pas' {FormProva},
  VisuAluno in 'VisuAluno.pas' {FormVisuAulaAluno},
  Avaliacao in 'Avaliacao.pas' {FormAvaliacao},
  Presenca in 'Presenca.pas' {FormPresenca},
  Resultados in 'Resultados.pas' {FormResultados};

{$R *.res}

begin
  Application.Initialize;
  FormSplash:= TFormSplash.Create(Application);
  FormSplash.Show;
  FormSplash.Repaint;

  Repeat //Inicia o loop at� que a hora atual - hora do TP seja maior que 3 seg
  Application.ProcessMessages; //N�o deixa a aplica��o presa no loop

  until FormSplash.BarraProgresso.Position>=100;
  //Now - Hora >= EncodeTime(0,0,3,0);   //Crit�rio para sair do loop

  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormCadastro, FormCadastro);
  Application.CreateForm(TFormCadastrarMateria, FormCadastrarMateria);
  Application.CreateForm(TFormVisuAulaAluno, FormVisuAulaAluno);
  Application.CreateForm(TFormAvaliacao, FormAvaliacao);
  Application.CreateForm(TFormPresenca, FormPresenca);
  Application.CreateForm(TFormResultados, FormResultados);
  //ao finalizar os 3 segundos, cria
  FormSplash.Hide; //oculta a tela de splash
  FormSplash.Close; //fecha a tela de splash

  FormLogin.Show; // chama o formul�rio principal
  Application.Run; // For�a a inicializa��o da aplica��o
end.
