unit LocationService;

interface

uses
  Androidapi.JNI.Location,
  Androidapi.JNIBridge,
  FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText;

 type
  TLocationService = class(TObject)
  private

  public

    class function CheckLocationEnable(): Boolean;

  end;

implementation

  // Comprueba que est� disponible la localizaci�n en android (en iOS no har� falta)
class function TLocationService.CheckLocationEnable(): Boolean;
  var
    locationManager : JLocationManager;
  begin
    locationManager := TJLocationManager.Wrap( ((SharedActivity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)) as ILocalObject).GetObjectID);

    Result := false;

    // Con que una de las dos localizaciones funcione, devolver� true
    if locationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER) then
       Result := true
    else if locationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER) then
       Result := true;
    end;

end.



