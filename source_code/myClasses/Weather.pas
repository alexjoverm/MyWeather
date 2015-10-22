unit Weather;

interface

uses
  System.IOUtils;

type
  TWeather = class(TObject)
  private
    _tempCurrent:    Integer;  { Temperatura }
    _tempMin:        Integer;
    _tempMax:        Integer;

    _humidity:       Integer;   { Otros datos climatológicos }
    _windSpeed:      Integer; { en KM/H }
    _windDirection:  Integer;
    _clouds:         Integer;

    _symbol:         Integer;

    _latitude:       Double;  { Localización }
    _longitude:      Double;
    _city:           string;
    _date:           string;

  public
    constructor Create; overload;
    constructor Create(temp, lat, lon: Integer;  cit: string); overload;
    destructor Destroy; override;

    procedure SetAllTemps(temp: Integer);
    procedure SetWindSpeed(speed: Integer);

  // Estos serán estáticos
     function IconTempBlue: string;
     function IconTempOrange: string;
     function IconTempRed: string;
     function IconWind: string;
     function IconHumidity: string;

     function IconWeather: string; // Este dependerá del parámetro symbol

    property TempCurrent:   Integer  read _tempCurrent   write _tempCurrent;
    property TempMin:       Integer  read _tempMin       write _tempMin;
    property TempMax:       Integer  read _tempMax       write _tempMax;
    property Humidity:      Integer   read _humidity      write _humidity;
    property WindSpeed:     Integer  read _windSpeed     write SetWindSpeed;  // Se convierte a KM/h
    property WindDirection: Integer   read _windDirection write _windDirection;
    property Clouds:        Integer   read _clouds        write _clouds;

    property Symbol:        Integer  read _symbol   write _symbol;
    property Latitude:      Double  read _latitude      write _latitude;
    property Longitude:     Double  read _longitude     write _longitude;
    property City:          String    read _city          write _city;
    property Date:          String    read _date          write _date;

  end;

implementation

uses
  System.SysUtils, FMX.Dialogs;



{ ************* CONSTRUCTOR Y DESTRUCTOR ************* }

constructor TWeather.Create;
begin
    _tempCurrent      := 0;
    _tempMin          := 0;
    _tempMax          := 0;

    _humidity         := 0;
    _windSpeed        := 0;
    _windDirection    := 0;
    _clouds           := 0;

    _latitude         := 0;
    _longitude        := 0;
    _city             := '';
end;

constructor TWeather.Create(temp, lat, lon: Integer;  cit: string);
begin
   _tempCurrent := temp;
   _tempMin := temp;
   _tempMax := temp;

   _humidity         := 0;
   _windSpeed        := 0;
   _windDirection    := 0;
   _clouds           := 0;

   _latitude := lat;
   _longitude := lon;
   _city := cit;
end;

destructor TWeather.Destroy;
begin
end;


procedure TWeather.SetAllTemps(temp: Integer);
begin
   _tempCurrent := temp;
   _tempMin := temp;
   _tempMax := temp;
end;

procedure TWeather.SetWindSpeed(speed: Integer);
begin
   _windSpeed := Round(speed * 3.6);
end;


function TWeather.IconTempBlue: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'termAzul.png';
end;

function TWeather.IconTempOrange: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'termNaranja.png';
end;

function TWeather.IconTempRed: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'termRojo.png';
end;

function TWeather.IconWind: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'viento.png';
end;

function TWeather.IconHumidity: string;
begin
  Result := TPath.GetDocumentsPath + PathDelim + 'gota.png';
end;

function TWeather.IconWeather: string;
var
  strRuta: string;
begin

  if FileExists(TPath.GetDocumentsPath + PathDelim + 'sol.png') then
    strRuta := TPath.GetDocumentsPath + PathDelim
  else
    strRuta := TPath.GetHomePath + PathDelim;


  if (_symbol >= 200) and (_symbol < 300) then
    Result := strRuta + 'tormenta.png'
  else if (_symbol >= 300) and (_symbol < 400) then
    Result := strRuta + 'lluvia.png'
  else if (_symbol >= 500) and (_symbol < 505) then
    Result := strRuta + 'solnubelluvia.png'
  else if (_symbol >= 505) and (_symbol < 600) then
    Result := strRuta + 'lluvia.png'
  else if (_symbol >= 600) and (_symbol < 700) then
    Result := strRuta + 'nieve.png'
  else if (_symbol >= 700) and (_symbol < 800) then
    Result := strRuta + 'nube.png'
  else if _symbol = 800 then
    Result := strRuta + 'sol.png'
  else if (_symbol >= 801) and (_symbol <= 802) then
    Result := strRuta + 'solnube.png'
  else if (_symbol >= 803) and (_symbol < 900) then
    Result := strRuta + 'nube.png'
  else if (_symbol >= 900) and (_symbol <= 902) then
    Result := strRuta + 'tormenta.png'
  else if _symbol = 903  then
    Result := strRuta + 'nieve.png'
  else if _symbol = 904  then
    Result := strRuta + 'sol.png'
  else if _symbol >= 905  then
    Result := strRuta + 'nube.png';

end;

end.
