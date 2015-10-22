unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, FMX.Layouts, FMX.ListBox, System.Classes, Xml.xmldom, Xml.XMLIntf,
  Xml.adomxmldom, Xml.XMLDoc, XMLParser, LocationService, ModalForm, Weather, MyLayout, NetworkState, FMX.Ani,
  System.Sensors, FMX.Sensors, System.UIConsts, System.IOUtils;

type
  TMainForm = class(TForm)
    ToolBar: TToolBar;
    ToolText: TText;
    btnLoad: TButton;      { Botones }

    IdHTTP1: TIdHTTP;            { HTTP y XML }
    XMLDocument1: TXMLDocument;
    rectCity: TRectangle;
    rectLocalized: TRectangle;
    layTop: TLayout;
    txtLocalized: TText;
    txtCity: TText;
    btnLocaliz: TButton;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    MyLayout1: TMyLayout;
    MyLayout2: TMyLayout;
    MyLayout3: TMyLayout;
    FloatAnimation1: TFloatAnimation;
    ListBoxItem4: TListBoxItem;
    MyLayout4: TMyLayout;
    FloatAnimation2: TFloatAnimation;
    imgToobBar: TImage;
    LocationSensor1: TLocationSensor;
    btnCancel: TButton;


    { Eventos }
    procedure btnLoadClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure btnLocalizClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  private
    // XML
    procedure LoadXML(var lat, lon: Double;  cnt, mode: Integer); { mode: 0=Current, 1=Daily }
    procedure LoadXMLDaily(var lat, lon: Double;  cnt: Integer);

    // Rellenar GUI
    procedure InsertXMLDaily();

    function CheckForInternet(): Boolean;

  public

  end;

var
  MainForm: TMainForm;
  weatherCurrent: TWeather;
  weatherDays: array of TWeather;

  FormModal: Tform1;

  Downloading: Boolean;
  Latitud, Longitud: Double;

implementation

{$R *.fmx}




{ ************************************************************************** }
{ *************************  PROCEDIMIENTOS XML  *************************** }
{ ************************************************************************** }

{ ****************  GENERAL  *************** }

{ Comprueba conexión, y llama al XML correspondiente  }
procedure TMainForm.LoadXML(var lat, lon: Double;  cnt, mode: Integer);
begin
    if CheckForInternet() then
      begin

        btnLoad.Enabled := false;
        FormModal := TForm1.Create(nil);

        FormModal.ShowModal(procedure(ModalResult: TModalResult)
        begin
          FormModal.DisposeOf;
        end);

         if mode=0 then
          //  LoadXMLCurrent(lat, lon)
         else if mode=1 then
            LoadXMLDaily(lat, lon, cnt);

      btnLoad.Enabled := true;
      end
    else
      ShowMessage('No tienes internet. Por favor enciende tu Wifi o Datos para poder consultar el tiempo');

end;




{ *************** XML DIARIO ******************* }

procedure TMainForm.LoadXMLDaily(var lat, lon: Double;  cnt: Integer);
var
  strUrl: string; {XML}
  strXml: string;
  i: Integer;
  hasError: boolean;
begin


  { Inicializamos Array }
  try
    SetLength(weatherDays, cnt);
    for i := 0 to Length(weatherDays) - 1 do
      if not Assigned(weatherDays[i]) then
        weatherDays[i] := TWeather.Create;
  except on E: Exception do
    begin
      ShowMessage ('Error en WeatherArray Create: ' + E.Message);
      Exit;
    end;
  end;


  // Montamos URL ( Actual = http://api.openweathermap.org/data/2.5/weather?lat=38.34&lon=-0.48&mode=xml&units=metric&lang=sp )
  strUrl := 'http://api.openweathermap.org/data/2.5/forecast/daily?lat=';
  strUrl := strUrl +  lat.ToString + '&lon=' + lon.ToString + '&cnt=' + cnt.ToString;
  strUrl := strUrl + '&mode=xml&units=metric&lang=sp';


  Downloading := true;
   hasError := false;

  TThread.CreateAnonymousThread(
    procedure
      begin
        try
          strXml := '';
          strXml := IdHTTP1.Get (strUrl);
        except on E:Exception do
          begin
            hasError := true;
            Exit;
          end;
        end;

       TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          if FormModal <> nil then
            FormModal.ModalResult := mrOk;
              
          Downloading := false;
          if not hasError then
          begin
            // Parseamos y Creamos los objetos Weather
            TXMLParser.LoadXMLDaily(strXml, XMLDocument1, weatherDays);

           // Insertamos en la GUI
            InsertXMLDaily;
          end
          else
              ShowMessage('Error en la descarga de datos. Intentalo de nuevo');
        end);

    end).Start;

end;






{ ************************************************************************** }
{ *************************  INSERCCIONES EN GUI  ************************** }
{ ************************************************************************** }

// ********************  DAILY

