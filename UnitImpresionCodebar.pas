unit UnitImpresionCodebar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, dbisamtb,
  frxClass, frxDBSet;

type
  TformCodebar = class(TForm)
    btn1: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    frdtEtiqueta3: TfrxDBDataset;
    frpPresentaciones: TfrxReport;
    frpInventario: TfrxReport;
    frdtDetalleEtiqueta2: TfrxDBDataset;
    frdtInventario: TfrxDBDataset;
    frdtPresentacion: TfrxDBDataset;
    SQDetEtiquetasPresentaciones1: TDBISAMQuery;
    SQPresentacion1: TDBISAMQuery;
    SQInventario1: TDBISAMQuery;
    SQDetalleetiquetaInventario1: TDBISAMQuery;
    procedure btn1Click(Sender: TObject);
  private
    CodigosImpresos: TStringList;
    ArchivoLog: string;
    procedure ImprimirTodasLasEtiquetas;
    procedure CargarCodigosImpresos;
    procedure GuardarCodigoImpreso(const Codigo: string);
    function CodigoYaImpreso(const Codigo: string): Boolean;
  public
    miFactor: Double; // Variable para el factor
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  formCodebar: TformCodebar;


implementation

uses
  UnitDatos;

{$R *.dfm}

constructor TformCodebar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CodigosImpresos := TStringList.Create;
  ArchivoLog := ExtractFilePath(Application.ExeName) + 'CodigosImpresos.txt';
  CargarCodigosImpresos;
end;

destructor TformCodebar.Destroy;
begin
  CodigosImpresos.Free;
  inherited Destroy;
end;

procedure TformCodebar.CargarCodigosImpresos;
begin
  CodigosImpresos.Clear;
  if FileExists(ArchivoLog) then
  begin
    try
      CodigosImpresos.LoadFromFile(ArchivoLog);
    except
      // Si hay error leyendo el archivo, crear uno vacío
      CodigosImpresos.Clear;
    end;
  end;
end;

procedure TformCodebar.GuardarCodigoImpreso(const Codigo: string);
begin
  if not CodigoYaImpreso(Codigo) then
  begin
    CodigosImpresos.Add(Codigo);
    try
      CodigosImpresos.SaveToFile(ArchivoLog);
    except
      ShowMessage('Error al guardar el código en el archivo: ' + Codigo);
    end;
  end;
end;

function TformCodebar.CodigoYaImpreso(const Codigo: string): Boolean;
begin
  Result := CodigosImpresos.IndexOf(Codigo) >= 0;
end;

procedure TformCodebar.btn1Click(Sender: TObject);
begin
  ImprimirTodasLasEtiquetas;
end;

procedure TformCodebar.ImprimirTodasLasEtiquetas;
var
  SQLText: string;
  SQLTextInventario: string;
  TasaStr: string;
  CodigoProducto: string;
