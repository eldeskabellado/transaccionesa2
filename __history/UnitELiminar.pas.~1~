unit UnitELiminar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TformEliminar = class(TForm)
    pnl2: TPanel;
    lbl1: TLabel;
    edtCodigo: TEdit;
    btn2: TButton;
    pnl21: TPanel;
    btn21: TButton;
    procedure btn21Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formEliminar: TformEliminar;

implementation

uses
  UnitBuscarProducto, UnitDatos;

{$R *.dfm}

procedure TformEliminar.btn21Click(Sender: TObject);
begin
if edtCodigo.Text = '' then
begin
  ShowMessage('Debe Seleccionar un Producto');
end
else
begin
           with d.sqCambiarCodigo do
begin
  Close;
  SQL.Clear;
  SQL.Add('DELETE FROM Sinventario  WHERE FI_CODIGO = :FI_CODIGO');

  ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

  ExecSQL;

end;
//with d.sqCambiarCodigoOfertas do
//begin
//  Close;
//  SQL.Clear;
//  SQL.Add('UPDATE SInvOferta set FO_CODE = :NUEVOCODIGO WHERE FO_CODE = :FI_CODIGO');
//
// ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;
// ParamByName('NUEVOCODIGO').AsString:=edtNCodigo.Text;
// ExecSQL;
//end;

with d.sqCambiarCodigo do
begin
 Close;
  SQL.Clear;
 SQL.Add('DELETE FROM SinvDep WHERE FT_CODIGOPRODUCTO = :FI_CODIGO');

 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ExecSQL;
end;

with d.sqCambiarCodigo do
begin
   Close;
  SQL.Clear;
   SQL.Add('DELETE FROM Sfixed WHERE FX_CODIGO = :FI_CODIGO AND FX_TIPO = :TIPO');

 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ParamByName('TIPO').AsString:='B';
 ExecSQL;
end;

with d.sqCambiarCodigo do
begin
 Close;
  SQL.Clear;
 SQL.Add('DELETE FROM SDetalleVenta  WHERE FDI_CODIGO = :FI_CODIGO');

 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ExecSQL;
end;
with d.sqCambiarCodigo do
begin
 Close;
  SQL.Clear;
 SQL.Add('DELETE FROM SDetallePartes WHERE FDC_CODEPRODUCTO = :FI_CODIGO');

 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ExecSQL;
end;
with d.sqCambiarCodigo do
begin
 Close;
  SQL.Clear;
  SQL.Add('DELETE FROM SDetalleInv WHERE FDI_CODIGO = :FI_CODIGO');

 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ExecSQL;
end;
with d.sqCambiarCodigo do
begin
 Close;
  SQL.Clear;
 SQL.Add('DELETE FROM SDetalleCompra WHERE FDI_CODIGO = :FI_CODIGO');

 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ExecSQL;
end;
with d.sqCambiarCodigo do
begin
 Close;
  SQL.Clear;
 SQL.Add('DELETE FROM a2InvCostosPrecios WHERE FIC_CODEITEM = :FI_CODIGO');
 ParamByName('FI_CODIGO').AsString:=edtCodigo.Text;

 ExecSQL;
end;
 ShowMessage('PRODUCTO ELIMINADO EXITOSAMENTE');
 edtCodigo.Clear;
 edtCodigo.SetFocus;
end;
end;

procedure TformEliminar.btn2Click(Sender: TObject);
begin
 formbuscarProducto:= TformbuscarProducto.Create(Application);
      try
          with formbuscarProducto do
          begin
          Caption:= 'SELECCIONES PRODUCTO';


          ShowModal;
          end;

      finally
       edtCodigo.Text:=formbuscarProducto.codigoproducto;
       formbuscarProducto.Free;
      end;
end;

end.
