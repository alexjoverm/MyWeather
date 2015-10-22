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

  // Comprueba que esté disponible la localización en android (en iOS no hará falta)
class function TLocationService.CheckLocationEnable(): Boolean;
  var
    locationManager : JLocationManager;
  begin
    locationManager := TJLocationManager.Wrap( ((SharedActivity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)) as ILocalObject).GetObjectID);

    Result := false;

    // Con que una de las dos localizaciones funcione, devolverá true
    if locationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER) then
       Result := true
    else if locationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER) then
       Result := true;
    end;

end.



