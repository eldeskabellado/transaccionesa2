unit ConfigHeader;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils, ConfigEncryption;

type
  // Registro para información de la aplicación
  TAppInfo = record
    Empresa: string;
    Serial: string;
    NombreApp: string;
    AppId: string;        // Nuevo: ID único de la aplicación
    Version: string;
    CreatedBy: string;
    CreatedAt: string;
  end;

  // Registro para configuración completa
  TEvolutionConfigData = record
    AppInfo: TAppInfo;
    ApiUrl: string;
    ApiKey: string;
    InstanceId: string;
    Timeout: Integer;
    Description: string;
    ConfigLoaded: Boolean;
  end;

// Variables globales para la configuración
var
  G_ConfigData: TEvolutionConfigData;

// Funciones principales
function LeerConfiguracionCompleta(const ARutaArchivo: string): Boolean; overload;
function LeerConfiguracionCompleta(const ARutaArchivo: string; const APassword: string): Boolean; overload;
function ValidarConfiguracionCompleta: Boolean;
function ObtenerInfoApp: TAppInfo;
function ObtenerConfiguracionAPI: string; // Retorna resumen de la config
procedure LimpiarConfiguracionCompleta;
function EsConfiguracionValida: Boolean;

// Funciones de utilidad
function GenerarCabeceraEstandar(const AEmpresa, ASerial, ANombreApp: string): TJSONObject;
function ExtraerCabeceraDeJSON(const AJSONContent: string): TAppInfo;

// Nuevas funciones de validación
function ValidarAppIdYVersion(const AAppId, AVersion: string): Boolean;
function CargarAplicacionesPermitidas(const ARutaJSON: string): TJSONArray;
function ValidarAplicacionContraJSON(const AAppId, AVersion: string; const ARutaJSON: string): Boolean;

implementation

uses
  Vcl.Dialogs;

// Declaraciones forward
function ProcesarJSONConfiguracion(const AJSONContent: string): Boolean; forward;
function EsArchivoEncriptado(const ARutaArchivo: string): Boolean; forward;

function LeerConfiguracionCompleta(const ARutaArchivo: string): Boolean;
var
  ContenidoJSON: string;
  ArchivoEncriptado: Boolean;
begin
  Result := False;
  
  try
    if not TFile.Exists(ARutaArchivo) then
    begin
      ShowMessage('Error: Archivo de configuración no encontrado: ' + ARutaArchivo);
      Exit;
    end;

    // Detectar si es archivo encriptado
    ArchivoEncriptado := EsArchivoEncriptado(ARutaArchivo);
    
    if ArchivoEncriptado then
    begin
      ShowMessage('El archivo está encriptado. Use LeerConfiguracionCompleta(ruta, password)');
      Exit;
    end
    else
    begin
      // Leer archivo JSON plano
      ContenidoJSON := TFile.ReadAllText(ARutaArchivo, TEncoding.UTF8);
      Result := ProcesarJSONConfiguracion(ContenidoJSON);
    end;
    
  except
    on E: Exception do
    begin
      ShowMessage('Error leyendo configuración: ' + E.Message);
      LimpiarConfiguracionCompleta;
    end;
  end;
end;

function LeerConfiguracionCompleta(const ARutaArchivo: string; const APassword: string): Boolean;
var
  ContenidoJSON: string;
begin
  Result := False;
  
  try
    if not TFile.Exists(ARutaArchivo) then
    begin
      ShowMessage('Error: Archivo de configuración no encontrado: ' + ARutaArchivo);
      Exit;
    end;

    // Desencriptar archivo
    ContenidoJSON := TConfigEncryption.DecryptConfigFile(ARutaArchivo, APassword);
    
    if ContenidoJSON = '' then
    begin
      ShowMessage('Error: No se pudo desencriptar el archivo. Verifique la contraseña.');
      Exit;
    end;

    Result := ProcesarJSONConfiguracion(ContenidoJSON);
    
  except
    on E: Exception do
    begin
      ShowMessage('Error leyendo configuración encriptada: ' + E.Message);
      LimpiarConfiguracionCompleta;
    end;
  end;
end;

function ProcesarJSONConfiguracion(const AJSONContent: string): Boolean;
var
  JSONObj: TJSONObject;
  AppInfoObj: TJSONObject;
