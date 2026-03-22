unit UnitDetalleOrdenPago;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, dbisamtb, System.StrUtils,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormDetalleOrdenPago = class(TForm)
    Panel1: TPanel;
    lblTitulo: TLabel;
    DBGridDetalle: TDBGrid;
    sqDetalle: TDBISAMQuery;
    dsDetalle: TDataSource;
    Panel2: TPanel;
    btnCerrar: TButton;
    lblTotal: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure sqDetalleAfterOpen(DataSet: TDataSet);
  private
    FNumeroDoc: String;
    procedure CargarDetalle;
    procedure CalcularTotal;
    procedure ConfigurarGridDetalle;
  public
    class procedure MostrarDetalle(const ANumeroDoc: String);
  end;

var
  FormDetalleOrdenPago: TFormDetalleOrdenPago;

implementation

uses
  UnitDatos;

{$R *.dfm}

class procedure TFormDetalleOrdenPago.MostrarDetalle(const ANumeroDoc: String);
begin
  FormDetalleOrdenPago := TFormDetalleOrdenPago.Create(Application);
  try
    FormDetalleOrdenPago.FNumeroDoc := ANumeroDoc;
    FormDetalleOrdenPago.Caption := 'Detalle Orden de Pago: ' + ANumeroDoc;
    FormDetalleOrdenPago.lblTitulo.Caption := 'Detalle de la Orden: ' + ANumeroDoc;
    FormDetalleOrdenPago.CargarDetalle;
    FormDetalleOrdenPago.ShowModal;
  finally
    FormDetalleOrdenPago.Free;
  end;
end;

procedure TFormDetalleOrdenPago.FormCreate(Sender: TObject);
begin
  dsDetalle.DataSet := sqDetalle;
end;

procedure TFormDetalleOrdenPago.ConfigurarGridDetalle;
var
  i: Integer;
begin
  if not sqDetalle.Active then Exit;

  // Configurar propiedades generales del grid
  DBGridDetalle.Options := DBGridDetalle.Options + [dgRowSelect, dgAlwaysShowSelection];
  DBGridDetalle.ReadOnly := True;
  DBGridDetalle.Font.Size := 9;
  DBGridDetalle.Color := clWhite;

  // Configurar columnas
  for i := 0 to DBGridDetalle.Columns.Count - 1 do
  begin
    case AnsiIndexStr(DBGridDetalle.Columns[i].FieldName,
      ['FDO_CODIGO', 'FDO_NUMERODOC', 'FDO_DETALLEDOC', 'FDO_MONTOPAGO']) of

      0: begin // FDO_CODIGO
        DBGridDetalle.Columns[i].Width := 80;
        DBGridDetalle.Columns[i].Title.Caption := 'Código';
        DBGridDetalle.Columns[i].Title.Font.Style := [fsBold];
        DBGridDetalle.Columns[i].Title.Alignment := taCenter;
      end;

      1: begin // FDO_NUMERODOC
        DBGridDetalle.Columns[i].Width := 120;
        DBGridDetalle.Columns[i].Title.Caption := 'Nro. Documento';
        DBGridDetalle.Columns[i].Title.Font.Style := [fsBold];
      end;

      2: begin // FDO_DETALLEDOC
        DBGridDetalle.Columns[i].Width := 400;
        DBGridDetalle.Columns[i].Title.Caption := 'Descripción';
        DBGridDetalle.Columns[i].Title.Font.Style := [fsBold];
      end;

      3: begin // FDO_MONTOPAGO
        DBGridDetalle.Columns[i].Width := 120;
        DBGridDetalle.Columns[i].Title.Caption := 'Monto';
        DBGridDetalle.Columns[i].Title.Font.Style := [fsBold];
        DBGridDetalle.Columns[i].Title.Alignment := taRightJustify;
        if sqDetalle.FieldByName('FDO_MONTOPAGO') is TFloatField then
          TFloatField(sqDetalle.FieldByName('FDO_MONTOPAGO')).DisplayFormat := '#,##0.00';
      end;
    end;
  end;
end;

procedure TFormDetalleOrdenPago.CargarDetalle;
begin
  try
    sqDetalle.Close;
    sqDetalle.SQL.Clear;
    sqDetalle.SQL.Text :=
      'SELECT ' +
      '  FDO_CODIGO, ' +
      '  FDO_NUMERODOC, ' +
      '  FDO_DETALLEDOC, ' +
      '  FDO_MONTOPAGO ' +
      'FROM SOrdenPagoDetalle ' +
      'WHERE FDO_CODIGO = :NUMERODOC ' +
      'ORDER BY FDO_CODIGO';

    sqDetalle.ParamByName('NUMERODOC').AsString := FNumeroDoc;
    sqDetalle.Open;

    // Configurar grid después de abrir
    ConfigurarGridDetalle;

  except
    on E: Exception do
      ShowMessage('Error al cargar detalle: ' + E.Message);
  end;
end;

procedure TFormDetalleOrdenPago.sqDetalleAfterOpen(DataSet: TDataSet);
begin
  CalcularTotal;
end;

procedure TFormDetalleOrdenPago.CalcularTotal;
var
  Total: Double;
begin
  Total := 0;
  if sqDetalle.Active and not sqDetalle.IsEmpty then
  begin
    sqDetalle.First;
    while not sqDetalle.Eof do
    begin
      Total := Total + sqDetalle.FieldByName('FDO_MONTOPAGO').AsFloat;
      sqDetalle.Next;
    end;
    sqDetalle.First;
  end;

  lblTotal.Caption := 'Total: ' + FormatFloat('#,##0.00', Total);
  lblTotal.Font.Size := 11;
  lblTotal.Font.Style := [fsBold];
end;

procedure TFormDetalleOrdenPago.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

end.
