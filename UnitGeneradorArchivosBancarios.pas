unit UnitGeneradorArchivosBancarios;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, Datasnap.DBClient;

type
  TGeneradorArchivoMercantil = class
  private
    FRutaINI: string;
    FEmpresaSeccion: string;

    // Datos de la empresa desde INI
    FNombreEmpresa: string;
    FTipoRif: string;
    FRifNumero: string;
    FCuentaDebito: string;
    FCodigoSwift: string;

    function FormatearNumerico(const AValor: string; ALongitud: Integer): string;
    function FormatearAlfanumerico(const AValor: string; ALongitud: Integer): string;
    function FormatearMonto(AMonto: Double): string;
    function FormatearFecha(AFecha: TDateTime): string;
    function GenerarNumeroLote: string;
    function GenerarCabecera(ACantidadRegistros: Integer; AMontoTotal: Double;
                            AFechaValor: TDateTime; ANumeroLote: string): string;
    function GenerarDetalle(const ARifBeneficiario: string;
                           const ATipoRifBenef: string;
                           const ACuentaBeneficiario: string;
                           AMonto: Double;
                           const ANombreBeneficiario: string;
                           const AEmailBeneficiario: string;
                           const AConcepto: string;
                           ANumeroRecibo: Integer): string;
    procedure CargarDatosEmpresa;
  public
    constructor Create(const ARutaINI: string; const AEmpresaSeccion: string);
    function GenerarArchivoTXT(cdsOrdenes: TClientDataSet; const ARutaSalida: string): Boolean;
  end;

implementation

{ TGeneradorArchivoMercantil }

constructor TGeneradorArchivoMercantil.Create(const ARutaINI: string; const AEmpresaSeccion: string);
begin
  FRutaINI := ARutaINI;
  FEmpresaSeccion := AEmpresaSeccion;
  CargarDatosEmpresa;
end;

procedure TGeneradorArchivoMercantil.CargarDatosEmpresa;
var
  IniFile: TIniFile;
begin
  if not FileExists(FRutaINI) then
    raise Exception.Create('No se encuentra el archivo empresas.ini');

  IniFile := TIniFile.Create(FRutaINI);
  try
    FNombreEmpresa := IniFile.ReadString(FEmpresaSeccion, 'Nombre', '');
    FTipoRif := IniFile.ReadString(FEmpresaSeccion, 'TipoRif', 'J');
    FRifNumero := IniFile.ReadString(FEmpresaSeccion, 'RifNumero', '');
    FCuentaDebito := IniFile.ReadString(FEmpresaSeccion, 'CuentaDebito', '');
    FCodigoSwift := IniFile.ReadString(FEmpresaSeccion, 'CodigoSwift', 'BAMRVECA');

    if (FRifNumero = '') or (FCuentaDebito = '') then
      raise Exception.Create('Faltan datos de empresa en el archivo INI');
  finally
    IniFile.Free;
  end;
end;

function TGeneradorArchivoMercantil.FormatearNumerico(const AValor: string; ALongitud: Integer): string;
begin
  // Justificar a la derecha y rellenar con ceros a la izquierda
  Result := AValor;
  while Length(Result) < ALongitud do
    Result := '0' + Result;

  if Length(Result) > ALongitud then
    Result := Copy(Result, Length(Result) - ALongitud + 1, ALongitud);
end;

function TGeneradorArchivoMercantil.FormatearAlfanumerico(const AValor: string; ALongitud: Integer): string;
var
  i: Integer;
  Limpio: string;
begin
  // Eliminar caracteres especiales
  Limpio := '';
  for i := 1 to Length(AValor) do
  begin
    if not (AValor[i] in ['á','é','í','ó','ú','Á','É','Í','Ó','Ú','ñ','Ñ','¿','¡']) then
      Limpio := Limpio + AValor[i];
  end;

  // Justificar a la izquierda y rellenar con espacios a la derecha
  Result := Limpio;
  while Length(Result) < ALongitud do
    Result := Result + ' ';

  if Length(Result) > ALongitud then
    Result := Copy(Result, 1, ALongitud);
end;

function TGeneradorArchivoMercantil.FormatearMonto(AMonto: Double): string;
var
  MontoStr: string;
  Entero, Decimal: string;
  PosDecimal: Integer;
begin
  // Formato: 15 enteros + 2 decimales = 17 caracteres sin punto
  MontoStr := FormatFloat('0.00', AMonto);
  MontoStr := StringReplace(MontoStr, '.', '', [rfReplaceAll]);
  MontoStr := StringReplace(MontoStr, ',', '', [rfReplaceAll]);

  Result := FormatearNumerico(MontoStr, 17);
