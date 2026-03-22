unit UnitOrdenPago;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, dbisamtb, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Datasnap.DBClient, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    DBGridOrdenPago: TDBGrid;
    sqCXP: TDBISAMQuery;
    dsqOrdenPago: TDataSource;
    DBGridOrdenPagoSeleccionada: TDBGrid;
    dsTMOrdenpagoSeleccionada: TDataSource;
    btnCargarOrdenesPendientes: TButton;
    btnVerDetalle: TButton;
    btnProcesar: TButton;
    btnQuitarOrden: TButton;
    cdsOrdenesSeleccionadas: TClientDataSet;
    procedure btnCargarOrdenesPendientesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridOrdenPagoDblClick(Sender: TObject);
    procedure btnVerDetalleClick(Sender: TObject);
    procedure btnQuitarOrdenClick(Sender: TObject);
    procedure btnProcesarClick(Sender: TObject);
  private
    procedure CargarOrdenesPagoPendientes;
    procedure AgregarOrdenAMemoria;
    function ExisteOrdenEnMemoria(const ADocumento: String): Boolean;
    procedure InicializarTablaMemoria;
    function ShowBancoSelector: Integer;
    procedure ConfigurarGridOrdenesPendientes;
    procedure ConfigurarGridOrdenesSeleccionadas;
  public
    class procedure MostrarFormulario;
  end;

var
  Form1: TForm1;

implementation

uses
  UnitDatos, UnitDetalleOrdenPago, UnitGeneradorArchivosBancarios;

{$R *.dfm}

class procedure TForm1.MostrarFormulario;
begin
  if not Assigned(Form1) then
    Form1 := TForm1.Create(Application);

  Form1.Show;
  Form1.BringToFront;
end;

procedure TForm1.ConfigurarGridOrdenesPendientes;
var
  i: Integer;
begin
  if not sqCXP.Active then Exit;

  // Configurar propiedades generales del grid
  DBGridOrdenPago.Options := DBGridOrdenPago.Options + [dgRowSelect, dgAlwaysShowSelection];
  DBGridOrdenPago.ReadOnly := True;
  DBGridOrdenPago.Font.Size := 9;

  // Configurar columnas
  for i := 0 to DBGridOrdenPago.Columns.Count - 1 do
  begin
    case AnsiIndexStr(DBGridOrdenPago.Columns[i].FieldName,
      ['FOP_DOCUMENTO', 'FOP_FECHA', 'FOP_HORA',
       'NOMBRE_PROVEEDOR', 'FOP_MONTO', 'CUENTA_PAGAR', 'FP_RIF',
       'FP_EMAIL', 'FP_TELEFONO', 'FOP_STATUS', 'FOP_DETALLE',
       'FOP_ELABORADO', 'FOP_APROBADO', 'FOP_USUARIO',
       'FOP_MACHINENAME']) of

      0: begin // FOP_DOCUMENTO
        DBGridOrdenPago.Columns[i].Width := 100;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Documento';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      1: begin // FOP_FECHA
        DBGridOrdenPago.Columns[i].Width := 80;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Fecha';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      2: begin // FOP_HORA
        DBGridOrdenPago.Columns[i].Width := 70;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Hora';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      3: begin // NOMBRE_PROVEEDOR
        DBGridOrdenPago.Columns[i].Width := 250;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Proveedor';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      4: begin // FOP_MONTO
        DBGridOrdenPago.Columns[i].Width := 100;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Monto';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
        DBGridOrdenPago.Columns[i].Title.Alignment := taRightJustify;
        if sqCXP.FieldByName('FOP_MONTO') is TFloatField then
          TFloatField(sqCXP.FieldByName('FOP_MONTO')).DisplayFormat := '#,##0.00';
      end;

      5: begin // CUENTA_PAGAR
        DBGridOrdenPago.Columns[i].Width := 150;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Cuenta Bancaria';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      6: begin // FP_RIF
        DBGridOrdenPago.Columns[i].Width := 100;
        DBGridOrdenPago.Columns[i].Title.Caption := 'RIF';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      7: begin // FP_EMAIL
        DBGridOrdenPago.Columns[i].Width := 180;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Email';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      8: begin // FP_TELEFONO
        DBGridOrdenPago.Columns[i].Width := 100;
        DBGridOrdenPago.Columns[i].Title.Caption := 'Teléfono';
        DBGridOrdenPago.Columns[i].Title.Font.Style := [fsBold];
      end;

      9..15: begin // Ocultar campos
        DBGridOrdenPago.Columns[i].Visible := False;
      end;
    end;
  end;
