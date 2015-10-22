unit MyLayout;

interface

uses
    System.SysUtils, System.Classes, System.Types, System.UITypes, System.UIConsts,
    FMX.Types, FMX.Controls, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Graphics;
type
  TMyLayout = class(TStyledControl)
  private
  // Variables Objetos
      _textTempMin, _textTempMedium, _textTempMax: string;
      _textHumidity, _textWind: string;
      _textDate: string;

      _urlImageWeather: string;
      _urlImageTermBlue, _urlImageTermOrange, _urlImageTermRed: string;
      _urlImageWind, _urlImageDrop: string;

      _rectDateColor: TAlphaColor;
      _textDateColor: TAlphaColor;

  // Objetos Visibles
      imgWeather: TImage;
      rectDate: TRectangle;
      txtDate: TText;
      layContent: TLayout;
      layRow1: TLayout;
      layRow2: TLayout;

      imgTermBlue: TImage;
      txtMin: TText;
      imgTermOrange: TImage;
      txtMedium: TText;
      imgTermRed: TImage;
      txtMax: TText;
      imgWind: TImage;
      txtWind: TText;
      imgDrop: TImage;
      txtHumidity: TText;

  // SETTERS
    procedure SetRectDateColor(const Value: TAlphaColor);
    procedure SetTextDateColor(const Value: TAlphaColor);

    procedure SetTextMin(const Value: string);
    procedure SetTextMedium(const Value: string);
    procedure SetTextMax(const Value: string);
    procedure SetTextHumidity(const Value: string);
    procedure SetTextWind(const Value: string);
    procedure SetTextDate(const Value: string);

    procedure SetUrlImageWeather(const Value: string);
    procedure SetUrlImageTermBlue(const Value: string);
    procedure SetUrlImageTermOrange(const Value: string);
    procedure SetUrlImageTermRed(const Value: string);
    procedure SetUrlImageWind(const Value: string);
    procedure SetUrlImageDrop(const Value: string);

  // UPDATES
    procedure Update;

  protected
    { Protected declarations }
    function GetStyleObject: TFmxObject; override;
    procedure ApplyStyle; override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    { Published declarations }
    property Align;
    property Anchors;
    property Cursor;
    property Height;
    property Position;
    property Visible;
    property Width;

    property ColorDateRect: TAlphaColor read _rectDateColor write SetRectDateColor;
    property ColorDateText: TAlphaColor read _textDateColor write SetTextDateColor;

    property TextTempMin: string read _textTempMin write SetTextMin;
    property TextTempMedium: string read _textTempMedium write SetTextMedium;
    property TextTempMax: string read _textTempMax write SetTextMax;
    property TextHumidity: string read _textHumidity write SetTextHumidity;
    property TextWind: string read _textWind write SetTextWind;
    property TextDate: string read _textDate write SetTextDate;

    property UrlImageWeather: string read _urlImageWeather write SetUrlImageWeather;
    property UrlImageTermBlue: string read _urlImageTermBlue write SetUrlImageTermBlue;
    property UrlImageTermOrange: string read _urlImageTermOrange write SetUrlImageTermOrange;
    property UrlImageTermRed: string read _urlImageTermRed write SetUrlImageTermRed;
    property UrlImageWind: string read _urlImageWind write SetUrlImageWind;
    property UrlImageDrop: string read _urlImageDrop write SetUrlImageDrop;


  end;

procedure Register;

implementation

uses
   FMX.Styles;

procedure Register;
begin
  RegisterComponents('AlexPalette', [TMyLayout]);
end;


// ************************************* CREATE & UPDATE

constructor TMyLayout.Create(AOwner: TComponent);
begin
  inherited;
  Align := TAlignLayout.alTop;
  Height := 110;

// Variables de Objetos
  _rectDateColor := claChocolate;
  _textDateColor := claWhite;
end;


procedure TMyLayout.Update;
begin
    Self.BeginUpdate;

    try
  // Actualizamos Variables
      if (imgWeather <> nil) and (_urlImageWeather <> '') then
        imgWeather.Bitmap.LoadFromFile(_urlImageWeather);

      if (imgTermBlue <> nil) and (_urlImageTermBlue <> '') then
        imgTermBlue.Bitmap.LoadFromFile(_urlImageTermBlue);
      if (imgTermOrange <> nil) and (_urlImageTermOrange <> '') then
        imgTermOrange.Bitmap.LoadFromFile(_urlImageTermOrange);
      if (imgTermRed <> nil) and (_urlImageTermRed <> '') then
        imgTermRed.Bitmap.LoadFromFile(_urlImageTermRed);

      if (imgWind <> nil) and (_urlImageWind <> '') then
        imgWind.Bitmap.LoadFromFile(_urlImageWind);
      if (imgDrop <> nil) and (_urlImageDrop <> '') then
        imgDrop.Bitmap.LoadFromFile(_urlImageDrop);

      if rectDate <> nil then
        rectDate.Fill.Color := _rectDateColor;
      if txtDate <> nil then
        txtDate.Text := _textDate;
      if txtDate <> nil then
        txtDate.Color := _textDateColor;

       if txtMin <> nil then
        txtMin.Text := _textTempMin;
       if txtMedium <> nil then
        txtMedium.Text := _textTempMedium;
       if txtMax <> nil then
        txtMax.Text := _textTempMax;
       if txtWind <> nil then
        txtWind.Text := _textWind;
       if txtHumidity <> nil then
        txtHumidity.Text := _textHumidity;

    finally
      Self.EndUpdate;
      Self.Repaint;
    end;
