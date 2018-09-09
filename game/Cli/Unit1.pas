{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
unit Unit1;

interface

uses
  //PngImage,
  Dialogs,Jpeg, GLFileMD2, GLFile3DS, VectorGeometry, GLProxyObjects,
  OpenGL1x, GLEllipseCollision,GLKeyboard,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  GLCoordinates, GLCrossPlatform, BaseClasses, GLDCE, GLFireFX, GLMaterial,
  GLObjects, GLVectorFileObjects, GLScene, GLHeightData, GLCadencer,
  GLHUDObjects, GLTerrainRenderer, GLWin32Viewer, GLCollision,
  GLParticleFX, GLPerlinPFX, GLBlur, GLFileSmd, GLPostEffects, AsyncTimer,
  ExtCtrls, GLSkydome, GLSkyBox, GLGameMenu, GLThorFX, GLSpaceText,
  GLBitmapFont, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;//,GLFileMAX;

Const
  StForce=500;
  AreaTrg   =1;
  ShotTrg   =2;
  AroundTrg =3;
  FrontTrg  =4;
  SelfTrg   =5;

  NoneDmg   =1;
  NormalDmg =2;
  HealDmg   =3;

  NoneAct   =1;
  MoveAct   =2;
  DodgeAct  =3;
  JumpAct   =4;
  CastAct   =5;
  DieAct    =6;

  FrontWay  =1;
  BackWay   =3;
  RigthWay  =2;
  LeftWay   =4;

  MaxBuffs  =5;
  NoneBuff  =0;
  SpeedBuff =1;
  SmallBuff =2;
  RegenBuff =3;
SpecialBuff =4;

  MaxEff    =7;
  NoneEff   =0;
  StunEff   =1;
  DOTEff    =2;
  SlowEff   =3;
  ShackEff  =4;
  BigEff    =5;
  SpecialEff=6;




  MaxHeroes =3;
  MaxSkills =4;
  HeroName:array[1..MaxHeroes]of string=('Mage','Juggler','Shaman');
  HeroHealth:array[1..MaxHeroes]of integer=(322,400,250);
  StandartScale:array[1..MaxHeroes]of real = (0.2,0.0228,0.0250);
type


  TMainF = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLCadencer1: TGLCadencer;
    GLLightSource1: TGLLightSource;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLBitmapHDS1: TGLBitmapHDS;
    Terrain: TGLTerrainRenderer;
    Mage: TGLDummyCube;
    Solo322: TGLActor;
    GLDCEManager1: TGLDCEManager;
    MainHUD: TGLHUDSprite;
    GLLines1: TGLLines;
    pricel: TGLSphere;
    Fireball: TGLDummyCube;
    CollisionManager1: TCollisionManager;
    IceManager: TGLPerlinPFXManager;
    Iceball: TGLDummyCube;
    for12: TGLParticleFXRenderer;
    Fire: TGLPerlinPFXManager;
    Blink: TGLDummyCube;
    GLFireFXManager1: TGLFireFXManager;
    GLPostEffect1: TGLPostEffect;
    for11: TGLParticleFXRenderer;
    for14: TGLParticleFXRenderer;
    Freez: TGLDummyCube;
    Timer1: TTimer;
    Freezing: TGLPerlinPFXManager;
    GLCamera2: TGLCamera;
    pricel2: TGLSphere;
    DreadLev: TGLActor;
    MageAndSkills: TGLDummyCube;
    Salve: TGLDummyCube;
    Throw: TGLDummyCube;
    JugglerAndSkills: TGLDummyCube;
    bootmodel1: TGLActor;
    bootmodel2: TGLActor;
    bootmodel3: TGLActor;
    boots: TGLDummyCube;
    Salve1: TGLActor;
    Salve2: TGLActor;
    Salve3: TGLActor;
    knifes: TGLDummyCube;
    knife1: TGLActor;
    knife2: TGLActor;
    knife3: TGLActor;
    TBoot: TGLDummyCube;
    TSalve: TGLDummyCube;
    TKnife: TGLDummyCube;
    TB: TGLActor;
    TS: TGLActor;
    TK: TGLActor;
    juggler: TGLDummyCube;
    GLSkyBox1: TGLSkyBox;
    GLGameMenu1: TGLGameMenu;
    ShamanAndSkills: TGLDummyCube;
    Shaman: TGLDummyCube;
    pricel3: TGLSphere;
    GLCamera3: TGLCamera;
    Vitushaman: TGLActor;
    Ltg: TGLDummyCube;
    Heal: TGLDummyCube;
    Meteorit: TGLDummyCube;
    Stun: TGLDummyCube;
    GLThorFXManager1: TGLThorFXManager;
    For32: TGLParticleFXRenderer;
    HealAnim: TGLPerlinPFXManager;
    MeteorAnim1: TGLPerlinPFXManager;
    GLPerlinPFXManager3: TGLPerlinPFXManager;
    ExplosionMeteor: TGLPerlinPFXManager;
    StunSham: TGLPerlinPFXManager;
    For34: TGLParticleFXRenderer;
    choosecamera: TGLCamera;
    GLLightSource2: TGLLightSource;
    GLPlane1: TGLPlane;
    choosecube: TGLDummyCube;
    GLSprite1: TGLSprite;
    GLSprite2: TGLSprite;
    GLSprite3: TGLSprite;
    GLBitmapFont1: TGLBitmapFont;
    Client: TIdTCPClient;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewer1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FireballBehaviours0Collision(Sender: TObject;
      ObjectCollided: TGLBaseSceneObject; CollisionInfo: TDCECollision);
    procedure CollisionManager1Collision(Sender: TObject; object1,
      object2: TGLBaseSceneObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    aiming:boolean;
    mx,my:integer;
    //MassSkills:array[1..4]Of Tskills;
    Procedure Load;
  end;
 type
  TSkills=class(TObject)
    Private
    Public
    effect    :integer;
    EffectDur :real;
    Damage    :integer;
    AOE       :integer;
    TipTarget :integer;
    TipDamage :integer;
    CoolDown  :integer;
    Icon      :TGLHUDSprite;
    Number    :byte;
    Hero      :byte;
    casttime  :real;
    lifetime  :real;
  //  pricelPos :array[0..2]of ^real;
  MyHeroModel :^TGLDummyCube;
  LifeTimeLeft:real;
    Me        :^TGLDummyCube;
    Procedure Targeting;
    Procedure Hide;
    Procedure AreaTargeting;
    Procedure ShotTargeting;
    Procedure TargetingComplete(xx,yy,zz:real);
    Procedure Anim(xx,yy,zz:real);
    Procedure Anim1(xx,yy,zz:real);
    Procedure CheckAOE(xx,yy,zz:real);
    Constructor CreateS(HeroNumber,SkillNumber:byte;nMyHero:pointer);
  end;
  THeroes=class(TObject)
    Private
    Public
    MyCamera  :TGLCamera;
 ControlAble  :Boolean;
    MoveAble  :boolean;
    effect    :integer;
    buff      :integer;
    Health    :integer;
    StSpeed   :real;
    speed     :real;
    StSize    :real;
    Size      :real;
    MaxHealth :integer;
    Buffs     :array[1..MaxBuffs]Of real;
    BuffIcons :array[1..2]of TGLSprite;
    CoolDowns :array[1..MaxSkills]of real;
// CoolDownIcons:array[1..MaxSkills]of TGLHUDSprite;
    Effects   :array[1..MaxEff]Of real;
    EffIcons  :array[1..5]of TGLSprite;
    Skill     :array[1..MaxSkills]of TSkills;
    HealthBar :TGLSprite;
    dmg1vis   :real;
    dmg50vis  :real;
    dmg100vis :real;
    dmg150vis :real;
    Heal150vis:real;
    Dmg1      :TGLSprite;
    Dmg50     :TGLSprite;
    Dmg100    :TGLSprite;
    Dmg150    :TGLSprite;
    Heal150   :TGLSprite;
  //  ChangeHP  :TGLSprite;
  SkillSprites:array[1..MaxSkills]of TGLHUDSprite;
   ActiveSkill:TSkills;
    MyNumber  :byte;
    MyName    :string;
    MyPricel  :^TGLSphere;
    Me        :^TGLDummyCube;
    Actor     :^TGlActor;
    Action    :byte;
    Constructor CreateH(nMyNumber:byte);
    Procedure DecCDs(t:real);
    Procedure CheckBuff(t:real);
    Procedure CheckEffect(t:real);
    Procedure AddBuff(n:integer;t:real);
    Procedure AddEffect(n:integer;t:real);
    Procedure DelBuff(n:integer);
    Procedure DelEffect(n:integer);
    Procedure Move(dx,dy,dz:real);
    Procedure Dodge(way:byte);
    Procedure Cast(SNumber:byte);
    Procedure Jump;
    Procedure Die;
    Procedure ChangeAction(newAct:byte);
    Procedure TakeDamage(Damage:integer);
  end;

var
  MainF: TMainF;
//  Skill:tSkills;
  Chosed:boolean;
  numChose:integer;
  PredHp:array[0..1]of integer;
  HNames:array[1..MaxHeroes]of TGLSpaceText;
  AllHeroes:array[1..maxheroes]of THeroes;
  heroes:array[0..1]of THeroes;
  CoolDownIcons:array[1..MaxSkills]of TGLHUDSprite;
  MyNumber:integer;
  SkillUsed:boolean;
  sNumber:integer;
  sx,sy,sz:real;
implementation


{$R *.dfm}

{******************TSkills**********************************}

Constructor TSkills.CreateS(HeroNumber,SkillNumber:byte;nMyHero:pointer);
var s,s1:string;
f:textFile;
j,i:integer;
Begin

  Inherited;
  s:='skills\' ;
  s:=s+IntToStr(HeroNumber);
  s:=s+' ';
  s1:=IntToStr(SkillNumber);
  s:=s+s1;
  s:=s+'.txt';
 //rewrite(f,s);
  assignFile(f,s);
  reset(f);
  readln(f);
  read(f,s1);
  i:=1;
  //damage:=10;
 // self.Damage:=10;
  j:=0;
  Repeat
    s:='';
    While s1[i]=' ' do inc(i);
    While s1[i]<>' 'do
      begin
       s:=s+s1[i];
       Inc(i);
      end;
    Inc(j);
    Case j of
    1:Damage:=StrToInt(s);
    2:AOE:=StrToInt(s);
    3:TipTarget:=StrToInt(s);
    4:TipDamage:=StrToInt(s);
    5:CoolDown:=StrToInt(s);
    6:CastTime:=StrToInt(s)/10;
    7:LifeTime:=StrToInt(s)/10;
    8:Effect:=StrToInt(s);
    9:EffectDur:=StrToInt(s)/10;
    end;
  until s='###';
  //AOE,TipTarget,TipDamage,Cooldown,CastTime,LifeTime);
 // read(AOE);
  //,TipTarget,TipDamage,Cooldown,CastTime,LifeTime);
  Number:=SkillNumber;
  Hero:=HeroNumber;
  New(MyHeroModel);
  MyHeroModel:=nMyHero;
  Case Hero of
    1: begin
        New(me);
        Case Number of
        1: Me:=@MainF.Fireball;
        2: Me:=@MainF.Iceball;
        3: Me:=@MainF.Blink;
        4: Me:=@MainF.Freez;
        end;
       end;
    2: Begin
        New(me);
        Case Number of
        1: Me:=@MainF.Boots;
        2: Me:=@MainF.Salve;
        3: Me:=@MainF.Knifes;
        4: begin
            Me:=@MainF.tKnife;
            Hide;
            Me:=@MainF.tSalve;
            Hide;
            Me:=@MainF.tBoot;
            Hide;
            //Me:=@MainF.Throw;
           end;
        end;
       End;
    3: Begin
        New(me);
        Case Number of
          1:Me:=@MainF.Ltg;
          2:Me:=@MainF.Heal;
          3:Me:=@MainF.Meteorit;
          4:Me:=@MainF.Stun;
        end;
       End;
  end;
  Self.Hide;
  closeFile(f);
End;

Procedure TSkills.Targeting;
var xx,yy,zz:real;
Begin
  Case Self.TipTarget of
    AreaTrg:  Begin
                AreaTargeting;

              End;
    ShotTrg:  Begin
                ShotTargeting;

              End;
    AroundTrg:Begin
                TargetingComplete(0,0,0);
              End;
    FrontTrg: Begin
                {TargetingComplete(3*myheromodel^.direction.x,3*myheromodel^.direction.y,3*myheromodel^.direction.z)}
                TargetingComplete(0,0,1);
              End;
    SelfTrg:  Begin anim(MyHeroModel^.Position.x,MyHeroModel^.Position.y,MyHeroModel^.Position.z) End;
   end;
end;

Procedure TSkills.AreaTargeting;
Begin
End;

Procedure TSkills.ShotTargeting;
Begin
  Case Hero of
  1: begin MainF.Pricel.visible:=true; end;
  2: begin MainF.pricel2.Visible:=true; end;
  3: begin MainF.pricel3.Visible:=true; end;
  end;
  MainF.aiming:=true;
End;

Procedure tSkills.TargetingComplete(xx,yy,zz:real);
var x,y,z:real;
Begin
   Case Self.TipTarget of
    AreaTrg:  Begin

              End;
    ShotTrg:  Begin
                MainF.pricel2.Visible:=false;
                MainF.aiming:=false;
                //Anim(MainF.Mage.position.x+MainF.pricel.Position.x-xx,MainF.Mage.position.y+MainF.pricel.Position.y-yy,MainF.Mage.position.z+MainF.pricel.Position.z-zz);
                //x:=AllHeroes[Hero].me^.Position.x+AllHeroes[Hero].MyPricel^.Position.x;
                //y:=AllHeroes[Hero].me^.Position.y+AllHeroes[Hero].MyPricel^.Position.y;
                //z:=AllHeroes[Hero].me^.Position.z+AllHeroes[Hero].MyPricel^.Position.z;
                Anim(AllHeroes[Hero].MyPricel^.Position.x-xx,AllHeroes[Hero].MyPricel^.Position.y-yy,AllHeroes[Hero].MyPricel^.Position.z-zz);
                //Anim(x-xx,y-yy,z-zz);
                //Anim(0,MainF.pricel.Position.y-yy,1);
              End;
    AroundTrg:Begin Anim(xx,yy,zz) End;
    FrontTrg: Begin Anim(xx,yy,zz) End;
    SelfTrg:  Begin End;
   end;
End;

Procedure TSkills.Hide;
Begin
  Self.Me^.Position.X:=10000+number*5;
  Self.Me^.Position.Y:=10000;
  Self.Me^.Position.Z:=10000+Self.Hero*5;
  Case Hero Of
  1:  Case Number of
        1:Begin
            GetOrCreateDceDynamic(Self.me^).Friction:=9999;
          End;
        2:Begin
            GetOrCreateDceDynamic(Self.me^).Friction:=9999;
          End;
        3:Begin
            MainF.GLPostEffect1.Preset:=pepNone;
          End;
        4:Begin
          End;
      end;
  2:  Case Number of
        1:Begin
          End;
        2:Begin
          End;
        3:Begin
          End;
        4:Begin
            GetOrCreateDceDynamic(Self.me^).Friction:=9999;
          End;
      end;
  3:  Case Number of
        1:Begin
            MainF.GLThorFXManager1.Maxpoints:=1;
           // MainF.GLThorFXManager1.Disabled:=true;
          End;
        2:Begin
          End;
        3:Begin
            GetOrCreateDceDynamic(Self.me^).Friction:=9999;
          End;
        4:Begin
          End;
      End;
  end;
End;

Procedure TSkills.CheckAOE(xx,yy,zz:real);
var i:integer;
Begin
  If Self.Hero=Heroes[0].MyNumber
  then i:=1
  else i:=0;
  If sqrt(sqr(xx-Heroes[i].Me^.position.x)+ sqr(yy-heroes[i].Me^.Position.y))<=AOE
  then Begin
        heroes[i].Health:=heroes[i].Health-Damage;
        heroes[i].Effects[effect]:=EffectDur;
       End;
End;

Procedure Tskills.Anim(xx,yy,zz:real);
var force:tAffineVector;
x:single;
s,q:integer;
Begin
  SkillUsed:=true;
  sNumber:=Number;
  sx:=xx;
  sy:=yy;
  sz:=zz;
  AllHeroes[Hero].CoolDowns[Number]:=CoolDown;
  Case Hero of
  1: begin
      Case Number of
      1:begin
         // MainF.Fireball.Behaviours.
         //GetOrCreateDCEDynamic(MainF.Mage).active:=False;
          //MainF.Fireball.Tag:=Self.lifetime;
          GetOrCreateDCEDynamic(Me^).active:=false;
          Me^.Position:=MainF.pricel.Position;
          Me^.Direction:=MyHeroModel^.Direction;
          Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
          Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
          Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
          GetOrCreateDCEDynamic(Me^).active:=true;
          GetOrCreateDceDynamic(Self.me^).Friction:=0;
         // MainF.Fireball.VisibleAtRunTime:=true;
          Force:=NullVector;
          //GetOrCreateDCEDynamic(MainF.Fireball).Move(force,0);
          Force[0]:=xx*StForce/2;
          Force[1]:=yy*StForce/2;
          Force[2]:=zz*StForce/2;
          //GetOrCreateDceDynamic(MainF.Fireball).Friction:=0;
          GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
          //GetOrCreateDCEDynamic(MainF.Mage).active:=true;
          Force:=NullVector;
        end;
      2:begin
          GetOrCreateDCEDynamic(Me^).active:=false;
          Me^.Position:=MainF.pricel.Position;
          Me^.Direction:=MyHeroModel^.Direction;
          Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
          Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
          Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
          GetOrCreateDCEDynamic(Me^).active:=true;
          GetOrCreateDceDynamic(Self.me^).Friction:=0;
          Force:=NullVector;
          Force[0]:=xx*StForce/2;
          Force[1]:=yy*StForce/2;
          Force[2]:=zz*StForce/2;
          GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
          Force:=NullVector;
        end;
      3:begin
          Force:=NullVector;
          Force[0]:=xx*stForce*100;
          Force[1]:=yy*stForce*100;
          Force[2]:=zz*stForce*100;
          {MyHeroModel^.Position.X:=MyHeroModel.Position.X+xx;
          MyHeroModel^.Position.y:=MyHeroModel.Position.y+yy;
          MyHeroModel^.Position.z:=MyHeroModel.Position.z+zz;}
          GetOrCreateDceDynamic(MyHeroModel^).ApplyAccel(FOrce);
          MainF.GLPostEffect1.preset:=pepDistort;
        end;
      4:begin
           me^.Position:=MyHeroModel^.Position;
           x:=MainF.GLCadencer1.CurrentTime;
           GetOrCreateSourcePFX(me^).RingExplosion(x,25,30,100);
           //CheckAOE(Me^.Position.x,me^.Position.y,me^.Position.Z);
        end;
      end;
     end;
  2: begin
      Case Number of
      1:begin
          Self.Me^.Position.x:=0;
          Self.Me^.Position.y:=2;
          Self.Me^.Position.z:=0;
          If MainF.bootmodel1.Visible
          then If MainF.bootmodel2.Visible
               then begin
                      MainF.bootmodel3.Visible:=TRUE;
                      MainF.Salve3.Visible:=false;
                      MainF.knife3.Visible:=false;
                    end
               else begin
                      MainF.bootmodel2.Visible:=true;
                      MainF.Salve2.Visible:=false;
                      MainF.knife2.Visible:=false;
                    end
          else begin
                MainF.bootmodel1.Visible:=true;
                MainF.Salve1.Visible:=false;
                MainF.knife1.Visible:=false;
               end;
          If (MainF.Salve1.Visible=false)and(MainF.Salve2.Visible=false)and(MainF.Salve3.Visible=false)
          then AllHeroes[Hero].DelBuff(SmallBuff);
          AllHeroes[Hero].AddBuff(SpeedBuff,self.lifetime);
        end;
      2:begin
          Self.Me^.Position.x:=0;
          Self.Me^.Position.y:=2;
          Self.Me^.Position.z:=0;
          If MainF.Salve2.Visible
          then If MainF.Salve3.Visible
               then begin
                      MainF.Salve1.Visible:=true;
                      MainF.bootmodel1.Visible:=false;
                      MainF.knife1.Visible:=false;
                    end
               else begin
                      MainF.Salve3.Visible:=true;
                      MainF.bootmodel3.Visible:=false;
                      MainF.knife3.Visible:=false;
                    end
          else begin
                MainF.Salve2.Visible:=true;
                MainF.bootmodel2.Visible:=false;
                MainF.knife2.Visible:=false;
               end;
          If (MainF.bootmodel1.Visible=false)and(MainF.bootmodel2.Visible=false)and(MainF.bootmodel3.Visible=false)
          then AllHeroes[Hero].DelBuff(SpeedBuff);
          AllHeroes[Hero].AddBuff(SmallBuff,self.lifetime);
        end;
      3:begin
          Self.Me^.Position.x:=0;
          Self.Me^.Position.y:=2;
          Self.Me^.Position.z:=0;
          If MainF.knife3.Visible
          then If MainF.knife1.Visible
               then begin
                      MainF.Salve2.Visible:=false;
                      MainF.bootmodel2.Visible:=false;
                      MainF.knife2.Visible:=true;
                    end
               else begin
                      MainF.Salve1.Visible:=false;
                      MainF.bootmodel1.Visible:=false;
                      MainF.knife1.Visible:=true;
                    end
          else begin
                MainF.Salve3.Visible:=false;
                MainF.bootmodel3.Visible:=false;
                MainF.knife3.Visible:=true;
               end;
          If (MainF.bootmodel1.Visible=false)and(MainF.bootmodel2.Visible=false)and(MainF.bootmodel3.Visible=false)
          then AllHeroes[Hero].DelBuff(SpeedBuff);
          If (MainF.Salve1.Visible=false)and(MainF.Salve2.Visible=false)and(MainF.Salve3.Visible=false)
          then AllHeroes[Hero].DelBuff(SmallBuff);
        end;
      4:begin
          q:=Random(3);
          Inc(q);
          Case q of
            1:Begin
                If MainF.bootmodel1.Visible
                then s:=1;
                If MainF.Salve1.Visible
                then s:=2;
                If MainF.Knife1.Visible
                then s:=3;
              End;
            2:Begin
                If MainF.bootmodel2.Visible
                then s:=1;
                If MainF.Salve2.Visible
                then s:=2;
                If MainF.Knife2.Visible
                then s:=3;
              End;
            3:Begin
                If MainF.bootmodel3.Visible
                then s:=1;
                If MainF.Salve3.Visible
                then s:=2;
                If MainF.Knife3.Visible
                then s:=3;
              End;
            End;
            Self.Damage:=10;//AllHeroes[Hero].Skill[s].Damage;
            Case S of
              1:Begin Me:=@mainF.TBoot;end;
              2:Begin Me:=@MainF.TSalve;End;
            else me:=@mainF.TKnife;
            end;
          GetOrCreateDCEDynamic(Me^).active:=false;
          Me^.Position.x:=MainF.pricel2.Position.x;
          Me^.Position.y:=MainF.pricel2.Position.y;
          Me^.Position.z:=MainF.pricel2.Position.z;
          Me^.Direction:=MyHeroModel^.Direction;
          Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
          Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
          Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
          {Me^.Visible:=true;
          me^.VisibleAtRunTime:=true;}
          GetOrCreateDCEDynamic(Me^).active:=true;
          GetOrCreateDceDynamic(me^).Friction:=0;
          Force:=NullVector;
          Force[0]:=xx*StForce/3;
          Force[1]:=yy*StForce/3;
          Force[2]:=zz*StForce/3;
          GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
          Force:=NullVector;
        end;
      end;
     end;
  3: begin
      Case Number of
        1:Begin
           { Me^.Position.x:=MainF.Shaman.Position.x;
            Me^.Position.Y:=MainF.Shaman.Position.y;
            me^.Position.z:=MainF.Shaman.Position.z;}
            //me^.Direction:=MainF;
            MainF.GLThorFXManager1.MaxPoints:=256;
            MainF.GLThorFXManager1.Disabled:=false;
          End;
        2:Begin
            AllHeroes[3].Health:=allHeroes[3].Health-Damage;
            AllHeroes[3].Heal150.visible:=true;
            If AllHeroes[3].Health>allHeroes[3].MaxHealth
            then AllHeroes[3].Health:=allHeroes[3].MaxHealth;
            //Me^.Position:=MainF.Shaman.position;
            Me^.Position.x:=0;
            Me^.Position.y:=0;
            Me^.Position.z:=0;
          End;
        3:Begin
           GetOrCreateDCEDynamic(Me^).active:=false;
           Me^.Position:=MainF.pricel.Position;
           Me^.Direction:=MyHeroModel^.Direction;
           Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
           Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
           Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
           GetOrCreateDCEDynamic(Me^).active:=true;
           GetOrCreateDceDynamic(Self.me^).Friction:=0;
           Force:=NullVector;
           Force[0]:=xx*StForce/2;
           Force[1]:=yy*StForce/2;
           Force[2]:=zz*StForce/2;
           GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
           Force:=NullVector;
          End;
        4:Begin
           GetOrCreateDCEDynamic(Me^).active:=false;
           Me^.Position:=MainF.pricel.Position;
           Me^.Direction:=MyHeroModel^.Direction;
           Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
           Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
           Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
           GetOrCreateDCEDynamic(Me^).active:=true;
           GetOrCreateDceDynamic(Self.me^).Friction:=0;
           Force:=NullVector;
           Force[0]:=xx*StForce/2;
           Force[1]:=yy*StForce/2;
           Force[2]:=zz*StForce/2;
           GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
           Force:=NullVector;
          End;
      end;
     end;
  end;
  Self.LifeTimeLeft:=Self.lifetime;
End;

Procedure Tskills.Anim1(xx,yy,zz:real);
var force:tAffineVector;
x:single;
s,q:integer;
Begin
  AllHeroes[Hero].CoolDowns[Number]:=CoolDown;
  Case Hero of
  1: begin
      Case Number of
      1:begin
         // MainF.Fireball.Behaviours.
         //GetOrCreateDCEDynamic(MainF.Mage).active:=False;
          //MainF.Fireball.Tag:=Self.lifetime;
          GetOrCreateDCEDynamic(Me^).active:=false;
          Me^.Position:=MainF.pricel.Position;
          Me^.Direction:=MyHeroModel^.Direction;
          Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
          Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
          Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
          GetOrCreateDCEDynamic(Me^).active:=true;
          GetOrCreateDceDynamic(Self.me^).Friction:=0;
         // MainF.Fireball.VisibleAtRunTime:=true;
          Force:=NullVector;
          //GetOrCreateDCEDynamic(MainF.Fireball).Move(force,0);
          Force[0]:=xx*StForce/2;
          Force[1]:=yy*StForce/2;
          Force[2]:=zz*StForce/2;
          //GetOrCreateDceDynamic(MainF.Fireball).Friction:=0;
          GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
          //GetOrCreateDCEDynamic(MainF.Mage).active:=true;
          Force:=NullVector;
        end;
      2:begin
          GetOrCreateDCEDynamic(Me^).active:=false;
          Me^.Position:=MainF.pricel.Position;
          Me^.Direction:=MyHeroModel^.Direction;
          Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
          Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
          Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
          GetOrCreateDCEDynamic(Me^).active:=true;
          GetOrCreateDceDynamic(Self.me^).Friction:=0;
          Force:=NullVector;
          Force[0]:=xx*StForce/2;
          Force[1]:=yy*StForce/2;
          Force[2]:=zz*StForce/2;
          GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
          Force:=NullVector;
        end;
      3:begin
          Force:=NullVector;
          Force[0]:=xx*stForce*100;
          Force[1]:=yy*stForce*100;
          Force[2]:=zz*stForce*100;
          {MyHeroModel^.Position.X:=MyHeroModel.Position.X+xx;
          MyHeroModel^.Position.y:=MyHeroModel.Position.y+yy;
          MyHeroModel^.Position.z:=MyHeroModel.Position.z+zz;}
          GetOrCreateDceDynamic(MyHeroModel^).ApplyAccel(FOrce);
          MainF.GLPostEffect1.preset:=pepDistort;
        end;
      4:begin
           me^.Position:=MyHeroModel^.Position;
           x:=MainF.GLCadencer1.CurrentTime;
           GetOrCreateSourcePFX(me^).RingExplosion(x,25,30,100);
           //CheckAOE(Me^.Position.x,me^.Position.y,me^.Position.Z);
        end;
      end;
     end;
  2: begin
      Case Number of
      1:begin
          Self.Me^.Position.x:=0;
          Self.Me^.Position.y:=2;
          Self.Me^.Position.z:=0;
          If MainF.bootmodel1.Visible
          then If MainF.bootmodel2.Visible
               then begin
                      MainF.bootmodel3.Visible:=TRUE;
                      MainF.Salve3.Visible:=false;
                      MainF.knife3.Visible:=false;
                    end
               else begin
                      MainF.bootmodel2.Visible:=true;
                      MainF.Salve2.Visible:=false;
                      MainF.knife2.Visible:=false;
                    end
          else begin
                MainF.bootmodel1.Visible:=true;
                MainF.Salve1.Visible:=false;
                MainF.knife1.Visible:=false;
               end;
          If (MainF.Salve1.Visible=false)and(MainF.Salve2.Visible=false)and(MainF.Salve3.Visible=false)
          then AllHeroes[Hero].DelBuff(SmallBuff);
          AllHeroes[Hero].AddBuff(SpeedBuff,self.lifetime);
        end;
      2:begin
          Self.Me^.Position.x:=0;
          Self.Me^.Position.y:=2;
          Self.Me^.Position.z:=0;
          If MainF.Salve2.Visible
          then If MainF.Salve3.Visible
               then begin
                      MainF.Salve1.Visible:=true;
                      MainF.bootmodel1.Visible:=false;
                      MainF.knife1.Visible:=false;
                    end
               else begin
                      MainF.Salve3.Visible:=true;
                      MainF.bootmodel3.Visible:=false;
                      MainF.knife3.Visible:=false;
                    end
          else begin
                MainF.Salve2.Visible:=true;
                MainF.bootmodel2.Visible:=false;
                MainF.knife2.Visible:=false;
               end;
          If (MainF.bootmodel1.Visible=false)and(MainF.bootmodel2.Visible=false)and(MainF.bootmodel3.Visible=false)
          then AllHeroes[Hero].DelBuff(SpeedBuff);
          AllHeroes[Hero].AddBuff(SmallBuff,self.lifetime);
        end;
      3:begin
          Self.Me^.Position.x:=0;
          Self.Me^.Position.y:=2;
          Self.Me^.Position.z:=0;
          If MainF.knife3.Visible
          then If MainF.knife1.Visible
               then begin
                      MainF.Salve2.Visible:=false;
                      MainF.bootmodel2.Visible:=false;
                      MainF.knife2.Visible:=true;
                    end
               else begin
                      MainF.Salve1.Visible:=false;
                      MainF.bootmodel1.Visible:=false;
                      MainF.knife1.Visible:=true;
                    end
          else begin
                MainF.Salve3.Visible:=false;
                MainF.bootmodel3.Visible:=false;
                MainF.knife3.Visible:=true;
               end;
          If (MainF.bootmodel1.Visible=false)and(MainF.bootmodel2.Visible=false)and(MainF.bootmodel3.Visible=false)
          then AllHeroes[Hero].DelBuff(SpeedBuff);
          If (MainF.Salve1.Visible=false)and(MainF.Salve2.Visible=false)and(MainF.Salve3.Visible=false)
          then AllHeroes[Hero].DelBuff(SmallBuff);
        end;
      4:begin
          q:=Random(3);
          Inc(q);
          Case q of
            1:Begin
                If MainF.bootmodel1.Visible
                then s:=1;
                If MainF.Salve1.Visible
                then s:=2;
                If MainF.Knife1.Visible
                then s:=3;
              End;
            2:Begin
                If MainF.bootmodel2.Visible
                then s:=1;
                If MainF.Salve2.Visible
                then s:=2;
                If MainF.Knife2.Visible
                then s:=3;
              End;
            3:Begin
                If MainF.bootmodel3.Visible
                then s:=1;
                If MainF.Salve3.Visible
                then s:=2;
                If MainF.Knife3.Visible
                then s:=3;
              End;
            End;
            Self.Damage:=10;//AllHeroes[Hero].Skill[s].Damage;
            Case S of
              1:Begin Me:=@mainF.TBoot;end;
              2:Begin Me:=@MainF.TSalve;End;
            else me:=@mainF.TKnife;
            end;
          GetOrCreateDCEDynamic(Me^).active:=false;
          Me^.Position.x:=MainF.pricel2.Position.x;
          Me^.Position.y:=MainF.pricel2.Position.y;
          Me^.Position.z:=MainF.pricel2.Position.z;
          Me^.Direction:=MyHeroModel^.Direction;
          Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
          Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
          Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
          {Me^.Visible:=true;
          me^.VisibleAtRunTime:=true;}
          GetOrCreateDCEDynamic(Me^).active:=true;
          GetOrCreateDceDynamic(me^).Friction:=0;
          Force:=NullVector;
          Force[0]:=xx*StForce/3;
          Force[1]:=yy*StForce/3;
          Force[2]:=zz*StForce/3;
          GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
          Force:=NullVector;
        end;
      end;
     end;
  3: begin
      Case Number of
        1:Begin
           { Me^.Position.x:=MainF.Shaman.Position.x;
            Me^.Position.Y:=MainF.Shaman.Position.y;
            me^.Position.z:=MainF.Shaman.Position.z;}
            //me^.Direction:=MainF;
            MainF.GLThorFXManager1.MaxPoints:=256;
            MainF.GLThorFXManager1.Disabled:=false;
          End;
        2:Begin
            AllHeroes[3].Health:=allHeroes[3].Health-Damage;
            AllHeroes[3].Heal150.visible:=true;
            If AllHeroes[3].Health>allHeroes[3].MaxHealth
            then AllHeroes[3].Health:=allHeroes[3].MaxHealth;
            //Me^.Position:=MainF.Shaman.position;
            Me^.Position.x:=0;
            Me^.Position.y:=0;
            Me^.Position.z:=0;
          End;
        3:Begin
           GetOrCreateDCEDynamic(Me^).active:=false;
           Me^.Position:=MainF.pricel.Position;
           Me^.Direction:=MyHeroModel^.Direction;
           Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
           Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
           Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
           GetOrCreateDCEDynamic(Me^).active:=true;
           GetOrCreateDceDynamic(Self.me^).Friction:=0;
           Force:=NullVector;
           Force[0]:=xx*StForce/2;
           Force[1]:=yy*StForce/2;
           Force[2]:=zz*StForce/2;
           GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
           Force:=NullVector;
          End;
        4:Begin
           GetOrCreateDCEDynamic(Me^).active:=false;
           Me^.Position:=MainF.pricel.Position;
           Me^.Direction:=MyHeroModel^.Direction;
           Me^.Position.x:=Me^.Position.x+MyHeroModel^.position.x;
           Me^.Position.y:=Me^.Position.y+MyHeroModel^.position.y;
           Me^.Position.z:=Me^.Position.z+MyHeroModel^.position.z;
           GetOrCreateDCEDynamic(Me^).active:=true;
           GetOrCreateDceDynamic(Self.me^).Friction:=0;
           Force:=NullVector;
           Force[0]:=xx*StForce/2;
           Force[1]:=yy*StForce/2;
           Force[2]:=zz*StForce/2;
           GetOrCreateDceDynamic(Me^).ApplyAccel(FOrce);
           Force:=NullVector;
          End;
      end;
     end;
  end;
  Self.LifeTimeLeft:=Self.lifetime;
End;

{***************THeroes********************************}

Constructor THeroes.CreateH(nMyNumber:byte);
var I:integer;
p:pointer;
s:string;
Begin
  Inherited;
  MoveAble:=true;
  ControlAble:=true;
  MaxHealth:=HeroHealth[nMyNumber];
  Health   :=maxHealth;
  MyName   :=HeroName[nMyNumber];
  MyNumber :=nMyNumber;
  Action   :=NoneAct;
  StSize:=StandartScale[nMyNumber];
  Case nMyNumber of
    1:  begin
          New(me);
          me:=@MainF.Mage;
          new(Actor);
          Actor:=@mainF.solo322;
          MyCamera:=MainF.GLCamera1;
          StSpeed:=StForce/2;
          speed:=stSpeed;
          New(MyPricel);
          MyPricel:=@MainF.pricel;
        end;
    2:  begin
          New(me);
          Me:=@MainF.juggler;
          New(Actor);
          Actor:=@MainF.DreadLev;
          MyCamera:=MainF.GLCamera2;
          StSpeed:=StForce/2;
          speed:=StSpeed;
          New(MyPricel);
          MyPricel:=@mainF.pricel2;
        end;
    3:  begin
          New(me);
          Me:=@MainF.Shaman;
          New(Actor);
          Actor:=@MainF.Vitushaman;
          MyCamera:=MainF.GlCamera3;
          StSpeed:=StForce/2;
          Speed:=StSpeed;
          New(MyPricel);
          MyPricel:=@MainF.pricel3;
        end;
  end;
  new(p);
  p:=me;
 { If MyNumber=1
  then begin
  s:='media\Pic';
  s:=s+IntToStr(MyNumber);
  For i:=1 to MaxSkills do
    Begin
      s:=s+IntToStr(i);
      SkillSprites[i]:=TGLHUDSprite.CreateAsChild(MainF.GLScene1.Objects);
      SkillSprites[i].Material.Texture.Image.LoadFromFile(s+'.Jpg');
      SkillSprites[i].Material.Texture.Disabled:=false;
      With SkillSprites[i] do
        begin
          Height:=(GetDeviceCaps(GetDC(0),VERTRES))div 5;
          Width:=GetDeviceCaps(GetDC(0),HORZRES)div 5;
          Position.x:=GetDeviceCaps(GetDC(0),HORZRES)/4*i-Width/3*2;
          Position.y:=(GetDeviceCaps(GetDC(0),VERTRES)/5)*4
        end;
      Delete(s,Length(s),1);
    End;
    End;//for sprites If   }
  For i:=1 to MaxBuffs do
    Buffs[i]:=-0.1;
  For i:=1 to MaxEff do
    Effects[i]:=-0.1;
  For i:=1 to MaxSkills do
    begin
      Skill[i]:=TSkills.CreateS(nMyNumber,i,p);
      CoolDowns[i]:=0;
    end;
  //ChangeHP:=TGLSprite.CreateAsChild(me^);
  //ChangeHP.Visible:=false;

  Dmg1:=TGLSprite.CreateAsChild(me^);
  Dmg1.Visible:=false;
  Dmg1.Material.Texture.Image.LoadFromFile('media\Bang1.jpg');
  dmg1.Material.Texture.Disabled:=false;
  dmg1.Height:=3;
  Dmg1.Width:=3;
  dmg1.Position.x:=2-random(4);
  dmg1.Position.Y:=4-random(2);

  Dmg50:=TGLSprite.CreateAsChild(me^);
  Dmg50.Visible:=false;
  Dmg50.Material.Texture.Image.LoadFromFile('media\Bang50.jpg');
  dmg50.Material.Texture.Disabled:=false;
  dmg50.Height:=3;
  Dmg50.Width:=3;
  dmg50.Position.x:=2-random(4);
  dmg50.Position.Y:=4-random(2);

  Dmg100:=TGLSprite.CreateAsChild(me^);
  Dmg100.Visible:=false;
  Dmg100.Material.Texture.Image.LoadFromFile('media\Bang100.jpg');
  dmg100.Material.Texture.Disabled:=false;
  dmg100.Height:=3;
  Dmg100.Width:=3;
  dmg100.Position.x:=2-random(4);
  dmg100.Position.Y:=4-random(2);

  Dmg150:=TGLSprite.CreateAsChild(me^);
  Dmg150.Visible:=false;
  Dmg150.Material.Texture.Image.LoadFromFile('media\Bang150.jpg');
  dmg150.Material.Texture.Disabled:=false;
  dmg150.Height:=3;
  Dmg150.Width:=3;
  dmg150.Position.x:=2-random(4);
  dmg150.Position.Y:=4-random(2);

  Heal150:=TGLSprite.CreateAsChild(me^);
  Heal150.Visible:=false;
  Heal150.Material.Texture.Image.LoadFromFile('media\Heal150.jpg');
  Heal150.Material.Texture.Disabled:=false;
  Heal150.Height:=3;
  Heal150.Width:=3;
  Heal150.Position.x:=2-random(4);
  Heal150.Position.Y:=4-random(2);

  dmg1vis   :=0;
  dmg50vis  :=0;
  dmg100vis :=0;
  dmg150vis :=0;
  Heal150vis:=0;

  For i:=1 to 5 do
    begin
      Case i of
        1: s:='media\StunEff.jpg';
        2: s:='media\DoteEff.jpg';
        3: s:='media\SlowEff.jpg';
        4: s:='media\ShackEff.jpg';
        5: s:='media\BigEff.jpg';
       end;
       EffIcons[i]:=TGLSprite.CreateAsChild(me^);
       EffIcons[i].Visible:=false;
       EffIcons[i].Material.Texture.Image.LoadFromFile(s);
       EffIcons[i].Material.Texture.disabled:=false;
       EffIcons[i].Position.Y:=4;
       EffIcons[i].Position.X:=6-i*2;
       EffIcons[i].Height:=1;
       EffIcons[i].Width:=2;
    end;

  For i:=1 to 2 do
    begin
      Case i of
        1: s:='media\SpeedBuff.jpg';
        2: s:='media\SmallBuff.jpg';
       end;
       BuffIcons[i]:=TGLSprite.CreateAsChild(me^);
       BuffIcons[i].visible:=false;
       BuffIcons[i].Material.Texture.Image.LoadFromFile(s);
       BuffIcons[i].Material.Texture.disabled:=false;
       BuffIcons[i].Position.Y:=5;
       BuffIcons[i].Position.X:=3-i*2;
       BuffIcons[i].Height:=1;
       BuffIcons[i].Width:=2;
    end;

  HealthBar:=TGLSprite.CreateAsChild(me^);
  HealthBar.MoveDown;
  HealthBar.Material.Texture.Image.LoadFromFile('media\Hpbar.jpg');
  HealthBar.Material.Texture.Disabled:=false;
  HealthBar.Position.Y:=3;
  HealthBar.Height:=0.4;
  HealthBar.Width:=1.94;
  Actor^.Scale.X:=StSize;
  Actor^.Scale.y:=StSize;
  Actor^.Scale.z:=StSize;

 // AllHeroes[nMyNumber]:=@self;
End;

Procedure THeroes.DecCDs(t:real);
var i:integer;
Begin
  For i:=1 to MaxSkills do
    If  CoolDowns[i]>0
    then begin
          CoolDowns[i]:=CoolDowns[i]-t;
          //Self.CoolDownIcons[i].SetSize(SkillSprites[i].Width*(Cooldowns[i]/skill[i].CoolDown),20);
          CoolDownIcons[i].Width:=(SkillSprites[i].Width*(Cooldowns[i]/skill[i].CoolDown));
          CoolDownIcons[i].Position.x:=SkillSprites[i].Position.x+(CoolDownIcons[i].Width-SkillSprites[i].Width)/2;
         end;
End;

Procedure tHeroes.AddBuff(n:integer;t:real);
Begin
  Buffs[n]:=t;
End;

Procedure tHeroes.CheckBuff(t:real);
var i:integer;
x,y,z:real;
Begin
  For i:=1 to MaxBuffs do
    If Buffs[i]>0
    then Buffs[i]:=Buffs[i]-t;
  If Buffs[SpeedBuff]>0
  then self.speed:=1.5*StSpeed
  else self.speed:=1*StSpeed;
  If buffs[SmallBuff]>0
  then Self.Size:=StSize*0.5
  else Self.Size:=StSize*1;
  //RegenBuff  :begin end;
  //SpecialBuff:begin end;
  {x:=actor^.Scale.X;
  y:=actor^.Scale.y;
  z:=actor^.Scale.z;}
  actor^.Scale.X:=Size;
  actor^.Scale.y:=Size;
  actor^.Scale.z:=Size
End;

Procedure tHeroes.DelBuff(n:integer);
Begin
  buffs[n]:=-0.1;
End;

Procedure tHeroes.AddEffect(n:integer;t:real);
Begin
  Effects[n]:=t;
End;

Procedure tHeroes.CheckEffect(t:real);
var spd:real;
sz:real;
i:integer;
Begin
  For i:=1 to MaxEff do
    If Effects[i]>0
    then Effects[i]:=Effects[i]-t;
  For i:=1 to MaxBuffs do
    If Buffs[i]>0
    then Buffs[i]:=Buffs[i]-t;
  spd:=StSpeed;

  For i:=1 to 2 do
    If Buffs[i]>0
    then BuffIcons[i].Visible:=true
    else BuffIcons[i].Visible:=false;

  For i:=1 to 5 do
    If Effects[i]>0
    then effIcons[i].Visible:=true
    else effIcons[i].Visible:=false;

  If Buffs[SpeedBuff]>0
  then begin
        spd:=1.5*spd;
       end
  else begin
        spd:=1*spd;
       end;

  If Effects[SlowEff]>0
  then begin
        spd:=0.5*spd
       end
  else begin
        spd:=1*Spd;
       end;


  sz:=stSize;
  If buffs[SmallBuff]>0
  then sz:=sz*0.5
  else sz:=sz*1;

  If Effects[BigEff]>0
  then sz:=sz*1.5
  else sz:=sz*1;

  If Effects[ShackEff]>0
  then Begin
        MoveAble:=false;
        //SZ:=2.5*Sz;//YBERI
       end
  else Begin
        MoveAble:=true;
       End;

  If Effects[StunEff]>0
  then begin
          ControlAble:=false;
         // SZ:=2.5*Sz;//YBERI
       end
  else Begin
      ControlAble:=true;

      End;
//  Actor^.Scale.x:=sz;
//  Actor^.Scale.y:=sz;
//  Actor^.Scale.Z:=sz;
  Me^.Scale.X:=Sz/StSize;
  Me^.Scale.y:=Sz/StSize;
  Me^.Scale.z:=Sz/StSize;
  speed:=spd;
  If (Health<>PredHP[0])and(self.MyNumber=1)
  then begin
        i:=i+1;
       end;
  HealthBar.Width:=1.94*(Health/maxhealth);
//  HealthBar.Position.x:=0.97-HealthBar.Width/2;
  {If Health<=0
  then me^.Position.x:=999;}
End;

Procedure tHeroes.DelEffect(n:integer);
Begin
  Self.Effects[n]:=0;
End;

Procedure THeroes.Move(dx,dy,dz:real);
var Force:tAffineVector;
Begin
  Force[0]:=dx*Speed;
  Force[1]:=dy*Speed;
  Force[2]:=dz*Speed;
  GetOrCreateDceDynamic(me^).ApplyAccel(Force);
  Self.ChangeAction(MoveAct);
End;

Procedure THeroes.Dodge(way:byte);
Begin
End;

Procedure THeroes.Cast(sNumber:byte);
Begin
  If CoolDowns[sNumber]<=0
  then begin
        ActiveSkill:=Self.Skill[sNumber];
        Self.Skill[sNumber].Targeting;
        //CoolDowns[sNumber]:=Skill[sNumber].CoolDown;
       end;
End;

Procedure THeroes.Jump;
Begin
End;

Procedure THeroes.Die;
Begin
End;

Procedure THeroes.ChangeAction(newAct:byte);
Begin
  Self.Action:=NewAct;
End;

Procedure THeroes.TakeDamage(Damage:integer);
Begin
End;

{*****************FORM*********************************}

procedure TMainF.Load;
var c:char;
i:byte;
s:string;
begin
  Chosed:=false;
  with GLMaterialLibrary1 do
  begin
    AddTextureMaterial('TexPole','media\travka.jpg');
    AddTextureMaterial('Actor','media\SABTOOTH.jpg');
//    AddMaterialsFromFile('media\huds\mainfigure.png');
  end;
//('Juggler','pacan.3ds');
  GLBitmapHDS1.MaxPoolSize:=8*1024*1024;
  GLBitmapHDS1.Picture.LoadFromFile('media\terrain.bmp');
  Terrain.Direction.SetVector(0,1,0);
  Terrain.Material.LibMaterialName := 'TexPole';
  Terrain.TilesPerTexture:=16/Terrain.TileSize;
  Terrain.Scale.SetVector(1,1,0.02);
  For i:=1 to MaxHeroes do
    AllHeroes[i]:=THeroes.CreateH(i);

  Mage.Up.SetVector(0,1,0);
  Mage.Direction.SetVector(0,0,1);
  Solo322.LoadFromFile('media\mage.3ds');
  Solo322.Direction.SetVector(0,1,0);
  solo322.UseMeshMaterials:=true;
  //Solo322.Scale.SetVector(0.0322,0.0322,0.0322);

{************JugglerCreate********************}

  //GLMaterialLibrary1.AddTextureMaterial('Juggler','media\nskinbl.jpg');
  DreadLev.Direction.SetVector(0,1,0);
  DreadLev.MaterialLibrary:=GLMaterialLibrary1;
  DreadLev.LoadFromFile('media\barny.3ds');
  DreadLev.UseMeshMaterials:=true;
 // DreadLev.Material.LibMaterialName:='bootmat';
  Juggler.Up.SetVector(0,1,0);
  Juggler.Direction.SetVector(0,0,1);
  //DreadLev.Scale.SetVector(0.0228,0.0228,0.0228);

  BootModel1.MaterialLibrary:=GLMaterialLibrary1;
  BootModel1.LoadFromFile('media\obuv.3ds');
  BootModel1.UseMeshMaterials:=true;
  BootModel1.Scale.setvector(0.06,0.06,0.06);
  BootModel2.MaterialLibrary:=GLMaterialLibrary1;
  BootModel2.LoadFromFile('media\obuv.3ds');
  BootModel2.UseMeshMaterials:=true;
  BootModel2.Scale.setvector(0.06,0.06,0.06);
  BootModel3.MaterialLibrary:=GLMaterialLibrary1;
  BootModel3.LoadFromFile('media\obuv.3ds');
  BootModel3.UseMeshMaterials:=true;
  BootModel3.Scale.setvector(0.06,0.06,0.06);
  TB.MaterialLibrary:=GlMaterialLibrary1;
  TB.LoadFromFile('media\obuv.3ds');
  TB.UseMeshMaterials:=true;
  TB.Scale.setvector(0.06,0.06,0.06);

  Salve1.MaterialLibrary:=GLMaterialLibrary1;
  Salve1.Direction.SetVector(0,1,0);
  Salve1.LoadFromFile('media\potion_flask_subpatches.3ds');
  Salve1.Scale.SetVector(4,4,4);
  Salve1.UseMeshMaterials:=true;
  Salve2.MaterialLibrary:=GLMaterialLibrary1;
  Salve2.Direction.SetVector(0,1,0);
  Salve2.LoadFromFile('media\potion_flask_subpatches.3ds');
  Salve2.Scale.SetVector(4,4,4);
  Salve2.UseMeshMaterials:=true;
  Salve3.MaterialLibrary:=GLMaterialLibrary1;
  Salve3.Direction.SetVector(0,1,0);
  Salve3.LoadFromFile('media\potion_flask_subpatches.3ds');
  Salve3.Scale.SetVector(4,4,4);
  Salve3.UseMeshMaterials:=true;
  TS.MaterialLibrary:=GLMaterialLibrary1;
  TS.Direction.SetVector(0,1,0);
  TS.LoadFromFile('media\potion_flask_subpatches.3ds');
  TS.Scale.SetVector(4,4,4);
  TS.UseMeshMaterials:=true;

  Knife1.LoadFromFile('media\Knife Texture.3ds');
  Knife1.Scale.SetVector(0.2,0.2,0.2);
  Knife1.Direction.SetVector(1,0,0);
  Knife2.LoadFromFile('media\Knife Texture.3ds');
  Knife2.Scale.SetVector(0.2,0.2,0.2);
  Knife2.Direction.SetVector(1,0,0);
  Knife3.LoadFromFile('media\Knife Texture.3ds');
  Knife3.Scale.SetVector(0.2,0.2,0.2);
  Knife3.Direction.SetVector(1,0,0);
  TK.LoadFromFile('media\Knife Texture.3ds');
  TK.Scale.SetVector(0.2,0.2,0.2);
  TK.Direction.SetVector(0,1,0);

 {**************HUD Create****************}
  {MainHUD.Material.Texture.Image.LoadFromFile('media\huds\mainfigure.png');
 // MainHUD.Material.Texture.Image.
  MainHUD.Material.Texture.Disabled:=false;
  With MainHUD do
    begin
      //Material:='MainH';
      Width:=GetDeviceCaps(GetDC(0),HORZRES);
      Height:=(GetDeviceCaps(GetDC(0),VERTRES))div 5;
      Position.x:=Width/2;
      Position.y:=GetDeviceCaps(GetDC(0),VERTRES)-(Height/2)
    end;       }
  Shaman.Up.SetVector(0,1,0);
  Shaman.Direction.SetVector(0,0,1);
  Vitushaman.LoadFromFile('media\shamanking.3ds');
  Vitushaman.Direction.SetVector(0,1,0);
  Vitushaman.UseMeshMaterials:=true;



 { heroes[0]:=AllHeroes[1];
  heroes[1]:=AllHeroes[2];
  GLSceneViewer1.Camera:=heroes[0].MyCamera;
  s:='media\Pic';
  s:=s+IntToStr(heroes[0].MyNumber);
  For i:=1 to MaxSkills do
    Begin
      s:=s+IntToStr(i);
      heroes[0].SkillSprites[i]:=TGLHUDSprite.CreateAsChild(MainF.GLScene1.Objects);
      heroes[0].SkillSprites[i].Material.Texture.Image.LoadFromFile(s+'.Jpg');
      heroes[0].SkillSprites[i].Material.Texture.Disabled:=false;
      With heroes[0].SkillSprites[i] do
        begin
          Height:=(GetDeviceCaps(GetDC(0),VERTRES))div 5;
          Width:=GetDeviceCaps(GetDC(0),HORZRES)div 5;
          Position.x:=GetDeviceCaps(GetDC(0),HORZRES)/4*i-Width/3*2;
          Position.y:=(GetDeviceCaps(GetDC(0),VERTRES)/5)*4
        end;
      Delete(s,Length(s),1);
    End;}
     For i:=1 to MaxHeroes do
      begin
        AllHeroes[i].Me^.Position.x:=5000+i*5;
        AllHeroes[i].Me^.Position.Y:=5000;
        allHeroes[i].Me^.position.Z:=5;
        AllHeroes[i].Me^.Turn(180);
        allHeroes[i].CheckEffect(0);
        HNames[i]:=TGLSpaceText.CreateAsChild(MainF.GLScene1.Objects);
        HNames[i].Lines:=TStringList.Create;
        HNames[i].Lines.Append(HeroName[i]);
        HNames[i].Position.X:=AllHeroes[i].Me^.Position.x+length(HeroName[i])div 4;
        HNames[i].Position.y:=AllHeroes[i].Me^.Position.y-3;
        HNames[i].Position.Z:=AllHeroes[i].Me^.Position.Z;
        With HNames[i].Material.FrontProperties.Diffuse do
          begin
            Alpha:=1;
            Blue:=0;
            Green:=0.5;
            Red:=1;
          end;
        HNames[i].Direction.Z:=-1;
      end;
     GlDCEManager1.Gravity:=0;
  //   ChooseCamera.TargetObject:=AllHeroes[1].me^;
     NumChose:=1;
     Heroes[1]:=allHeroes[1];
end;



procedure TMainF.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var force:tAffineVector;
    j,i:integer;
    s:string;
    xx,yy,zz,x,y,x1,y1,x2,y2:real;
    SkillNumber:integer;
begin
If Chosed
then begin
  For i:=0 to 1 do
    PredHP[i]:=Heroes[i].Health;
  //Writing
  s := IntToStr(MyNumber) + '0000';
  If IsKeyDown('w')
  then begin
         s[2]:='1';
       end;
  If IsKeyDown('s')
  then begin
         s[4]:='1';
       end;
  If IsKeyDown('a')
  then begin
         s[5]:='1';
       end;
  If IsKeyDown('d')
  then begin
         s[3]:='1';
       end;
  s := s + FloatToStrF(Heroes[0].Me^.Direction.X,ffFixed,1,2) + ' '
         + FloatToStrF(Heroes[0].Me^.Direction.Y,ffFixed,1,2) + ' '
         + FloatToStrF(Heroes[0].Me^.Direction.Z,ffFixed,1,2) + ' ';
  if not skillused
  then s := s + '0'
  else begin
         skillused := false;
         s := s + '1';
         s := s + IntToStr(sNumber);
         s := s + FloatToStrF(sx,ffFixed,1,2) + ' '
                + FloatToStrF(sy,ffFixed,1,2) + ' '
                + FloatToStrF(sz,ffFixed,1,2);
       end;
  Client.Write(s + '$');
  //Reading
  s := Client.CurrentReadBuffer;
if s<>''
then begin
  s := copy(s,1,pos('$', s) - 1);
  Heroes[0].Me^.Position.X := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[0].Me^.Position.Y := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[0].Me^.Position.Z := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));

  Heroes[1].Me^.Position.X := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[1].Me^.Position.Y := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[1].Me^.Position.Z := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));

  Heroes[1].Me^.Direction.X := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[1].Me^.Direction.Y := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[1].Me^.Direction.Z := StrToFloat(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  //HP
  Heroes[0].Health := StrToInt(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  Heroes[1].Health := StrToInt(Copy(s,1,pos(' ', s)-1));
  delete(s,1,pos(' ', s));
  //Eff
  for i:=1 to 5 do
  if s[i]='1'
  then Heroes[0].Effects[i] := 10
  else Heroes[0].Effects[i] := 0;
  delete(s,1,5);
  for i:=1 to 2 do
  if s[i]='1'
  then Heroes[0].Buffs[i] := 10
  else Heroes[0].Buffs[i] := 0;
  delete(s,1,2);
  for i:=1 to 5 do
  if s[i]='1'
  then Heroes[1].Effects[i] := 10
  else Heroes[1].Effects[i] := 0;
  delete(s,1,5);
  for i:=1 to 2 do
  if s[i]='1'
  then Heroes[1].Buffs[i] := 10
  else Heroes[1].Buffs[i] := 0;
  delete(s,1,2);

  if s[1] = '1'
  then begin
         SkillNumber := StrToInt(copy(s,2,1));
         delete(s,1,2);
         xx := StrToFloat(copy(s,1,pos(' ', s) - 1));
         delete(s,1,pos(' ', s));
         yy := StrToFloat(copy(s,1,pos(' ', s) - 1));
         delete(s,1,pos(' ', s));
         zz := StrToFloat(copy(s,1,pos(' ', s) - 1));
         delete(s,1,pos(' ', s));
         Heroes[1].Skill[SkillNumber].Anim1(xx, yy, zz);
       end;
end;



  CollisionManager1.CheckCollisions;

 { If MainF.GLThorFXManager1.Maxpoints=256
  then Begin
        x1:=MainF.Shaman.Position.x;
        y1:=MainF.Shaman.Position.z;
        x2:=MainF.Shaman.Position.x+40*(MainF.Shaman.Direction.x);
        y2:=MainF.Shaman.Position.z+40*(MainF.Shaman.Direction.z);
        x:=heroes[1].me^.position.x;
        y:=heroes[1].me^.position.z;
        If (abs((x-x1)/(x2-x1)-(y-y1)/(y2-y1))<0.05)and(((x>x1)and(x<x2))or((x<x1)and(x>x2)))
        then heroes[1].Health:=heroes[1].Health-AllHeroes[3].skill[1].Damage;
        If heroes[1].Health<=0
        then heroes[1].me^.Position.x:=9999;
       End;    }

  If MainF.Meteorit.Position.y<=0
  then Begin
        x:=MainF.GLCadencer1.CurrentTime;
        GetOrCreateSourcePFX(MainF.Meteorit).RingExplosion(x,25,15,100);
        //AllHeroes[3].Skill[3].CheckAOE(Meteorit.Position.x,meteorit.Position.Y,meteorit.Position.z);
        AllHeroes[3].Skill[3].Hide;
        {If heroes[1].Health<=0
        then heroes[1].me^.Position.x:=9999;}
       End;

  TK.Pitch(-deltatime*1000);

  Force:=NullVector;

  {For i:=1 to MaxHeroes do
    AllHeroes[i]^.CheckBuff(deltatime);}
  heroes[0].CheckEffect(deltatime);

  If Heroes[0].Effects[StunEff]>0
  then GLPostEffect1.Preset:=pepNightVision
  else GLPostEffect1.Preset:=pepNone;
  heroes[1].CheckEffect(deltatime);

  {Heroes[1].HealthBar.Direction.x:=-Heroes[0].MyCamera.direction.x;
  Heroes[1].HealthBar.Direction.y:=-Heroes[0].MyCamera.direction.y;
  Heroes[1].HealthBar.Direction.z:=-Heroes[0].MyCamera.direction.z;}

  heroes[0].DecCDs(deltatime);
  //heroes[1].DecCDs(deltatime);

  If (IsKeyDown('w'))and(heroes[0].MoveAble)and(heroes[0].ControlAble)
  then begin
     //Solo322.Position.z:=Player.Position.z+3*deltatime;
     //Solo322.Direction.SetVector(0,0,0);
     //Player.Up
     //SetVector(0,0,1);
     //Force[2]:=StForce;
     heroes[0].Move(0,0,1);
  end;
  If (IsKeyDown('s'))and(heroes[0].MoveAble)and(heroes[0].ControlAble)
  then begin
      //Solo322.Position.z:=Player.Position.z-3*deltatime;
      //Solo322.Up.SetVector(0,0,2);
      //Force[2]:=-StForce;
      heroes[0].Move(0,0,-1);
  end;
  If (IsKeyDown('a'))and(heroes[0].MoveAble)and(heroes[0].ControlAble)
  then begin
       //Solo322.Position.x:=Player.Position.x+3*deltatime;
       //Solo322.Up.SetVector(0,0,3);
       //Force[0]:=StForce;
       heroes[0].Move(1,0,0);
  end;
  If (IsKeyDown('d'))and(heroes[0].MoveAble)and(heroes[0].ControlAble)
  then begin
        //Solo322.Up.SetVector(0,0,4);
        //Solo322.Position.x:=Player.Position.x-3*deltatime;
        //Force[0]:=-StForce;
        heroes[0].Move(-1,0,0);
  end;
 //GetOrCreateDceDynamic(Mage).ApplyAccel(FOrce);

 {********LifeTime************}
 For j:=0 to 1 do
  For i:=1 to 4 do
    If heroes[j].Skill[i].LifeTimeLeft>0
    then Begin
          heroes[j].Skill[i].LifeTimeLeft:=heroes[j].Skill[i].LifeTimeLeft-deltatime;
          If heroes[j].Skill[i].LifeTimeLeft<=0
          then heroes[j].Skill[i].Hide
         end;
 {********LifeTimeEns*********}

    For i:=0 to 1 do
      begin
        Case PredHP[i]-Heroes[i].Health of
           1:  begin
                Heroes[i].Dmg1.Visible:=true;
                Heroes[i].Dmg1.Position.x:=2-random(4);
                Heroes[i].Dmg1.Position.Y:=6-random(2);
               end;
           50: begin
                Heroes[i].Dmg50.Visible:=true;
                Heroes[i].Dmg50.Position.x:=2-random(4);
                Heroes[i].Dmg50.Position.Y:=6-random(2);
               end;
           100:begin
                Heroes[i].Dmg100.Visible:=true;
                Heroes[i].Dmg100.Position.x:=2-random(4);
                Heroes[i].Dmg100.Position.Y:=6-random(2);
               end;
           150:begin
                Heroes[i].Dmg150.Visible:=true;
                Heroes[i].Dmg150.Position.x:=2-random(4);
                Heroes[i].Dmg150.Position.Y:=6-random(2);
               end;
        end;
        If PredHP[i]-Heroes[i].Health<0
        then begin
              Heroes[i].Heal150.Visible:=true;
              Heroes[i].Heal150.Position.x:=2-random(4);
              Heroes[i].Heal150.Position.Y:=6-random(2);
             end;
      end;

      For i:=0 to 1 do
        begin
          If heroes[i].Dmg1.Visible
          then heroes[i].dmg1vis:=heroes[i].dmg1vis+deltatime;
          If heroes[i].Dmg50.Visible
          then heroes[i].dmg50vis:=heroes[i].dmg50vis+deltatime;
          If heroes[i].Dmg100.Visible
          then heroes[i].dmg100vis:=heroes[i].dmg100vis+deltatime;
          If heroes[i].Dmg150.Visible
          then heroes[i].dmg150vis:=heroes[i].dmg150vis+deltatime;
          If heroes[i].Heal150.Visible
          then heroes[i].heal150vis:=heroes[i].Heal150vis+deltatime;

          If heroes[i].dmg1vis>1
          then begin
                heroes[i].Dmg1.Visible:=false;
                heroes[i].dmg1vis:=0;
               end;
          If heroes[i].dmg50vis>1
          then Begin
                heroes[i].Dmg50.Visible:=false;
                heroes[i].dmg50vis:=0;
               end;
          If heroes[i].dmg100vis>1
          then begin
                heroes[i].Dmg100.Visible:=false;
                heroes[i].dmg100vis:=0;
               end;
          If heroes[i].dmg150vis>1
          then Begin
                heroes[i].Dmg150.Visible:=false;
                heroes[i].dmg150vis:=0;
               end;
          If heroes[i].Heal150vis>1
          then begin
                heroes[i].Heal150.Visible:=false;
                heroes[i].heal150vis:=0;
               end;
        end;

  If Heroes[0].Health<=0
  then begin
        ShowMessage('Вы проиграли');
        MAinF.Close;
       end
  else If Heroes[1].Health<=0
       then begin
              ShowMessage('Вы победили');
              MAinF.Close;
            end;
  End //for chosed if
Else Begin //if not chosed
      For i:=1 to MaxHeroes do
        AllHeroes[i].me^.Turn(deltatime*30);
      If abs(ChooseCamera.position.X-AllHeroes[numChose].me^.position.X)>0.1
      then
      If ChooseCamera.position.X<AllHeroes[numChose].me^.position.X
      then begin
            ChooseCamera.position.X:=ChooseCamera.position.X+Deltatime*10;
         //   ChooseCube.position.X:=ChooseCamera.position.X;
           end
      else If ChooseCamera.position.X>AllHeroes[numChose].me^.position.X
           then begin
                  ChooseCamera.position.X:=ChooseCamera.position.X-Deltatime*10;
                //  ChooseCube.position.X:=ChooseCamera.position.X;
                end;
     End;
end;

procedure TMainF.FormCreate(Sender: TObject);
begin
Load;
Client.Connect;
  MyNumber := StrToInt(Client.CurrentReadBuffer);
  {if MyNumber = 0
           then begin
                  Heroes[0] := AllHeroes[3];
                  Heroes[1] := AllHeroes[1];
                end
           else begin
                  Heroes[0] := AllHeroes[1];
                  Heroes[1] := AllHeroes[3];
                end;
           GLSceneViewer1.Camera:=Heroes[0].MyCamera;}
  skillused := false;
end;

procedure TMainF.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  //Mouse look
  if ((ssRight in Shift)or(Aiming))and(heroes[0].ControlAble)
  then begin
       If (heroes[0].MyCamera.Position.y>3)or(my-y<0)
       then heroes[0].MyCamera.MoveAroundTarget((my-y),0);
       heroes[0].Me^.Turn(- (mx-x));
       end;
 { If (Aiming)and(ssLeft in Shift)
       then begin
            Skill.TargetingComplete(GLCamera1.position.x,GLCamera1.position.y,GLCamera1.position.z);
            end;}
  mx:=x;
  my:=y;
end;


procedure TMainF.GLSceneViewer1Click(Sender: TObject);
begin
  If (Aiming)
       then begin
//            MyHero.ActiveSkill.TargetingComplete(GLCamera1.position.x+Mage.Position.x,GLCamera1.position.y+Mage.Position.y,GLCamera1.position.z+Mage.Position.z);
              heroes[0].ActiveSkill.TargetingComplete(heroes[0].MyCamera.position.x,heroes[0].MyCamera.position.y,heroes[0].MyCamera.position.z);
            end;
end;

procedure TMainF.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If (IsKeyDown('1'))and(heroes[0].ControlAble)and(not Aiming)
  then heroes[0].Cast(1);
  If (IsKeyDown('2'))and(heroes[0].ControlAble)and(not Aiming)
  then heroes[0].Cast(2);
  If (IsKeyDown('3'))and(heroes[0].ControlAble)and(not Aiming)
  then heroes[0].Cast(3);
  If (IsKeyDown('4'))and(heroes[0].ControlAble)and(not Aiming)
  then heroes[0].Cast(4);
end;
procedure TMainF.FireballBehaviours0Collision(Sender: TObject;
  ObjectCollided: TGLBaseSceneObject; CollisionInfo: TDCECollision);
begin
  Case ObjectCollided.Tag of
    2: heroes[1].Health:=heroes[1].Health-heroes[0].Skill[1].Damage;
  end;
  If heroes[1].Health<=0
  then ObjectCollided.Scale.SetVector(0.001,0.001,0.001);
end;

procedure TMainF.CollisionManager1Collision(Sender: TObject; object1,
  object2: TGLBaseSceneObject);
var k,h,i,j:integer;
begin
  h:=0;
  i:=0;
  j:=0;
  If (object1.Tag mod 10=0)and(object2.Tag mod 10<>0)
  then begin
        i:=object2.Tag div 10;
        j:=object2.Tag mod 10;
        h:=object1.Tag div 10;
       end;
  If (object2.Tag mod 10=0)and(object1.Tag mod 10<>0)
  then begin
        i:=object1.Tag div 10;
        j:=object1.Tag mod 10;
        h:=object2.Tag div 10;
       end;
  If (i<>0)and(j<>0)and(h<>0)
  then begin
//        AllHeroes[h].Health:=AllHeroes[h].Health-AllHeroes[i].skill[j].Damage;
//        AllHeroes[h].Effects[AllHeroes[i].skill[j].effect]:=AllHeroes[i].skill[j].EffectDur;
        If i<>2
        then AllHeroes[i].Skill[j].Hide
        else allHeroes[2].Skill[4].Hide;
       end;
  {If h<>0
  then
  If AllHeroes[h].Health<=0
  then AllHeroes[h].Me^.Position.x:=9999;}
end;

procedure TMainF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s:string;
i:integer;
begin
  If key= VK_Escape
  then begin
        ShowMessage('Вы проиграли');
        mainF.Close;
       end;
  If not Chosed
  then Case key of
        VK_Left:begin
                  INc(numChose);
                  If numChose>MaxHeroes
                  then numChose:=1;
                //  ChooseCamera.TargetObject:=AllHeroes[numChose].me^;
                //  ChooseCamera.position.X:=AllHeroes[numChose].me^.position.X;
                 end;
        VK_Right: begin
                  Dec(numChose);
                  If numChose<1
                  then numChose:=MaxHeroes;
                 // ChooseCamera.TargetObject:=AllHeroes[numChose].me^;
                //  ChooseCamera.position.X:=AllHeroes[numChose].me^.position.X;
                 end;
        VK_Return:begin
                   Client.Write('#' + IntToStr(numChose));
                   s := Client.CurrentReadBuffer;
                   if Copy(s,1,2) <> 'ok'
                   then begin
                          showmessage('Этот герой уже выбран');
                          exit;
                        end;
                   if s[3] <> '!'
                   then Heroes[1] := AllHeroes[StrToInt(Copy(s,3,1))]
                   else begin
                          ShowMessage('Противник не выбрал персонажа, пожалуйста, подождите');
                          s := Client.CurrentReadBuffer;
                          Heroes[1] := AllHeroes[StrToInt(Copy(s,1,1))]
                        end;
                   Heroes[0]:=AllHeroes[numChose];
                   Chosed:=true;
                   GlSceneViewer1.camera:=AllHeroes[numChose].MyCamera;
                   Heroes[0].me^.position.x:=5;
                   Heroes[0].Me^.position.y:=2;
                   s:='media\Pic';
                   s:=s+IntToStr(heroes[0].MyNumber);
                   For i:=1 to MaxSkills do
                    Begin
                      s:=s+IntToStr(i);
                      heroes[0].SkillSprites[i]:=TGLHUDSprite.CreateAsChild(MainF.GLScene1.Objects);
                      heroes[0].SkillSprites[i].Material.Texture.Image.LoadFromFile(s+'.Jpg');
                      heroes[0].SkillSprites[i].Material.Texture.Disabled:=false;
                      With heroes[0].SkillSprites[i] do
                        begin
                          Height:=(GetDeviceCaps(GetDC(0),VERTRES))div 5;
                          Width:=GetDeviceCaps(GetDC(0),HORZRES)div 5;
                          Position.x:=GetDeviceCaps(GetDC(0),HORZRES)/4*i-Width/3*2;
                          Position.y:=(GetDeviceCaps(GetDC(0),VERTRES)/5)*4
                        end;
                      Delete(s,Length(s),1);
                    End;
                    For i:=1 to MaxSkills do
                      begin
                        CoolDownIcons[i]:=TGLHUDSprite.createAsChild(MainF.GLScene1.Objects);
                        //heroes[0].CoolDownIcons[i].MoveLast;
                        CooldownIcons[i].Material.Texture.Image.LoadFromFile('media\cooldown.jpg');
                        CoolDownIcons[i].Material.Texture.Disabled:=false;
                        CoolDownIcons[i].Position.X:=heroes[0].skillsprites[i].Position.x;
                        CoolDownIcons[i].Position.y:=heroes[0].skillsprites[i].Position.y+heroes[0].skillsprites[i].Height/2+10;
                        CoolDownIcons[i].Height:=20;
                        CoolDownIcons[i].Width:=0;
                      end;
                    GLDCEManager1.Gravity:=-30;
                  end;
       end;
end;

end.
