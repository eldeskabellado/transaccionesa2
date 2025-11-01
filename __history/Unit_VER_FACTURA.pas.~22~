unit Unit_VER_FACTURA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, dbisamtb;

type
  TFormVerFactura = class(TForm)
    DBGrid1: TDBGrid;
    DateFecha: TDateTimePicker;
    Label1: TLabel;
    sqfacturas: TDBISAMQuery;
    Button1: TButton;
    dsqfacturas: TDataSource;
    sqscim: TDBISAMQuery;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormVerFactura: TFormVerFactura;
  tipooperacion,
  serie, codigocliente:string;
  codautorizado,
  docProceso:Integer;

implementation

{$R *.dfm}

uses UnitDatos, UnitVerificar;

procedure TFormVerFactura.Button1Click(Sender: TObject);
begin
  with sqfacturas do
  begin
    close;
    PARAMBYNAME('Tfecha').AsDate:=DateFecha.DateTime;
    Parambyname('Ttipo').AsInteger:=11;
    Open;
  end;
end;

procedure TFormVerFactura.DBGrid1DblClick(Sender: TObject);
begin
sqscim.Close;
sqscim.ParamByName('PCODIGOCLIENTE').AsString:=sqfacturas.FieldByName('FTI_RESPONSABLE').AsString;;
sqscim.ParamByName('PCODIGO').AsInteger:=sqfacturas.FieldByName('FTI_AUTORIZADOS').AsInteger;;
sqscim.Open;
FormVerificar:= TFormVerificar.Create(Application);
      try
            with FormVerificar.sqborrar do
            begin
              Close;
              ParamByName('pdocumento').AsString:=documento;
              ExecSQL;
            end;
          with FormVerificar do
          begin

          labeldocumento.Caption:=sqfacturas.FieldByName('FTI_DOCUMENTO').AsString;
          labelCLIENTE.Caption:=sqfacturas.FieldByName('FTI_PERSONACONTACTO').AsString;
          documento:=sqfacturas.FieldByName('FTI_DOCUMENTO').AsString;
          nroregistro:=sqfacturas.FieldByName('FTI_AUTOINCREMENT').AsInteger;
          mmo1.Text:=sqfacturas.FieldByName('FTI_DIRECCIONDESPACHO').AsString;
          vendedor:=sqfacturas.FieldByName('FTI_VENDEDORASIGNADO').AsString;
          nro_scim:= sqscim.FieldByName('FCA_CEDULA').AsString;
          accion:=docProceso;
          ShowModal;
          end;

      finally
       FormVerificar.Free;

      end;
end;

procedure TFormVerFactura.FormShow(Sender: TObject);
begin
datefecha.DateTime:=now;
end;

end.
