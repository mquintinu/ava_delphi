object DM: TDM
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ZConnection1: TZConnection
    Protocol = 'mysql-5'
    HostName = 'localhost'
    Port = 3306
    Database = 'AVA'
    User = 'root'
    Password = '123456'
    Left = 136
    Top = 32
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 136
    Top = 80
  end
end
