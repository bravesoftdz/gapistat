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
  i : integer;
begin
  n:=lowercase(vendor);
  if pos('nvidia', n)>0 then Result:=vcNvidia
  else if pos('intel',n)>0 then Result:=vcIntel
  else begin
    i:=pos('ati',n);
    if (i>0) and ((i+3=length(n)+1) or (n[i+3] in [' ',#9,#13,#10])) then Result:=vcAti
    else Result:=vcOther;
  end;
end;

var
  gapi : TGAPIStat;

begin
  gapi:=AllocGapiStat;
  try
    writeln('Card:    ', gapi.VideoCard);
    writeln('Vendor:  ', gapi.Vendor);
    writeln('Version: ', gapi.GAPIName,' ', gapi.Version);
    writeln;
    writeln('Card is ', DetectVideoCorp(gapi.Vendor));
  finally
    gapi.Free;
  end;
end.