end;

procedure TForm1.ConfigurarGridOrdenesSeleccionadas;
var
  i: Integer;
begin
  if not cdsOrdenesSeleccionadas.Active then Exit;

  // Configurar propiedades generales del grid
  DBGridOrdenPagoSeleccionada.Options := DBGridOrdenPagoSeleccionada.Options + [dgRowSelect, dgAlwaysShowSelection];
  DBGridOrdenPagoSeleccionada.ReadOnly := True;
  DBGridOrdenPagoSeleccionada.Font.Size := 9;
  DBGridOrdenPagoSeleccionada.Color := $00E8F4E8; // Verde claro

  // Configurar columnas
  for i := 0 to DBGridOrdenPagoSeleccionada.Columns.Count - 1 do
  begin
    case AnsiIndexStr(DBGridOrdenPagoSeleccionada.Columns[i].FieldName,
      ['FOP_DOCUMENTO', 'FOP_FECHA', 'FOP_PROVEEDOR', 'NOMBRE_PROVEEDOR',
       'FOP_MONTO', 'CUENTA_PAGAR', 'FP_RIF', 'FP_EMAIL', 'FP_TELEFONO']) of

      0: begin // FOP_DOCUMENTO
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 100;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Documento';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;

      1: begin // FOP_FECHA
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 80;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Fecha';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
        if cdsOrdenesSeleccionadas.FieldByName('FOP_FECHA') is TDateTimeField then
          TDateTimeField(cdsOrdenesSeleccionadas.FieldByName('FOP_FECHA')).DisplayFormat := 'dd/mm/yyyy';
      end;

      2: begin // FOP_PROVEEDOR
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 80;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Código';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;

      3: begin // NOMBRE_PROVEEDOR
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 250;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Proveedor';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;

      4: begin // FOP_MONTO
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 100;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Monto';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Alignment := taRightJustify;
        if cdsOrdenesSeleccionadas.FieldByName('FOP_MONTO') is TFloatField then
          TFloatField(cdsOrdenesSeleccionadas.FieldByName('FOP_MONTO')).DisplayFormat := '#,##0.00';
      end;

      5: begin // CUENTA_PAGAR
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 150;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Cuenta Bancaria';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;

      6: begin // FP_RIF
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 100;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'RIF';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;

      7: begin // FP_EMAIL
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 180;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Email';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;

      8: begin // FP_TELEFONO
        DBGridOrdenPagoSeleccionada.Columns[i].Width := 100;
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Caption := 'Teléfono';
        DBGridOrdenPagoSeleccionada.Columns[i].Title.Font.Style := [fsBold];
      end;
    end;
  end;
end;


function TForm1.ShowBancoSelector: Integer;
var
  FormBanco: TForm;
  RadioGroup: TRadioGroup;
  BtnOk, BtnCancelar: TButton;
