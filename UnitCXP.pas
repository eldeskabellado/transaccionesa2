unit UnitCXP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, dbisamtb, UnitDatos;

type
  TFormCXP = class(TForm)
    EditCodigoProveedor: TEdit;
    ButtonBuscarProveedor: TButton;
    LabelNombreProveedor: TLabel;
    DBGridCXP: TDBGrid;
    sqCXP: TDBISAMQuery;
    DataSourceCXP: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure EditCodigoProveedorChange(Sender: TObject);
    procedure ButtonBuscarProveedorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FUpdatingFromSearch: Boolean;
    procedure ConfigurarQuery;
    procedure EjecutarConsultaCXP(const CodigoProveedor: string);
    procedure LimpiarFormulario;
  public
    // Funciones públicas para uso externo
    procedure CargarProveedorPorCodigo(const Codigo: string);
    procedure ActualizarGridCXP;
  end;

var
  FormCXP: TFormCXP;

// Funciones auxiliares públicas de la unidad
function ObtenerNombreProveedor(const CodigoProveedor: string): string;
function ValidarCodigoProveedor(const Codigo: string): Boolean;
function CalcularTotalCXPProveedor(const CodigoProveedor: string): Currency;
function ContarDocumentosPendientes(const CodigoProveedor: string): Integer;

implementation

{$R *.dfm}



{$REGION 'Funciones Auxiliares de la Unidad'}

function ObtenerNombreProveedor(const CodigoProveedor: string): string;
var
  qTemp: TDBISAMQuery;
begin
  Result := '';

  if Trim(CodigoProveedor) = '' then
    Exit;

  qTemp := TDBISAMQuery.Create(nil);
  try
    qTemp.DatabaseName := d.datprincipal.DatabaseName;
    qTemp.SQL.Text := 'SELECT FP_DESCRIPCION FROM Sproveedor WHERE FP_CODIGO = :CODIGO';
    qTemp.ParamByName('CODIGO').AsString := CodigoProveedor;

    try
      qTemp.Open;
      if not qTemp.IsEmpty then
        Result := qTemp.FieldByName('FP_DESCRIPCION').AsString;
    except
      on E: Exception do
        Result := '';
    end;
  finally
    qTemp.Free;
  end;
end;

function ValidarCodigoProveedor(const Codigo: string): Boolean;
var
  qTemp: TDBISAMQuery;
begin
  Result := False;

  if Trim(Codigo) = '' then
    Exit;

  qTemp := TDBISAMQuery.Create(nil);
  try
    qTemp.DatabaseName := d.datprincipal.DatabaseName;
    qTemp.SQL.Text := 'SELECT FP_CODIGO FROM Sproveedor WHERE FP_CODIGO = :CODIGO';
    qTemp.ParamByName('CODIGO').AsString := Codigo;

    try
      qTemp.Open;
      Result := not qTemp.IsEmpty;
    except
      Result := False;
    end;
  finally
    qTemp.Free;
  end;
end;

function CalcularTotalCXPProveedor(const CodigoProveedor: string): Currency;
var
  qTemp: TDBISAMQuery;
begin
  Result := 0;

  if Trim(CodigoProveedor) = '' then
    Exit;

  qTemp := TDBISAMQuery.Create(nil);
  try
    qTemp.DatabaseName := d.datprincipal.DatabaseName;
    qTemp.SQL.Text := 'SELECT SUM(FCP_SALDOMONEDAEXT) AS TOTAL ' +
                      'FROM Scuentasxpagar ' +
                      'WHERE FCP_TIPOTRANSACCION = 1 ' +
                      'AND FCP_CODIGO = :CODIGO ' +
                      'AND FCP_SALDOMONEDAEXT > 0';
    qTemp.ParamByName('CODIGO').AsString := CodigoProveedor;

    try
      qTemp.Open;
      if not qTemp.IsEmpty then
        Result := qTemp.FieldByName('TOTAL').AsCurrency;
    except
      Result := 0;
    end;
  finally
    qTemp.Free;
  end;
end;

function ContarDocumentosPendientes(const CodigoProveedor: string): Integer;
var
  qTemp: TDBISAMQuery;
begin
  Result := 0;

  if Trim(CodigoProveedor) = '' then
    Exit;

  qTemp := TDBISAMQuery.Create(nil);
  try
    qTemp.DatabaseName := d.datprincipal.DatabaseName;
    qTemp.SQL.Text := 'SELECT COUNT(*) AS CANTIDAD ' +
                      'FROM Scuentasxpagar ' +
                      'WHERE FCP_TIPOTRANSACCION = 1 ' +
                      'AND FCP_CODIGO = :CODIGO ' +
                      'AND FCP_SALDOMONEDAEXT > 0';
    qTemp.ParamByName('CODIGO').AsString := CodigoProveedor;

    try
      qTemp.Open;
      if not qTemp.IsEmpty then
        Result := qTemp.FieldByName('CANTIDAD').AsInteger;
    except
      Result := 0;
    end;
  finally
    qTemp.Free;
  end;
end;

{$ENDREGION}

{$REGION 'Métodos del Formulario'}

procedure TFormCXP.FormCreate(Sender: TObject);
begin
  FUpdatingFromSearch := False;
  ConfigurarQuery;
  LimpiarFormulario;

  DataSourceCXP.DataSet := sqCXP;
  DBGridCXP.DataSource := DataSourceCXP;

  // Configurar apariencia del grid
  with DBGridCXP do
  begin
    Options := Options + [dgRowSelect, dgAlwaysShowSelection];
    ReadOnly := True;
  end;
