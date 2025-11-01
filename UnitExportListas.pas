unit UnitExportListas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Data.DB, dbisamtb, ComObj, Winapi.ActiveX;

type
  // Thread para Reporte de Inventario Inicio de Operaciones
  TReporteInventarioInicioThread = class(TThread)
  private
    FQuery: TDBISAMQuery;
    FMensaje: string;
    FError: Boolean;
    FMaxRetries: Integer;
    FRetryDelay: Integer;
    procedure ExportarInventarioInicioExcel;
    procedure MostrarMensaje;
    procedure WriteLog(const Msg: string);
    function TryCreateExcel(out ExcelApp: Variant): Boolean;
    procedure SafeCloseExcel(var ExcelApp, WorkBook: Variant);
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

  // Thread para Reporte de Ventas
  TReporteVentasThread = class(TThread)
  private
    FFechaInicio: TDateTime;
    FFechaFin: TDateTime;
    FQuery: TDBISAMQuery;
    FMensaje: string;
    FError: Boolean;
    FMaxRetries: Integer;
    FRetryDelay: Integer;
    procedure ExportarVentasExcel;
    procedure MostrarMensaje;
    function TryCreateExcel(out ExcelApp: Variant): Boolean;
    procedure SafeCloseExcel(var ExcelApp, WorkBook: Variant);
  protected
    procedure Execute; override;
  public
    constructor Create(AFechaInicio, AFechaFin: TDateTime; AQuery: TDBISAMQuery);
  end;

  // Thread para Reporte de Ventas con Cantidad Despachada
  TReporteVentasDespachadasThread = class(TThread)
  private
    FFechaInicio: TDateTime;
    FFechaFin: TDateTime;
    FQuery: TDBISAMQuery;
    FMensaje: string;
    FError: Boolean;
    FMaxRetries: Integer;
    FRetryDelay: Integer;
    procedure ExportarVentasDespachadasExcel;
    procedure MostrarMensaje;
    function TryCreateExcel(out ExcelApp: Variant): Boolean;
    procedure SafeCloseExcel(var ExcelApp, WorkBook: Variant);
  protected
    procedure Execute; override;
  public
    constructor Create(AFechaInicio, AFechaFin: TDateTime; AQuery: TDBISAMQuery);
  end;

  // Thread para Reporte de Compras
  TReporteComprasThread = class(TThread)
  private
    FFechaInicio: TDateTime;
    FFechaFin: TDateTime;
    FQuery: TDBISAMQuery;
    FMensaje: string;
    FError: Boolean;
    FMaxRetries: Integer;
    FRetryDelay: Integer;
    procedure ExportarComprasExcel;
    procedure MostrarMensaje;
    function TryCreateExcel(out ExcelApp: Variant): Boolean;
    procedure SafeCloseExcel(var ExcelApp, WorkBook: Variant);
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

  // Thread para Reporte de Inventario
  TReporteInventarioThread = class(TThread)
  private
    FQuery: TDBISAMQuery;
    FMensaje: string;
    FError: Boolean;
    FMaxRetries: Integer;
    FRetryDelay: Integer;
    procedure ExportarInventarioExcel;
    procedure MostrarMensaje;
    procedure WriteLog(const Msg: string);
    function TryCreateExcel(out ExcelApp: Variant): Boolean;
    procedure SafeCloseExcel(var ExcelApp, WorkBook: Variant);
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

  // Thread para Productos Vendidos
  TProductosVendidosThread = class(TThread)
  private
    FMensaje: string;
    procedure MostrarMensaje;
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

  TformExport = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    lbl1: TLabel;
    lbl2: TLabel;
    btnProcesar: TButton;
    rgReporte: TRadioGroup;
    sqProductosVendidos: TDBISAMQuery;
    procedure btnProcesarClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure EjecutarReporteVentas;
    procedure EjecutarReporteVentasDespachadas;
    procedure EjecutarReporteCompras;
    procedure EjecutarReporteInventario;
    procedure EjecutarProductosVendidos;
    procedure EjecutarReportesdelDia;
    procedure EjecutarReporteInventarioInicio;
  public
    { Public declarations }
  end;

var
  formExport: TformExport;

implementation

uses
  UnitDatos, UnitVariablesGlobales, unitVariables;

{$R *.dfm}

{ TReporteInventarioInicioThread }

// Constructor del Thread para Reporte de Inventario Inicio
constructor TReporteInventarioInicioThread.Create;
begin
  inherited Create(False);
  WriteLog('=== INICIO: Constructor TReporteInventarioInicioThread ===');

  // Tomar parámetros desde el formulario actual
  if Assigned(formExport) then
  begin
    WriteLog('formExport está asignado');
    FQuery := formExport.sqProductosVendidos;
    if not Assigned(FQuery) then
    begin
      WriteLog('ERROR: El componente sqProductosVendidos NO está asignado');
      raise Exception.Create('El componente sqProductosVendidos no está asignado');
    end;
    WriteLog('sqProductosVendidos está asignado correctamente');
  end
  else
  begin
    WriteLog('ERROR: El formulario formExport NO está asignado');
    raise Exception.Create('El formulario formExport no está asignado');
  end;

  FMaxRetries := 3;
  FRetryDelay := 2000; // 2 segundos
  FreeOnTerminate := True;
  WriteLog('Constructor completado exitosamente');
end;

// Implementación del Thread para Reporte de Inventario Inicio
procedure TReporteInventarioInicioThread.Execute;
begin
  WriteLog('=== INICIO: Execute (Inventario Inicio) ===');
  try
    try
      WriteLog('Llamando a ExportarInventarioInicioExcel...');
      ExportarInventarioInicioExcel;
      WriteLog('ExportarInventarioInicioExcel completado exitosamente');
      FMensaje := 'Reporte de Inventario Inicio exportado correctamente a Excel';
      FError := False;
    except
      on E: Exception do
      begin
        WriteLog('ERROR en Execute: ' + E.Message + ' - Clase: ' + E.ClassName);
        FMensaje := 'Error al exportar inventario inicio: ' + E.Message;
        FError := True;
      end;
    end;
  finally
    WriteLog('Llamando a Synchronize(MostrarMensaje)...');
    Synchronize(MostrarMensaje);
    WriteLog('=== FIN: Execute (Inventario Inicio) ===');
  end;
end;

procedure TReporteInventarioInicioThread.MostrarMensaje;
begin
  ShowMessage(FMensaje);
end;

// Método para escribir en el log
procedure TReporteInventarioInicioThread.WriteLog(const Msg: string);
var
  LogFile: TextFile;
  LogPath, LogFileName: string;
