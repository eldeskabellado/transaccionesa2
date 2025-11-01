unit EvolutionConfig;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils, ConfigEncryption, ConfigHeader;

// Variables globales para almacenar la configuración
var
  G_ApiURL: string = '';
  G_ApiKey: string = '';
  G_InstanciaID: string = '';

// Funciones para gestión de configuración
function CargarConfiguracionSegura(const ARutaArchivoConfig: string): Boolean; overload;
function CargarConfiguracionSegura(const ARutaArchivoConfig: string; const APassword: string): Boolean; overload;
function CargarConfiguracionDesdeJSON(const ARutaArchivoJSON: string): Boolean;
function ValidarConfiguracion: Boolean;
function ObtenerRutaConfigPorDefecto: string;
procedure LimpiarConfiguracion;
function EsArchivoEncriptado(const ARutaArchivo: string): Boolean;

// Nuevas funciones que usan ConfigHeader
function CargarConfiguracionCompleta(const ARutaArchivo: string): Boolean; overload;
function CargarConfiguracionCompleta(const ARutaArchivo: string; const APassword: string): Boolean; overload;
function ObtenerInfoAplicacion: TAppInfo;
function ObtenerResumenConfiguracion: string;

implementation

uses
  Vcl.Dialogs;

// Función principal que detecta automáticamente el tipo de archivo
function CargarConfiguracionSegura(const ARutaArchivoConfig: string): Boolean;
begin
  Result := False;
  
  try
    // 1. Verificar si el archivo existe
    if not TFile.Exists(ARutaArchivoConfig) then
    begin
      ShowMessage('Error: El archivo de configuración no existe: ' + ARutaArchivoConfig);
      Exit;
    end;

    // 2. Detectar si es un archivo encriptado o JSON plano
    if EsArchivoEncriptado(ARutaArchivoConfig) then
    begin
      // Es un archivo encriptado, solicitar contraseña
      ShowMessage('El archivo está encriptado. Use CargarConfiguracionSegura(ruta, password) ' +
                  'o implemente un diálogo para solicitar la contraseña.');
      Exit;
    end
    else
    begin
      // Es un archivo JSON plano
      Result := CargarConfiguracionDesdeJSON(ARutaArchivoConfig);
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error cargando configuración: ' + E.Message);
      LimpiarConfiguracion;
    end;
  end;
end;

// Función sobrecargada que acepta contraseña para archivos encriptados
function CargarConfiguracionSegura(const ARutaArchivoConfig: string; const APassword: string): Boolean;
var
  ContenidoDesencriptado: string;
  JSONConfig: TJSONObject;
begin
  Result := False;
  
  try
    // 1. Verificar si el archivo existe
    if not TFile.Exists(ARutaArchivoConfig) then
    begin
      ShowMessage('Error: El archivo de configuración no existe: ' + ARutaArchivoConfig);
      Exit;
    end;

    // 2. Desencriptar el archivo usando ConfigEncryption
    ContenidoDesencriptado := TConfigEncryption.DecryptConfigFile(ARutaArchivoConfig, APassword);
    
    if ContenidoDesencriptado = '' then
    begin
      ShowMessage('Error: No se pudo desencriptar el archivo. Verifique la contraseña.');
      Exit;
    end;

    // 3. Parsear el JSON desencriptado
    JSONConfig := TJSONObject.ParseJSONValue(ContenidoDesencriptado) as TJSONObject;
    
    if not Assigned(JSONConfig) then
    begin
      ShowMessage('Error: El contenido desencriptado no es un JSON válido');
      Exit;
    end;

    try
      // 4. Asignar los valores del JSON a las variables globales
      if not JSONConfig.TryGetValue<string>('apiUrl', G_ApiURL) then
      begin
        ShowMessage('Error: Falta el campo "apiUrl" en la configuración');
        Exit;
      end;

      if not JSONConfig.TryGetValue<string>('apiKey', G_ApiKey) then
      begin
        ShowMessage('Error: Falta el campo "apiKey" en la configuración');
        Exit;
      end;

      if not JSONConfig.TryGetValue<string>('instanceId', G_InstanciaID) then
      begin
        ShowMessage('Error: Falta el campo "instanceId" en la configuración');
        Exit;
      end;

      // Validar que los valores no estén vacíos
      if (G_ApiURL = '') or (G_ApiKey = '') or (G_InstanciaID = '') then
      begin
        ShowMessage('Error: Uno o más campos de configuración están vacíos');
        Exit;
      end;

      // 5. Configuración cargada exitosamente
      Result := True;
      
    finally
      JSONConfig.Free;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error cargando configuración encriptada: ' + E.Message);
      LimpiarConfiguracion;
    end;
  end;
