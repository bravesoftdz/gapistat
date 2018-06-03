unit gapistattypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TGAPIStat }

  TGAPIStat = class(TObject)
    function GAPIName: string; virtual;
    function Version: String; virtual;
    function Vendor: String; virtual;
    function VideoCard: String; virtual;
  end;

implementation

{ TGAPIStat }

function TGAPIStat.GAPIName: string;
begin
  Result:='';
end;

function TGAPIStat.Version: String;
begin
  Result:='';
end;

function TGAPIStat.Vendor: String;
begin
  Result:='';
end;

function TGAPIStat.VideoCard: String;
begin
  Result:='';
end;

end.