end;

procedure TFormCXP.ConfigurarQuery;
begin
  sqCXP.DatabaseName := d.datprincipal.DatabaseName;
  sqCXP.SQL.Clear;
  sqCXP.SQL.Add('SELECT');
  sqCXP.SQL.Add('    FCP_CODIGO,');
  sqCXP.SQL.Add('    FCP_FECHAEMISION,');
  sqCXP.SQL.Add('    FCP_FECHAVENCIMIENTO,');
  sqCXP.SQL.Add('    FCP_CODIGOUNICO,');
  sqCXP.SQL.Add('    FCP_CODIGOUNICO2,');
  sqCXP.SQL.Add('    FCP_TIPOTRANSACCION,');
  sqCXP.SQL.Add('    FCP_TIPOOPERACION,');
  sqCXP.SQL.Add('    FCP_DESCRIPCIONMOV,');
  sqCXP.SQL.Add('    FCP_MONTODOCUMENTO,');
  sqCXP.SQL.Add('    FCP_SALDOMONEDAEXT,');
  sqCXP.SQL.Add('    FCP_MONEDA,');
  sqCXP.SQL.Add('    FCP_MONTOORIGINALEXT');
  sqCXP.SQL.Add('FROM');
  sqCXP.SQL.Add('    Scuentasxpagar');
  sqCXP.SQL.Add('WHERE');
  sqCXP.SQL.Add('    FCP_TIPOTRANSACCION = 1');
  sqCXP.SQL.Add('    AND FCP_CODIGO = :CODIGOPROVEEDOR');
  sqCXP.SQL.Add('    AND FCP_SALDOMONEDAEXT > 0');
  sqCXP.SQL.Add('ORDER BY FCP_FECHAVENCIMIENTO');
end;

procedure TFormCXP.LimpiarFormulario;
begin
  EditCodigoProveedor.Clear;
  LabelNombreProveedor.Caption := '';
  sqCXP.Close;
end;

procedure TFormCXP.EjecutarConsultaCXP(const CodigoProveedor: string);
var
  NombreProveedor: string;
  TotalCXP: Currency;
  CantidadDocs: Integer;
begin
  if Trim(CodigoProveedor) = '' then
  begin
    LimpiarFormulario;
    Exit;
  end;

  // Validar que el proveedor existe
  if not ValidarCodigoProveedor(CodigoProveedor) then
  begin
    ShowMessage('El código de proveedor no existe.');
    LimpiarFormulario;
    Exit;
  end;

  try
    // Obtener nombre del proveedor
    NombreProveedor := ObtenerNombreProveedor(CodigoProveedor);
    LabelNombreProveedor.Caption := NombreProveedor;

    // Ejecutar consulta de CXP
    sqCXP.Close;
    sqCXP.ParamByName('CODIGOPROVEEDOR').AsString := CodigoProveedor;
    sqCXP.Open;

    // Mostrar información adicional (opcional)
    if sqCXP.IsEmpty then
    begin
      ShowMessage('El proveedor no tiene cuentas por pagar pendientes.');
    end
    else
    begin
      CantidadDocs := ContarDocumentosPendientes(CodigoProveedor);
      TotalCXP := CalcularTotalCXPProveedor(CodigoProveedor);

      Caption := Format('Cuentas por Pagar - %s - %d documento(s) - Total: %s',
        [NombreProveedor, CantidadDocs, FormatCurr('#,##0.00', TotalCXP)]);
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error al consultar CXP: ' + E.Message);
      LimpiarFormulario;
    end;
  end;
end;

procedure TFormCXP.EditCodigoProveedorChange(Sender: TObject);
begin
  if not FUpdatingFromSearch then
  begin
    EjecutarConsultaCXP(Trim(EditCodigoProveedor.Text));
  end;
end;

procedure TFormCXP.ButtonBuscarProveedorClick(Sender: TObject);
var
  FormBusqueda: TFormBuscarProveedor;
begin
  FormBusqueda := TFormBuscarProveedor.Create(Self);
  try
    if FormBusqueda.ShowModal = mrOK then
    begin
      FUpdatingFromSearch := True;
      try
        EditCodigoProveedor.Text := FormBusqueda.CodigoProveedorSeleccionado;
        LabelNombreProveedor.Caption := FormBusqueda.NombreProveedorSeleccionado;
        EjecutarConsultaCXP(FormBusqueda.CodigoProveedorSeleccionado);
      finally
        FUpdatingFromSearch := False;
      end;
    end;
  finally
    FormBusqueda.Free;
  end;
end;

procedure TFormCXP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  sqCXP.Close;
end;

{$ENDREGION}

{$REGION 'Métodos Públicos'}

procedure TFormCXP.CargarProveedorPorCodigo(const Codigo: string);
begin
  FUpdatingFromSearch := True;
  try
    EditCodigoProveedor.Text := Codigo;
    EjecutarConsultaCXP(Codigo);
  finally
    FUpdatingFromSearch := False;
  end;
end;

procedure TFormCXP.ActualizarGridCXP;
begin
  if sqCXP.Active then
    sqCXP.Refresh;
end;

{$ENDREGION}

end.