procedure TMainForm.InsertXMLDaily();
var
  MyLayoutAux: TMyLayout;

begin

{ ********** ESTE BLOQUE DE CÓDIGO NO ME FUNCIONABA DEL TODO BIEN. No
             actualiza los valores de MyLayoutAux, así que he acabado
             haciendo esto estático, como se puede ver abajo


  // Nombre de la ciudad (solo 1)
  txtCity.Text := weatherDays[0].City;

  ListBox1.BeginUpdate;

  try
    ListBox1.Clear;

    for i := 0 to Length(weatherDays) - 1 do
    begin

      ListBoxItem := TListBoxItem.Create(ListBox1);
      ListBoxItem.Height := 100;
      ListBox1.AddObject(ListBoxItem);

      // Creamos un MyLayout con los textos
      MyLayoutAux := TMyLayout.Create(ListBox1);
      MyLayoutAux.TextDate := 'Fecha' + i.ToString;

      MyLayoutAux.TextTempMin := weatherDays[i].TempMin.ToString + Chr(176);
      MyLayoutAux.TextTempMedium := weatherDays[i].TempCurrent.ToString + Chr(176);
      MyLayoutAux.TextTempMax := weatherDays[i].TempMax.ToString + Chr(176);
      MyLayoutAux.TextHumidity := weatherDays[i].Humidity.ToString + '%';
      MyLayoutAux.TextWind := weatherDays[i].WindSpeed.ToString + ' km/h , '
                               + weatherDays[i].WindDirection.ToString + Chr(176);

    //  ShowMessage(MyLayoutAux.TextWind);

      MyLayoutAux.UrlImageWeather := weatherDays[i].IconWeather;
      MyLayoutAux.UrlImageWind := weatherDays[i].IconWind;
      MyLayoutAux.UrlImageTermBlue := weatherDays[i].IconTempBlue;
      MyLayoutAux.UrlImageTermOrange := weatherDays[i].IconTempOrange;
      MyLayoutAux.UrlImageTermRed := weatherDays[i].IconTempRed;
      MyLayoutAux.UrlImageDrop := weatherDays[i].IconHumidity;

      Listbox1.AddObject(MyLayoutAux);
    end;

  finally
    ListBox1.EndUpdate;
  end;
  }


   // Nombre de la ciudad (solo 1)
  txtCity.Text := weatherDays[0].City;

  MyLayout1.TextDate := weatherDays[0].Date;
  MyLayout1.TextTempMin := weatherDays[0].TempMin.ToString + Chr(176);
  MyLayout1.TextTempMedium := weatherDays[0].TempCurrent.ToString + Chr(176);
  MyLayout1.TextTempMax := weatherDays[0].TempMax.ToString + Chr(176);
  MyLayout1.TextHumidity := weatherDays[0].Humidity.ToString + '%';
  MyLayout1.TextWind := weatherDays[0].WindSpeed.ToString + ' km/h , '
                           + weatherDays[0].WindDirection.ToString + Chr(176);


  MyLayout1.UrlImageWeather := weatherDays[0].IconWeather;
  MyLayout1.UrlImageTermBlue := weatherDays[0].IconTempBlue;
  MyLayout1.UrlImageTermOrange := weatherDays[0].IconTempOrange;
  MyLayout1.UrlImageTermRed := weatherDays[0].IconTempRed;
  MyLayout1.UrlImageWind := weatherDays[0].IconWind;
  MyLayout1.UrlImageDrop := weatherDays[0].IconHumidity;


    MyLayout2.TextDate := weatherDays[1].Date;
    MyLayout2.TextTempMin := weatherDays[1].TempMin.ToString + Chr(176);
    MyLayout2.TextTempMedium := weatherDays[1].TempCurrent.ToString + Chr(176);
    MyLayout2.TextTempMax := weatherDays[1].TempMax.ToString + Chr(176);
    MyLayout2.TextHumidity := weatherDays[1].Humidity.ToString + '%';
    MyLayout2.TextWind := weatherDays[1].WindSpeed.ToString + ' km/h , '
                             + weatherDays[1].WindDirection.ToString + Chr(176);

    MyLayout2.UrlImageWeather := weatherDays[1].IconWeather;
    MyLayout2.UrlImageTermBlue := weatherDays[1].IconTempBlue;
    MyLayout2.UrlImageTermOrange := weatherDays[1].IconTempOrange;
    MyLayout2.UrlImageTermRed := weatherDays[1].IconTempRed;
    MyLayout2.UrlImageWind := weatherDays[1].IconWind;
    MyLayout2.UrlImageDrop := weatherDays[1].IconHumidity;

    MyLayout3.TextDate := weatherDays[2].Date;
    MyLayout3.TextTempMin := weatherDays[2].TempMin.ToString + Chr(176);
    MyLayout3.TextTempMedium := weatherDays[2].TempCurrent.ToString + Chr(176);
    MyLayout3.TextTempMax := weatherDays[2].TempMax.ToString + Chr(176);
    MyLayout3.TextHumidity := weatherDays[2].Humidity.ToString + '%';
    MyLayout3.TextWind := weatherDays[2].WindSpeed.ToString + ' km/h , '
                             + weatherDays[2].WindDirection.ToString + Chr(176);

    MyLayout3.UrlImageWeather := weatherDays[2].IconWeather;
    MyLayout3.UrlImageTermBlue := weatherDays[2].IconTempBlue;
    MyLayout3.UrlImageTermOrange := weatherDays[2].IconTempOrange;
    MyLayout3.UrlImageTermRed := weatherDays[2].IconTempRed;
    MyLayout3.UrlImageWind := weatherDays[2].IconWind;
    MyLayout3.UrlImageDrop := weatherDays[2].IconHumidity;

    MyLayout4.TextDate := weatherDays[3].Date;
  MyLayout4.TextTempMin := weatherDays[3].TempMin.ToString + Chr(176);
  MyLayout4.TextTempMedium := weatherDays[3].TempCurrent.ToString + Chr(176);
  MyLayout4.TextTempMax := weatherDays[3].TempMax.ToString + Chr(176);
  MyLayout4.TextHumidity := weatherDays[3].Humidity.ToString + '%';
  MyLayout4.TextWind := weatherDays[3].WindSpeed.ToString + ' km/h , '
                           + weatherDays[3].WindDirection.ToString + Chr(176);


  MyLayout4.UrlImageWeather := weatherDays[3].IconWeather;
  MyLayout4.UrlImageTermBlue := weatherDays[3].IconTempBlue;
  MyLayout4.UrlImageTermOrange := weatherDays[3].IconTempOrange;
  MyLayout4.UrlImageTermRed := weatherDays[3].IconTempRed;
  MyLayout4.UrlImageWind := weatherDays[3].IconWind;
  MyLayout4.UrlImageDrop := weatherDays[3].IconHumidity;


  
  FloatAnimation1.Start;
  FloatAnimation2.Start;


