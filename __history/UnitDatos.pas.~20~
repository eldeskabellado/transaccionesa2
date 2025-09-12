unit UnitDatos;

interface

uses
  System.SysUtils, System.Classes, Data.DB, dbisamtb, Datasnap.Provider,
  Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Td = class(TDataModule)
    datprincipal: TDBISAMDatabase;
    data2: TDBISAMDatabase;
    sqconfig: TDBISAMQuery;
    sqoperacioninv: TDBISAMQuery;
    sqdetalleventa: TDBISAMQuery;
    sqborrarfactura: TDBISAMQuery;
    sqcontar: TDBISAMQuery;
    sqborrarproductos: TDBISAMQuery;
    squsuarios: TDBISAMQuery;
    datlocal: TDBISAMDatabase;
    sqserie: TDBISAMQuery;
    dsSERIE: TDataSource;
    sqFacturas: TDBISAMQuery;
    sqVendedores: TDBISAMQuery;
    dtmfldFacturasFCC_FECHAVENCIMIENTO: TDateTimeField;
    mfldFacturasFCC_DESCRIPCIONMOV: TMemoField;
    sqFacturasFCC_SALDODOCUMENTO: TCurrencyField;
    sqFacturasFCC_MONTODOCUMENTO: TCurrencyField;
    dtmfldFacturasFCC_FECHAEMISION: TDateTimeField;
    intgrfldFacturasFCC_TIPOTRANSACCION: TIntegerField;
    fieldFacturasFCC_NUMERO: TStringField;
    fieldFacturasFCC_CODIGO: TStringField;
    fieldFacturasFCC_NROVENDEDOR: TStringField;
    fieldFacturasFC_DESCRIPCION: TStringField;
    fieldFacturasFC_RIF: TStringField;
    fieldFacturasFC_CONTACTO: TStringField;
    fieldFacturasFC_TELEFONO: TStringField;
    fieldVendedoresFV_CODIGO: TStringField;
    fieldVendedoresFV_DESCRIPCION: TStringField;
    blnfldVendedoresFV_STATUS: TBooleanField;
    blnfldVendedoresFV_CLASIFICACION: TBooleanField;
    fieldVendedoresFV_CLAVE: TStringField;
    smlntfldVendedoresFV_TIPO: TSmallintField;
    mfldVendedoresFV_DESCRIPCIONDETALLADA: TMemoField;
    mfldVendedoresFV_DIRECCION: TMemoField;
    fieldVendedoresFV_TELEFONOS: TStringField;
    fieldVendedoresFV_EMAIL: TStringField;
    blnfldVendedoresFV_TIENEPRECIO: TBooleanField;
    blnfldVendedoresFV_TIENEVENTA: TBooleanField;
    blnfldVendedoresFV_TIENECOBRO: TBooleanField;
    blnfldVendedoresFV_TIENETABLAUTILIDAD: TBooleanField;
    blnfldVendedoresFV_TIENECATEGORIA: TBooleanField;
    blnfldVendedoresFV_FLAGTABLAUTILIDAD: TBooleanField;
    blnfldVendedoresFV_TIENETOLERANCIA: TBooleanField;
    blnfldVendedoresFV_FLAGTOLERANCIA: TBooleanField;
    intgrfldVendedoresFV_INDEXPORCENT: TIntegerField;
    crncyfldVendedoresFV_COMISIONVTA1: TCurrencyField;
    crncyfldVendedoresFV_COMISIONVTA2: TCurrencyField;
    crncyfldVendedoresFV_COMISIONVTA3: TCurrencyField;
    crncyfldVendedoresFV_COMISIONVTA4: TCurrencyField;
    crncyfldVendedoresFV_COMISIONVTA5: TCurrencyField;
    crncyfldVendedoresFV_COMISIONVTA6: TCurrencyField;
    crncyfldVendedoresFV_COMISIONVTAMIN: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOB1: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOB2: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOB3: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOB4: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOB5: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOB6: TCurrencyField;
    crncyfldVendedoresFV_COMISIONCOBMIN: TCurrencyField;
    blbfldVendedoresFV_TOLERANCIA: TBlobField;
    blbfldVendedoresFV_TABLACOMVOLUMEN: TBlobField;
    blbfldVendedoresFV_TABLATOLERANCIA: TBlobField;
    blbfldVendedoresFV_TABLAUTILIDAD: TBlobField;
    fieldVendedoresFV_ZONAVENTA: TStringField;
    blnfldVendedoresFV_SUPERVISOR: TBooleanField;
    fieldVendedoresFV_GRUPO: TStringField;
    atncfldVendedoresBASE_AUTOINCREMENT: TAutoIncField;
    fieldVendedoresFV_SERIE: TStringField;
    fieldVendedoresFV_MSGTEXTO1: TStringField;
    fieldVendedoresFV_MSGTEXTO2: TStringField;
    fieldVendedoresFV_MSGTEXTO3: TStringField;
    fieldVendedoresFV_MSGTEXTO4: TStringField;
    fieldVendedoresFV_MSGTEXTO5: TStringField;
    fieldVendedoresFV_CODENOMINA: TStringField;
    fieldVendedoresFV_PATHNOMINA: TStringField;
    fieldVendedoresFV_INTEGRANTE: TStringField;
    fieldVendedoresFV_CONSTANTECOM: TStringField;
    crncyfldVendedoresFV_PORCENTMETAUP: TCurrencyField;
    crncyfldVendedoresFV_PORCENTMETADOWN: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS1: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS2: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS3: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS4: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS5: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS6: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS7: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS8: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS9: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS10: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS11: TCurrencyField;
    crncyfldVendedoresFV_METAVENTAS12: TCurrencyField;
    crncyfldVendedoresFV_PORCENTSVENTA: TCurrencyField;
    dtmfldFacturasFCC_ULTFECHAABONO: TDateTimeField;
    fieldFacturasFCC_FACTORCAMBIO: TFloatField;
    crncyfldFacturasFCC_MONTOMONEDAEXT: TCurrencyField;
    fieldFacturasFCC_SERIE: TStringField;
    dtmfldFacturasFCC_FECHAPROXIMA: TDateTimeField;
    sqLista: TDBISAMQuery;
    fieldListaFL_CODIGO: TStringField;
    fieldListaFI_DESCRIPCION: TStringField;
    fieldListaFL_LOTE: TStringField;
    crncyfldListaFL_COSTO: TCurrencyField;
    crncyfldListaFL_PRECIOSINIMPUESTO: TCurrencyField;
    crncyfldListaFL_MONTOIMPUESTO1: TCurrencyField;
    crncyfldListaFL_MONTOIMPUESTO2: TCurrencyField;
    fieldListaFT_CODIGOPRODUCTO: TStringField;
    crncyfldListaExistencia: TCurrencyField;
    crncyfldListaFL_PRECIOIMPORTADO: TCurrencyField;
    sqListaFL_VENCIMIENTO: TDateField;
    fieldListaZZCAMPO_001: TStringField;
    sqbuscarProducto: TDBISAMQuery;
    fieldProductoFI_CODIGO: TStringField;
    fieldProductoFI_DESCRIPCION: TStringField;
    fieldProductoFIC_P01PRECIOTOTALEXT: TFloatField;
    sqCambiarCodigo: TDBISAMQuery;
    sqVerificarCodigo: TDBISAMQuery;
    sqLicores: TDBISAMQuery;
    sqLicoresEntrada: TDBISAMQuery;
    ds1: TClientDataSet;
    dtsp1: TDataSetProvider;
    fieldds1FTI_RIFCLIENTE: TStringField;
    fieldds1DOCUMENTO: TStringField;
    dtmfldds1FTI_FECHAEMISION: TDateTimeField;
    intgrfldds1FTI_TIPO: TIntegerField;
    intgrfldds1FTI_STATUS: TIntegerField;
    fieldds1ESPECIE: TStringField;
    fieldds1FTI_PERSONACONTACTO: TStringField;
    fieldds1FTI_ZONAVENTA: TStringField;
    fieldds1FTI_SERIE: TStringField;
    fieldds1FDI_CODIGO: TStringField;
    intgrfldds1FDI_DEPOSITOSOURCE: TIntegerField;
    fieldds1FDI_CANTIDAD: TFloatField;
    fieldds1FI_DESCRIPCION: TStringField;
    fieldds1FI_CATEGORIA: TStringField;
    fieldds1LTS: TStringField;
    fieldds1FI_MARCA: TStringField;
    fieldds1GRADOALCOHOLICO: TStringField;
    crncyfldds1CAPACIDAD: TCurrencyField;
    fieldds1NACIONALIMPORTADO: TStringField;
    crncyfldds1COMISION: TCurrencyField;
    fieldds1DESTINO: TStringField;
    crncyfldds1totallitros: TCurrencyField;
    tmemSalidas: TFDMemTable;
    fieldSalidasFTI_RIFCLIENTE: TStringField;
    fieldSalidasFTI_DOCUMENTO: TStringField;
    tmemSalidasFTI_FECHAEMISION: TDateField;
    fieldSalidasFTI_TIPO: TStringField;
    fieldSalidasFTI_STATUS: TStringField;
    fieldSalidasESPECIE: TStringField;
    fieldSalidasFTI_PERSONACONTACTO: TStringField;
    fieldSalidasFDI_CODIGO: TStringField;
    crncyfldSalidasFDI_CANTIDAD: TCurrencyField;
    fieldSalidasFI_DESCRIPCION: TStringField;
    fieldSalidasGRADOALCOHOLICO: TStringField;
    crncyfldSalidasCAPACIDAD: TCurrencyField;
    fieldSalidasNACIONALIMPORTADO: TStringField;
    crncyfldSalidasTOTALVENTA: TCurrencyField;
    fieldSalidasFI_CATEGORIA: TStringField;
    tmemEntradas: TFDMemTable;
    field: TStringField;
    field1: TStringField;
    DateField1: TDateField;
    field2: TStringField;
    field3: TStringField;
    field4: TStringField;
    field5: TStringField;
    field6: TStringField;
    crncyfld: TCurrencyField;
    field7: TStringField;
    field8: TStringField;
    crncyfld1: TCurrencyField;
    field9: TStringField;
    crncyfld2: TCurrencyField;
    field10: TStringField;
    sqCompras: TDBISAMQuery;
    sqVentas: TDBISAMQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  d: Td;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
