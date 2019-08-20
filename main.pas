unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SimpleFFT, StdCtrls, ExtCtrls;

type

  TDemoMode = (dmNone, dmUse);

  TPosCoobe = record
    height,width:integer;
  end;

  TForm1 = class(TForm)
    mainImg: TImage;
    fftImg: TImage;
    FilterImg: TImage;
    loadMainImage: TButton;
    Filter: TCheckBox;
    invFFT: TCheckBox;
    Label5: TLabel;
    Label3: TLabel;
    RBModule: TRadioButton;
    RBPhase: TRadioButton;
    RBReal: TRadioButton;
    RBImag: TRadioButton;
    HeightFilter: TLabeledEdit;
    WidthFilter: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Dsquer: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure loadMainImageClick(Sender: TObject);
    procedure ExecDemo(Sender:TObject);
  private
    DemoMode: TDemoMode;
    function GetDisplayMode:TProcessMode;
    procedure Save2DBmp(buf:TByte2DArray);
    procedure Load2DBmp(out buf:TByte2DArray);
    procedure LoadFilterBmp(out buf:TByte2DArray);
    procedure FreeFilterImg;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure Make8BitPal(pal:PLogPalette);

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure CreateEArr(out eArr:TComplex2DArray; Y_len:integer; X_len:integer);
var
  i,j:integer;
  e:TComplex;
begin
  SetLength(eArr,X_len,X_len);
  for i:=0 to Y_len-1 do
    for j:=0 to Y_len-1 do
      begin
         e.Real:=1;
         e.Imag:=0;
         eArr[i,j]:= e;
      end;

end;

procedure ArrPowArr(out outArr:TComplex2DArray; firstArr:TComplex2DArray; secondArr:TComplex2DArray);
var
  i,j,len:integer;
begin
   len:= Length(firstArr);
   SetLength(outArr,len,len);
   for i:=0 to len-1 do
    for j:=0 to len-1 do
      begin
        outArr[i,j].Real:=firstArr[i,j].Real*secondArr[i,j].Real;
        outArr[i,j].Imag:=firstArr[i,j].Imag*secondArr[i,j].Imag;
      end;

end;

procedure TForm1.FreeFilterImg;
var
  bmp:TBitmap;
  pPal:PLogPalette;
begin
  GetMem(pPal,1028);
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf8bit;
  Make8BitPal(pPal);
  bmp.Palette := CreatePalette(pPal^);
  bmp.Height := 256; bmp.Width := 256;
  FilterImg.Picture.Bitmap := bmp;
  bmp.Free;
  FreeMem(pPal);
  FilterImg.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  FilterImg.Picture.Bitmap.Canvas.Pen.Color := clWhite;
end;

procedure TForm1.Save2DBmp(buf:TByte2DArray);
var
  i,h:integer;
  bmp:TBitmap;
begin
  bmp := fftImg.Picture.Bitmap;
  h := bmp.Height;
    for i:=0 to h-1 do
      Move(buf[i,0],(bmp.ScanLine[i])^,h);
  fftImg.Refresh;
end;

procedure TForm1.ExecDemo(Sender:TObject);
begin
 if DemoMode = dmUse then
  loadMainImageClick(self);
end;

function TForm1.GetDisplayMode:TProcessMode;
begin
  if RBModule.Checked then Result := module
  else if RBPhase.Checked then Result := phase
  else if RBReal.Checked then Result := real
  else Result := imag;
end;

procedure TForm1.Load2DBmp(out buf:TByte2DArray);
var
  bmp:TBitmap;
  i,j,k,w,h:integer;
begin
  DemoMode := dmUse;
  h := 256;
  SetLength(buf,h,h);
  for i:=0 to h-1 do
    FillChar(buf[i,0],h,0);
  k := h div 2;
  w := StrToInt(Dsquer.Text) div 2;
  if (w<=0) or (w>k) then
    raise Exception.Create('Pulse size is out of range [2,255]');
  for i:=k-w+40 to k+w+40 do
    for j:=k-w-40 to k+w-40 do
      buf[i,j] := 255;
  Label1.Caption:=IntToStr(k-w-40);
  Label2.Caption:=IntToStr(k-w+40);
  bmp := mainImg.Picture.Bitmap;

  for i:=0 to h-1 do
    Move(buf[i,0],(bmp.ScanLine[i])^,h);
  mainImg.Refresh;
end;

procedure TForm1.LoadFilterBmp(out buf:TByte2DArray);
var
  bmp:TBitmap;
  i,j,k,w,h:integer;
