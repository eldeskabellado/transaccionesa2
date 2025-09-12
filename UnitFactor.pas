unit UnitFactor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Data.DB, dbisamtb, Vcl.ComCtrls;

type
  TformCambioTasa = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    edtTasaActual: TEdit;
    edtNuevaTasa: TEdit;
    btn1: TButton;
    sqTasa: TDBISAMQuery;
    pbProceso: TProgressBar;
    sqUpdateSinvOferta: TDBISAMQuery;
    lblEstado: TLabel;
    btnCancelar: TButton;

    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }
    procedure InicializarFormulario;
    procedure HabilitarControles(AHabilitar: Boolean);
    function ValidarDatos: Boolean;

  public
    { Public declarations }
    tasamoneda: Double;
  end;

var
  formCambioTasa: TformCambioTasa;

implementation

uses UnitDatos;

{$R *.dfm}

// ================================
// IMPLEMENTACIÓN DEL FORMULARIO
// ================================

procedure TformCambioTasa.FormCreate(Sender: TObject);
begin
  InicializarFormulario;
end;

procedure TformCambioTasa.FormShow(Sender: TObject);
begin
  // Mostrar la tasa actual recibida del formulario padre
  edtTasaActual.Text := FormatFloat('0.00', tasamoneda);
  edtNuevaTasa.SetFocus;
end;

procedure TformCambioTasa.InicializarFormulario;
begin
  // Configurar labels
  lbl1.Caption := 'Tasa Actual:';
  lbl2.Caption := 'Nueva Tasa:';

  // Configurar botones
  btn1.Caption := 'Actualizar Precios';
  btnCancelar.Caption := 'Cancelar';

  // Configurar barra de progreso
  pbProceso.Min := 0;
  pbProceso.Max := 100;
  pbProceso.Position := 0;
  pbProceso.Visible := False;

  // Configurar label de estado
  lblEstado.Caption := 'Listo para actualizar precios';
  lblEstado.Font.Color := clGreen;

  // Solo lectura para tasa actual
  edtTasaActual.ReadOnly := True;
  edtTasaActual.Color := clBtnFace;

  // Configurar el formulario
  Caption := 'Cambio de Tasa de Moneda';
  Position := poScreenCenter;
end;

function TformCambioTasa.ValidarDatos: Boolean;
var
  NuevaTasa: Double;
begin
  Result := False;

  // Validar que se haya ingresado nueva tasa
  if Trim(edtNuevaTasa.Text) = '' then
  begin
    ShowMessage('Debe ingresar la nueva tasa');
    edtNuevaTasa.SetFocus;
    Exit;
  end;

  // Validar que sea un número válido
  if not TryStrToFloat(edtNuevaTasa.Text, NuevaTasa) then
  begin
    ShowMessage('La nueva tasa debe ser un número válido');
    edtNuevaTasa.SetFocus;
    Exit;
  end;

  // Validar que sea mayor que cero
  if NuevaTasa <= 0 then
  begin
    ShowMessage('La nueva tasa debe ser mayor que cero');
    edtNuevaTasa.SetFocus;
    Exit;
  end;

  // Validar que sea diferente a la actual
  if Abs(NuevaTasa - tasamoneda) < 0.001 then
  begin
    ShowMessage('La nueva tasa debe ser diferente a la actual');
    edtNuevaTasa.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TformCambioTasa.HabilitarControles(AHabilitar: Boolean);
begin
  edtNuevaTasa.Enabled := AHabilitar;
  btn1.Enabled := AHabilitar;
  btnCancelar.Enabled := not AHabilitar; // Cancelar solo disponible durante proceso
  pbProceso.Visible := not AHabilitar;
end;

procedure TformCambioTasa.btn1Click(Sender: TObject);
var
  NuevaTasa, Factor: Double;
  Mensaje: string;
  TotalRegistros: Integer;