begin
  Result := 0; // 0 = Cancelado

  // Crear formulario de selección
  FormBanco := TForm.Create(nil);
  try
    FormBanco.Caption := 'Seleccionar Banco';
    FormBanco.Width := 350;
    FormBanco.Height := 220;
    FormBanco.Position := poMainFormCenter;
    FormBanco.BorderStyle := bsDialog;

    // Crear RadioGroup
    RadioGroup := TRadioGroup.Create(FormBanco);
    RadioGroup.Parent := FormBanco;
    RadioGroup.Left := 16;
    RadioGroup.Top := 16;
    RadioGroup.Width := 305;
    RadioGroup.Height := 105;
    RadioGroup.Caption := ' Seleccione el formato de archivo bancario ';
    RadioGroup.Items.Add('Banco Mercantil');
    RadioGroup.Items.Add('Banco Banesco');
    RadioGroup.Items.Add('Banco de Venezuela');
    RadioGroup.ItemIndex := 0; // Mercantil por defecto

    // Botón OK
    BtnOk := TButton.Create(FormBanco);
    BtnOk.Parent := FormBanco;
    BtnOk.Caption := 'Aceptar';
    BtnOk.Left := 150;
    BtnOk.Top := 135;
    BtnOk.Width := 80;
    BtnOk.ModalResult := mrOk;
    BtnOk.Default := True;

    // Botón Cancelar
    BtnCancelar := TButton.Create(FormBanco);
    BtnCancelar.Parent := FormBanco;
    BtnCancelar.Caption := 'Cancelar';
    BtnCancelar.Left := 240;
    BtnCancelar.Top := 135;
    BtnCancelar.Width := 80;
    BtnCancelar.ModalResult := mrCancel;
    BtnCancelar.Cancel := True;

    // Mostrar modal
    if FormBanco.ShowModal = mrOk then
    begin
      Result := RadioGroup.ItemIndex + 1; // 1=Mercantil, 2=Banesco, 3=Venezuela
    end;

  finally
    FormBanco.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Configurar los DataSources
  dsqOrdenPago.DataSet := sqCXP;
  dsTMOrdenpagoSeleccionada.DataSet := cdsOrdenesSeleccionadas;

  // Inicializar tabla en memoria
  InicializarTablaMemoria;

  // Configurar grid de órdenes seleccionadas
  ConfigurarGridOrdenesSeleccionadas;

  // Cargar automáticamente al abrir el formulario
  CargarOrdenesPagoPendientes;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Form1 := nil;
end;

procedure TForm1.InicializarTablaMemoria;
begin
  // Cerrar si está activo
  if cdsOrdenesSeleccionadas.Active then
    cdsOrdenesSeleccionadas.Close;

  // Limpiar definiciones anteriores
  cdsOrdenesSeleccionadas.FieldDefs.Clear;

  // Crear la estructura de la tabla en memoria
  with cdsOrdenesSeleccionadas.FieldDefs do
  begin
    Add('FOP_DOCUMENTO', ftString, 20, True);
    Add('FOP_FECHA', ftDateTime, 0, False);
    Add('FOP_PROVEEDOR', ftString, 20, False);
    Add('NOMBRE_PROVEEDOR', ftString, 100, False);
    Add('FOP_MONTO', ftFloat, 0, False);
    Add('CUENTA_PAGAR', ftString, 50, False);
    Add('FP_RIF', ftString, 20, False);
    Add('FP_TELEFONO', ftString, 20, False);
    Add('FP_EMAIL', ftString, 100, False);
  end;

  // Crear el dataset
  cdsOrdenesSeleccionadas.CreateDataSet;
  cdsOrdenesSeleccionadas.LogChanges := False;
end;

procedure TForm1.CargarOrdenesPagoPendientes;
begin
  try
    sqCXP.Close;
    sqCXP.SQL.Clear;
    sqCXP.SQL.Text :=
      'SELECT ' +
      '  OP.FOP_DOCUMENTO, ' +
      '  OP.FOP_FECHA, ' +
      '  OP.FOP_HORA, ' +
      '  OP.FOP_STATUS, ' +
      '  OP.FOP_PROVEEDOR, ' +
      '  OP.FOP_DESCRIPCION AS NOMBRE_PROVEEDOR, ' +
      '  OP.FOP_DETALLE, ' +
      '  OP.FOP_MONTO, ' +
      '  OP.FOP_ELABORADO, ' +
      '  OP.FOP_APROBADO, ' +
      '  OP.FOP_USUARIO, ' +
      '  OP.FOP_MACHINENAME, ' +
      '  P.FP_DESCRIPCIONDETALLADA AS CUENTA_PAGAR, ' +
      '  P.FP_EMAIL, ' +
      '  P.FP_RIF, ' +
      '  P.FP_TELEFONO ' +
      'FROM SOrdenesPago OP ' +
      'LEFT JOIN Sproveedor P ON OP.FOP_PROVEEDOR = P."FP_CODIGO" ' +
      'WHERE OP.FOP_STATUS = 4 ' +
      'ORDER BY OP.FOP_FECHA DESC, OP.FOP_HORA DESC';

    sqCXP.Open;

    // Configurar grid después de abrir
    ConfigurarGridOrdenesPendientes;

    if sqCXP.RecordCount > 0 then
      ShowMessage(Format('Se encontraron %d órdenes de pago pendientes', [sqCXP.RecordCount]))
    else
      ShowMessage('No hay órdenes de pago pendientes');

  except
    on E: Exception do
      ShowMessage('Error al cargar órdenes de pago: ' + E.Message);
  end;