begin
  try
    LogPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
    if not DirectoryExists(LogPath) then
      ForceDirectories(LogPath);

    LogFileName := LogPath + 'LOG_INVENTARIO_INICIO_' + FormatDateTime('yyyymmdd', Now) + '.txt';

    AssignFile(LogFile, LogFileName);
    if FileExists(LogFileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    WriteLn(LogFile, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + Msg);
    CloseFile(LogFile);
  except
    // Si falla el log, no interrumpir el proceso
  end;
end;

// Función auxiliar para crear Excel con reintentos
function TReporteInventarioInicioThread.TryCreateExcel(out ExcelApp: Variant): Boolean;
var
  Attempt: Integer;
begin
  Result := False;
  ExcelApp := Unassigned;
  WriteLog('=== INICIO: TryCreateExcel ===');

  for Attempt := 1 to FMaxRetries do
  begin
    try
      WriteLog('Intento ' + IntToStr(Attempt) + ' de ' + IntToStr(FMaxRetries) + ' para crear Excel');
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;
      WriteLog('Excel creado exitosamente en intento ' + IntToStr(Attempt));
      Result := True;
      Break;
    except
      on E: Exception do
      begin
        WriteLog('ERROR en intento ' + IntToStr(Attempt) + ': ' + E.Message);
        if Attempt < FMaxRetries then
        begin
          WriteLog('Esperando ' + IntToStr(FRetryDelay) + 'ms antes del siguiente intento...');
          Sleep(FRetryDelay);
          Continue;
        end
        else
        begin
          WriteLog('FALLO FINAL: No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos');
          raise Exception.Create('No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos: ' + E.Message);
        end;
      end;
    end;
  end;
  WriteLog('=== FIN: TryCreateExcel - Result: ' + BoolToStr(Result, True) + ' ===');
end;

// Función auxiliar para cerrar Excel de forma segura
procedure TReporteInventarioInicioThread.SafeCloseExcel(var ExcelApp, WorkBook: Variant);
begin
  WriteLog('=== INICIO: SafeCloseExcel ===');
  try
    if not VarIsEmpty(WorkBook) and not VarIsNull(WorkBook) then
    begin
      try
        WriteLog('Cerrando WorkBook...');
        WorkBook.Close(False);
        WriteLog('WorkBook cerrado');
      except
        on E: Exception do
          WriteLog('Error al cerrar WorkBook (ignorado): ' + E.Message);
      end;
      WorkBook := Unassigned;
    end;
  except
    on E: Exception do
      WriteLog('Error general al cerrar WorkBook (ignorado): ' + E.Message);
  end;

  try
    if not VarIsEmpty(ExcelApp) and not VarIsNull(ExcelApp) then
    begin
      try
        WriteLog('Cerrando ExcelApp...');
        ExcelApp.DisplayAlerts := True;
        ExcelApp.Quit;
        WriteLog('ExcelApp cerrado');
      except
        on E: Exception do
          WriteLog('Error al cerrar ExcelApp (ignorado): ' + E.Message);
      end;
      ExcelApp := Unassigned;
    end;
  except
    on E: Exception do
      WriteLog('Error general al cerrar ExcelApp (ignorado): ' + E.Message);
  end;
  WriteLog('=== FIN: SafeCloseExcel ===');
end;

// Función para exportar inventario inicio a Excel
procedure TReporteInventarioInicioThread.ExportarInventarioInicioExcel;
var
  ExcelApp, WorkBook, WorkSheet: Variant;
  SQL: string;
  FileName: string;
  RecordCount: Integer;
  DataArray: Variant;
  i: Integer;
begin
  WriteLog('=== INICIO: ExportarInventarioInicioExcel ===');

  // Inicializar COM para este thread con apartamento STA
  WriteLog('Inicializando COM con apartamento STA...');
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  WriteLog('COM inicializado');

  try
    // Crear aplicación Excel con reintentos
    WriteLog('Creando aplicación Excel con reintentos...');
    if not TryCreateExcel(ExcelApp) then
      raise Exception.Create('No se pudo inicializar Excel');
    WriteLog('Excel creado exitosamente');

    try
      // Deshabilitar actualizaciones de pantalla para mejor rendimiento
      WriteLog('Deshabilitando actualizaciones de pantalla...');
      ExcelApp.ScreenUpdating := False;
      WriteLog('ScreenUpdating deshabilitado');

      // Crear nuevo libro
      WriteLog('Creando nuevo libro de Excel...');
      WorkBook := ExcelApp.Workbooks.Add;
      WorkSheet := WorkBook.Worksheets[1];
      WriteLog('Libro y hoja creados');

      // Configurar encabezados en mayúsculas
      WriteLog('Configurando encabezados...');
      WorkSheet.Cells[1, 1] := 'CODIGO';
      WorkSheet.Cells[1, 2] := 'DESCRIPCION';
      WorkSheet.Cells[1, 3] := 'CANTIDAD';
      WorkSheet.Cells[1, 4] := 'COSTO';
      WorkSheet.Cells[1, 5] := 'DEPOSITO';

      // Formatear encabezados
      WorkSheet.Range['A1:E1'].Font.Bold := True;
      WorkSheet.Range['A1:E1'].Interior.Color := RGB(200, 200, 200);

      // Formatear columna CODIGO como texto
      WorkSheet.Columns['A:A'].NumberFormat := '@';
      WriteLog('Encabezados configurados');

      // Construir consulta SQL
      SQL := 'SELECT S1.FDI_CODIGO, ' +
             'S2.FI_DESCRIPCION AS NOMBRE_PRODUCTO, ' +
             'S3.FIC_COSTOACTEXTRANJERO AS COSTO, ' +
             'S1.FDI_TIPOOPERACION, ' +
             'S2.FI_CATEGORIA, ' +
             'S1.FDI_FECHAOPERACION, ' +
             'S1.FDI_CANTIDAD, ' +
             'S1.FDI_MONEDA, ' +
             'S1.FDI_FACTORCAMBIO, ' +
             'S1.FDI_PRECIODEVENTA, ' +
             'S1.FDI_COSTODEVENTAS, ' +
             'S1.FDI_DOCUMENTO ' +
             'FROM SdetalleInv S1 ' +
             'INNER JOIN Sinventario S2 ON S1.FDI_CODIGO = S2.FI_CODIGO ' +
             'INNER JOIN a2InvCostosPrecios S3 ON S1.FDI_CODIGO = S3.FIC_CODEITEM ' +
             'WHERE S1.FDI_VISIBLE = 1 ' +
             'AND S1.FDI_TIPOOPERACION = 4 ' +
             'AND S1.FDI_DOCUMENTO IN (''00000003'', ''00000004'') ' +
             'ORDER BY S1.FDI_FECHAOPERACION DESC, S1.FDI_DOCUMENTO DESC';
      WriteLog('SQL construido: ' + SQL);

      // Ejecutar consulta
      WriteLog('Verificando FQuery...');
      if not Assigned(FQuery) then
        raise Exception.Create('No se encontró componente de consulta');

      WriteLog('Cerrando query anterior si existe...');
      FQuery.Close;
      WriteLog('Asignando SQL al query...');
      FQuery.SQL.Text := SQL;
      WriteLog('Configurando propiedades para consultas...');

      // Configurar propiedades para consultas en DBISAM
      if FQuery is TDBISAMQuery then
      begin
        with TDBISAMQuery(FQuery) do
        begin
          WriteLog('Configurando RequestLive := False para mejor rendimiento...');
          RequestLive := False;  // Solo lectura, más rápido
        end;
      end;

      WriteLog('Abriendo query...');
      FQuery.Open;
      WriteLog('Query abierto exitosamente');

      WriteLog('Verificando si hay registros...');
      if FQuery.Eof then
      begin
        WriteLog('WARNING: Query no retornó registros');
        FQuery.Close;
        raise Exception.Create('No se encontraron registros de inventario inicio para exportar');
      end;

      // Contar registros para dimensionar el array
      WriteLog('Contando registros...');
      FQuery.Last;
      RecordCount := FQuery.RecordCount;
      FQuery.First;
      WriteLog('Total de registros a exportar: ' + IntToStr(RecordCount));

      if RecordCount = 0 then
        raise Exception.Create('No se encontraron registros de inventario inicio para exportar');

      // Crear array de variantes [filas, columnas]
      WriteLog('Creando array de datos...');
      DataArray := VarArrayCreate([1, RecordCount, 1, 5], varVariant);

      // Llenar array con datos del query
      WriteLog('Llenando array con datos...');
      i := 1;
      while not FQuery.Eof do
      begin
        // Llenar array (mucho más rápido que escribir celda por celda)
        DataArray[i, 1] := '''' + UpperCase(FQuery.FieldByName('FDI_CODIGO').AsString);
        DataArray[i, 2] := UpperCase(FQuery.FieldByName('NOMBRE_PRODUCTO').AsString);
        DataArray[i, 3] := FQuery.FieldByName('FDI_CANTIDAD').AsFloat;
        DataArray[i, 4] := FQuery.FieldByName('COSTO').AsFloat;
        DataArray[i, 5] := '1';  // DEPOSITO fijo

        // Log cada 1000 registros para monitorear progreso
        if (i mod 1000) = 0 then
          WriteLog('Procesados ' + IntToStr(i) + ' registros en array...');

        Inc(i);
        FQuery.Next;
      end;

      FQuery.Close;
      WriteLog('Query cerrado');
      WriteLog('Array llenado con ' + IntToStr(RecordCount) + ' registros');

      // Escribir todo el array de una sola vez a Excel
      WriteLog('Escribiendo array completo a Excel...');
      WorkSheet.Range[WorkSheet.Cells[2, 1], WorkSheet.Cells[RecordCount + 1, 5]].Value := DataArray;
      WriteLog('Datos escritos exitosamente en Excel');

      // Reactivar actualizaciones antes de autoajustar
      WriteLog('Reactivando actualizaciones de pantalla...');
      ExcelApp.ScreenUpdating := True;
      WriteLog('ScreenUpdating reactivado');

      // Autoajustar columnas
      WriteLog('Autoajustando columnas...');
      WorkSheet.Columns.AutoFit;
      WriteLog('Columnas autoajustadas');

      // Crear carpeta EXPORTADO si no existe
      WriteLog('Verificando carpeta EXPORTADO...');
      var ExportPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
      if not DirectoryExists(ExportPath) then
      begin
        WriteLog('Creando carpeta EXPORTADO...');
        ForceDirectories(ExportPath);
        if not DirectoryExists(ExportPath) then
          raise Exception.Create('No se pudo crear la carpeta: ' + ExportPath);
      end;
      WriteLog('Carpeta EXPORTADO verificada: ' + ExportPath);

      // Guardar archivo en carpeta EXPORTADO
      FileName := ExportPath + NAME_EMPRESA + '_REPORTE_INVENTARIO_INICIO_' +
                  FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx';
      WriteLog('Nombre de archivo: ' + FileName);

      try
        WriteLog('Guardando archivo Excel...');
        WorkBook.SaveAs(FileName);
        WriteLog('Archivo guardado en Excel');

        // Verificar que el archivo se creó
        WriteLog('Verificando que el archivo existe...');
        if not FileExists(FileName) then
          raise Exception.Create('El archivo no se guardó correctamente: ' + FileName);

        WriteLog('Archivo verificado exitosamente');

      except
        on E: Exception do
        begin
          WriteLog('ERROR al guardar: ' + E.Message);
          raise Exception.Create('Error al guardar archivo Excel: ' + E.Message);
        end;
      end;

      FMensaje := 'Archivo guardado en: ' + FileName + ' (' + IntToStr(RecordCount) + ' registros)';
      WriteLog('FMensaje asignado: ' + FMensaje);

    finally
      // Cerrar Excel de forma segura
      SafeCloseExcel(ExcelApp, WorkBook);
    end;

  finally
    // Finalizar COM
    CoUninitialize;
  end;
end;

{ TReporteVentasThread }

// Constructor del Thread para Reporte de Ventas
constructor TReporteVentasThread.Create(AFechaInicio, AFechaFin: TDateTime; AQuery: TDBISAMQuery);
begin
  inherited Create(False);
  FFechaInicio := AFechaInicio;
  FFechaFin := AFechaFin;
  FQuery := AQuery;
  FMaxRetries := 3;
  FRetryDelay := 2000; // 2 segundos
  FreeOnTerminate := True;
end;

// Implementación del Thread para Reporte de Ventas
procedure TReporteVentasThread.Execute;
begin
  try
    ExportarVentasExcel;
    FMensaje := 'Reporte de Ventas exportado correctamente a Excel';
    FError := False;
  except
    on E: Exception do
    begin
      FMensaje := 'Error al exportar ventas: ' + E.Message;
      FError := True;
    end;
  end;

  Synchronize(MostrarMensaje);
end;

// Procedimiento para mostrar mensaje en el hilo principal
procedure TReporteVentasThread.MostrarMensaje;
begin
  ShowMessage(FMensaje);
end;

// Función auxiliar para crear Excel con reintentos
function TReporteVentasThread.TryCreateExcel(out ExcelApp: Variant): Boolean;
var
  Attempt: Integer;
begin
  Result := False;
  ExcelApp := Unassigned;

  for Attempt := 1 to FMaxRetries do
  begin
    try
      // Intentar crear Excel
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;
      Result := True;
      Break;
    except
      on E: Exception do
      begin
        if Attempt < FMaxRetries then
        begin
          Sleep(FRetryDelay);
          Continue;
        end
        else
          raise Exception.Create('No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos: ' + E.Message);
      end;
    end;
  end;
end;

// Función auxiliar para cerrar Excel de forma segura
procedure TReporteVentasThread.SafeCloseExcel(var ExcelApp, WorkBook: Variant);
begin
  try
    if not VarIsEmpty(WorkBook) and not VarIsNull(WorkBook) then
    begin
      try
        WorkBook.Close(False);
      except
        // Ignorar errores al cerrar el libro
      end;
      WorkBook := Unassigned;
    end;
  except
    // Ignorar errores
  end;

  try
    if not VarIsEmpty(ExcelApp) and not VarIsNull(ExcelApp) then
    begin
      try
        ExcelApp.DisplayAlerts := True;
        ExcelApp.Quit;
      except
        // Ignorar errores al cerrar Excel
      end;
      ExcelApp := Unassigned;
    end;
  except
    // Ignorar errores
  end;
end;

// Función para exportar ventas a Excel
procedure TReporteVentasThread.ExportarVentasExcel;
var
  ExcelApp, WorkBook, WorkSheet: Variant;
  SQL: string;
  Row: Integer;
  FileName: string;
  Cantidad, Monto, Costo: Double;
  TipoDoc: Integer;
  DataArray: Variant;
  RowCount, i: Integer;
begin
  // Inicializar COM para este thread con apartamento STA
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

  try
    // Crear aplicación Excel con reintentos
    if not TryCreateExcel(ExcelApp) then
      raise Exception.Create('No se pudo inicializar Excel');

  try
    // Deshabilitar actualizaciones de pantalla para mejor rendimiento con consultas largas
    ExcelApp.ScreenUpdating := False;

    // Crear nuevo libro
    WorkBook := ExcelApp.Workbooks.Add;
    WorkSheet := WorkBook.Worksheets[1];

    // Configurar encabezados en mayúsculas
    WorkSheet.Cells[1, 1] := 'CODIGO';
    WorkSheet.Cells[1, 2] := 'GRUPO_ID';
    WorkSheet.Cells[1, 3] := 'FECHA';
    WorkSheet.Cells[1, 4] := 'CANTIDAD';
    WorkSheet.Cells[1, 5] := 'MONEDA';
    WorkSheet.Cells[1, 6] := 'CAMBIO';
    WorkSheet.Cells[1, 7] := 'MONTO';
    WorkSheet.Cells[1, 8] := 'COSTO';
    WorkSheet.Cells[1, 9] := 'DOCUMENTO';
    WorkSheet.Cells[1, 10] := 'CLIENTE';
    WorkSheet.Cells[1, 11] := 'CORREO';
    WorkSheet.Cells[1, 12] := 'TELEF';
    WorkSheet.Cells[1, 13] := 'EMPRESA';
    WorkSheet.Cells[1, 14] := 'TIPO DOCUMENTO';

    // Formatear encabezados
    WorkSheet.Range['A1:N1'].Font.Bold := True;
    WorkSheet.Range['A1:N1'].Interior.Color := RGB(200, 200, 200);

    // Formatear columnas CODIGO y GRUPO_ID como texto
    WorkSheet.Columns['A:A'].NumberFormat := '@';  // Columna CODIGO como texto
    WorkSheet.Columns['B:B'].NumberFormat := '@';  // Columna GRUPO_ID como texto

    // Construir consulta SQL con filtros de fecha y tipos de documento
    // Construir consulta SQL con filtros de fecha y tipos de documento
SQL := 'SELECT S1.FDI_CODIGO, ' +
       'S2.FI_CATEGORIA, ' +
       'S1.FDI_FECHAOPERACION, ' +
       'S1.FDI_CANTIDAD, ' +
       'S1.FDI_MONEDA, ' +
       'S1.FDI_FACTORCAMBIO, ' +
       'S1.FDI_PRECIODEVENTA, ' +
       'S5.FIC_COSTOACTEXTRANJERO AS FDI_COSTODEVENTAS, ' +  // <- CAMBIO AQUÍ
       'S1.FDI_DOCUMENTO, ' +
       'S3.FTI_PERSONACONTACTO, ' +
       'S4.FC_EMAIL, ' +
       'S3.FTI_TELEFONOCONTACTO, ' +
       'S1.FDI_TIPOOPERACION ' +
       'FROM SDetalleVenta S1 ' +
       'INNER JOIN Sinventario S2 ON S1.FDI_CODIGO = S2.FI_CODIGO ' +
       'INNER JOIN SOperacionInv S3 ON S1.FDI_DOCUMENTO = S3.FTI_DOCUMENTO ' +
       'INNER JOIN Sclientes S4 ON S1.FDI_CLIENTEPROVEEDOR = S4.FC_CODIGO ' +
       'INNER JOIN a2InvCostosPrecios S5 ON S1.FDI_CODIGO = S5.FIC_CODEITEM ' +  // <- NUEVA LÍNEA
       'WHERE S1.FDI_VISIBLE = True ' +
       'AND S2.FI_STATUS = True ' +
       'AND S3.FTI_VISIBLE = True ' +
       'AND S4.FC_STATUS = True ' +
       'AND S1.FDI_TIPOOPERACION IN (11, 12) ' +
       'AND S1.FDI_FECHAOPERACION >= ''' + FormatDateTime('yyyy-mm-dd', FFechaInicio) + ''' ' +
       'AND S1.FDI_FECHAOPERACION <= ''' + FormatDateTime('yyyy-mm-dd', FFechaFin) + ''' ' +
       'ORDER BY S1.FDI_FECHAOPERACION DESC, S1.FDI_DOCUMENTO DESC';

    // Ejecutar consulta con configuración optimizada
    FQuery.Close;
    FQuery.SQL.Text := SQL;
    // Configurar propiedades para consultas largas en DBISAM
    if FQuery is TDBISAMQuery then
    begin
      with TDBISAMQuery(FQuery) do
      begin
        // Configurar para mejor rendimiento en consultas largas
        RequestLive := False;  // Solo lectura, más rápido
      end;
    end;
    FQuery.Open;

    // Contar registros para dimensionar el array
    FQuery.Last;
    RowCount := FQuery.RecordCount;
    FQuery.First;

    if RowCount = 0 then
      raise Exception.Create('No hay datos para exportar');

    // Crear array de variantes [filas, columnas]
    DataArray := VarArrayCreate([1, RowCount, 1, 14], varVariant);

    // Llenar array con datos del query
    i := 1;
    while not FQuery.Eof do
    begin
      TipoDoc := FQuery.FieldByName('FDI_TIPOOPERACION').AsInteger;
      Cantidad := FQuery.FieldByName('FDI_CANTIDAD').AsFloat;
      Monto := FQuery.FieldByName('FDI_PRECIODEVENTA').AsFloat;
      Costo := FQuery.FieldByName('FDI_COSTODEVENTAS').AsFloat;

      // Si es devolución (tipo 12), convertir a negativo
      if TipoDoc = 12 then
      begin
        Cantidad := -Abs(Cantidad);
        Monto := -Abs(Monto);
        Costo := -Abs(Costo);
      end;

      // Llenar array (mucho más rápido que escribir celda por celda)
      DataArray[i, 1] := '''' + UpperCase(FQuery.FieldByName('FDI_CODIGO').AsString);
      DataArray[i, 2] := '''' + UpperCase(FQuery.FieldByName('FI_CATEGORIA').AsString);
      DataArray[i, 3] := FQuery.FieldByName('FDI_FECHAOPERACION').AsDateTime;
      DataArray[i, 4] := Cantidad;
      DataArray[i, 5] := UpperCase(FQuery.FieldByName('FDI_MONEDA').AsString);
      DataArray[i, 6] := FQuery.FieldByName('FDI_FACTORCAMBIO').AsFloat;
      DataArray[i, 7] := Monto;
      DataArray[i, 8] := Costo;
      DataArray[i, 9] := FQuery.FieldByName('FDI_DOCUMENTO').AsString;
      DataArray[i, 10] := UpperCase(FQuery.FieldByName('FTI_PERSONACONTACTO').AsString);
      DataArray[i, 11] := UpperCase(FQuery.FieldByName('FC_EMAIL').AsString);
      DataArray[i, 12] := FQuery.FieldByName('FTI_TELEFONOCONTACTO').AsString;
      DataArray[i, 13] := NAME_EMPRESA;  // <- Variable dinámica

      // Determinar tipo de documento
      if TipoDoc = 11 then
        DataArray[i, 14] := 'FACTURA'
      else if TipoDoc = 12 then
        DataArray[i, 14] := 'N.C.'
      else
        DataArray[i, 14] := 'OTRO';

      Inc(i);
      FQuery.Next;
    end;

    FQuery.Close;

    // Escribir todo el array de una sola vez a Excel (1 sola llamada COM)
    WorkSheet.Range[WorkSheet.Cells[2, 1], WorkSheet.Cells[RowCount + 1, 14]].Value := DataArray;

    // Reactivar actualizaciones antes de autoajustar
    ExcelApp.ScreenUpdating := True;

    // Autoajustar columnas
    WorkSheet.Columns.AutoFit;

    // Crear carpeta EXPORTADO si no existe
    var ExportPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
    if not DirectoryExists(ExportPath) then
      ForceDirectories(ExportPath);

    // Guardar archivo en carpeta EXPORTADO con nombre dinámico
    FileName := ExportPath + NAME_EMPRESA + '_REPORTE_VENTAS_' +
                FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx';
    WorkBook.SaveAs(FileName);

    FMensaje := 'Archivo guardado en: ' + FileName;

  finally
    // Cerrar Excel de forma segura
    SafeCloseExcel(ExcelApp, WorkBook);
  end;

  finally
    // Finalizar COM
    CoUninitialize;
  end;
end;

{ TReporteVentasDespachadasThread }

// Constructor del Thread para Reporte de Ventas Despachadas
constructor TReporteVentasDespachadasThread.Create(AFechaInicio, AFechaFin: TDateTime; AQuery: TDBISAMQuery);
begin
  inherited Create(False);
  FFechaInicio := AFechaInicio;
  FFechaFin := AFechaFin;
  FQuery := AQuery;
  FMaxRetries := 3;
  FRetryDelay := 2000; // 2 segundos
  FreeOnTerminate := True;
end;

// Implementación del Thread para Reporte de Ventas Despachadas
procedure TReporteVentasDespachadasThread.Execute;
begin
  try
    ExportarVentasDespachadasExcel;
    FMensaje := 'Reporte de Ventas Despachadas exportado correctamente a Excel';
    FError := False;
  except
    on E: Exception do
    begin
      FMensaje := 'Error al exportar ventas despachadas: ' + E.Message;
      FError := True;
    end;
  end;

  Synchronize(MostrarMensaje);
end;

// Procedimiento para mostrar mensaje en el hilo principal
procedure TReporteVentasDespachadasThread.MostrarMensaje;
begin
  ShowMessage(FMensaje);
end;

// Función auxiliar para crear Excel con reintentos
function TReporteVentasDespachadasThread.TryCreateExcel(out ExcelApp: Variant): Boolean;
var
  Attempt: Integer;
begin
  Result := False;
  ExcelApp := Unassigned;

  for Attempt := 1 to FMaxRetries do
  begin
    try
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;
      Result := True;
      Break;
    except
      on E: Exception do
      begin
        if Attempt < FMaxRetries then
        begin
          Sleep(FRetryDelay);
          Continue;
        end
        else
          raise Exception.Create('No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos: ' + E.Message);
      end;
    end;
  end;
end;

// Función auxiliar para cerrar Excel de forma segura
procedure TReporteVentasDespachadasThread.SafeCloseExcel(var ExcelApp, WorkBook: Variant);
begin
  try
    if not VarIsEmpty(WorkBook) and not VarIsNull(WorkBook) then
    begin
      try
        WorkBook.Close(False);
      except
        // Ignorar errores al cerrar el libro
      end;
      WorkBook := Unassigned;
    end;
  except
    // Ignorar errores
  end;

  try
    if not VarIsEmpty(ExcelApp) and not VarIsNull(ExcelApp) then
    begin
      try
        ExcelApp.DisplayAlerts := True;
        ExcelApp.Quit;
      except
        // Ignorar errores al cerrar Excel
      end;
      ExcelApp := Unassigned;
    end;
  except
    // Ignorar errores
  end;
end;

// Función para exportar ventas despachadas a Excel
procedure TReporteVentasDespachadasThread.ExportarVentasDespachadasExcel;
var
  ExcelApp, WorkBook, WorkSheet: Variant;
  SQL: string;
  FileName: string;
  Cantidad, Monto, Costo, CantidadPendiente, CantidadDespachada: Double;
  TipoDoc: Integer;
  DataArray: Variant;
  RowCount, i: Integer;
begin
  // Inicializar COM para este thread con apartamento STA
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

  try
    // Crear aplicación Excel con reintentos
    if not TryCreateExcel(ExcelApp) then
      raise Exception.Create('No se pudo inicializar Excel');

    try
      // Deshabilitar actualizaciones de pantalla para mejor rendimiento
      ExcelApp.ScreenUpdating := False;

      // Crear nuevo libro
      WorkBook := ExcelApp.Workbooks.Add;
      WorkSheet := WorkBook.Worksheets[1];

      // Configurar encabezados en mayúsculas (15 columnas ahora)
      WorkSheet.Cells[1, 1] := 'CODIGO';
      WorkSheet.Cells[1, 2] := 'GRUPO_ID';
      WorkSheet.Cells[1, 3] := 'FECHA';
      WorkSheet.Cells[1, 4] := 'CANTIDAD';
      WorkSheet.Cells[1, 5] := 'CANTIDAD DESPACHADA';  // Nueva columna
      WorkSheet.Cells[1, 6] := 'MONEDA';
      WorkSheet.Cells[1, 7] := 'CAMBIO';
      WorkSheet.Cells[1, 8] := 'MONTO';
      WorkSheet.Cells[1, 9] := 'COSTO';
      WorkSheet.Cells[1, 10] := 'DOCUMENTO';
      WorkSheet.Cells[1, 11] := 'CLIENTE';
      WorkSheet.Cells[1, 12] := 'CORREO';
      WorkSheet.Cells[1, 13] := 'TELEF';
      WorkSheet.Cells[1, 14] := 'EMPRESA';
      WorkSheet.Cells[1, 15] := 'TIPO DOCUMENTO';

      // Formatear encabezados
      WorkSheet.Range['A1:O1'].Font.Bold := True;
      WorkSheet.Range['A1:O1'].Interior.Color := RGB(200, 200, 200);

      // Formatear columnas CODIGO y GRUPO_ID como texto
      WorkSheet.Columns['A:A'].NumberFormat := '@';  // Columna CODIGO como texto
      WorkSheet.Columns['B:B'].NumberFormat := '@';  // Columna GRUPO_ID como texto

      // Construir consulta SQL con filtros de fecha y tipos de documento
      SQL := 'SELECT S1.FDI_CODIGO, ' +
             'S2.FI_CATEGORIA, ' +
             'S1.FDI_FECHAOPERACION, ' +
             'S1.FDI_CANTIDAD, ' +
             'S1.FDI_CANTIDADPENDIENTE, ' +  // Agregar campo de cantidad pendiente
             'S1.FDI_MONEDA, ' +
             'S1.FDI_FACTORCAMBIO, ' +
             'S1.FDI_PRECIODEVENTA, ' +
             'S5.FIC_COSTOACTEXTRANJERO AS FDI_COSTODEVENTAS, ' +
             'S1.FDI_DOCUMENTO, ' +
             'S3.FTI_PERSONACONTACTO, ' +
             'S4.FC_EMAIL, ' +
             'S3.FTI_TELEFONOCONTACTO, ' +
             'S1.FDI_TIPOOPERACION ' +
             'FROM SDetalleVenta S1 ' +
             'INNER JOIN Sinventario S2 ON S1.FDI_CODIGO = S2.FI_CODIGO ' +
             'INNER JOIN SOperacionInv S3 ON S1.FDI_DOCUMENTO = S3.FTI_DOCUMENTO ' +
             'INNER JOIN Sclientes S4 ON S1.FDI_CLIENTEPROVEEDOR = S4.FC_CODIGO ' +
             'INNER JOIN a2InvCostosPrecios S5 ON S1.FDI_CODIGO = S5.FIC_CODEITEM ' +
             'WHERE S1.FDI_VISIBLE = True ' +
             'AND S2.FI_STATUS = True ' +
             'AND S3.FTI_VISIBLE = True ' +
             'AND S4.FC_STATUS = True ' +
             'AND S1.FDI_TIPOOPERACION IN (11, 12) ' +
             'AND S1.FDI_FECHAOPERACION >= ''' + FormatDateTime('yyyy-mm-dd', FFechaInicio) + ''' ' +
             'AND S1.FDI_FECHAOPERACION <= ''' + FormatDateTime('yyyy-mm-dd', FFechaFin) + ''' ' +
             'ORDER BY S1.FDI_FECHAOPERACION DESC, S1.FDI_DOCUMENTO DESC';

      // Ejecutar consulta con configuración optimizada
      FQuery.Close;
      FQuery.SQL.Text := SQL;

      if FQuery is TDBISAMQuery then
      begin
        with TDBISAMQuery(FQuery) do
        begin
          RequestLive := False;  // Solo lectura, más rápido
        end;
      end;
      FQuery.Open;

      // Contar registros para dimensionar el array
      FQuery.Last;
      RowCount := FQuery.RecordCount;
      FQuery.First;

      if RowCount = 0 then
        raise Exception.Create('No hay datos para exportar');

      // Crear array de variantes [filas, columnas] - ahora 15 columnas
      DataArray := VarArrayCreate([1, RowCount, 1, 15], varVariant);

      // Llenar array con datos del query
      i := 1;
      while not FQuery.Eof do
      begin
        TipoDoc := FQuery.FieldByName('FDI_TIPOOPERACION').AsInteger;
        Cantidad := FQuery.FieldByName('FDI_CANTIDAD').AsFloat;
        CantidadPendiente := FQuery.FieldByName('FDI_CANTIDADPENDIENTE').AsFloat;
        Monto := FQuery.FieldByName('FDI_PRECIODEVENTA').AsFloat;
        Costo := FQuery.FieldByName('FDI_COSTODEVENTAS').AsFloat;

        // Calcular cantidad despachada = cantidad - cantidad pendiente
        CantidadDespachada := Cantidad - CantidadPendiente;

        // Si es devolución (tipo 12), convertir a negativo
        if TipoDoc = 12 then
        begin
          Cantidad := -Abs(Cantidad);
          CantidadDespachada := -Abs(CantidadDespachada);
          Monto := -Abs(Monto);
          Costo := -Abs(Costo);
        end;

        // Llenar array (mucho más rápido que escribir celda por celda)
        DataArray[i, 1] := '''' + UpperCase(FQuery.FieldByName('FDI_CODIGO').AsString);
        DataArray[i, 2] := '''' + UpperCase(FQuery.FieldByName('FI_CATEGORIA').AsString);
        DataArray[i, 3] := FQuery.FieldByName('FDI_FECHAOPERACION').AsDateTime;
        DataArray[i, 4] := Cantidad;
        DataArray[i, 5] := CantidadDespachada;  // Nueva columna
        DataArray[i, 6] := UpperCase(FQuery.FieldByName('FDI_MONEDA').AsString);
        DataArray[i, 7] := FQuery.FieldByName('FDI_FACTORCAMBIO').AsFloat;
        DataArray[i, 8] := Monto;
        DataArray[i, 9] := Costo;
        DataArray[i, 10] := FQuery.FieldByName('FDI_DOCUMENTO').AsString;
        DataArray[i, 11] := UpperCase(FQuery.FieldByName('FTI_PERSONACONTACTO').AsString);
        DataArray[i, 12] := UpperCase(FQuery.FieldByName('FC_EMAIL').AsString);
        DataArray[i, 13] := FQuery.FieldByName('FTI_TELEFONOCONTACTO').AsString;
        DataArray[i, 14] := NAME_EMPRESA;  // <- Variable dinámica

        // Determinar tipo de documento
        if TipoDoc = 11 then
          DataArray[i, 15] := 'FACTURA'
        else if TipoDoc = 12 then
          DataArray[i, 15] := 'N.C.'
        else
          DataArray[i, 15] := 'OTRO';

        Inc(i);
        FQuery.Next;
      end;

      FQuery.Close;

      // Escribir todo el array de una sola vez a Excel (1 sola llamada COM)
      WorkSheet.Range[WorkSheet.Cells[2, 1], WorkSheet.Cells[RowCount + 1, 15]].Value := DataArray;

      // Reactivar actualizaciones antes de autoajustar
      ExcelApp.ScreenUpdating := True;

      // Autoajustar columnas
      WorkSheet.Columns.AutoFit;

      // Crear carpeta EXPORTADO si no existe
      var ExportPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
      if not DirectoryExists(ExportPath) then
        ForceDirectories(ExportPath);

      // Guardar archivo en carpeta EXPORTADO con nombre dinámico
      FileName := ExportPath + NAME_EMPRESA + '_REPORTE_VENTAS_DESPACHADAS_' +
                  FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx';
      WorkBook.SaveAs(FileName);

      FMensaje := 'Archivo guardado en: ' + FileName;

    finally
      // Cerrar Excel de forma segura
      SafeCloseExcel(ExcelApp, WorkBook);
    end;

  finally
    // Finalizar COM
    CoUninitialize;
  end;
end;

{ TReporteComprasThread }

// Constructor del Thread para Reporte de Compras
constructor TReporteComprasThread.Create;
begin
  inherited Create(False);
  // Tomar parámetros desde el formulario actual para mantener API sin cambios
  if Assigned(formExport) then
  begin
    FFechaInicio := formExport.dtp1.Date;
    FFechaFin := formExport.dtp2.Date;
    FQuery := formExport.sqProductosVendidos;
  end;
  FMaxRetries := 3;
  FRetryDelay := 2000; // 2 segundos
  FreeOnTerminate := True;
end;

// Implementación del Thread para Reporte de Compras
procedure TReporteComprasThread.Execute;
begin
  try
    ExportarComprasExcel;
    FMensaje := 'Reporte de Compras exportado correctamente a Excel';
    FError := False;
  except
    on E: Exception do
    begin
      FMensaje := 'Error al exportar compras: ' + E.Message;
      FError := True;
    end;
  end;

  Synchronize(MostrarMensaje);
end;

procedure TReporteComprasThread.MostrarMensaje;
begin
  ShowMessage(FMensaje);
end;

// Función auxiliar para crear Excel con reintentos
function TReporteComprasThread.TryCreateExcel(out ExcelApp: Variant): Boolean;
var
  Attempt: Integer;
begin
  Result := False;
  ExcelApp := Unassigned;

  for Attempt := 1 to FMaxRetries do
  begin
    try
      // Intentar crear Excel
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;
      Result := True;
      Break;
    except
      on E: Exception do
      begin
        if Attempt < FMaxRetries then
        begin
          Sleep(FRetryDelay);
          Continue;
        end
        else
          raise Exception.Create('No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos: ' + E.Message);
      end;
    end;
  end;
end;

// Función auxiliar para cerrar Excel de forma segura
procedure TReporteComprasThread.SafeCloseExcel(var ExcelApp, WorkBook: Variant);
begin
  try
    if not VarIsEmpty(WorkBook) and not VarIsNull(WorkBook) then
    begin
      try
        WorkBook.Close(False);
      except
        // Ignorar errores al cerrar el libro
      end;
      WorkBook := Unassigned;
    end;
  except
    // Ignorar errores
  end;

  try
    if not VarIsEmpty(ExcelApp) and not VarIsNull(ExcelApp) then
    begin
      try
        ExcelApp.DisplayAlerts := True;
        ExcelApp.Quit;
      except
        // Ignorar errores al cerrar Excel
      end;
      ExcelApp := Unassigned;
    end;
  except
    // Ignorar errores
  end;
end;

// Función para exportar compras a Excel
procedure TReporteComprasThread.ExportarComprasExcel;
var
  ExcelApp, WorkBook, WorkSheet: Variant;
  SQL: string;
  Row: Integer;
  FileName: string;
  Cantidad, Monto, Costo: Double;
  TipoDoc: Integer;
  DataArray: Variant;
  RowCount, i: Integer;
begin
  // Inicializar COM para este thread con apartamento STA
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

  try
    // Crear aplicación Excel con reintentos
    if not TryCreateExcel(ExcelApp) then
      raise Exception.Create('No se pudo inicializar Excel');

  try
    // Deshabilitar actualizaciones de pantalla para mejor rendimiento con consultas largas
    ExcelApp.ScreenUpdating := False;

    // Crear nuevo libro
    WorkBook := ExcelApp.Workbooks.Add;
    WorkSheet := WorkBook.Worksheets[1];

    // Configurar encabezados en mayúsculas
    WorkSheet.Cells[1, 1] := 'CODIGO';
    WorkSheet.Cells[1, 2] := 'GRUPO_ID';
    WorkSheet.Cells[1, 3] := 'FECHA';
    WorkSheet.Cells[1, 4] := 'CANTIDAD';
    WorkSheet.Cells[1, 5] := 'MONEDA';
    WorkSheet.Cells[1, 6] := 'CAMBIO';
    WorkSheet.Cells[1, 7] := 'MONTO';
    WorkSheet.Cells[1, 8] := 'COSTO';
    WorkSheet.Cells[1, 9] := 'DOCUMENTO';
    WorkSheet.Cells[1, 10] := 'CLIENTE';
    WorkSheet.Cells[1, 11] := 'CORREO';
    WorkSheet.Cells[1, 12] := 'TELEF';
    WorkSheet.Cells[1, 13] := 'EMPRESA';
    WorkSheet.Cells[1, 14] := 'TIPO DOCUMENTO';

    // Formatear encabezados
    WorkSheet.Range['A1:N1'].Font.Bold := True;
    WorkSheet.Range['A1:N1'].Interior.Color := RGB(200, 200, 200);

    // Formatear columnas CODIGO y GRUPO_ID como texto
    WorkSheet.Columns['A:A'].NumberFormat := '@';  // Columna CODIGO como texto
    WorkSheet.Columns['B:B'].NumberFormat := '@';  // Columna GRUPO_ID como texto

    // Construir consulta SQL con filtros de fecha y tipos de documento
    SQL := 'SELECT S1.FDI_CODIGO, ' +
           'S2.FI_CATEGORIA, ' +
           'S1.FDI_FECHAOPERACION, ' +
           'S1.FDI_CANTIDAD, ' +
           'S1.FDI_MONEDA, ' +
           'S1.FDI_FACTORCAMBIO, ' +
           'S1.FDI_PRECIODEVENTA, ' +
           'S1.FDI_COSTODEVENTAS, ' +
           'S1.FDI_DOCUMENTO, ' +
           'S3.FTI_PERSONACONTACTO, ' +
           'S4.FC_EMAIL, ' +
           'S3.FTI_TELEFONOCONTACTO, ' +
           'S1.FDI_TIPOOPERACION ' +
           'FROM SDetalleCompra S1 ' +
           'INNER JOIN Sinventario S2 ON S1.FDI_CODIGO = S2.FI_CODIGO ' +
           'INNER JOIN SOperacionInv S3 ON S1.FDI_DOCUMENTO = S3.FTI_DOCUMENTO ' +
           'INNER JOIN Sclientes S4 ON S1.FDI_CLIENTEPROVEEDOR = S4.FC_CODIGO ' +
           'WHERE S1.FDI_VISIBLE = True ' +
           'AND S2.FI_STATUS = True ' +
           'AND S3.FTI_VISIBLE = True ' +
           'AND S4.FC_STATUS = True ' +
           'AND S1.FDI_TIPOOPERACION IN (6, 6) ' +
           'AND S1.FDI_FECHAOPERACION >= ''' + FormatDateTime('yyyy-mm-dd', FFechaInicio) + ''' ' +
           'AND S1.FDI_FECHAOPERACION <= ''' + FormatDateTime('yyyy-mm-dd', FFechaFin) + ''' ' +
           'ORDER BY S1.FDI_FECHAOPERACION DESC, S1.FDI_DOCUMENTO DESC';

    // Ejecutar consulta con configuración optimizada
    if Assigned(FQuery) then
    begin
      FQuery.Close;
      FQuery.SQL.Text := SQL;
      // Configurar propiedades para consultas largas en DBISAM
      if FQuery is TDBISAMQuery then
      begin
        with TDBISAMQuery(FQuery) do
        begin
          // Configurar para mejor rendimiento en consultas largas
          RequestLive := False;  // Solo lectura, más rápido
        end;
      end;
      FQuery.Open;
    end
    else
      raise Exception.Create('No se encontró componente de consulta para ejecutar el reporte de compras');

    // Contar registros para dimensionar el array
    FQuery.Last;
    RowCount := FQuery.RecordCount;
    FQuery.First;

    if RowCount = 0 then
      raise Exception.Create('No hay datos para exportar');

    // Crear array de variantes [filas, columnas]
    DataArray := VarArrayCreate([1, RowCount, 1, 14], varVariant);

    // Llenar array con datos del query
    i := 1;
    while not FQuery.Eof do
    begin
      TipoDoc := FQuery.FieldByName('FDI_TIPOOPERACION').AsInteger;
      Cantidad := FQuery.FieldByName('FDI_CANTIDAD').AsFloat;
      Monto := FQuery.FieldByName('FDI_PRECIODEVENTA').AsFloat;
      Costo := FQuery.FieldByName('FDI_COSTODEVENTAS').AsFloat;

      // Si es devolución (tipo 12), convertir a negativo
      if TipoDoc = 12 then
      begin
        Cantidad := -Abs(Cantidad);
        Monto := -Abs(Monto);
        Costo := -Abs(Costo);
      end;

      // Llenar array (mucho más rápido que escribir celda por celda)
      DataArray[i, 1] := '''' + UpperCase(FQuery.FieldByName('FDI_CODIGO').AsString);
      DataArray[i, 2] := '''' + UpperCase(FQuery.FieldByName('FI_CATEGORIA').AsString);
      DataArray[i, 3] := FQuery.FieldByName('FDI_FECHAOPERACION').AsDateTime;
      DataArray[i, 4] := Cantidad;
      DataArray[i, 5] := UpperCase(FQuery.FieldByName('FDI_MONEDA').AsString);
      DataArray[i, 6] := FQuery.FieldByName('FDI_FACTORCAMBIO').AsFloat;
      DataArray[i, 7] := Monto;
      DataArray[i, 8] := Costo;
      DataArray[i, 9] := FQuery.FieldByName('FDI_DOCUMENTO').AsString;
      DataArray[i, 10] := UpperCase(FQuery.FieldByName('FTI_PERSONACONTACTO').AsString);
      DataArray[i, 11] := UpperCase(FQuery.FieldByName('FC_EMAIL').AsString);
      DataArray[i, 12] := FQuery.FieldByName('FTI_TELEFONOCONTACTO').AsString;
      DataArray[i, 13] := NAME_EMPRESA;  // <- Variable dinámica

      // Determinar tipo de documento
      if TipoDoc = 11 then
        DataArray[i, 14] := 'FACTURA'
      else if TipoDoc = 12 then
        DataArray[i, 14] := 'N.C.'
      else
        DataArray[i, 14] := 'OTRO';

      Inc(i);
      FQuery.Next;
    end;

    FQuery.Close;

    // Escribir todo el array de una sola vez a Excel (1 sola llamada COM)
    WorkSheet.Range[WorkSheet.Cells[2, 1], WorkSheet.Cells[RowCount + 1, 14]].Value := DataArray;

    // Reactivar actualizaciones antes de autoajustar
    ExcelApp.ScreenUpdating := True;

    // Autoajustar columnas
    WorkSheet.Columns.AutoFit;

    // Crear carpeta EXPORTADO si no existe
    var ExportPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
    if not DirectoryExists(ExportPath) then
      ForceDirectories(ExportPath);

    // Guardar archivo en carpeta EXPORTADO con nombre dinámico
    FileName := ExportPath + NAME_EMPRESA + '_REPORTE_COMPRAS_' +
                FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx';
    WorkBook.SaveAs(FileName);

    FMensaje := 'Archivo guardado en: ' + FileName;

  finally
    // Cerrar Excel de forma segura
    SafeCloseExcel(ExcelApp, WorkBook);
  end;

  finally
    // Finalizar COM
    CoUninitialize;
  end;
end;

{ TReporteInventarioThread }

// Constructor del Thread para Reporte de Inventario
constructor TReporteInventarioThread.Create;
begin
  inherited Create(False);
  WriteLog('=== INICIO: Constructor TReporteInventarioThread ===');

  // Tomar parámetros desde el formulario actual
  if Assigned(formExport) then
  begin
    WriteLog('formExport está asignado');
    FQuery := formExport.sqProductosVendidos;
    if not Assigned(FQuery) then
    begin
      WriteLog('ERROR: El componente sqProductosVendidos NO está asignado');
      raise Exception.Create('El componente sqProductosVendidos no está asignado');
    end;
    WriteLog('sqProductosVendidos está asignado correctamente');
  end
  else
  begin
    WriteLog('ERROR: El formulario formExport NO está asignado');
    raise Exception.Create('El formulario formExport no está asignado');
  end;

  FMaxRetries := 3;
  FRetryDelay := 2000; // 2 segundos
  FreeOnTerminate := True;
  WriteLog('Constructor completado exitosamente');
end;

// Implementación del Thread para Reporte de Inventario
procedure TReporteInventarioThread.Execute;
begin
  WriteLog('=== INICIO: Execute ===');
  try
    try
      WriteLog('Llamando a ExportarInventarioExcel...');
      ExportarInventarioExcel;
      WriteLog('ExportarInventarioExcel completado exitosamente');
      FMensaje := 'Reporte de Inventario exportado correctamente a Excel';
      FError := False;
    except
      on E: Exception do
      begin
        WriteLog('ERROR en Execute: ' + E.Message + ' - Clase: ' + E.ClassName);
        FMensaje := 'Error al exportar inventario: ' + E.Message + ' - Clase: ' + E.ClassName;
        FError := True;
      end;
    end;
  finally
    WriteLog('Llamando a Synchronize(MostrarMensaje)...');
    Synchronize(MostrarMensaje);
    WriteLog('=== FIN: Execute ===');
  end;
end;

procedure TReporteInventarioThread.MostrarMensaje;
begin
  ShowMessage(FMensaje);
end;

// Método para escribir en el log
procedure TReporteInventarioThread.WriteLog(const Msg: string);
var
  LogFile: TextFile;
  LogPath, LogFileName: string;
begin
  try
    LogPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
    if not DirectoryExists(LogPath) then
      ForceDirectories(LogPath);

    LogFileName := LogPath + 'LOG_INVENTARIO_' + FormatDateTime('yyyymmdd', Now) + '.txt';

    AssignFile(LogFile, LogFileName);
    if FileExists(LogFileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    WriteLn(LogFile, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + Msg);
    CloseFile(LogFile);
  except
    // Si falla el log, no interrumpir el proceso
  end;
end;

// Función auxiliar para crear Excel con reintentos
function TReporteInventarioThread.TryCreateExcel(out ExcelApp: Variant): Boolean;
var
  Attempt: Integer;
begin
  Result := False;
  ExcelApp := Unassigned;
  WriteLog('=== INICIO: TryCreateExcel ===');

  for Attempt := 1 to FMaxRetries do
  begin
    try
      WriteLog('Intento ' + IntToStr(Attempt) + ' de ' + IntToStr(FMaxRetries) + ' para crear Excel');
      // Intentar crear Excel
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;
      WriteLog('Excel creado exitosamente en intento ' + IntToStr(Attempt));
      Result := True;
      Break;
    except
      on E: Exception do
      begin
        WriteLog('ERROR en intento ' + IntToStr(Attempt) + ': ' + E.Message);
        if Attempt < FMaxRetries then
        begin
          WriteLog('Esperando ' + IntToStr(FRetryDelay) + 'ms antes del siguiente intento...');
          Sleep(FRetryDelay);
          Continue;
        end
        else
        begin
          WriteLog('FALLO FINAL: No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos');
          raise Exception.Create('No se pudo crear Excel después de ' + IntToStr(FMaxRetries) + ' intentos: ' + E.Message);
        end;
      end;
    end;
  end;
  WriteLog('=== FIN: TryCreateExcel - Result: ' + BoolToStr(Result, True) + ' ===');
end;

// Función auxiliar para cerrar Excel de forma segura
procedure TReporteInventarioThread.SafeCloseExcel(var ExcelApp, WorkBook: Variant);
begin
  WriteLog('=== INICIO: SafeCloseExcel ===');
  try
    if not VarIsEmpty(WorkBook) and not VarIsNull(WorkBook) then
    begin
      try
        WriteLog('Cerrando WorkBook...');
        WorkBook.Close(False);
        WriteLog('WorkBook cerrado');
      except
        on E: Exception do
          WriteLog('Error al cerrar WorkBook (ignorado): ' + E.Message);
      end;
      WorkBook := Unassigned;
    end;
  except
    on E: Exception do
      WriteLog('Error general al cerrar WorkBook (ignorado): ' + E.Message);
  end;

  try
    if not VarIsEmpty(ExcelApp) and not VarIsNull(ExcelApp) then
    begin
      try
        WriteLog('Cerrando ExcelApp...');
        ExcelApp.DisplayAlerts := True;
        ExcelApp.Quit;
        WriteLog('ExcelApp cerrado');
      except
        on E: Exception do
          WriteLog('Error al cerrar ExcelApp (ignorado): ' + E.Message);
      end;
      ExcelApp := Unassigned;
    end;
  except
    on E: Exception do
      WriteLog('Error general al cerrar ExcelApp (ignorado): ' + E.Message);
  end;
  WriteLog('=== FIN: SafeCloseExcel ===');
end;

// Función para exportar inventario a Excel
procedure TReporteInventarioThread.ExportarInventarioExcel;
var
  ExcelApp, WorkBook, WorkSheet: Variant;
  SQL: string;
  Row: Integer;
  FileName: string;
  RecordCount: Integer;
  DataArray: Variant;
  i: Integer;
begin
  WriteLog('=== INICIO: ExportarInventarioExcel ===');

  // Inicializar COM para este thread con apartamento STA
  WriteLog('Inicializando COM con apartamento STA...');
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  WriteLog('COM inicializado');

  try
    // Crear aplicación Excel con reintentos
    WriteLog('Creando aplicación Excel con reintentos...');
    if not TryCreateExcel(ExcelApp) then
      raise Exception.Create('No se pudo inicializar Excel');
    WriteLog('Excel creado exitosamente');

  try
    // Deshabilitar actualizaciones de pantalla para mejor rendimiento con consultas largas
    WriteLog('Deshabilitando actualizaciones de pantalla...');
    ExcelApp.ScreenUpdating := False;
    WriteLog('ScreenUpdating deshabilitado');

    // Crear nuevo libro
    WriteLog('Creando nuevo libro de Excel...');
    WorkBook := ExcelApp.Workbooks.Add;
    WorkSheet := WorkBook.Worksheets[1];
    WriteLog('Libro y hoja creados');

    // Configurar encabezados en mayúsculas
    WriteLog('Configurando encabezados...');
    WorkSheet.Cells[1, 1] := 'CODIGO';
    WorkSheet.Cells[1, 2] := 'DESCRIPCION';
    WorkSheet.Cells[1, 3] := 'CANTIDAD';
    WorkSheet.Cells[1, 4] := 'COSTO';
    WorkSheet.Cells[1, 5] := 'DEPOSITO';

    // Formatear encabezados
    WorkSheet.Range['A1:E1'].Font.Bold := True;
    WorkSheet.Range['A1:E1'].Interior.Color := RGB(200, 200, 200);

    // Formatear columna CODIGO como texto
    WorkSheet.Columns['A:A'].NumberFormat := '@';
    WriteLog('Encabezados configurados');

    // Construir consulta SQL
    SQL := 'SELECT S1.FT_CODIGOPRODUCTO, ' +
           'S1.FT_CODIGODEPOSITO, ' +
           'S1.FT_EXISTENCIA, ' +
           'S2.FI_DESCRIPCION AS NOMBRE_PRODUCTO, ' +
           'S3.FIC_COSTOACTEXTRANJERO AS COSTO ' +
           'FROM SInvDep S1 ' +
           'INNER JOIN SInventario S2 ON S1.FT_CODIGOPRODUCTO = S2.FI_CODIGO ' +
           'INNER JOIN a2InvCostosPrecios S3 ON S1.FT_CODIGOPRODUCTO = S3.FIC_CODEITEM ' +
           'ORDER BY S1.FT_CODIGOPRODUCTO';
    WriteLog('SQL construido: ' + SQL);

    // Ejecutar consulta
    WriteLog('Verificando FQuery...');
    if not Assigned(FQuery) then
      raise Exception.Create('No se encontró componente de consulta para ejecutar el reporte de inventario');

    WriteLog('Cerrando query anterior si existe...');
    FQuery.Close;
    WriteLog('Asignando SQL al query...');
    FQuery.SQL.Text := SQL;
    WriteLog('Configurando propiedades para consultas largas...');
    // Configurar propiedades para consultas largas en DBISAM
    if FQuery is TDBISAMQuery then
    begin
      with TDBISAMQuery(FQuery) do
      begin
        WriteLog('Configurando RequestLive := False para mejor rendimiento...');
        RequestLive := False;  // Solo lectura, más rápido
      end;
    end;
    WriteLog('Abriendo query...');

    FQuery.Open;
    WriteLog('Query abierto exitosamente');

    WriteLog('Verificando si hay registros...');
    if FQuery.Eof then
    begin
      WriteLog('WARNING: Query no retornó registros');
      FQuery.Close;
      raise Exception.Create('No se encontraron registros de inventario para exportar');
    end;

    // Contar registros para dimensionar el array
    WriteLog('Contando registros...');
    FQuery.Last;
    RecordCount := FQuery.RecordCount;
    FQuery.First;
    WriteLog('Total de registros a exportar: ' + IntToStr(RecordCount));

    if RecordCount = 0 then
      raise Exception.Create('No se encontraron registros de inventario para exportar');

    // Crear array de variantes [filas, columnas]
    WriteLog('Creando array de datos...');
    DataArray := VarArrayCreate([1, RecordCount, 1, 5], varVariant);

    // Llenar array con datos del query
    WriteLog('Llenando array con datos...');
    i := 1;
    while not FQuery.Eof do
    begin
      // Llenar array (mucho más rápido que escribir celda por celda)
      DataArray[i, 1] := '''' + UpperCase(FQuery.FieldByName('FT_CODIGOPRODUCTO').AsString);
      DataArray[i, 2] := UpperCase(FQuery.FieldByName('NOMBRE_PRODUCTO').AsString);
      DataArray[i, 3] := FQuery.FieldByName('FT_EXISTENCIA').AsFloat;
      DataArray[i, 4] := FQuery.FieldByName('COSTO').AsFloat;
      DataArray[i, 5] := UpperCase(FQuery.FieldByName('FT_CODIGODEPOSITO').AsString);

      // Log cada 1000 registros para monitorear progreso (solo para llenar array)
      if (i mod 1000) = 0 then
        WriteLog('Procesados ' + IntToStr(i) + ' registros en array...');

      Inc(i);
      FQuery.Next;
    end;

    FQuery.Close;
    WriteLog('Query cerrado');
    WriteLog('Array llenado con ' + IntToStr(RecordCount) + ' registros');

    // Escribir todo el array de una sola vez a Excel (1 sola llamada COM)
    WriteLog('Escribiendo array completo a Excel...');
    WorkSheet.Range[WorkSheet.Cells[2, 1], WorkSheet.Cells[RecordCount + 1, 5]].Value := DataArray;
    WriteLog('Datos escritos exitosamente en Excel');

    // Reactivar actualizaciones antes de autoajustar
    WriteLog('Reactivando actualizaciones de pantalla...');
    ExcelApp.ScreenUpdating := True;
    WriteLog('ScreenUpdating reactivado');

    // Autoajustar columnas
    WriteLog('Autoajustando columnas...');
    WorkSheet.Columns.AutoFit;
    WriteLog('Columnas autoajustadas');

    // Crear carpeta EXPORTADO si no existe
    WriteLog('Verificando carpeta EXPORTADO...');
    var ExportPath := ExtractFilePath(Application.ExeName) + 'EXPORTADO\';
    if not DirectoryExists(ExportPath) then
    begin
      WriteLog('Creando carpeta EXPORTADO...');
      ForceDirectories(ExportPath);
      if not DirectoryExists(ExportPath) then
        raise Exception.Create('No se pudo crear la carpeta: ' + ExportPath);
    end;
    WriteLog('Carpeta EXPORTADO verificada: ' + ExportPath);

    // Guardar archivo en carpeta EXPORTADO con nombre dinámico
    FileName := ExportPath + NAME_EMPRESA + '_REPORTE_INVENTARIO_' +
                FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx';
    WriteLog('Nombre de archivo: ' + FileName);

    try
      WriteLog('Guardando archivo Excel...');
      WorkBook.SaveAs(FileName);
      WriteLog('Archivo guardado en Excel');

      // Verificar que el archivo se creó
      WriteLog('Verificando que el archivo existe...');
      if not FileExists(FileName) then
        raise Exception.Create('El archivo no se guardó correctamente: ' + FileName);

      WriteLog('Archivo verificado exitosamente');

    except
      on E: Exception do
      begin
        WriteLog('ERROR al guardar: ' + E.Message);
        raise Exception.Create('Error al guardar archivo Excel: ' + E.Message);
      end;
    end;

    FMensaje := 'Archivo guardado en: ' + FileName + ' (' + IntToStr(RecordCount) + ' registros)';
    WriteLog('FMensaje asignado: ' + FMensaje);

  finally
    // Cerrar Excel de forma segura
    SafeCloseExcel(ExcelApp, WorkBook);
  end;

  finally
    // Finalizar COM
    CoUninitialize;
  end;
end;

{ TProductosVendidosThread }

// Constructor del Thread para Productos Vendidos
constructor TProductosVendidosThread.Create;
begin
  inherited Create(False);
  FreeOnTerminate := True;
end;

// Implementación del Thread para Productos Vendidos
procedure TProductosVendidosThread.Execute;
begin
  // Simular procesamiento
  Sleep(1500);
  FMensaje := 'Productos Vendidos ejecutado correctamente desde Thread';
  Synchronize(MostrarMensaje);
end;

procedure TProductosVendidosThread.MostrarMensaje;
begin
  ShowMessage(FMensaje);
end;

{ TformExport }

// Función para ejecutar Reporte de Ventas
procedure TformExport.EjecutarReporteVentas;
var
  Thread: TReporteVentasThread;
begin
  if dtp1.Date > dtp2.Date then
  begin
    ShowMessage('La fecha inicial no puede ser mayor que la fecha final');
    Exit;
  end;

  Thread := TReporteVentasThread.Create(dtp1.Date, dtp2.Date, sqProductosVendidos);
end;

// Función para ejecutar Reporte de Ventas Despachadas
procedure TformExport.EjecutarReporteVentasDespachadas;
var
  Thread: TReporteVentasDespachadasThread;
begin
  if dtp1.Date > dtp2.Date then
  begin
    ShowMessage('La fecha inicial no puede ser mayor que la fecha final');
    Exit;
  end;

  Thread := TReporteVentasDespachadasThread.Create(dtp1.Date, dtp2.Date, sqProductosVendidos);
end;

// Función para ejecutar Reporte de Compras
procedure TformExport.EjecutarReporteCompras;
var
  Thread: TReporteComprasThread;
begin
  Thread := TReporteComprasThread.Create;
end;

// Función para ejecutar Reporte de Inventario
procedure TformExport.EjecutarReporteInventario;
var
  Thread: TReporteInventarioThread;
begin
  try
    Thread := TReporteInventarioThread.Create;
  except
    on E: Exception do
      ShowMessage('Error al crear thread de inventario: ' + E.Message);
  end;
end;

// Función para ejecutar Reporte de Inventario Inicio
procedure TformExport.EjecutarReporteInventarioInicio;
var
  Thread: TReporteInventarioInicioThread;
begin
  try
    Thread := TReporteInventarioInicioThread.Create;
  except
    on E: Exception do
      ShowMessage('Error al crear thread de inventario inicio: ' + E.Message);
  end;
end;

// Función para ejecutar Productos Vendidos
procedure TformExport.EjecutarProductosVendidos;
var
  Thread: TProductosVendidosThread;
begin
  Thread := TProductosVendidosThread.Create;
end;

// Función para ejecutar Reportes del Día (Ventas, Compras e Inventario)
procedure TformExport.EjecutarReportesdelDia;
begin
  // Validar fechas antes de ejecutar
  if dtp1.Date > dtp2.Date then
  begin
    ShowMessage('La fecha inicial no puede ser mayor que la fecha final');
    Exit;
  end;

  // Deshabilitar el botón para evitar múltiples ejecuciones
  btnProcesar.Enabled := False;

  // Mostrar mensaje de inicio
  ShowMessage('Se generarán 3 reportes: Ventas, Compras e Inventario. Este proceso puede tardar unos minutos.');

  // Ejecutar los tres reportes
  try
    // 1. Reporte de Ventas
    EjecutarReporteVentas;
    Application.ProcessMessages;

    // Esperar 3 segundos para que el thread de ventas termine de inicializar y usar el query
    Sleep(5000);
    Application.ProcessMessages;

    // 2. Reporte de Compras
    EjecutarReporteCompras;
    Application.ProcessMessages;

    // Esperar 3 segundos para que el thread de compras termine de inicializar y usar el query
    Sleep(5000);
    Application.ProcessMessages;

    // 3. Reporte de Inventario
    EjecutarReporteInventario;
    Application.ProcessMessages;

    // Esperar 2 segundos antes de habilitar el botón nuevamente
    Sleep(5000);

    // Mensaje informativo
  //  ShowMessage('Los 3 reportes se están generando. Recibirá una notificación cuando cada uno termine.');
  except
    on E: Exception do
      ShowMessage('Error al ejecutar reportes del día: ' + E.Message);
  end;

  // Habilitar el botón nuevamente
  btnProcesar.Enabled := True;
end;

procedure TformExport.FormShow(Sender: TObject);
var
  Year, Month, Day: Word;
begin
   // Obtener el año y mes actual
   DecodeDate(Now, Year, Month, Day);
   // dtp1 = Primer día del mes actual
   dtp1.Date := EncodeDate(Year, Month, 1);
   // dtp2 = Día de hoy
   dtp2.Date := Now;
end;

procedure TformExport.FormStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin

end;

// Event handler para el botón procesar
procedure TformExport.btnProcesarClick(Sender: TObject);
begin
  case rgReporte.ItemIndex of
    0: EjecutarReporteVentas;
    1: EjecutarReporteCompras;
    2: EjecutarReporteInventario;
    3: EjecutarReportesdelDia;
    4: EjecutarReporteVentasDespachadas;  // Reporte de Ventas Despachadas
  else
    ShowMessage('Seleccione un tipo de reporte');
  end;
end;

end.