end;



// ***********************************  SETTERS

procedure TMyLayout.SetTextMin(const Value: string);
begin
    _textTempMin := Value;
    Update;
end;

procedure TMyLayout.SetTextMedium(const Value: string);
begin
    _textTempMedium := Value;
    Update;
end;

procedure TMyLayout.SetTextMax(const Value: string);
begin
    _textTempMax := Value;
    Update;
end;

procedure TMyLayout.SetTextHumidity(const Value: string);
begin
    _textHumidity := Value;
    Update;
end;

procedure TMyLayout.SetTextWind(const Value: string);
begin
    _textWind := Value;
    Update;
end;

procedure TMyLayout.SetTextDate(const Value: string);
begin
    _textDate := Value;
    Update;
end;


// IMAGES
procedure TMyLayout.SetUrlImageWeather(const Value: string);
begin
    _urlImageWeather := Value;
    Update;
end;

procedure TMyLayout.SetUrlImageTermBlue(const Value: string);
begin
    _urlImageTermBlue := Value;
    Update;
end;

procedure TMyLayout.SetUrlImageTermOrange(const Value: string);
begin
    _urlImageTermOrange := Value;
    Update;
end;

procedure TMyLayout.SetUrlImageTermRed(const Value: string);
begin
    _urlImageTermRed := Value;
    Update;
end;

procedure TMyLayout.SetUrlImageWind(const Value: string);
begin
    _urlImageWind := Value;
    Update;
end;

procedure TMyLayout.SetUrlImageDrop(const Value: string);
begin
    _urlImageDrop := Value;
    Update;
end;


// COLORS
procedure TMyLayout.SetRectDateColor(const Value: TAlphaColor);
begin
    _rectDateColor := Value;
    Update;
end;

procedure TMyLayout.SetTextDateColor(const Value: TAlphaColor);
begin
    _textDateColor := Value;
    Update;
end;



// *******************************************  STYLES

function TMyLayout.GetStyleObject: TFmxObject;
var
 FRectDate: TRectangle;
  FLayContent: TLayout;
  FLayRow1: TLayout;
  FLayRow2: TLayout;

  FWrap1: TLayout;
  FWrap2: TLayout;
  FWrap3: TLayout;
  FWrap4: TLayout;
  FWrap5: TLayout;
begin
  Result := TLayout.Create(nil);

  // IZQUIERDA
  with TImage.Create(Result) do
  begin
    StyleName := 'ImageWeather';
    Parent := Result;
    Align := TAlignLayout.alLeft;
    Margins.Left := 5;
    Width := 80;
    Visible := True;
  end;


// CABECERA
  FRectDate := TRectangle.Create(Result);
  with FRectDate do
  begin
    StyleName := 'RectDate';
    Parent := Result;
    Sides := [];
    Align := TAlignLayout.alTop;
    Fill.Color := _rectDateColor;
    Height := 25;
    Visible := True;
  end;

  with TText.Create(Result) do
  begin
    StyleName := 'TextDate';
    Parent := FRectDate;
    Align := TAlignLayout.alContents;
    Color := _textDateColor;
    Text := _textDate;
    Font.Size := 13;
    Font.Style := [TFontStyle.fsBold];
    Visible := True;
  end;


// CONTENIDO
  FLayContent := TLayout.Create(Result);
  with FLayContent do
  begin
    StyleName := 'LayContent';
    Parent := Result;
    Align := TAlignLayout.alClient;
    Visible := True;
  end;

  FLayRow1 := TLayout.Create(Result);
  with FLayRow1 do
  begin
    StyleName := 'LayRow1';
    Parent := FLayContent;
    Align := TAlignLayout.alTop;
    Visible := True;
  end;

  FLayRow2 := TLayout.Create(Result);
  with FLayRow2 do
  begin
    StyleName := 'LayRow2';
    Parent := FLayContent;
    Align := TAlignLayout.alBottom;
    Visible := True;
  end;

