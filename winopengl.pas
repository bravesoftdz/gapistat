unit winopengl;

{$mode delphi}{$H+}

interface

uses
  Windows, gl, gapistattypes;

type

  { TWinOpenGLStat }

  TWinOpenGLStat = class(TGAPIStat)
  private
    ctx : HGLRC;
    fwnd : Windows.HWND;
    fownWnd : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function GAPIName: string; override;
    function Version: string; override;
    function Vendor: String; override;
    function VideoCard: String; override;
  end;

function glGetString(prm: GLEnum): string;

implementation

function glGetString(prm: GLEnum): string;
var
  p : PChar;
begin
  p := gl.glGetString(prm);
  if Assigned(p) then
    Result:=p
  else
    Result:='';
end;

function WinProc(wnd:HWND; msg:UINT; wparam:WPARAM; lparam:LPARAM):LRESULT;stdcall;
begin
  Result:=DefWindowProc(wnd, msg, wparam, lparam);
end;

function AllocWindow: Hwnd;
var
  cls : TWNDCLASSA;
begin
  FillChar(cls, sizeof(cls),0);
  cls.style:=CS_OWNDC; // recommended by Khronos
  cls.hInstance:=HINSTANCE;
  cls.lpfnWndProc:=@WinProc;
  cls.lpszClassName:='GLSTAT';
  Windows.RegisterClassA(cls);
  Result:=Windows.CreateWindow('GLSTAT', nil, 0, 0,0,0,0,0, 0, HINSTANCE, nil);
end;

{ TWinOpenGLStat }

constructor TWinOpenGLStat.Create;
var
  dc : HDC;
  i  : integer;
  d  : TPIXELFORMATDESCRIPTOR;
begin
  inherited Create;

  fwnd:=AllocWindow; //GetDesktopWindow;
  fownWnd:=true;
  dc:=GetDC(fwnd);

  FillChar(d, sizeof(d), 0);
  d.nSize:=sizeof(d);
  d.nVersion:=1;
  d.dwFlags:=PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or PFD_DOUBLEBUFFER;
  d.iPixelType:=PFD_TYPE_RGBA;
  d.cColorBits:=32;
  d.cDepthBits:=24;
  d.cStencilBits:=8;
  d.iLayerType:=PFD_MAIN_PLANE;

  i:=ChoosePixelFormat(dc, @d);
  SetPixelFormat(dc, i, nil);
  ctx:=wglCreateContext(dc);

  wglMakeCurrent(dc, ctx);
end;

destructor TWinOpenGLStat.Destroy;
begin
  if ctx<>0 then begin
    wglMakeCurrent(0,0);
    wglDeleteContext(ctx);
  end;

  if (fwnd<>0) and (fownWnd) then begin
    DestroyWindow(fwnd);
    fwnd:=0;
  end;
  inherited Destroy;
end;

function TWinOpenGLStat.GAPIName: string;
begin
  Result:='OpenGL';
end;

function TWinOpenGLStat.Version: string;
begin
  Result:=glGetString(GL_VERSION);
end;

function TWinOpenGLStat.Vendor: String;
begin
  Result:=glGetString(GL_VENDOR);
end;

function TWinOpenGLStat.VideoCard: String;
begin
  Result:=glGetString(GL_RENDERER);
end;

end.

