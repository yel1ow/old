unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLObjects, GLCoordinates, GLCadencer, GLCrossPlatform,
  BaseClasses, GLWin32Viewer;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    GLDummyCube1: TGLDummyCube;
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private declarations }
  public
    mx,my:real;{ Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  //Mouse look
  if (ssLeft in Shift)or(Aiming)
  then begin
       MyHero.MyCamera.MoveAroundTarget((my-y),0);
       MyHero.Me^.Turn(- (mx-x));
       end;
 { If (Aiming)and(ssLeft in Shift)
       then begin
            Skill.TargetingComplete(GLCamera1.position.x,GLCamera1.position.y,GLCamera1.position.z);
            end;}
  mx:=x;
  my:=y;
end;

end.
