unit XMLParser;

interface

uses
  Weather, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Xml.adomxmldom, System.DateUtils,
  System.SysUtils;

 type
  TXMLParser = class(TObject)
  private

  public
    {constructor Create;
    destructor Destroy;   }

    class procedure LoadXMLDaily(strXML: string;    var XMLDocument: TXMLDocument;  var aWeather: array of TWeather);

  end;

implementation

uses
  FMX.Dialogs, System.Classes, System.Types, System.StrUtils;


{ *************************  DAILY ****************************}

class procedure TXMLParser.LoadXMLDaily(strXML: string;  var XMLDocument: TXMLDocument;  var aWeather: array of TWeather);
var
  ParentNode, ItemNode, ArticleNode, ForecastNode: IXMLNode;
  i: Integer;
  fdate: TDateTime;

  strList: TStringDynArray;
  FSettings: TFormatSettings;
  FDecSeparator : Char;

begin

  FDecSeparator := FormatSettings.DecimalSeparator;
  FSettings := FormatSettings;
  try
    FormatSettings.DecimalSeparator := '.';

    { Abrimos XML }
    XMLDocument.LoadFromXML(strXml);
    XMLDocument.Active := True;

    { Accedemos al primer nodo, el cual tendrá todos los hijos que queremos }
    ParentNode := XMLDocument.ChildNodes.FindNode('weatherdata');

    { Ciudad }
    ItemNode := ParentNode.ChildNodes.FindNode('location').ChildNodes.FindNode('name');
    for i := 0 to Length(aWeather) - 1 do
       aWeather[i].City := ItemNode.Text;

    { Coordenadas }
    ItemNode := ParentNode.ChildNodes.FindNode('location').ChildNodes.FindNode('location');
    for i := 0 to Length(aWeather) - 1 do
    begin
       aWeather[i].Latitude := StrToFloat(ItemNode.Attributes['latitude']);
       aWeather[i].Longitude := StrToFloat(ItemNode.Attributes['longitude']);
    end;


  {*********************** Hacer recorrido en i por Cada item **************************}

    ForecastNode := ParentNode.ChildNodes.FindNode('forecast');

    for i := 0 to ForecastNode.ChildNodes.Count - 1 do
    begin
       ArticleNode := ForecastNode.ChildNodes.Get(i);

       { Rellenamos variables }

       aWeather[i].Symbol := StrToInt(ArticleNode.ChildNodes.FindNode('symbol').Attributes['number']);

       aWeather[i].TempCurrent := Round(StrToFloat(ArticleNode.ChildNodes.FindNode('temperature').Attributes['eve']));
       aWeather[i].TempMin := Round(StrToFloat(ArticleNode.ChildNodes.FindNode('temperature').Attributes['min']));
       aWeather[i].TempMax := Round(StrToFloat(ArticleNode.ChildNodes.FindNode('temperature').Attributes['max']));

       aWeather[i].WindSpeed := Round(StrToFloat(ArticleNode.ChildNodes.FindNode('windSpeed').Attributes['mps'])); { Se pasa automático a KM/H }
       aWeather[i].WindDirection := StrToInt(ArticleNode.ChildNodes.FindNode('windDirection').Attributes['deg']);
       aWeather[i].Humidity := StrToInt(ArticleNode.ChildNodes.FindNode('humidity').Attributes['value']);

       aWeather[i].Clouds := StrToInt(ArticleNode.ChildNodes.FindNode('clouds').Attributes['all']);

       strList :=  SplitString(ArticleNode.Attributes['day'] , '-');

       aWeather[i].Date := strList[2] + '-' + strList[1] + '-' + strList[0];
    end;

  finally
    FormatSettings.DecimalSeparator := FDecSeparator;
  end;
end;



end.
