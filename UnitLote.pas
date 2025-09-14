unit UnitLote;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, dbisamtb;

type
  TformLotes = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    btnCancelar: TButton;
    DBGrid1: TDBGrid;
    sqLotes: TDBISAMQuery;
    dsLotes: TDataSource;
    procedure btnCancelarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure CargarLotes(const CodigoArticulo: string);
  public
    { Public declarations }
    loteSeleccionado: string;
    loteVencimiento: string;
    loteCodigoRandon: Integer;
    function MostrarLotes(const CodigoArticulo: string): TModalResult;
  end;

var
  formLotes: TformLotes;

implementation

uses
  UnitDatos;

{$R *.dfm}

procedure TformLotes.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TformLotes.DBGrid1DblClick(Sender: TObject);
begin
  if not sqLotes.IsEmpty then
  begin
    // Capturar los valores seleccionados
    loteSeleccionado := sqLotes.FieldByName('FL_LOTE').AsString;
    loteVencimiento := sqLotes.FieldByName('FL_VENCIMIENTO').AsString;
    loteCodigoRandon := sqLotes.FieldByName('FL_RANDOM').AsInteger;

    // Cerrar el modal con resultado OK
    ModalResult := mrOk;
  end;
end;

procedure TformLotes.CargarLotes(const CodigoArticulo: string);
begin
  try
    sqLotes.Close;
    sqLotes.SQL.Clear;
    sqLotes.SQL.Add('SELECT FL_CODIGO, FL_LOTE, FL_RANDOM, FL_VENCIMIENTO');
    sqLotes.SQL.Add('FROM SInvlote');
    sqLotes.SQL.Add('WHERE FL_CODIGO = :codigo');

    sqLotes.ParamByName('codigo').AsString := CodigoArticulo;
    sqLotes.Open;
  except
    on E: Exception do
      ShowMessage('Error al cargar lotes: ' + E.Message);
  end;
end;

function TformLotes.MostrarLotes(const CodigoArticulo: string): TModalResult;
begin
  // Limpiar variables
  loteSeleccionado := '';
  loteVencimiento := '';
  loteCodigoRandon := 0;

  // Cargar los lotes del artículo
  CargarLotes(CodigoArticulo);

  // Mostrar el formulario como modal
  Result := ShowModal;
end;

end.