end;

function TGeneradorArchivoMercantil.FormatearFecha(AFecha: TDateTime): string;
begin
  // Formato AAAAMMDD
  Result := FormatDateTime('yyyymmdd', AFecha);
end;

function TGeneradorArchivoMercantil.GenerarNumeroLote: string;
begin
  // Generar número de lote único basado en fecha y hora
  Result := FormatDateTime('ddmmyyyyhhnnss', Now); // 14 caracteres
  Result := FormatearAlfanumerico(Result, 15);
end;

function TGeneradorArchivoMercantil.GenerarCabecera(ACantidadRegistros: Integer;
  AMontoTotal: Double; AFechaValor: TDateTime; ANumeroLote: string): string;
var
  Linea: string;
begin
  Linea := '';

  // 1. Tipo Registro (1)
  Linea := Linea + '1';

  // 2. Identificación del Banco (12) - BAMRVECA con espacios
  Linea := Linea + FormatearAlfanumerico(FCodigoSwift, 12);

  // 3. Número de lote (15)
  Linea := Linea + FormatearAlfanumerico(ANumeroLote, 15);

  // 4. Tipo de Producto (5) - "PROVE"
  Linea := Linea + 'PROVE';

  // 5. Tipo de Pago (10) - "0000000062"
  Linea := Linea + '0000000062';

  // 6. Tipo de Identificación (1) - J, V, G, E, P
  Linea := Linea + FTipoRif;

  // 7. Número de Identificación RIF (15)
  Linea := Linea + FormatearNumerico(FRifNumero, 15);

  // 8. Cantidad Total Registros de Detalle (8)
  Linea := Linea + FormatearNumerico(IntToStr(ACantidadRegistros), 8);

  // 9. Monto Total (17)
  Linea := Linea + FormatearMonto(AMontoTotal);

  // 10. Fecha Valor (8) - AAAAMMDD
  Linea := Linea + FormatearFecha(AFechaValor);

  // 11. Código Cuenta Cliente (20)
  Linea := Linea + FormatearNumerico(FCuentaDebito, 20);

  // 12. Área Reservada (7)
  Linea := Linea + FormatearNumerico('0', 7);

  // 13. Número Serial Nota Empresa (8)
  Linea := Linea + FormatearNumerico('0', 8);

  // 14. Código Respuesta (4) - Dato de salida
  Linea := Linea + FormatearNumerico('0', 4);

  // 15. Fecha proceso (8) - Dato de salida
  Linea := Linea + FormatearNumerico('0', 8);

  // 16. Área Reservada (261)
  Linea := Linea + FormatearNumerico('0', 261);

  Result := Linea;
end;

function TGeneradorArchivoMercantil.GenerarDetalle(const ARifBeneficiario: string;
  const ATipoRifBenef: string; const ACuentaBeneficiario: string; AMonto: Double;
  const ANombreBeneficiario: string; const AEmailBeneficiario: string;
  const AConcepto: string; ANumeroRecibo: Integer): string;
var
  Linea: string;
  RifLimpio: string;