end;

function ValidarConfiguracion: Boolean;
begin
  Result := (G_ApiURL <> '') and (G_ApiKey <> '') and (G_InstanciaID <> '');
  
  if not Result then
    ShowMessage('Error: La configuración no ha sido cargada correctamente. ' +
                'Ejecute CargarConfiguracionSegura() primero.');
end;

function ObtenerRutaConfigPorDefecto: string;
begin
  // Ruta por defecto en el directorio de la aplicación
  Result := ExtractFilePath(ParamStr(0)) + 'config.dat';
end;

procedure LimpiarConfiguracion;
begin
  G_ApiURL := '';
  G_ApiKey := '';
  G_InstanciaID := '';
end;

function CargarConfiguracionDesdeJSON(const ARutaArchivoJSON: string): Boolean;
var
  ContenidoJSON: string;
  JSONConfig: TJSONObject;
begin
  Result := False;
  
  try
    // 1. Leer el archivo JSON
    ContenidoJSON := TFile.ReadAllText(ARutaArchivoJSON, TEncoding.UTF8);
    
    if ContenidoJSON = '' then
    begin
      ShowMessage('Error: El archivo JSON está vacío');
      Exit;
    end;

    // 2. Parsear el JSON
    JSONConfig := TJSONObject.ParseJSONValue(ContenidoJSON) as TJSONObject;
    
    if not Assigned(JSONConfig) then
    begin
      ShowMessage('Error: El archivo no contiene un JSON válido');
      Exit;
    end;

    try
      // 3. Asignar los valores del JSON a las variables globales
      if not JSONConfig.TryGetValue<string>('apiUrl', G_ApiURL) then
      begin
        ShowMessage('Error: Falta el campo "apiUrl" en la configuración');
        Exit;
      end;

      if not JSONConfig.TryGetValue<string>('apiKey', G_ApiKey) then
      begin
        ShowMessage('Error: Falta el campo "apiKey" en la configuración');
        Exit;
      end;

      if not JSONConfig.TryGetValue<string>('instanceId', G_InstanciaID) then
      begin
        ShowMessage('Error: Falta el campo "instanceId" en la configuración');
        Exit;
      end;

      // Validar que los valores no estén vacíos
      if (G_ApiURL = '') or (G_ApiKey = '') or (G_InstanciaID = '') then
      begin
        ShowMessage('Error: Uno o más campos de configuración están vacíos');
        Exit;
      end;

      // 4. Configuración cargada exitosamente
      Result := True;
      
    finally
      JSONConfig.Free;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error cargando configuración desde JSON: ' + E.Message);
      LimpiarConfiguracion;
    end;
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
      // Verificar si el archivo tiene al menos 8 bytes para el header
      if FileStream.Size < 8 then
        Exit;
        
      // Leer los primeros 8 bytes
      FileStream.ReadBuffer(Header[0], 8);
      
      // Verificar si tiene el header de archivo encriptado
      Result := (string(Header) = 'EVOCFG01');
      
    finally
      FileStream.Free;
    end;
    
  except
    // En caso de error, asumir que no es encriptado
    Result := False;
  end;
end;

// Nuevas funciones que usan ConfigHeader para manejo completo
function CargarConfiguracionCompleta(const ARutaArchivo: string): Boolean;
begin
  Result := LeerConfiguracionCompleta(ARutaArchivo);
  
  if Result then
  begin
    // Sincronizar con variables globales para compatibilidad
    G_ApiURL := G_ConfigData.ApiUrl;
    G_ApiKey := G_ConfigData.ApiKey;
    G_InstanciaID := G_ConfigData.InstanceId;
  end;
end;

function CargarConfiguracionCompleta(const ARutaArchivo: string; const APassword: string): Boolean;
begin
  Result := LeerConfiguracionCompleta(ARutaArchivo, APassword);
  
  if Result then
  begin
    // Sincronizar con variables globales para compatibilidad
    G_ApiURL := G_ConfigData.ApiUrl;
    G_ApiKey := G_ConfigData.ApiKey;
    G_InstanciaID := G_ConfigData.InstanceId;
  end;
end;

function ObtenerInfoAplicacion: TAppInfo;
begin
  Result := ObtenerInfoApp;
end;

function ObtenerResumenConfiguracion: string;
begin
  Result := ObtenerConfiguracionAPI;
end;

initialization
  // Inicializar variables vacías por seguridad
  LimpiarConfiguracion;
  LimpiarConfiguracionCompleta;

finalization
  // Limpiar variables al finalizar por seguridad
  LimpiarConfiguracion;
  LimpiarConfiguracionCompleta;

end.