// ROW 1
  FWrap1 := TLayout.Create(Result);
  with FWrap1 do
  begin
    Parent := FLayRow1;
    Align := TAlignLayout.alLeft;
    Margins.Left := 15;
    Width := 80;
    Visible := True;
  end;

  with TImage.Create(Result) do
  begin
    StyleName := 'ImageTempMin';
    Parent := FWrap1;
    Align := TAlignLayout.alLeft;
    Width := 18;
    Visible := True;
  end;

  with TText.Create(Result) do
  begin
    StyleName := 'TextTempMin';
    Parent := FWrap1;
    Align := TAlignLayout.alLeft;
    Color := claBlack;
    Font.Size := 15;
    HorzTextAlign := TTextAlign.taLeading;
    Margins.Left := 5;
    Width := 40;
    Position.X := 23;
    Visible := True;
  end;


  FWrap2 := TLayout.Create(Result);
  with FWrap2 do
  begin
    Parent := FLayRow1;
    Align := TAlignLayout.alLeft;
    Position.X := 95;
    Width := 80;
    Visible := True;
  end;

   with TImage.Create(Result) do
  begin
    StyleName := 'ImageTempMedium';
    Parent := FWrap2;
    Align := TAlignLayout.alLeft;
    Width := 18;
    Visible := True;
  end;

  with TText.Create(Result) do
  begin
    StyleName := 'TextTempMedium';
    Parent := FWrap2;
    Align := TAlignLayout.alLeft;
    Color := claBlack;
    Font.Size := 15;
    HorzTextAlign := TTextAlign.taLeading;
    Margins.Left := 5;
    Width := 40;
    Position.X := 23;
    Visible := True;
  end;


  FWrap3 := TLayout.Create(Result);
  with FWrap3 do
  begin
    Parent := FLayRow1;
    Align := TAlignLayout.alLeft;
    Position.X := 190;
    Width := 80;
    Visible := True;
  end;

  with TImage.Create(Result) do
  begin
    StyleName := 'ImageTempMax';
    Parent := FWrap3;
    Align := TAlignLayout.alLeft;
    Width := 18;
    Visible := True;
  end;

  with TText.Create(Result) do
  begin
    StyleName := 'TextTempMax';
    Parent := FWrap3;
    Align := TAlignLayout.alLeft;
    Color := claBlack;
    Font.Size := 15;
    HorzTextAlign := TTextAlign.taLeading;
    Margins.Left := 5;
    Width := 55;
    Position.X := 23;
    Visible := True;
  end;


// ROW 2
  FWrap4 := TLayout.Create(Result);
  with FWrap4 do
  begin
    Parent := FLayRow2;
    Align := TAlignLayout.alLeft;
    Margins.Left := 15;
    Width := 160;
    Visible := True;
  end;

  with TImage.Create(Result) do
  begin
    StyleName := 'ImageWind';
    Parent := FWrap4;
    Align := TAlignLayout.alLeft;
    Width := 30;
    Visible := True;
  end;

  with TText.Create(Result) do
  begin
    StyleName := 'TextWind';
    Parent := FWrap4;
    Align := TAlignLayout.alLeft;
    Color := claBlack;
    Font.Size := 14;
    HorzTextAlign := TTextAlign.taLeading;
    Margins.Left := 5;
    Width := 125;
    Visible := True;
  end;


  FWrap5 := TLayout.Create(Result);
  with FWrap5 do
  begin
    Parent := FLayRow2;
    Align := TAlignLayout.alLeft;
    Position.X := 180;
    Width := 80;
    Visible := True;
  end;

  with TImage.Create(Result) do
  begin
    StyleName := 'ImageDrop';
    Parent := FWrap5;
    Align := TAlignLayout.alLeft;
    Width := 18;
    Visible := True;
  end;

  with TText.Create(Result) do
  begin
    StyleName := 'TextHumidity';
    Parent := FWrap5;
    Align := TAlignLayout.alLeft;
    Color := claBlack;
    Font.Size := 14;
    HorzTextAlign := TTextAlign.taLeading;
    Margins.Left := 5;
    Width := 40;
    Visible := True;
  end;

end;

procedure TMyLayout.ApplyStyle;
begin
  inherited;
  // IZQUIERDA
  imgWeather := TImage(FindStyleResource('ImageWeather'));

  // CABECERA
  rectDate := TRectangle(FindStyleResource('RectDate'));
  txtDate := TText(FindStyleResource('TextDate'));

  // CONTENIDO
  layContent := TLayout(FindStyleResource('LayContent'));
  layRow1 := TLayout(FindStyleResource('LayRow1'));
  layRow2 := TLayout(FindStyleResource('LayRow2'));

  // ROW 1
  imgTermBlue := TImage(FindStyleResource('ImageTempMin'));
  txtMin := TText(FindStyleResource('TextTempMin'));

  imgTermOrange := TImage(FindStyleResource('ImageTempMedium'));
  txtMedium := TText(FindStyleResource('TextTempMedium'));

  imgTermRed := TImage(FindStyleResource('ImageTempMax'));
  txtMax := TText(FindStyleResource('TextTempMax'));

  // ROW 2
  imgWind := TImage(FindStyleResource('ImageWind'));
  txtWind := TText(FindStyleResource('TextWind'));

  imgDrop := TImage(FindStyleResource('ImageDrop'));
  txtHumidity := TText(FindStyleResource('TextHumidity'));


end;


end.