end;

function TForm1.ExisteOrdenEnMemoria(const ADocumento: String): Boolean;
begin
  Result := False;
  if cdsOrdenesSeleccionadas.Active then
  begin
    Result := cdsOrdenesSeleccionadas.Locate('FOP_DOCUMENTO', ADocumento, []);
  end;
end;

procedure TForm1.AgregarOrdenAMemoria;
var
  Documento: String;
  EmailProveedor: String;
const
  EMAIL_POR_DEFECTO = 'CXPAGARGM@GRUPOELMORRO.COM';
begin
  if sqCXP.IsEmpty then
  begin
    ShowMessage('No hay ninguna orden seleccionada');
    Exit;
  end;

  Documento := sqCXP.FieldByName('FOP_DOCUMENTO').AsString;

  // Validar si ya existe en la tabla en memoria
  if ExisteOrdenEnMemoria(Documento) then
  begin
    ShowMessage('Esta orden ya fue agregada. No se puede agregar dos veces.');
    Exit;
  end;

  try
    // Obtener email del proveedor
    EmailProveedor := Trim(sqCXP.FieldByName('FP_EMAIL').AsString);

    // Si el email está vacío, usar el email por defecto
    if EmailProveedor = '' then
      EmailProveedor := EMAIL_POR_DEFECTO;

    // Agregar a la tabla en memoria
    cdsOrdenesSeleccionadas.Append;
    cdsOrdenesSeleccionadas.FieldByName('FOP_DOCUMENTO').AsString :=
      sqCXP.FieldByName('FOP_DOCUMENTO').AsString;
    cdsOrdenesSeleccionadas.FieldByName('FOP_FECHA').AsDateTime :=
      sqCXP.FieldByName('FOP_FECHA').AsDateTime;
    cdsOrdenesSeleccionadas.FieldByName('FOP_PROVEEDOR').AsString :=
      sqCXP.FieldByName('FOP_PROVEEDOR').AsString;
    cdsOrdenesSeleccionadas.FieldByName('NOMBRE_PROVEEDOR').AsString :=
      sqCXP.FieldByName('NOMBRE_PROVEEDOR').AsString;
    cdsOrdenesSeleccionadas.FieldByName('FOP_MONTO').AsFloat :=
      sqCXP.FieldByName('FOP_MONTO').AsFloat;
    cdsOrdenesSeleccionadas.FieldByName('CUENTA_PAGAR').AsString :=
      sqCXP.FieldByName('CUENTA_PAGAR').AsString;
    cdsOrdenesSeleccionadas.FieldByName('FP_RIF').AsString :=
      sqCXP.FieldByName('FP_RIF').AsString;
    cdsOrdenesSeleccionadas.FieldByName('FP_TELEFONO').AsString :=
      sqCXP.FieldByName('FP_TELEFONO').AsString;
    cdsOrdenesSeleccionadas.FieldByName('FP_EMAIL').AsString := EmailProveedor;
    cdsOrdenesSeleccionadas.Post;

    // Mensaje informativo
    if Trim(sqCXP.FieldByName('FP_EMAIL').AsString) = '' then
      ShowMessage('Orden agregada correctamente' + #13#10 +
                 'Nota: Se asignó email por defecto: ' + EMAIL_POR_DEFECTO)
    else
      ShowMessage('Orden agregada correctamente');

  except
    on E: Exception do
    begin
      cdsOrdenesSeleccionadas.Cancel;
      ShowMessage('Error al agregar orden: ' + E.Message);
    end;
  end;
end;

procedure TForm1.DBGridOrdenPagoDblClick(Sender: TObject);
begin
  AgregarOrdenAMemoria;
end;

procedure TForm1.btnCargarOrdenesPendientesClick(Sender: TObject);
begin
  CargarOrdenesPagoPendientes;
end;

procedure TForm1.btnVerDetalleClick(Sender: TObject);
var
  Documento: String;