end;







{ ************************************************************************** }
{ *****************************  INTERNET  ********************************* }
{ ************************************************************************** }



function TMainForm.CheckForInternet(): Boolean;
var
  netState: TNetworkState;
begin
  try
    netState := TNetworkState.Create;
    Result := netState.IsConnected;
  finally
    netState.Free;
  end;
end;







{ ************************************************************************** }
{ ******************************  EVENTOS  ********************************* }
{ ************************************************************************** }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if FileExists(TPath.GetDocumentsPath + PathDelim + 'sol.png') then 
    imgToobBar.Bitmap.LoadFromFile(TPath.GetDocumentsPath + PathDelim + 'sol.png')
  else 
    imgToobBar.Bitmap.LoadFromFile(TPath.GetHomePath + PathDelim + 'sol.png');
end;


procedure TMainForm.btnCancelClick(Sender: TObject);
begin
   btnLocaliz.Enabled := true;
   LocationSensor1.Active := false;
   rectLocalized.Fill.Color := claOrangered;
   txtLocalized.Text := 'No localizado';
   btnCancel.Visible := false;
end;

procedure TMainForm.btnLoadClick(Sender: TObject);
begin

  if not Downloading then
  begin
    if txtLocalized.Text = 'Localizado' then
    begin
      LoadXML(Latitud, Longitud, 4, 1);
    end
    else
      ShowMessage('Primero necesito localizarte. Pulsa el botón de Localizar');
  end
  else
    ShowMessage('Los datos se están descargando');
end;


procedure TMainForm.btnLocalizClick(Sender: TObject);
begin

{$IFDEF ANDROID}
  if TLocationService.CheckLocationEnable then
    begin
     rectLocalized.Fill.Color := claDodgerblue;
     txtLocalized.Text := 'Localizando...';
     btnLocaliz.Enabled := false;
     btnCancel.Visible := true;
     LocationSensor1.Active := true;
    end
  else
     ShowMessage('Tienes que activar la localización (desde ajustes de tu teléfono)');
{$ELSE}
{$IFDEF IOS}
// En iOS no hará falta, ya lo comprueba el sistema por nosotros
     rectLocalized.Fill.Color := claDodgerblue;
     txtLocalized.Text := 'Localizando...';
     btnLocaliz.Enabled := false;
     btnCancel.Visible := true;
     LocationSensor1.Active := true;
{$ENDIF IOS}
{$ENDIF ANDROID}
end;




//*********** Localización

// Aquí no se puede llamar a un ShowMessage()
procedure TMainForm.LocationSensor1LocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin

   Latitud := NewLocation.Latitude;
   Longitud := NewLocation.Longitude;

   btnCancel.Visible := false;
   btnLocaliz.Enabled := true;
   rectLocalized.Fill.Color := claMediumseagreen;
   txtLocalized.Text := 'Localizado';

   //Localizar;
   LocationSensor1.Active := false;

end;



end.
