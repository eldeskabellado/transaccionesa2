unit EvolutionConfigReader;

{
  Unidad para leer archivos de configuración .lic de Evolution API
  Uso simple en cualquier programa:
  
  1. Agregar esta unidad a los uses
  2. Llamar: CargarConfiguracion('archivo.lic', 'password');
  3. Usar las variables globales directamente
  
  Ejemplo:
    if CargarConfiguracion('config.lic', 'mipassword') then
    begin
      ShowMessage('API URL: ' + G_ApiURL);
      ShowMessage('Empresa: ' + G_Empresa);
    end;
}

interface

uses
  System.SysUtils, System.JSON, ConfigEncryption;

// Variables globales - Acceso directo desde cualquier programa
var
  // Configuración API
  G_ApiURL: string = '';
  G_ApiKey: string = '';
  G_InstanceId: string = '';
  
  // Información de la aplicación
  G_Empresa: string = '';
  G_Serial: string = '';
  G_NombreApp: string = '';
  G_Version: string = '';
  G_CreatedBy: string = '';
  G_CreatedAt: string = '';
  
  // Verificación de archivo
  G_HashVerificacion: string = '';
  G_TipoHash: string = '';
  G_ArchivoVerificacion: string = '';
  
  // Estado de la configuración
  G_ConfigCargada: Boolean = False;
  G_ArchivoConfig: string = '';
  G_UltimoError: string = '';

// Funciones principales
function CargarConfiguracion(const ArchivoLIC: string; const Password: string): Boolean;
function ObtenerResumenConfig: string;
function ValidarConfiguracion: Boolean;
procedure LimpiarConfiguracion;

// Funciones de utilidad
function ConfigToJSON: string;
function ObtenerInfoCompleta: string;

implementation

function CargarConfiguracion(const ArchivoLIC: string; const Password: string): Boolean;
var
  JSONContent: string;
  JSONObj, AppInfoObj: TJSONObject;
  JSONValue: TJSONValue;
begin
  Result := False;
  G_ConfigCargada := False;
  G_UltimoError := '';
  
  try
    // Limpiar variables anteriores
    LimpiarConfiguracion;
    
    // Verificar que el archivo existe
    if not FileExists(ArchivoLIC) then
    begin
      G_UltimoError := 'El archivo no existe: ' + ArchivoLIC;
      Exit;
    end;
    
    // Desencriptar archivo
    JSONContent := TConfigEncryption.DecryptConfigFile(ArchivoLIC, Password);
    
    if JSONContent = '' then
    begin
      G_UltimoError := 'No se pudo desencriptar el archivo. Verifique la contraseña.';
      Exit;
    end;
    
    // Parsear JSON
    JSONObj := nil;
    try
      JSONValue := TJSONObject.ParseJSONValue(JSONContent);
      if not Assigned(JSONValue) then
      begin
        G_UltimoError := 'El contenido desencriptado no es JSON válido';
        Exit;
      end;
      
      if not (JSONValue is TJSONObject) then
      begin
        G_UltimoError := 'El JSON no tiene la estructura esperada';
        JSONValue.Free;
        Exit;
      end;
      
      JSONObj := JSONValue as TJSONObject;
      
      // Extraer configuración API (obligatoria)
      if JSONObj.TryGetValue('apiUrl', G_ApiURL) then
        G_ApiURL := Trim(G_ApiURL);
      if JSONObj.TryGetValue('apiKey', G_ApiKey) then
        G_ApiKey := Trim(G_ApiKey);
      if JSONObj.TryGetValue('instanceId', G_InstanceId) then
        G_InstanceId := Trim(G_InstanceId);
      
      // Extraer información de aplicación (opcional)
      if JSONObj.TryGetValue('appInfo', JSONValue) and (JSONValue is TJSONObject) then
      begin
        AppInfoObj := JSONValue as TJSONObject;
        
        if AppInfoObj.TryGetValue('empresa', G_Empresa) then
          G_Empresa := Trim(G_Empresa);
        if AppInfoObj.TryGetValue('serial', G_Serial) then
          G_Serial := Trim(G_Serial);
        if AppInfoObj.TryGetValue('nombreApp', G_NombreApp) then
          G_NombreApp := Trim(G_NombreApp);
        if AppInfoObj.TryGetValue('version', G_Version) then
          G_Version := Trim(G_Version);
        if AppInfoObj.TryGetValue('createdBy', G_CreatedBy) then
          G_CreatedBy := Trim(G_CreatedBy);
        if AppInfoObj.TryGetValue('createdAt', G_CreatedAt) then
          G_CreatedAt := Trim(G_CreatedAt);
      end;
      
      // Extraer información de verificación (opcional)
      if JSONObj.TryGetValue('hashVerificacion', G_HashVerificacion) then
        G_HashVerificacion := Trim(G_HashVerificacion);
      if JSONObj.TryGetValue('tipoHash', G_TipoHash) then
        G_TipoHash := Trim(G_TipoHash);
      if JSONObj.TryGetValue('archivoVerificacion', G_ArchivoVerificacion) then
        G_ArchivoVerificacion := Trim(G_ArchivoVerificacion);
      
      // Validar que tenemos los datos mínimos necesarios
      if (G_ApiURL = '') or (G_ApiKey = '') or (G_InstanceId = '') then
      begin
        G_UltimoError := 'Faltan datos obligatorios en el archivo de configuración';
        Exit;
      end;
      
      // Configuración cargada exitosamente
      G_ConfigCargada := True;
      G_ArchivoConfig := ArchivoLIC;
      Result := True;
      
    finally
      if Assigned(JSONObj) then
        JSONObj.Free;
    end;
    
  except
    on E: Exception do
    begin
      G_UltimoError := 'Error cargando configuración: ' + E.Message;
      Result := False;
    end;
  end;
