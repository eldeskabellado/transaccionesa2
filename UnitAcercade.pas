unit UnitAcercade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.JSON, System.NetEncoding,
  BaileysAPI;  // ⭐ Usar la nueva clase BaileysAPI

type
  TformConectar = class(TForm)
    btnMostrarQR: TButton;
    imgQR: TImage;
    lblEstado: TLabel;
    imgLogo: TImage;
    lblEmpresa: TLabel;
    lblEstado1: TLabel;
    procedure btnMostrarQRClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FBaileysAPI: TBaileysAPI;  // ⭐ Cambio de TEvolutionAPI a TBaileysAPI
    procedure ShowQRImage(const AQRData: string);
  public
    { Public declarations }
  end;

var
  formConectar: TformConectar;

implementation

uses
  unitVariables;

{$R *.dfm}

procedure TformConectar.ShowQRImage(const AQRData: string);
var
  JSONObj: TJSONObject;
  QRValue: TJSONValue;
  Base64Data: string;
  ImageStream: TMemoryStream;
  DecodedBytes: TBytes;
  QRImageURL: string;
begin
  try
    JSONObj := TJSONObject.ParseJSONValue(AQRData) as TJSONObject;
    if Assigned(JSONObj) then
    begin
      try
        // Buscar el campo del QR en múltiples posibles nombres
        QRValue := JSONObj.FindValue('qrcode');
        if not Assigned(QRValue) then QRValue := JSONObj.FindValue('qr');
        if not Assigned(QRValue) then QRValue := JSONObj.FindValue('base64');
        if not Assigned(QRValue) then QRValue := JSONObj.FindValue('data');
        if not Assigned(QRValue) then QRValue := JSONObj.FindValue('image');
        if not Assigned(QRValue) then QRValue := JSONObj.FindValue('code');

        if Assigned(QRValue) then
        begin
          QRImageURL := QRValue.Value;

          // Procesar base64
          if (Pos('data:image', LowerCase(QRImageURL)) = 1) or
             (Pos('base64,', QRImageURL) > 0) then
          begin
            // Extraer base64
            if Pos('base64,', QRImageURL) > 0 then
              Base64Data := Copy(QRImageURL, Pos('base64,', QRImageURL) + 7, Length(QRImageURL))
            else
              Base64Data := QRImageURL;

            // Limpiar
            Base64Data := StringReplace(Base64Data, #13, '', [rfReplaceAll]);
            Base64Data := StringReplace(Base64Data, #10, '', [rfReplaceAll]);
            Base64Data := StringReplace(Base64Data, ' ', '', [rfReplaceAll]);

            try
              // Decodificar
              DecodedBytes := TNetEncoding.Base64.DecodeStringToBytes(Base64Data);

              // Cargar en imagen
              ImageStream := TMemoryStream.Create;
              try
                ImageStream.WriteBuffer(DecodedBytes[0], Length(DecodedBytes));
                ImageStream.Position := 0;

                imgQR.Picture.LoadFromStream(ImageStream);
                imgQR.Stretch := True;
                imgQR.Proportional := True;
                imgQR.Visible := True;

                lblEstado.Caption := '📱 Escanea el QR con WhatsApp';
                lblEstado.Font.Color := clBlue;

                ShowMessage('Código QR generado' + #13#10 +
                           'Escanéalo con WhatsApp en tu celular' + #13#10 +
                           '(El QR expira en 60 segundos)');
              finally
                ImageStream.Free;
              end;
            except
              on E: Exception do
                ShowMessage('Error al decodificar: ' + E.Message);
            end;
          end
          else
          begin
            ShowMessage('El QR no está en formato base64');
          end;
        end
        else
        begin
          ShowMessage('No se encontró el código QR en la respuesta');
        end;
      finally
        JSONObj.Free;
      end;
    end
    else
    begin
      ShowMessage('La respuesta no es JSON válido');
    end;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TformConectar.FormCreate(Sender: TObject);
begin
  imgQR.Visible := False;

  // ⭐⭐⭐ CREAR INSTANCIA DE BAILEYS API ⭐⭐⭐
  // Leer configuración desde unitVariables (que viene del .ini)
  FBaileysAPI := TBaileysAPI.Create(
    URL_BAILEYS,      // URL del servidor Baileys (ej: http://localhost:3000)
    APIKEY_BAILEYS    // API Key (opcional, según tu configuración)
  );

  lblEstado.Caption := '✓ Baileys API Configurada';
  lblEstado.Font.Color := clGreen;
end;

procedure TformConectar.FormDestroy(Sender: TObject);
begin
  if Assigned(FBaileysAPI) then
    FBaileysAPI.Free;
end;

procedure TformConectar.FormShow(Sender: TObject);
begin
  btnMostrarQRClick(Self);
  lblEmpresa.Caption := NAME_EMPRESA;
end;

procedure TformConectar.btnMostrarQRClick(Sender: TObject);
var
  Response: TBaileysResponse;
  JSONObj, InstanceObj: TJSONObject;
  State: string;
  IsConnected: Boolean;
begin
  lblEstado.Caption := 'Verificando conexión...';
  lblEstado.Font.Color := clBlue;
  imgQR.Visible := False;  // Ocultar QR al inicio
  Application.ProcessMessages;

  try
    // 1. Verificar si ya está conectado
    Response := FBaileysAPI.GetInstanceStatus;

    if Response.Success then
    begin
      JSONObj := TJSONObject.ParseJSONValue(Response.Data) as TJSONObject;
      if Assigned(JSONObj) then
      try
        // ⭐ Verificar si tiene campo 'connected' (respuesta directa del servidor)
        if JSONObj.TryGetValue<Boolean>('connected', IsConnected) and IsConnected then
        begin
          lblEstado.Caption := '✓ WhatsApp Conectado';
          lblEstado.Font.Color := clGreen;
          imgQR.Visible := False;

          var Message: string;
          if JSONObj.TryGetValue<string>('message', Message) then
            ShowMessage(Message)
          else
            ShowMessage('WhatsApp está conectado y listo para usar.');
          Exit;
        end;

        // Verificar formato Evolution (con 'instance')
        if JSONObj.TryGetValue<TJSONObject>('instance', InstanceObj) and Assigned(InstanceObj) then
        begin
          if InstanceObj.TryGetValue<string>('state', State) and (LowerCase(State) = 'open') then
          begin
            lblEstado.Caption := '✓ WhatsApp Conectado';
            lblEstado.Font.Color := clGreen;
            imgQR.Visible := False;

            var UserName: string;
            if InstanceObj.TryGetValue<string>('profileName', UserName) then
              ShowMessage('WhatsApp está conectado.' + #13#10 +
                         'Usuario: ' + UserName)
            else
              ShowMessage('WhatsApp está conectado y listo para usar.');
            Exit;
          end;
        end;
      finally
        JSONObj.Free;
      end;
    end;

    // 2. Si no está conectado, obtener QR
    lblEstado.Caption := 'Generando código QR...';
    lblEstado.Font.Color := $0000A5FF; // Naranja
    Application.ProcessMessages;

    Response := FBaileysAPI.GetQRCode;

    if Response.Success then
    begin
      // ⭐ Verificar de nuevo si ya está conectado (por si conectó mientras verificábamos)
      JSONObj := TJSONObject.ParseJSONValue(Response.Data) as TJSONObject;
      if Assigned(JSONObj) then
      try
        if JSONObj.TryGetValue<Boolean>('connected', IsConnected) and IsConnected then
        begin
          lblEstado.Caption := '✓ WhatsApp Conectado';
          lblEstado.Font.Color := clGreen;
          imgQR.Visible := False;

          var Message: string;
          if JSONObj.TryGetValue<string>('message', Message) then
            ShowMessage(Message)
          else
            ShowMessage('WhatsApp está conectado y listo para usar.');
          Exit;
        end;
      finally
        JSONObj.Free;
      end;

      // Mostrar QR si no está conectado
      imgQR.Visible := True;
      ShowQRImage(Response.Data);

      lblEstado.Caption := '📱 Escanea el QR con tu celular';
      lblEstado.Font.Color := clBlue;
    end
    else
    begin
      ShowMessage('Error obteniendo QR:' + #13#10 +
                 Response.Message + #13#10#13#10 +
                 'Verifica que el servidor Baileys esté corriendo en: ' + #13#10 +
                 URL_BAILEYS);
      lblEstado.Caption := '✗ Error - Servidor no disponible';
      lblEstado.Font.Color := clRed;
      imgQR.Visible := False;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error de conexión: ' + E.Message + #13#10#13#10 +
                 'Asegúrate que el servidor esté corriendo en:' + #13#10 +
                 URL_BAILEYS);
      lblEstado.Caption := '✗ Error de Conexión';
      lblEstado.Font.Color := clRed;
      imgQR.Visible := False;
    end;
  end;
end;

end.
