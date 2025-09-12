unit FormProducta2U;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFormProducta2 = class(TForm)
    // Sección de Idioma (RadioGroup adicional)
    rgIdioma: TRadioGroup;

    // F1.Básico
    gbBasico: TGroupBox;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblDescripcion: TLabel;
    edtDescripcion: TEdit;
    lblCategoria: TLabel;
    cbCategoria: TComboBox;
    lblIVA: TLabel;
    cbIVA: TComboBox;
    lblCosto: TLabel;
    edtCosto: TEdit;
    lblDivisaCosto: TLabel;
    edtDivisaCosto: TEdit;
    lblGanancia: TLabel;
    edtGanancia: TEdit;
    lblPrecio: TLabel;
    edtPrecio: TEdit;
    lblDivisaPrecio: TLabel;
    edtDivisaPrecio: TEdit;
    cbDivisaAuto: TCheckBox;

    // F2.Mayor (Grid para precios al mayor)
    gbMayor: TGroupBox;
    sgMayor: TStringGrid;

    // F3.Comprar
    gbComprar: TGroupBox;
    lblBulto: TLabel;
    edtBulto: TEdit;
    lblCant: TLabel;
    edtCant: TEdit;
    lblStock: TLabel;
    edtStock: TEdit;

    // Botones inferiores
    btnGuardar: TButton;
    btnEtiqueta: TButton;
    btnStock: TButton;
    btnEntradas: TButton;
    btnBarras: TButton;
    btnSupBor: TButton;

    procedure FormCreate(Sender: TObject);
  end;

var
  FormProducta2: TFormProducta2;

implementation

{$R *.dfm}

// Aquí puedes inicializar valores del RadioGroup y combos
procedure TFormProducta2.FormCreate(Sender: TObject);
begin
  rgIdioma.Items.Add('Español');
  rgIdioma.Items.Add('Chino Tradicional');
  rgIdioma.ItemIndex := 0;

  cbCategoria.Items.Add('1 - Otro');
  cbCategoria.Items.Add('2 - Ferretería');
  cbCategoria.Items.Add('3 - QUINCALLERIA');
  cbIVA.Items.Add('16%');
  cbIVA.Items.Add('8%');
  cbIVA.Items.Add('0%');
  cbDivisaAuto.Caption := 'Automático';

  // Configuración de grid sgMayor
  sgMayor.ColCount := 6;
  sgMayor.RowCount := 5;
  sgMayor.Cells[0,0] := 'Precio';
  sgMayor.Cells[1,0] := 'Paquete';
  sgMayor.Cells[2,0] := 'Nota';
  sgMayor.Cells[3,0] := 'Ganancia %';
  sgMayor.Cells[4,0] := 'Divisa';
  sgMayor.Cells[5,0] := 'Automático';
end;

end.
