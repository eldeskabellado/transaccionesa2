program Gerencia;

uses
  Vcl.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {Form2},
  UnitAcceso in 'UnitAcceso.pas' {formAcceso},
  UnitDatos in 'UnitDatos.pas' {d: TDataModule},
  UnitProceso in 'UnitProceso.pas' {FormProcesos},
  funciones in 'funciones.pas',
  cifrado in 'cifrado.pas',
  SeMD5 in 'SeMD5.pas',
  SeAES256 in 'SeAES256.pas',
  SeBase64 in 'SeBase64.pas',
  SeEasyAES in 'SeEasyAES.pas',
  SeSHA256 in 'SeSHA256.pas',
  SeStreams in 'SeStreams.pas',
  Unit_VER_FACTURA in 'Unit_VER_FACTURA.pas' {FormVerFactura},
  UnitVerificar in 'UnitVerificar.pas' {FormVerificar},
  sicm in 'sicm.pas',
  UnitCXC in 'UnitCXC.pas' {formComisiones},
  UnitEditFactura in 'UnitEditFactura.pas' {formEditFactura},
  UnitBuscarProducto in 'UnitBuscarProducto.pas' {formbuscarProducto},
  UnitProductos in 'UnitProductos.pas' {formProductos},
  UnitEtiquetas in 'UnitEtiquetas.pas' {formEtiquetas},
  UnitCambiarCodigo in 'UnitCambiarCodigo.pas' {CambiarCo},
  UnitELiminar in 'UnitELiminar.pas' {formEliminar},
  UnitLicores in 'UnitLicores.pas' {formLicores},
  UnitClave in 'UnitClave.pas' {formClave},
  UnitpProductosVendidos in 'UnitpProductosVendidos.pas' {formProductosVendidos};

{$R *.res}

begin
  begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(Td, d);
  Application.CreateForm(TformProductosVendidos, formProductosVendidos);
  if TformAcceso.Execute then
  begin
    Application.Initialize;
    Application.CreateForm(Tform2, form2);
    Application.Run;
  end
  else
  begin
     D.Destroy;
    Application.Terminate;
  end;
  end;
end.