begin
  Result := False;
  
  try
    JSONObj := TJSONObject.ParseJSONValue(AJSONContent) as TJSONObject;
    
    if not Assigned(JSONObj) then
    begin
      ShowMessage('Error: El contenido no es un JSON válido');
      Exit;
    end;

    try
      // Limpiar configuración anterior
      LimpiarConfiguracionCompleta;
      
      // Extraer información de la aplicación
      if JSONObj.TryGetValue<TJSONObject>('appInfo', AppInfoObj) then
      begin
        AppInfoObj.TryGetValue<string>('empresa', G_ConfigData.AppInfo.Empresa);
        AppInfoObj.TryGetValue<string>('serial', G_ConfigData.AppInfo.Serial);
        AppInfoObj.TryGetValue<string>('nombreApp', G_ConfigData.AppInfo.NombreApp);
        AppInfoObj.TryGetValue<string>('appId', G_ConfigData.AppInfo.AppId);
        AppInfoObj.TryGetValue<string>('version', G_ConfigData.AppInfo.Version);
        AppInfoObj.TryGetValue<string>('createdBy', G_ConfigData.AppInfo.CreatedBy);
        AppInfoObj.TryGetValue<string>('createdAt', G_ConfigData.AppInfo.CreatedAt);
      end;

      // Extraer configuración de la API
      if not JSONObj.TryGetValue<string>('apiUrl', G_ConfigData.ApiUrl) then
      begin
        ShowMessage('Error: Falta el campo "apiUrl" en la configuración');
        Exit;
      end;

      if not JSONObj.TryGetValue<string>('apiKey', G_ConfigData.ApiKey) then
      begin
        ShowMessage('Error: Falta el campo "apiKey" en la configuración');
        Exit;
      end;

      if not JSONObj.TryGetValue<string>('instanceId', G_ConfigData.InstanceId) then
      begin
        ShowMessage('Error: Falta el campo "instanceId" en la configuración');
        Exit;
      end;

      // Campos opcionales
      JSONObj.TryGetValue<Integer>('timeout', G_ConfigData.Timeout);
      if G_ConfigData.Timeout = 0 then
        G_ConfigData.Timeout := 30000; // Valor por defecto
        
      JSONObj.TryGetValue<string>('description', G_ConfigData.Description);

      // Validar campos obligatorios
      if (G_ConfigData.ApiUrl = '') or (G_ConfigData.ApiKey = '') or (G_ConfigData.InstanceId = '') then
      begin
        ShowMessage('Error: Uno o más campos obligatorios están vacíos');
        Exit;
      end;

      G_ConfigData.ConfigLoaded := True;
      Result := True;
      
    finally
      JSONObj.Free;
    end;
    
  except
    on E: Exception do
    begin
      ShowMessage('Error procesando JSON: ' + E.Message);
      LimpiarConfiguracionCompleta;
    end;
  end;
end;

function ValidarConfiguracionCompleta: Boolean;
begin
  Result := G_ConfigData.ConfigLoaded and 
            (G_ConfigData.ApiUrl <> '') and 
            (G_ConfigData.ApiKey <> '') and 
            (G_ConfigData.InstanceId <> '');
            
  if not Result then
    ShowMessage('Error: La configuración no ha sido cargada correctamente o está incompleta');
end;

function ObtenerInfoApp: TAppInfo;
begin
  Result := G_ConfigData.AppInfo;
end;

function ObtenerConfiguracionAPI: string;
begin
  if G_ConfigData.ConfigLoaded then
  begin
    Result := Format('Empresa: %s | App: %s | Serial: %s | API: %s | Instancia: %s', [
      G_ConfigData.AppInfo.Empresa,
      G_ConfigData.AppInfo.NombreApp,
      G_ConfigData.AppInfo.Serial,
      G_ConfigData.ApiUrl,
      G_ConfigData.InstanceId
    ]);
  end
  else
    Result := 'Configuración no cargada';
end;

procedure LimpiarConfiguracionCompleta;
begin
  // Limpiar información de la aplicación
  G_ConfigData.AppInfo.Empresa := '';
  G_ConfigData.AppInfo.Serial := '';
  G_ConfigData.AppInfo.NombreApp := '';
  G_ConfigData.AppInfo.AppId := '';
  G_ConfigData.AppInfo.Version := '';
  G_ConfigData.AppInfo.CreatedBy := '';
  G_ConfigData.AppInfo.CreatedAt := '';
  
  // Limpiar configuración de la API
  G_ConfigData.ApiUrl := '';
  G_ConfigData.ApiKey := '';
  G_ConfigData.InstanceId := '';
  G_ConfigData.Timeout := 0;
  G_ConfigData.Description := '';
  G_ConfigData.ConfigLoaded := False;
end;

function EsConfiguracionValida: Boolean;
begin
  Result := ValidarConfiguracionCompleta;
end;