end;

function ObtenerResumenConfig: string;
begin
  if not G_ConfigCargada then
  begin
    Result := 'Configuración no cargada. Error: ' + G_UltimoError;
    Exit;
  end;
  
  Result := '=== CONFIGURACIÓN EVOLUTION API ===' + #13#10 +
            'Archivo: ' + ExtractFileName(G_ArchivoConfig) + #13#10 +
            'API URL: ' + G_ApiURL + #13#10 +
            'Instance ID: ' + G_InstanceId + #13#10 +
            'API Key: ' + Copy(G_ApiKey, 1, 8) + '...' + #13#10;
            
  if G_Empresa <> '' then
    Result := Result + 'Empresa: ' + G_Empresa + #13#10;
  if G_NombreApp <> '' then
    Result := Result + 'Aplicación: ' + G_NombreApp + #13#10;
  if G_Serial <> '' then
    Result := Result + 'Serial: ' + G_Serial + #13#10;
  if G_Version <> '' then
    Result := Result + 'Versión: ' + G_Version + #13#10;
  if G_HashVerificacion <> '' then
    Result := Result + 'Hash Verificación: ' + Copy(G_HashVerificacion, 1, 16) + '...' + #13#10;
  if G_TipoHash <> '' then
    Result := Result + 'Tipo Hash: ' + G_TipoHash + #13#10;
  if G_ArchivoVerificacion <> '' then
    Result := Result + 'Archivo Verificación: ' + G_ArchivoVerificacion + #13#10;
    
  Result := Result + 'Estado: ✓ Configuración válida';
end;

function ValidarConfiguracion: Boolean;
begin
  Result := G_ConfigCargada and 
            (G_ApiURL <> '') and 
            (G_ApiKey <> '') and 
            (G_InstanceId <> '');
end;

procedure LimpiarConfiguracion;
begin
  G_ApiURL := '';
  G_ApiKey := '';
  G_InstanceId := '';
  G_Empresa := '';
  G_Serial := '';
  G_NombreApp := '';
  G_Version := '';
  G_CreatedBy := '';
  G_CreatedAt := '';
  G_HashVerificacion := '';
  G_TipoHash := '';
  G_ArchivoVerificacion := '';
  G_ConfigCargada := False;
  G_ArchivoConfig := '';
  G_UltimoError := '';
end;

function ConfigToJSON: string;
var
  JSONObj, AppInfoObj: TJSONObject;
