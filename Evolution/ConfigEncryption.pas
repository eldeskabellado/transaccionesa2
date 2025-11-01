unit ConfigEncryption;

interface

uses
  System.SysUtils, System.Classes, System.Hash, System.NetEncoding;

type
  // Clase para manejo de encriptación simple de configuración
  TConfigEncryption = class
  private
    class function SimpleXOREncrypt(const AData: string; const AKey: string): TBytes;
    class function SimpleXORDecrypt(const AData: TBytes; const AKey: string): string;
    class function GenerateKeyFromPassword(const APassword: string): string;
  public
    // Métodos principales
    class function EncryptConfigFile(const AJSONContent: string; const APassword: string; const AOutputFile: string): Boolean;
    class function DecryptConfigFile(const AEncryptedFile: string; const APassword: string): string;
    class function CreateEncryptedConfigFromJSON(const AJSONFile: string; const APassword: string; const AOutputFile: string): Boolean;
    class function DecryptConfigFromZIP(const AZipFile: string; const APassword: string): string;
    
    // Métodos de utilidad
    class function ValidatePassword(const APassword: string): Boolean;
    class function GenerateRandomPassword(ALength: Integer = 32): string;
  end;

implementation

uses
  System.IOUtils, Vcl.Dialogs, System.Zip;

{ TConfigEncryption }

class function TConfigEncryption.GenerateKeyFromPassword(const APassword: string): string;
var
  HashSHA256: string;
begin
  // Generar hash SHA256 de la contraseña para usar como clave
  HashSHA256 := THashSHA2.GetHashString(APassword, THashSHA2.TSHA2Version.SHA256);
  
  // Tomar los primeros 32 caracteres como clave
  Result := Copy(HashSHA256, 1, 32);
end;

class function TConfigEncryption.SimpleXOREncrypt(const AData: string; const AKey: string): TBytes;
var
  DataBytes: TBytes;
  KeyBytes: TBytes;
  i: Integer;
  KeyIndex: Integer;
begin
  // Convertir string a bytes
  DataBytes := TEncoding.UTF8.GetBytes(AData);
  KeyBytes := TEncoding.UTF8.GetBytes(AKey);
  
  SetLength(Result, Length(DataBytes));
  
  // Aplicar XOR con la clave
  for i := 0 to High(DataBytes) do
  begin
    KeyIndex := i mod Length(KeyBytes);
    Result[i] := DataBytes[i] xor KeyBytes[KeyIndex];
  end;
end;

class function TConfigEncryption.SimpleXORDecrypt(const AData: TBytes; const AKey: string): string;
var
  KeyBytes: TBytes;
  DecryptedBytes: TBytes;
  i: Integer;
  KeyIndex: Integer;
begin
  Result := '';
  
  try
    KeyBytes := TEncoding.UTF8.GetBytes(AKey);
    SetLength(DecryptedBytes, Length(AData));
    
    // Aplicar XOR con la clave (XOR es simétrico)
    for i := 0 to High(AData) do
    begin
      KeyIndex := i mod Length(KeyBytes);
      DecryptedBytes[i] := AData[i] xor KeyBytes[KeyIndex];
    end;
    
    // Convertir bytes de vuelta a string con manejo robusto de errores
    try
      // Intentar primero con UTF8
      Result := TEncoding.UTF8.GetString(DecryptedBytes);
      
      // Verificar si el resultado parece válido (contiene caracteres JSON básicos)
      if (Length(Result) > 0) and 
         ((Pos('{', Result) > 0) or (Pos('"', Result) > 0) or (Pos(':', Result) > 0)) then
      begin
        // Resultado parece válido, usar UTF8
        Exit;
      end;
      
      // Si UTF8 no produce resultado válido, intentar conversión manual byte a byte
      SetLength(Result, Length(DecryptedBytes));
      for i := 0 to High(DecryptedBytes) do
      begin
        if DecryptedBytes[i] < 128 then
          Result[i + 1] := Chr(DecryptedBytes[i])
        else
          Result[i + 1] := '?'; // Reemplazar caracteres problemáticos
      end;
      
    except
      // En caso de cualquier error, conversión manual segura
      try
        SetLength(Result, Length(DecryptedBytes));
        for i := 0 to High(DecryptedBytes) do
        begin
          if (DecryptedBytes[i] >= 32) and (DecryptedBytes[i] < 127) then
            Result[i + 1] := Chr(DecryptedBytes[i])
          else if DecryptedBytes[i] = 10 then
            Result[i + 1] := #10  // Line feed
          else if DecryptedBytes[i] = 13 then
            Result[i + 1] := #13  // Carriage return
          else
            Result[i + 1] := ' '; // Reemplazar otros caracteres con espacio
        end;
      except
        Result := '';
      end;
    end;
    
  except
    Result := '';
  end;
end;

class function TConfigEncryption.EncryptConfigFile(const AJSONContent: string; const APassword: string; const AOutputFile: string): Boolean;
var
  Key: string;
  EncryptedData: TBytes;
  FileStream: TFileStream;
