program gapistat;

uses gapistattypes
  {$ifdef mswindows},winopengl{$endif};

function AllocGapiStat: TGAPIStat;
begin
  {$ifdef mswindows}
  Result:=TWinOpenGLStat.Create;
  {$else}
  ResulT:=TGAPIState.Create;
  {$endif}
end;

type
  TVideoCorp = (vcOther, vcNvidia, vcAti, vcIntel);

function DetectVideoCorp(const vendor: string): TVideoCorp;
var
  n : string;
begin
  n:=lowercase(vendor);
  if pos('nvidia', n)>0 then Result:=vcNvidia
  else if pos('intel',n)>0 then Result:=vcIntel
  else if pos('ati',n)>0 then Result:=vcAti
  else Result:=vcOther;
end;

var
  gapi : TGAPIStat;

begin
  gapi:=AllocGapiStat;
  try
    writeln('Vendor:  ', gapi.Vendor);
    writeln('Card:    ', gapi.VideoCard);
    writeln('Version: ', gapi.GAPIName,' ', gapi.Version);
    writeln;
    writeln('Card by: ', DetectVideoCorp(gapi.Vendor));
  finally
    gapi.Free;
  end;
end.