begin
  if not ValidarDatos then
    Exit;

  NuevaTasa := StrToFloat(edtNuevaTasa.Text);
  Factor := NuevaTasa / tasamoneda;

  // Confirmar la operación
  Mensaje := Format('¿Está seguro de cambiar la tasa de %.2f a %.2f?' + #13#10 +
                   'Esta operación actualizará TODOS los precios en las ofertas.' + #13#10 +
                   'Factor de conversión: %.6f',
                   [tasamoneda, NuevaTasa, Factor]);

  if MessageDlg(Mensaje, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // Deshabilitar controles durante el proceso
  HabilitarControles(False);
  pbProceso.Visible := True;

  try
    lblEstado.Caption := 'Contando registros a actualizar...';
    lblEstado.Font.Color := clBlue;
    Application.ProcessMessages;

    // 1. Contar registros en data2
    with sqUpdateSinvOferta do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM sinvoferta WHERE FO_VISIBLE = TRUE';
      Open;
      TotalRegistros := FieldByName('TOTAL').AsInteger;
      Close;
    end;

    if TotalRegistros = 0 then
    begin
      ShowMessage('No hay registros para actualizar en sinvoferta');
      Exit;
    end;

    pbProceso.Max := 100;
    pbProceso.Position := 30;

    lblEstado.Caption := Format('Actualizando %d registros en data2...', [TotalRegistros]);
    Application.ProcessMessages;

    // 2. Actualizar precios en sinvoferta (data2)
    with sqUpdateSinvOferta do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'UPDATE sinvoferta SET ' +
        'FO_PRECIODESC = FO_PRECIODESC * :Factor, ' +
        'FO_MTOIMPUESTO1 = FO_MTOIMPUESTO1 * :Factor, ' +
        'FO_MTOIMPUESTO2 = FO_MTOIMPUESTO2 * :Factor, ' +
        'FO_MTOTOTAL = FO_MTOTOTAL * :Factor ' +
        'WHERE FO_VISIBLE = TRUE';

      ParamByName('Factor').AsFloat := Factor;
      ExecSQL; // Ejecutar sin asignar - DBISAM no retorna registros afectados
    end;

    pbProceso.Position := 70;

    lblEstado.Caption := 'Actualizando tabla de moneda...';
    Application.ProcessMessages;

    // 3. Actualizar tabla de moneda (data2)
    with sqTasa do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'UPDATE smoneda SET ' +
        'FM_LASTFACTOR = :TasaActual, ' +
        'FM_FACTOR = :NuevaTasa ' +
        'WHERE FM_CODE = 2';

      ParamByName('TasaActual').AsFloat := tasamoneda;
      ParamByName('NuevaTasa').AsFloat := NuevaTasa;
      ExecSQL; // Ejecutar sin asignar
    end;

    pbProceso.Position := 100;

    // Actualizar interfaz
    tasamoneda := NuevaTasa;
    edtTasaActual.Text := FormatFloat('0.00', tasamoneda);
    edtNuevaTasa.Text := '';

    lblEstado.Caption := Format('¡Completado! Se procesaron %d registros', [TotalRegistros]);
    lblEstado.Font.Color := clGreen;

    ShowMessage(Format('Actualización completada exitosamente.' + #13#10 +
                      'Se procesaron %d registros de ofertas.' + #13#10 +
                      'Nueva tasa establecida: %.2f',
                      [TotalRegistros, tasamoneda]));

  except
    on E: Exception do
    begin
      lblEstado.Caption := 'Error en la actualización';
      lblEstado.Font.Color := clRed;
      ShowMessage('Error durante la actualización: ' + E.Message);
    end;
  end;

  // Rehabilitar controles
  HabilitarControles(True);
  pbProceso.Visible := False;
end;

procedure TformCambioTasa.btnCancelarClick(Sender: TObject);
begin
  Close; // Simplificado - ya no hay thread que cancelar
end;

procedure TformCambioTasa.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True; // Simplificado - ya no hay proceso en curso que verificar
end;

end.
