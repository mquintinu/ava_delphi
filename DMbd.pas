unit DMbd;

interface

uses
  SysUtils, Classes, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection;

type
  TDM = class(TDataModule)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

end.