function GenerarCabeceraEstandar(const AEmpresa, ASerial, ANombreApp: string): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('empresa', AEmpresa);
  Result.AddPair('serial', ASerial);
  Result.AddPair('nombreApp', ANombreApp);
  Result.AddPair('version', '1.0');
  Result.AddPair('createdBy', 'ConfigGenerator v1.0');
  Result.AddPair('createdAt', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
end;

function ExtraerCabeceraDeJSON(const AJSONContent: string): TAppInfo;
var
  JSONObj: TJSONObject;
  AppInfoObj: TJSONObject;
begin
  // Inicializar resultado
  FillChar(Result, SizeOf(Result), 0);
  
  try
    JSONObj := TJSONObject.ParseJSONValue(AJSONContent) as TJSONObject;
    
    if Assigned(JSONObj) then
    begin
      try
        if JSONObj.TryGetValue<TJSONObject>('appInfo', AppInfoObj) then
        begin
          AppInfoObj.TryGetValue<string>('empresa', Result.Empresa);
          AppInfoObj.TryGetValue<string>('serial', Result.Serial);
          AppInfoObj.TryGetValue<string>('nombreApp', Result.NombreApp);
          AppInfoObj.TryGetValue<string>('appId', Result.AppId);
          AppInfoObj.TryGetValue<string>('version', Result.Version);
          AppInfoObj.TryGetValue<string>('createdBy', Result.CreatedBy);
          AppInfoObj.TryGetValue<string>('createdAt', Result.CreatedAt);
        end;
      finally
        JSONObj.Free;
      end;
    end;
    
  except
    // En caso de error, devolver estructura vacía
  end;
end;

// Validar AppId y Version básico
function ValidarAppIdYVersion(const AAppId, AVersion: string): Boolean;
begin
  Result := (Trim(AAppId) <> '') and (Trim(AVersion) <> '');
  
  if not Result then
  begin
    ShowMessage('Error: AppId y Version son campos obligatorios');
  end;
end;

// Cargar aplicaciones permitidas desde JSON
function CargarAplicacionesPermitidas(const ARutaJSON: string): TJSONArray;
var
  JSONContent: string;
  JSONObj: TJSONObject;
begin
  Result := nil;
  
  try
    if not FileExists(ARutaJSON) then
    begin
      ShowMessage('Archivo de aplicaciones no encontrado: ' + ARutaJSON);
      Exit;
    end;
    
    JSONContent := TFile.ReadAllText(ARutaJSON, TEncoding.UTF8);
    JSONObj := TJSONObject.ParseJSONValue(JSONContent) as TJSONObject;
    
    if Assigned(JSONObj) then
    begin
      Result := JSONObj.GetValue('aplicaciones') as TJSONArray;
      if Assigned(Result) then
        Result := Result.Clone as TJSONArray; // Clonar para evitar problemas de memoria
    end;
    
  except
    on E: Exception do
    begin
      ShowMessage('Error cargando aplicaciones permitidas: ' + E.Message);
      Result := nil;
    end;
  end;
end;

// Validar aplicación contra archivo JSON
function ValidarAplicacionContraJSON(const AAppId, AVersion: string; const ARutaJSON: string): Boolean;
var
  AppsArray: TJSONArray;
  AppObj: TJSONObject;
  I: Integer;
  AppIdJSON, VersionJSON: string;
begin
  Result := False;
  
  // Validación básica
  if not ValidarAppIdYVersion(AAppId, AVersion) then
    Exit;
  
  // Cargar aplicaciones permitidas
  AppsArray := CargarAplicacionesPermitidas(ARutaJSON);
  if not Assigned(AppsArray) then
    Exit;
  
  try
    // Buscar la aplicación en el JSON
    for I := 0 to AppsArray.Count - 1 do
    begin
      AppObj := AppsArray.Items[I] as TJSONObject;
      if Assigned(AppObj) then
      begin
        AppIdJSON := AppObj.GetValue('id').Value;
        VersionJSON := AppObj.GetValue('version').Value;
        
        if (AppIdJSON = AAppId) and (VersionJSON = AVersion) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
    
    if not Result then
    begin
      ShowMessage(Format('Error: La aplicación %s versión %s no está autorizada.', [AAppId, AVersion]));
    end;
    
  finally
    AppsArray.Free;
  end;
end;

function EsArchivoEncriptado(const ARutaArchivo: string): Boolean;
var
  FileStream: TFileStream;
  Header: array[0..7] of AnsiChar;
begin
  Result := False;
  
  try
    if not TFile.Exists(ARutaArchivo) then
      Exit;
      
    FileStream := TFileStream.Create(ARutaArchivo, fmOpenRead);
    try
      if FileStream.Size < 8 then
        Exit;
        
      FileStream.ReadBuffer(Header[0], 8);
      Result := (string(Header) = 'EVOCFG01');
      
    finally
      FileStream.Free;
    end;
    
  except
    Result := False;
  end;
end;

initialization
  LimpiarConfiguracionCompleta;

finalization
  LimpiarConfiguracionCompleta;

end.