begin
  Linea := '';

  // Limpiar RIF (solo números)
  RifLimpio := StringReplace(ARifBeneficiario, '-', '', [rfReplaceAll]);
  RifLimpio := StringReplace(RifLimpio, 'J', '', [rfReplaceAll]);
  RifLimpio := StringReplace(RifLimpio, 'V', '', [rfReplaceAll]);
  RifLimpio := StringReplace(RifLimpio, 'E', '', [rfReplaceAll]);
  RifLimpio := StringReplace(RifLimpio, 'G', '', [rfReplaceAll]);
  RifLimpio := StringReplace(RifLimpio, 'P', '', [rfReplaceAll]);

  // 1. Tipo Registro (1)
  Linea := Linea + '2';

  // 2. Tipo de Identificación (1)
  Linea := Linea + ATipoRifBenef;

  // 3. Número de Identificación (15)
  Linea := Linea + FormatearNumerico(RifLimpio, 15);

  // 4. Forma de Pago (1) - 1=Abono en cuenta
  Linea := Linea + '1';

  // 5. Área Reservada (12)
  Linea := Linea + FormatearNumerico('0', 12);

  // 6. Área reservada (15) - Espacios
  Linea := Linea + FormatearAlfanumerico('', 15);

  // 7. Área Reservada (15)
  Linea := Linea + FormatearNumerico('0', 15);

  // 8. Código Cuenta Beneficiario (20)
  Linea := Linea + FormatearNumerico(ACuentaBeneficiario, 20);

  // 9. Monto Operación (17)
  Linea := Linea + FormatearMonto(AMonto);

  // 10. Identificación Cliente Empresa (16)
  Linea := Linea + FormatearAlfanumerico('', 16);

  // 11. Tipo de Pago (10)
  Linea := Linea + '0000000062';

  // 12. Área reservada (3)
  Linea := Linea + FormatearNumerico('0', 3);

  // 13. Nombre del Proveedor (60)
  Linea := Linea + FormatearAlfanumerico(ANombreBeneficiario, 60);

  // 14. Área Reservada (7)
  Linea := Linea + FormatearNumerico('0', 7);

  // 15. Número de Recibo (8)
  Linea := Linea + FormatearNumerico(IntToStr(ANumeroRecibo), 8);

  // 16. E-mail del Cliente (50)
  Linea := Linea + FormatearAlfanumerico(AEmailBeneficiario, 50);

  // 17. Código Respuesta (4)
  Linea := Linea + FormatearNumerico('0', 4);

  // 18. Mensaje Respuesta (30)
  Linea := Linea + FormatearAlfanumerico('', 30);

  // 19. Concepto Pago (80)
  Linea := Linea + FormatearAlfanumerico(AConcepto, 80);

  // 20. Área Reservada (35)
  Linea := Linea + FormatearNumerico('0', 35);

  Result := Linea;
end;

function TGeneradorArchivoMercantil.GenerarArchivoTXT(cdsOrdenes: TClientDataSet;
  const ARutaSalida: string): Boolean;
var
  Archivo: TStringList;
  NumeroLote: string;
  CantidadRegistros: Integer;
  MontoTotal: Double;
  FechaValor: TDateTime;
  NumeroRecibo: Integer;
  TipoRifBenef: string;
begin
  Result := False;

  if cdsOrdenes.IsEmpty then
  begin
    raise Exception.Create('No hay órdenes para procesar');
  end;

  Archivo := TStringList.Create;
  try
    NumeroLote := GenerarNumeroLote;
    CantidadRegistros := 0;
    MontoTotal := 0;
    FechaValor := Date; // Puedes cambiarlo por otro
    NumeroRecibo := 1;

    // Calcular totales
    cdsOrdenes.First;
    while not cdsOrdenes.Eof do
    begin
      MontoTotal := MontoTotal + cdsOrdenes.FieldByName('FOP_MONTO').AsFloat;
      Inc(CantidadRegistros);
      cdsOrdenes.Next;
    end;

    // Generar cabecera
    Archivo.Add(GenerarCabecera(CantidadRegistros, MontoTotal, FechaValor, NumeroLote));

    // Generar detalles
    cdsOrdenes.First;
    while not cdsOrdenes.Eof do
    begin
      // Determinar tipo de RIF del beneficiario
      TipoRifBenef := 'J'; // Por defecto jurídico
      if cdsOrdenes.FieldByName('FP_RIF').AsString <> '' then
      begin
        if Pos('V-', cdsOrdenes.FieldByName('FP_RIF').AsString) > 0 then
          TipoRifBenef := 'V'
        else if Pos('E-', cdsOrdenes.FieldByName('FP_RIF').AsString) > 0 then
          TipoRifBenef := 'E'
        else if Pos('G-', cdsOrdenes.FieldByName('FP_RIF').AsString) > 0 then
          TipoRifBenef := 'G'
        else if Pos('P-', cdsOrdenes.FieldByName('FP_RIF').AsString) > 0 then
          TipoRifBenef := 'P';
      end;

      Archivo.Add(GenerarDetalle(
        cdsOrdenes.FieldByName('FP_RIF').AsString,
        TipoRifBenef,
        cdsOrdenes.FieldByName('CUENTA_PAGAR').AsString,
        cdsOrdenes.FieldByName('FOP_MONTO').AsFloat,
        cdsOrdenes.FieldByName('NOMBRE_PROVEEDOR').AsString,
        cdsOrdenes.FieldByName('FP_EMAIL').AsString,
        'pago', // Concepto - puedes personalizarlo
        NumeroRecibo
      ));

      Inc(NumeroRecibo);
      cdsOrdenes.Next;
    end;

    // Guardar archivo
    Archivo.SaveToFile(ARutaSalida, TEncoding.ASCII);
    Result := True;

  finally
    Archivo.Free;
  end;
end;

end.