begin
  DemoMode := dmUse;
  h := 256;
  w := StrToInt(Dsquer.Text) div 2;

  SetLength(buf,h,h);
  for i:=0 to h-1 do
    FillChar(buf[i,0],h,0);

  k := h div 2;
  if (w<=0) or (w>k) then
    raise Exception.Create('Pulse size is out of range [2,255]');

  for i:=0 to w*2 do
    for j:=0 to w*2 do
      buf[i,j] := 255;

  bmp := FilterImg.Picture.Bitmap;

  for i:=0 to h-1 do
    Move(buf[i,0],(bmp.ScanLine[i])^,h);
  FilterImg.Refresh;
end;

procedure Make8BitPal(pal:PLogPalette);
var
  i,j:integer;
  k:array[0..3] of byte absolute j;
begin
  pal^.palVersion := $300;
  pal^.palNumEntries := 256;
  for i:=0 to 255 do begin
    j:=i; k[1]:=i; k[2]:=i;
    pal^.palPalEntry[i] := TPaletteEntry(j);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  bmp:TBitmap;
  pPal:PLogPalette;
begin
  DemoMode := dmNone;
  GetMem(pPal,1028);
  //create a gray custom bitmap and assign it to both images
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf8bit;
  Make8BitPal(pPal);
  bmp.Palette := CreatePalette(pPal^);
  bmp.Height := 256; bmp.Width := 256;
  mainImg.Picture.Bitmap := bmp;
  fftImg.Picture.Bitmap := bmp;
  FilterImg.Picture.Bitmap := bmp;
  bmp.Free;
  FreeMem(pPal);
  mainImg.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  mainImg.Picture.Bitmap.Canvas.Pen.Color := clWhite;
  fftImg.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  fftImg.Picture.Bitmap.Canvas.Pen.Color := clWhite;
  FilterImg.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  FilterImg.Picture.Bitmap.Canvas.Pen.Color := clWhite;
end;

procedure Max(inp:TComplex2DArray; out x:integer; out y:integer);
var
  i,j,len:integer;
  value:double;
begin
  len:=Length(inp);
  value := inp[0,0].Real;
  x:=0;
  y:=0;
  for i:=0 to len-1 do
    for j:=0 to len-1 do
      if inp[i,j].Real>value then
        begin
          value := inp[i,j].Real;
          x :=j;
          y :=i;
        end;

end;

procedure TForm1.loadMainImageClick(Sender: TObject);
var
  finalArr,firstArr,secondArr,bArr,cArr,eArr:TComplex2DArray;
  i,j,len,X,Y:integer;
  buf,bufFilter:TByte2DArray;
  c, b:TComplex;

  f:double;
begin

  Load2DBmp(buf);

  c.Real := 0; c.Imag := 0;
  len := Length(buf);
  f:=1.0;
  SetLength(cArr,len,len);

  for i:=0 to len-1 do
    for j:=0 to len-1 do
      begin
        c.Real := buf[i,j];
        cArr[i,j] := c;
      end;

  ftu(1,len,cArr);

  if Filter.Checked then
  begin
    LoadFilterBmp(bufFilter);
    b.Real := 0; b.Imag := 0;
    len:=Length(bufFilter);
    SetLength(bArr,len,len);
    for i:=0 to len-1 do
      for j:=0 to len-1 do
        begin
          b.Real := bufFilter[i,j];
          bArr[i,j] := b;
        end;

    SetLength(finalArr,len,len);

    ftu(1,len,bArr);
    Reorder(bArr);
    ArrPowArr(firstArr,cArr,bArr);

    for i:=0 to len-1 do
      for j:=0 to len-1 do
        begin
          cArr[i,j].Real:=cArr[i,j].Real*cArr[i,j].Real;
          cArr[i,j].Imag:=cArr[i,j].Imag*cArr[i,j].Imag;
        end;

    CreateEArr(eArr,StrToInt(Dsquer.Text),len);
    Reorder(eArr);
    ArrPowArr(secondArr,cArr,eArr);

    ftu(-1,len,firstArr);
    ftu(-1,len,secondArr);

    for i:=0 to len-1 do
      for j:=0 to len-1 do
        begin
          finalArr[i,j].Real:=(f + firstArr[i,j].Real)/(f + secondArr[i,j].Real);
        end;
    Max(finalArr,X,Y);

    HeightFilter.Text:=IntToStr(X);
    WidthFilter.Text:=IntToStr(Y);

  end
  else begin
    finalArr:=cArr;
    FreeFilterImg;
  end;
  

  if InvFFT.Checked then ftu(-1,len,finalArr);


  Normalize(finalArr,buf,GetDisplayMode);

  Save2DBmp(buf);
end;

end.