begin
  // Inicializar el factor (ajusta según necesites)
   // O el valor que corresponda

  // Recargar la lista de códigos impresos al inicio
  CargarCodigosImpresos;

  // PASO 1: Procesar INVENTARIO - Consulta padre SQInventario1 (capacidad = 1)
  with SQInventario1 do
  begin
    Close;
    SQL.Clear;
    SQLTextInventario := 'SELECT I.FI_CODIGO, I.FI_DESCRIPCION, I.FI_STATUS, ' +
                         'I.FI_UNIDAD, I.FI_CAPACIDAD, C.FIC_P01PRECIOTOTALEXT ' +
                         'FROM SINVENTARIO AS I ' +
                         'INNER JOIN a2InvCostosPrecios AS C ON I.FI_CODIGO = C.FIC_CODEITEM ' +
                         'WHERE I.FI_STATUS = TRUE AND I.FI_CAPACIDAD = 1';
    SQL.Add(SQLTextInventario);
    Open;

    // SI SQInventario1 TIENE REGISTROS, SE IMPRIME
    if RecordCount > 0 then
    begin
      // Recorrer todos los registros de inventario
      First;
      while not EOF do
      begin
        CodigoProducto := FieldByName('FI_CODIGO').AsString;

        // Verificar si el código ya fue impreso
        if not CodigoYaImpreso(CodigoProducto) then
        begin
          // Para cada producto de inventario, ejecutar las dos consultas
          with SQDetalleetiquetaInventario1 do
          begin
            Close;
            SQL.Clear;
            SQLTextInventario := 'SELECT I.FI_CODIGO, I.FI_DESCRIPCION, I.FI_STATUS, ' +
                                 'I.FI_UNIDAD, I.FI_CAPACIDAD, ' +
                                 '(C.FIC_P01PRECIOTOTALEXT * 1.16) AS FIC_P01PRECIOTOTALEXT ' +
                                 'FROM SINVENTARIO AS I ' +
                                 'INNER JOIN a2InvCostosPrecios AS C ON I.FI_CODIGO = C.FIC_CODEITEM ' +
                                 'WHERE I.FI_STATUS = TRUE AND I.FI_CAPACIDAD <> 1 ' +
                                 'AND I.FI_CODIGO = ' + QuotedStr(CodigoProducto);
            SQL.Add(SQLTextInventario);
            Open;
          end;

          with SQDetEtiquetasPresentaciones1 do
          begin
            Close;
            SQL.Clear;
             TasaStr := StringReplace(FloatToStr(miFactor), ',', '.', [rfReplaceAll]);
    SQLText := 'SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, ' +
               '(FO_MTOTOTAL / ' + TasaStr + ') AS FO_MTOTOTAL ' +
               'FROM sinvoferta ' +
           'WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA <> 1 ' +
           'AND FO_PRODUCTO = ' + QuotedStr(CodigoProducto) +
           ' ORDER BY FO_UNDDESCARGA';
            SQL.Add(SQLText);
            Open;
          end;

          // Imprimir reporte de inventario


          // Para imprimir sin preparar (más rápido)
          frpInventario.PrintOptions.ShowDialog := False;
          frpInventario.PrepareReport;
          frpInventario.Print;
      //    frpInventario.ShowReport;

          // Registrar el código como impreso
          GuardarCodigoImpreso(CodigoProducto);
        end;

        // Avanzar al siguiente registro de inventario
        Next;
      end;
    end;
  end;

  // PASO 2: Procesar PRESENTACIONES - Consulta padre SQPresentacion1 (FO_UNDDESCARGA = 1)
  with SQPresentacion1 do
  begin
    Close;
    SQL.Clear;
    TasaStr := StringReplace(FloatToStr(miFactor), ',', '.', [rfReplaceAll]);
    SQLText := 'SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, ' +
               '(FO_MTOTOTAL / ' + TasaStr + ') AS FO_MTOTOTAL ' +
               'FROM sinvoferta ' +
               'WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA = 1 ' +
               'ORDER BY FO_PRODUCTO';
    SQL.Add(SQLText);
    Open;

    // SI SQPresentacion1 TIENE REGISTROS, SE IMPRIME
    if RecordCount > 0 then
    begin
      // Recorrer todos los registros de presentaciones
      First;
      while not EOF do
      begin
        CodigoProducto := FieldByName('FO_PRODUCTO').AsString;

        // Verificar si el código ya fue impreso
        if not CodigoYaImpreso(CodigoProducto) then
        begin
          // Para cada producto de presentación, ejecutar las dos consultas
          with SQDetalleetiquetaInventario1 do
          begin
            Close;
            SQL.Clear;
            SQLTextInventario := 'SELECT I.FI_CODIGO, I.FI_DESCRIPCION, I.FI_STATUS, ' +
                                 'I.FI_UNIDAD, I.FI_CAPACIDAD, ' +
                                 '(C.FIC_P01PRECIOTOTALEXT * 1.16) AS FIC_P01PRECIOTOTALEXT ' +
                                 'FROM SINVENTARIO AS I ' +
                                 'INNER JOIN a2InvCostosPrecios AS C ON I.FI_CODIGO = C.FIC_CODEITEM ' +
                                 'WHERE I.FI_STATUS = TRUE AND I.FI_CAPACIDAD <> 1 ' +
                                 'AND I.FI_CODIGO = ' + QuotedStr(CodigoProducto);
            SQL.Add(SQLTextInventario);
            Open;
          end;

          with SQDetEtiquetasPresentaciones1 do
          begin
            Close;
            SQL.Clear;
             TasaStr := StringReplace(FloatToStr(miFactor), ',', '.', [rfReplaceAll]);
             SQLText := 'SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, ' +
               '(FO_MTOTOTAL / ' + TasaStr + ') AS FO_MTOTOTAL ' +
               'FROM sinvoferta ' +
                       'WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA <> 1 ' +
                       'AND FO_PRODUCTO = ' + QuotedStr(CodigoProducto) +
                       ' ORDER BY FO_UNDDESCARGA';
            SQL.Add(SQLText);
            Open;
          end;

          // Imprimir reporte de presentaciones


          // Para imprimir sin preparar (más rápido)
        frpPresentaciones.PrintOptions.ShowDialog := False;
         frpPresentaciones.PrintOptions.ShowDialog := False;
         frpPresentaciones.Print;
      //    frpPresentaciones.ShowReport;

          // Registrar el código como impreso
          GuardarCodigoImpreso(CodigoProducto);
        end;

        // Avanzar al siguiente registro de presentaciones
        Next;
      end;
    end;
  end;

  ShowMessage('Proceso de impresión completado. Códigos omitidos: ' +
              IntToStr(CodigosImpresos.Count));
end;

end.
