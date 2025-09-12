unit UnitAcceso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, JvDBLookup, Vcl.Imaging.pngimage;

type
  Str255 = String[255];
  TformAcceso = class(TForm)
    edtCedula: TEdit;
    edt2: TEdit;
    btn1: TButton;
    btn2: TButton;
    img1: TImage;
    lbl4: TLabel;
    lbl1: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    class function Execute: boolean;
    { Public declarations }
  end;
Const CRIPTPASSWORD   = 9281711.00;
var
  formAcceso: TformAcceso;
   licencia: string;
  directorioa2 : string;
  directorio_datos: string;


implementation

uses
  funciones, UnitDatos;

{$R *.dfm}
Function CriptClave ( Signo:ShortInt;Nombre : Str255; Cripto: Real) : String;
Var L,I: Byte;
    S: String;
    Temp: Array[0..255] Of Byte Absolute Nombre;
Begin
 Str(Trunc(Cripto),S);
 L:=Length(Nombre);
 While Length(S)<L Do
  S:=S+S;
 For I:=1 To L Do
   Temp[I]:=Temp[I] + (Ord(S[I])-48)*SigNo;
 CriptClave:= Nombre;
End { CriptClave };

procedure TformAcceso.btn1Click(Sender: TObject);
var
clave:string;
begin

clave:=CriptClave(1,edt2.Text,CriptPassword);

 // ShowMessage(funciones.serie);
  if UsuarioValido(UPPERCASE(edtCedula.Text), clave) then
    ModalResult := mrOK
  else
    ShowMessage('Sus datos son incorrectos.')

end;

procedure TformAcceso.btn2Click(Sender: TObject);
begin
Close;
end;

class function TformAcceso.Execute: Boolean;

begin
  with TformAcceso.Create(nil) do
    try
      Result := ShowModal = mrOK;
    finally
      Free;
    end;
end;


procedure TformAcceso.FormShow(Sender: TObject);
begin
edtCedula.Clear;
edt2.Clear;
edtCedula.SetFocus;
   with d.datprincipal do
        begin
        Connected:=False;
        Directory:='';
        DatabaseName:='datprincipal';
        Directory:='datos';
        Connected:=True;
        end;

         with d.sqconfig do
         begin
         close;
         ExecSQL;
         directorioa2:=FieldByName('ADMIN').AsString;
         directorio_datos:=FieldByName('DATOS').AsString;
         end;
    with d.data2 do
        begin
        Connected:=False;
        Directory:='';
        DatabaseName:='data2';
        Directory:=directorioa2+'\'+directorio_datos;
        Connected:=True;
        end;
    serie:=d.sqconfig.FieldByName('CELULAR').AsString;
end;

end.