begin
  if not G_ConfigCargada then
  begin
    Result := '{"error": "Configuración no cargada"}';
    Exit;
  end;
  
  JSONObj := TJSONObject.Create;
  try
    // Datos API
    JSONObj.AddPair('apiUrl', G_ApiURL);
    JSONObj.AddPair('apiKey', G_ApiKey);
    JSONObj.AddPair('instanceId', G_InstanceId);
    
    // Información de verificación
    if G_HashVerificacion <> '' then
      JSONObj.AddPair('hashVerificacion', G_HashVerificacion);
    if G_TipoHash <> '' then
      JSONObj.AddPair('tipoHash', G_TipoHash);
    if G_ArchivoVerificacion <> '' then
      JSONObj.AddPair('archivoVerificacion', G_ArchivoVerificacion);
    
    // Información de aplicación
    if (G_Empresa <> '') or (G_Serial <> '') or (G_NombreApp <> '') then
    begin
      AppInfoObj := TJSONObject.Create;
      try
        if G_Empresa <> '' then
          AppInfoObj.AddPair('empresa', G_Empresa);
        if G_Serial <> '' then
          AppInfoObj.AddPair('serial', G_Serial);
        if G_NombreApp <> '' then
          AppInfoObj.AddPair('nombreApp', G_NombreApp);
        if G_Version <> '' then
          AppInfoObj.AddPair('version', G_Version);
        if G_CreatedBy <> '' then
          AppInfoObj.AddPair('createdBy', G_CreatedBy);
        if G_CreatedAt <> '' then
          AppInfoObj.AddPair('createdAt', G_CreatedAt);
          
        JSONObj.AddPair('appInfo', AppInfoObj);
      except
        AppInfoObj.Free;
        raise;
      end;
    end;
    
    Result := JSONObj.ToString;
  finally
    JSONObj.Free;
  end;
end;

function ObtenerInfoCompleta: string;
var
  Linea1, Linea2, Linea3, Linea4, Linea5: string;
begin
  if not G_ConfigCargada then
  begin
    Result := 'ERROR: Configuración no cargada' + #13#10 + 
              'Último error: ' + G_UltimoError;
    Exit;
  end;
  
  // Construir el resultado línea por línea para evitar strings muy largos
  Linea1 := '=== EVOLUTION API CONFIG ===' + #13#10;
  Linea2 := 'CONFIGURACIÓN API:' + #13#10;
  Linea3 := '• URL: ' + G_ApiURL + #13#10;
  Linea4 := '• Instance: ' + G_InstanceId + #13#10;
  Linea5 := '• Key: ' + Copy(G_ApiKey, 1, 12) + '...' + #13#10;
  
  Result := Linea1 + Linea2 + Linea3 + Linea4 + Linea5;
            
  if (G_Empresa <> '') or (G_NombreApp <> '') or (G_Serial <> '') then
  begin
    Result := Result + #13#10 + 'INFORMACIÓN DE APLICACIÓN:' + #13#10;
    if G_Empresa <> '' then
      Result := Result + '• Empresa: ' + G_Empresa + #13#10;
    if G_NombreApp <> '' then
      Result := Result + '• App: ' + G_NombreApp + #13#10;
    if G_Serial <> '' then
      Result := Result + '• Serial: ' + G_Serial + #13#10;
    if G_Version <> '' then
      Result := Result + '• Versión: ' + G_Version + #13#10;
  end;
  
  if (G_HashVerificacion <> '') or (G_TipoHash <> '') or (G_ArchivoVerificacion <> '') then
  begin
    Result := Result + #13#10 + 'VERIFICACIÓN DE ARCHIVO:' + #13#10;
    if G_ArchivoVerificacion <> '' then
      Result := Result + '• Archivo: ' + G_ArchivoVerificacion + #13#10;
    if G_TipoHash <> '' then
      Result := Result + '• Tipo Hash: ' + G_TipoHash + #13#10;
    if G_HashVerificacion <> '' then
      Result := Result + '• Hash: ' + Copy(G_HashVerificacion, 1, 20) + '...' + #13#10;
  end;
  
  Result := Result + #13#10 + 
            'Estado: CONFIGURACIÓN VÁLIDA' + #13#10 +
            'Archivo: ' + ExtractFileName(G_ArchivoConfig);
end;

end.
