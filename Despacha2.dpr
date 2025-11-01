program Despacha2;

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
  UnitpProductosVendidos in 'UnitpProductosVendidos.pas' {formProductosVendidos},
  UnitEditarCompra in 'UnitEditarCompra.pas' {FormEditarCompra},
  UnitListaPrecios in 'UnitListaPrecios.pas' {FormLista},
  unitvariables in 'unitvariables.pas',
  UnitVariablesGlobales in 'UnitVariablesGlobales.pas',
  UnitiCompras in 'UnitiCompras.pas' {formiCompras},
  UnitFormProductos in 'UnitFormProductos.pas' {formArticulos},
  UnitBuscarProductos in 'UnitBuscarProductos.pas' {formBuscarArticulo},
  UnitPresentacion in 'UnitPresentacion.pas' {formPresentaciones},
  UnitFactor in 'UnitFactor.pas' {formCambioTasa},
  UnitImpresionCodebar in 'UnitImpresionCodebar.pas' {formCodebar},
  UnitPedido in 'UnitPedido.pas' {formPedido},
  UnitLote in 'UnitLote.pas' {formLotes},
  UnitExportListas in 'UnitExportListas.pas' {formExport},
  UnitAcercade in 'UnitAcercade.pas' {formConectar},
  EvolutionAPI in 'Evolution\EvolutionAPI.pas',
  EvolutionConfigReader in 'Evolution\EvolutionConfigReader.pas',
  ConfigEncryption in 'Evolution\ConfigEncryption.pas',
  UnitFormCXP in 'UnitFormCXP.pas' {formCXP};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // Crear solo los componentes esenciales
  Application.CreateForm(Td, d);
  Application.CreateForm(TForm2, Form2);

  // NO crear formCXP aquí - se creará cuando se necesite
  // Application.CreateForm(TformCXP, formCXP);  // <-- ELIMINAR ESTA LÍNEA

  // Mostrar formulario de acceso
  if TformAcceso.Execute then
  begin
    // Login exitoso - mostrar formulario principal
    Form2.Show;
    Application.Run;
  end
  else
  begin
    // Login fallido - cerrar aplicación
    D.Free;
    Application.Terminate;
  end;
end.
