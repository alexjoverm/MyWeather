program MyWeather;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  Weather in 'myClasses\Weather.pas',
  XMLParser in 'myClasses\XMLParser.pas',
  NetworkState.Android in 'networkState\NetworkState.Android.pas',
  NetworkState in 'networkState\NetworkState.pas',
  LocationService in 'networkState\LocationService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