begin
  Result := False;
  
  try
    // Validar entrada
    if (AJSONContent = '') or (APassword = '') or (AOutputFile = '') then
      Exit;
    
    if not ValidatePassword(APassword) then
      Exit;
    
    // Generar clave desde la contraseña
    Key := GenerateKeyFromPassword(APassword);
    
    // Encriptar el contenido JSON
    EncryptedData := SimpleXOREncrypt(AJSONContent, Key);
    
    // Guardar archivo encriptado
    FileStream := TFileStream.Create(AOutputFile, fmCreate);
    try
      // Escribir un header simple para identificar el archivo
      FileStream.WriteBuffer(PAnsiChar('EVOCFG01')^, 8); // Header de 8 bytes
      
      // Escribir datos encriptados
      FileStream.WriteBuffer(EncryptedData[0], Length(EncryptedData));
      
      Result := True;
      
    finally
      FileStream.Free;
    end;
    
  except
    on E: Exception do
      Result := False;
  end;
end;

class function TConfigEncryption.DecryptConfigFile(const AEncryptedFile: string; const APassword: string): string;
var
  Key: string;
  FileStream: TFileStream;
  Header: array[0..7] of AnsiChar;
  EncryptedData: TBytes;
  DataSize: Integer;
  DecryptedContent: string;
begin
  Result := '';
  
  try
    // Validar entrada
    if not TFile.Exists(AEncryptedFile) then
      Exit;
    
    if not ValidatePassword(APassword) then
      Exit;
    
    // Generar clave desde la contraseña
    Key := GenerateKeyFromPassword(APassword);
    
    // Leer archivo encriptado
    FileStream := TFileStream.Create(AEncryptedFile, fmOpenRead);
    try
      // Verificar header
      if FileStream.Size < 8 then
        Exit;
      
      FileStream.ReadBuffer(Header[0], 8);
      
      if string(Header) <> 'EVOCFG01' then
        Exit;
      
      // Leer datos encriptados
      DataSize := FileStream.Size - 8;
      if DataSize <= 0 then
        Exit;
        
      SetLength(EncryptedData, DataSize);
      FileStream.ReadBuffer(EncryptedData[0], DataSize);
      
    finally
      FileStream.Free;
    end;
    
    // Desencriptar
    DecryptedContent := SimpleXORDecrypt(EncryptedData, Key);
    
    // Validar que el contenido desencriptado sea válido
    if (DecryptedContent <> '') and 
       ((Pos('{', DecryptedContent) > 0) or (Pos('"', DecryptedContent) > 0)) then
    begin
      Result := DecryptedContent;
    end;
    
  except
    on E: Exception do
      Result := '';
  end;
end;

class function TConfigEncryption.CreateEncryptedConfigFromJSON(const AJSONFile: string; const APassword: string; const AOutputFile: string): Boolean;
var
  JSONContent: string;
begin
  Result := False;
  
  try
    // Verificar que el archivo JSON existe
    if not TFile.Exists(AJSONFile) then
      Exit;
    
    // Leer contenido del archivo JSON
    JSONContent := TFile.ReadAllText(AJSONFile, TEncoding.UTF8);
    
    if JSONContent = '' then
      Exit;
    
    // Encriptar y guardar
    Result := EncryptConfigFile(JSONContent, APassword, AOutputFile);
    
  except
    Result := False;
  end;
end;

class function TConfigEncryption.ValidatePassword(const APassword: string): Boolean;
begin
  // Validación básica: al menos 8 caracteres
  Result := Length(APassword) >= 8;
end;

class function TConfigEncryption.GenerateRandomPassword(ALength: Integer): string;
const
  Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*';
var
  i: Integer;
begin
  Result := '';
  Randomize;
  
  for i := 1 to ALength do
    Result := Result + Chars[Random(Length(Chars)) + 1];
end;

class function TConfigEncryption.DecryptConfigFromZIP(const AZipFile: string; const APassword: string): string;
var
  ZipFile: TZipFile;
  TempFile: string;
  i: Integer;
begin
  Result := '';
  
  try
    // Verificar que el archivo ZIP existe
    if not TFile.Exists(AZipFile) then
      Exit;
    
    // Crear archivo temporal
    TempFile := TPath.GetTempFileName;
    try
      ZipFile := TZipFile.Create;
      try
        ZipFile.Open(AZipFile, zmRead);
        
        // Buscar archivo .lic en el ZIP
        for i := 0 to ZipFile.FileCount - 1 do
        begin
          if LowerCase(ExtractFileExt(ZipFile.FileName[i])) = '.lic' then
          begin
            // Extraer archivo .lic
            ZipFile.Extract(ZipFile.FileName[i], TempFile);
            
            // Desencriptar el archivo extraído
            Result := DecryptConfigFile(TempFile, APassword);
            Break;
          end;
        end;
        
        ZipFile.Close;
        
      finally
        ZipFile.Free;
      end;
      
    finally
      // Limpiar archivo temporal
      if TFile.Exists(TempFile) then
        TFile.Delete(TempFile);
    end;
    
  except
    on E: Exception do
      Result := '';
  end;
end;

end.