begin
  if sqCXP.IsEmpty then
  begin
    ShowMessage('Seleccione una orden de pago');
    Exit;
  end;

  Documento := sqCXP.FieldByName('FOP_DOCUMENTO').AsString;
  TFormDetalleOrdenPago.MostrarDetalle(Documento);
end;

procedure TForm1.btnQuitarOrdenClick(Sender: TObject);
begin
  if cdsOrdenesSeleccionadas.IsEmpty then
  begin
    ShowMessage('No hay órdenes seleccionadas para quitar');
    Exit;
  end;

  if MessageDlg('¿Está seguro de quitar esta orden de la selección?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    cdsOrdenesSeleccionadas.Delete;
  end;
end;

procedure TForm1.btnProcesarClick(Sender: TObject);
var
  TotalMonto: Double;
  Contador: Integer;
  Generador: TGeneradorArchivoMercantil;
  RutaINI, RutaSalida: string;
  SaveDialog: TSaveDialog;
  BancoSeleccionado: Integer;
begin
  if cdsOrdenesSeleccionadas.IsEmpty then
  begin
    ShowMessage('No hay órdenes seleccionadas para procesar');
    Exit;
  end;

  // Calcular total
  TotalMonto := 0;
  Contador := 0;
  cdsOrdenesSeleccionadas.First;
  while not cdsOrdenesSeleccionadas.Eof do
  begin
    TotalMonto := TotalMonto + cdsOrdenesSeleccionadas.FieldByName('FOP_MONTO').AsFloat;
    Inc(Contador);
    cdsOrdenesSeleccionadas.Next;
  end;

  // Mostrar diálogo de selección de banco
  BancoSeleccionado := ShowBancoSelector;

  if BancoSeleccionado = 0 then
  begin
    ShowMessage('Debe seleccionar un banco para continuar');
    Exit;
  end;

  // Verificar si es diferente a Mercantil
  if BancoSeleccionado <> 1 then // 1 = Mercantil
  begin
    ShowMessage('Verificar Estructura' + #13#10 +
                'Error en Licencia.');
    Exit;
  end;

  // Procesar con Mercantil
  if MessageDlg(Format('¿Procesar %d órdenes de pago con BANCO MERCANTIL por un total de %s?',
                [Contador, FormatFloat('#,##0.00', TotalMonto)]),
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      // Ruta del archivo INI
      RutaINI := ExtractFilePath(Application.ExeName) + 'empresas.ini';

      if not FileExists(RutaINI) then
      begin
        ShowMessage('No se encuentra el archivo empresas.ini.' + #13#10 +
                   'Por favor créelo en: ' + RutaINI);
        Exit;
      end;

      // Diálogo para guardar archivo
      SaveDialog := TSaveDialog.Create(nil);
      try
        SaveDialog.Title := 'Guardar Archivo de Pago Mercantil';
        SaveDialog.Filter := 'Archivos de Texto (*.txt)|*.txt';
        SaveDialog.DefaultExt := 'txt';
        SaveDialog.FileName := 'PPR-LOTE-' + FormatDateTime('ddmmyyyyhhnnss', Now) + '.txt';
        SaveDialog.InitialDir := ExtractFilePath(Application.ExeName);

        if SaveDialog.Execute then
        begin
          RutaSalida := SaveDialog.FileName;

          // Generar archivo
          Generador := TGeneradorArchivoMercantil.Create(RutaINI, 'EMPRESA1');
          try
            if Generador.GenerarArchivoTXT(cdsOrdenesSeleccionadas, RutaSalida) then
            begin
              ShowMessage('Archivo Banco Mercantil generado exitosamente:' + #13#10 +
                         RutaSalida + #13#10#13#10 +
                         'Total Registros: ' + IntToStr(Contador) + #13#10 +
                         'Monto Total: ' + FormatFloat('#,##0.00', TotalMonto));

              // Limpiar tabla en memoria después de procesar
              cdsOrdenesSeleccionadas.EmptyDataSet;

              // Recargar órdenes pendientes
              CargarOrdenesPagoPendientes;
            end;
          finally
            Generador.Free;
          end;
        end;
      finally
        SaveDialog.Free;
      end;

    except
      on E: Exception do
        ShowMessage('Error al procesar: ' + E.Message);
    end;
  end;
end;

end.
