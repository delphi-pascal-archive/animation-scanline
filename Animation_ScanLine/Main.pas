unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, AnimThread;

const
 asBottom=90; // Constante début d'arc depuis le bas de l'image
 asLeft=180; // Constante début d'arc depuis la gauche de l'image
 asRight=0; // Constante début d'arc depuis la droite de l'image
 asTop=270; // Constante début d'arc depuis le haut de l'image
 RadConst=Pi/180; // Constante de conversion de degrés en radians (Degré * (Pi/180) = Radian)
 DegConst=180/Pi; // Constante de conversion de radians en degrés (Radian * (180/Pi) = Degré)
 Sinus: array [0..359] of Extended = // Table des sinus (renvoie les sinus des angles [Index] qui sont en radians)
 (0, 0.0174524064372835, 0.034899496702501, 0.0523359562429438, 0.0697564737441253, 0.0871557427476582, 0.104528463267653, 0.121869343405147, 0.139173100960065, 0.156434465040231
  , 0.17364817766693, 0.190808995376545, 0.207911690817759, 0.224951054343865, 0.241921895599668, 0.258819045102521, 0.275637355816999, 0.292371704722737, 0.309016994374947, 0.325568154457157
  , 0.342020143325669, 0.3583679495453, 0.374606593415912, 0.390731128489274, 0.4067366430758, 0.422618261740699, 0.438371146789077, 0.453990499739547, 0.469471562785891, 0.484809620246337
  , 0.5, 0.515038074910054, 0.529919264233205, 0.544639035015027, 0.559192903470747, 0.573576436351046, 0.587785252292473, 0.601815023152048, 0.615661475325658, 0.629320391049837
  , 0.642787609686539, 0.656059028990507, 0.669130606358858, 0.681998360062499, 0.694658370458997, 0.707106781186548, 0.719339800338651, 0.73135370161917, 0.743144825477394, 0.754709580222772
  , 0.766044443118978, 0.777145961456971, 0.788010753606722, 0.798635510047293, 0.809016994374947, 0.819152044288992, 0.829037572555042, 0.838670567945424, 0.848048096156426, 0.857167300702112
  , 0.866025403784439, 0.874619707139396, 0.882947592858927, 0.891006524188368, 0.898794046299167, 0.90630778703665, 0.913545457642601, 0.92050485345244, 0.927183854566787, 0.933580426497202
  , 0.939692620785908, 0.945518575599317, 0.951056516295154, 0.956304755963035, 0.961261695938319, 0.965925826289068, 0.970295726275996, 0.974370064785235, 0.978147600733806, 0.981627183447664
  , 0.984807753012208, 0.987688340595138, 0.99026806874157, 0.992546151641322, 0.994521895368273, 0.996194698091746, 0.997564050259824, 0.998629534754574, 0.999390827019096, 0.999847695156391
  , 1, 0.999847695156391, 0.999390827019096, 0.998629534754574, 0.997564050259824, 0.996194698091746, 0.994521895368273, 0.992546151641322, 0.99026806874157, 0.987688340595138
  , 0.984807753012208, 0.981627183447664, 0.978147600733806, 0.974370064785235, 0.970295726275996, 0.965925826289068, 0.961261695938319, 0.956304755963035, 0.951056516295154, 0.945518575599317
  , 0.939692620785908, 0.933580426497202, 0.927183854566787, 0.92050485345244, 0.913545457642601, 0.90630778703665, 0.898794046299167, 0.891006524188368, 0.882947592858927, 0.874619707139396
  , 0.866025403784439, 0.857167300702112, 0.848048096156426, 0.838670567945424, 0.829037572555042, 0.819152044288992, 0.809016994374947, 0.798635510047293, 0.788010753606722, 0.777145961456971
  , 0.766044443118978, 0.754709580222772, 0.743144825477394, 0.73135370161917, 0.719339800338651, 0.707106781186548, 0.694658370458997, 0.681998360062499, 0.669130606358858, 0.656059028990507
  , 0.642787609686539, 0.629320391049837, 0.615661475325658, 0.601815023152048, 0.587785252292473, 0.573576436351046, 0.559192903470747, 0.544639035015027, 0.529919264233205, 0.515038074910054
  , 0.5, 0.484809620246337, 0.469471562785891, 0.453990499739547, 0.438371146789077, 0.422618261740699, 0.4067366430758, 0.390731128489274, 0.374606593415912, 0.3583679495453
  , 0.342020143325669, 0.325568154457157, 0.309016994374947, 0.292371704722737, 0.275637355816999, 0.258819045102521, 0.241921895599668, 0.224951054343865, 0.207911690817759, 0.190808995376545
  , 0.17364817766693, 0.156434465040231, 0.139173100960065, 0.121869343405147, 0.104528463267653, 0.0871557427476582, 0.0697564737441253, 0.0523359562429438, 0.034899496702501, 0.0174524064372835
  , -5.42101086242752E-20, -0.0174524064372835, -0.034899496702501, -0.0523359562429438, -0.0697564737441253, -0.0871557427476582, -0.104528463267653, -0.121869343405147, -0.139173100960065, -0.156434465040231
  , -0.17364817766693, -0.190808995376545, -0.207911690817759, -0.224951054343865, -0.241921895599668, -0.258819045102521, -0.275637355816999, -0.292371704722737, -0.309016994374947, -0.325568154457157
  , -0.342020143325669, -0.3583679495453, -0.374606593415912, -0.390731128489274, -0.4067366430758, -0.422618261740699, -0.438371146789077, -0.453990499739547, -0.469471562785891, -0.484809620246337
  , -0.5, -0.515038074910054, -0.529919264233205, -0.544639035015027, -0.559192903470747, -0.573576436351046, -0.587785252292473, -0.601815023152048, -0.615661475325658, -0.629320391049837
  , -0.642787609686539, -0.656059028990507, -0.669130606358858, -0.681998360062499, -0.694658370458997, -0.707106781186548, -0.719339800338651, -0.73135370161917, -0.743144825477394, -0.754709580222772
  , -0.766044443118978, -0.777145961456971, -0.788010753606722, -0.798635510047293, -0.809016994374947, -0.819152044288992, -0.829037572555042, -0.838670567945424, -0.848048096156426, -0.857167300702112
  , -0.866025403784439, -0.874619707139396, -0.882947592858927, -0.891006524188368, -0.898794046299167, -0.90630778703665, -0.913545457642601, -0.92050485345244, -0.927183854566787, -0.933580426497202
  , -0.939692620785908, -0.945518575599317, -0.951056516295154, -0.956304755963035, -0.961261695938319, -0.965925826289068, -0.970295726275996, -0.974370064785235, -0.978147600733806, -0.981627183447664
  , -0.984807753012208, -0.987688340595138, -0.99026806874157, -0.992546151641322, -0.994521895368273, -0.996194698091746, -0.997564050259824, -0.998629534754574, -0.999390827019096, -0.999847695156391
  , -1, -0.999847695156391, -0.999390827019096, -0.998629534754574, -0.997564050259824, -0.996194698091746, -0.994521895368273, -0.992546151641322, -0.99026806874157, -0.987688340595138
  , -0.984807753012208, -0.981627183447664, -0.978147600733806, -0.974370064785235, -0.970295726275996, -0.965925826289068, -0.961261695938319, -0.956304755963035, -0.951056516295154, -0.945518575599317
  , -0.939692620785908, -0.933580426497202, -0.927183854566787, -0.92050485345244, -0.913545457642601, -0.90630778703665, -0.898794046299167, -0.891006524188368, -0.882947592858927, -0.874619707139396
  , -0.866025403784439, -0.857167300702112, -0.848048096156426, -0.838670567945424, -0.829037572555042, -0.819152044288992, -0.809016994374947, -0.798635510047293, -0.788010753606722, -0.777145961456971
  , -0.766044443118978, -0.754709580222772, -0.743144825477394, -0.73135370161917, -0.719339800338651, -0.707106781186548, -0.694658370458997, -0.681998360062499, -0.669130606358858, -0.656059028990507
  , -0.642787609686539, -0.629320391049837, -0.615661475325658, -0.601815023152048, -0.587785252292473, -0.573576436351046, -0.559192903470747, -0.544639035015027, -0.529919264233205, -0.515038074910054
  , -0.5, -0.484809620246337, -0.469471562785891, -0.453990499739547, -0.438371146789077, -0.422618261740699, -0.4067366430758, -0.390731128489274, -0.374606593415912, -0.3583679495453
  , -0.342020143325669, -0.325568154457157, -0.309016994374947, -0.292371704722737, -0.275637355816999, -0.258819045102521, -0.241921895599668, -0.224951054343865, -0.207911690817759, -0.190808995376545
  , -0.17364817766693, -0.156434465040231, -0.139173100960065, -0.121869343405147, -0.104528463267653, -0.0871557427476582, -0.0697564737441253, -0.0523359562429438, -0.034899496702501, -0.0174524064372835);

  Cosinus: array [0..359] of Extended = // Table des cosinus (renvoie les cosinus des angles [Index] qui sont en radians)
  (1, 0.999847695156391, 0.999390827019096, 0.998629534754574, 0.997564050259824, 0.996194698091746, 0.994521895368273, 0.992546151641322, 0.99026806874157, 0.987688340595138
  , 0.984807753012208, 0.981627183447664, 0.978147600733806, 0.974370064785235, 0.970295726275996, 0.965925826289068, 0.961261695938319, 0.956304755963035, 0.951056516295154, 0.945518575599317
  , 0.939692620785908, 0.933580426497202, 0.927183854566787, 0.92050485345244, 0.913545457642601, 0.90630778703665, 0.898794046299167, 0.891006524188368, 0.882947592858927, 0.874619707139396
  , 0.866025403784439, 0.857167300702112, 0.848048096156426, 0.838670567945424, 0.829037572555042, 0.819152044288992, 0.809016994374947, 0.798635510047293, 0.788010753606722, 0.777145961456971
  , 0.766044443118978, 0.754709580222772, 0.743144825477394, 0.73135370161917, 0.719339800338651, 0.707106781186548, 0.694658370458997, 0.681998360062499, 0.669130606358858, 0.656059028990507
  , 0.642787609686539, 0.629320391049837, 0.615661475325658, 0.601815023152048, 0.587785252292473, 0.573576436351046, 0.559192903470747, 0.544639035015027, 0.529919264233205, 0.515038074910054
  , 0.5, 0.484809620246337, 0.469471562785891, 0.453990499739547, 0.438371146789077, 0.422618261740699, 0.4067366430758, 0.390731128489274, 0.374606593415912, 0.3583679495453
  , 0.342020143325669, 0.325568154457157, 0.309016994374947, 0.292371704722737, 0.275637355816999, 0.258819045102521, 0.241921895599668, 0.224951054343865, 0.207911690817759, 0.190808995376545
  , 0.17364817766693, 0.156434465040231, 0.139173100960065, 0.121869343405147, 0.104528463267653, 0.0871557427476582, 0.0697564737441253, 0.0523359562429438, 0.034899496702501, 0.0174524064372835
  , -2.71050543121376E-20, -0.0174524064372835, -0.034899496702501, -0.0523359562429438, -0.0697564737441253, -0.0871557427476582, -0.104528463267653, -0.121869343405147, -0.139173100960065, -0.156434465040231
  , -0.17364817766693, -0.190808995376545, -0.207911690817759, -0.224951054343865, -0.241921895599668, -0.258819045102521, -0.275637355816999, -0.292371704722737, -0.309016994374947, -0.325568154457157
  , -0.342020143325669, -0.3583679495453, -0.374606593415912, -0.390731128489274, -0.4067366430758, -0.422618261740699, -0.438371146789077, -0.453990499739547, -0.469471562785891, -0.484809620246337
  , -0.5, -0.515038074910054, -0.529919264233205, -0.544639035015027, -0.559192903470747, -0.573576436351046, -0.587785252292473, -0.601815023152048, -0.615661475325658, -0.629320391049837
  , -0.642787609686539, -0.656059028990507, -0.669130606358858, -0.681998360062499, -0.694658370458997, -0.707106781186548, -0.719339800338651, -0.73135370161917, -0.743144825477394, -0.754709580222772
  , -0.766044443118978, -0.777145961456971, -0.788010753606722, -0.798635510047293, -0.809016994374947, -0.819152044288992, -0.829037572555042, -0.838670567945424, -0.848048096156426, -0.857167300702112
  , -0.866025403784439, -0.874619707139396, -0.882947592858927, -0.891006524188368, -0.898794046299167, -0.90630778703665, -0.913545457642601, -0.92050485345244, -0.927183854566787, -0.933580426497202
  , -0.939692620785908, -0.945518575599317, -0.951056516295154, -0.956304755963035, -0.961261695938319, -0.965925826289068, -0.970295726275996, -0.974370064785235, -0.978147600733806, -0.981627183447664
  , -0.984807753012208, -0.987688340595138, -0.99026806874157, -0.992546151641322, -0.994521895368273, -0.996194698091746, -0.997564050259824, -0.998629534754574, -0.999390827019096, -0.999847695156391
  , -1, -0.999847695156391, -0.999390827019096, -0.998629534754574, -0.997564050259824, -0.996194698091746, -0.994521895368273, -0.992546151641322, -0.99026806874157, -0.987688340595138
  , -0.984807753012208, -0.981627183447664, -0.978147600733806, -0.974370064785235, -0.970295726275996, -0.965925826289068, -0.961261695938319, -0.956304755963035, -0.951056516295154, -0.945518575599317
  , -0.939692620785908, -0.933580426497202, -0.927183854566787, -0.92050485345244, -0.913545457642601, -0.90630778703665, -0.898794046299167, -0.891006524188368, -0.882947592858927, -0.874619707139396
  , -0.866025403784439, -0.857167300702112, -0.848048096156426, -0.838670567945424, -0.829037572555042, -0.819152044288992, -0.809016994374947, -0.798635510047293, -0.788010753606722, -0.777145961456971
  , -0.766044443118978, -0.754709580222772, -0.743144825477394, -0.73135370161917, -0.719339800338651, -0.707106781186548, -0.694658370458997, -0.681998360062499, -0.669130606358858, -0.656059028990507
  , -0.642787609686539, -0.629320391049837, -0.615661475325658, -0.601815023152048, -0.587785252292473, -0.573576436351046, -0.559192903470747, -0.544639035015027, -0.529919264233205, -0.515038074910054
  , -0.5, -0.484809620246337, -0.469471562785891, -0.453990499739547, -0.438371146789077, -0.422618261740699, -0.4067366430758, -0.390731128489274, -0.374606593415912, -0.3583679495453
  , -0.342020143325669, -0.325568154457157, -0.309016994374947, -0.292371704722737, -0.275637355816999, -0.258819045102521, -0.241921895599668, -0.224951054343865, -0.207911690817759, -0.190808995376545
  , -0.17364817766693, -0.156434465040231, -0.139173100960065, -0.121869343405147, -0.104528463267653, -0.0871557427476582, -0.0697564737441253, -0.0523359562429438, -0.034899496702501, -0.0174524064372835
  , 1.89735380184963E-19, 0.0174524064372835, 0.034899496702501, 0.0523359562429438, 0.0697564737441253, 0.0871557427476582, 0.104528463267653, 0.121869343405147, 0.139173100960065, 0.156434465040231
  , 0.17364817766693, 0.190808995376545, 0.207911690817759, 0.224951054343865, 0.241921895599668, 0.258819045102521, 0.275637355816999, 0.292371704722737, 0.309016994374947, 0.325568154457157
  , 0.342020143325669, 0.3583679495453, 0.374606593415912, 0.390731128489274, 0.4067366430758, 0.422618261740699, 0.438371146789077, 0.453990499739547, 0.469471562785891, 0.484809620246337
  , 0.5, 0.515038074910054, 0.529919264233205, 0.544639035015027, 0.559192903470747, 0.573576436351046, 0.587785252292473, 0.601815023152048, 0.615661475325658, 0.629320391049837
  , 0.642787609686539, 0.656059028990507, 0.669130606358858, 0.681998360062499, 0.694658370458997, 0.707106781186548, 0.719339800338651, 0.73135370161917, 0.743144825477394, 0.754709580222772
  , 0.766044443118978, 0.777145961456971, 0.788010753606722, 0.798635510047293, 0.809016994374947, 0.819152044288992, 0.829037572555042, 0.838670567945424, 0.848048096156426, 0.857167300702112
  , 0.866025403784439, 0.874619707139396, 0.882947592858927, 0.891006524188368, 0.898794046299167, 0.90630778703665, 0.913545457642601, 0.92050485345244, 0.927183854566787, 0.933580426497202
  , 0.939692620785908, 0.945518575599317, 0.951056516295154, 0.956304755963035, 0.961261695938319, 0.965925826289068, 0.970295726275996, 0.974370064785235, 0.978147600733806, 0.981627183447664
  , 0.984807753012208, 0.987688340595138, 0.99026806874157, 0.992546151641322, 0.994521895368273, 0.996194698091746, 0.997564050259824, 0.998629534754574, 0.999390827019096, 0.999847695156391);
  AnimCount=4; // Nombre d'animations disponibles

type
  TRGB=record // Enregistrement d'un pixel RGB (pour conversion HSV)
   R, G, B: Extended;
  end;

  THSV=record // Enregistrement d'un pixel HSV (pour conversion RGB)
   H, S, V: Extended;
  end;

  TAnimation=(aCircle, aRotatingArcCW, aRotatingLineCW, aWeirdLine); // Animations disponibles actuellement

  TAnimations=set of TAnimation; // Un set des animations disponibles !

  TAnimParams=record // Paramètres d'une animation
   RGB: TRGB; // Sa couleur RGB
   HSV: THSV; // Sa couleur HSV
   Angle: Integer; // Son angle (pas toujours nécessaire)
  end;

  TRGBARRAY=array [0..512] of TRGBQUAD; // Type array de RGBQuad 32 bit pour Scanline
  PRGBARRAY=^TRGBARRAY; // Pointeur sur la ligne RGBQuad

  TMainForm = class(TForm)
    Img: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure InitLines;
    procedure Draw;
    procedure FillBitmap(R, G, B: Byte);
    function AsByte(X: Integer): Byte;
    procedure SetPixel(X, Y: Cardinal; R, G, B: Byte);
    function GetPixel(X, Y: Integer): TRGBQUAD;
    function ScaleTo(X: Extended; Scale: Extended): Extended; overload;
    function ScaleTo(X: Int64; Scale: Int64): Int64; overload;
    procedure IncColor(Animation: TAnimation);
    procedure ManageAnimationSet;
    procedure PlaceRandomPixel(R, G, B: Byte);
    procedure Blur;
    procedure CreateCircle(R, G, B: Byte; Radius: Extended; Center: TPoint);
    procedure CreateArc(R, G, B: Byte; Radius: Extended; Center: TPoint; ArcValue: Integer; ArcStart: Integer);
    procedure CreateLine(R, G, B: Byte; M, N: TPoint; Width: Extended);
    // C'était les routines de base. Maintenant, les routines précisées
    procedure MakeCircleAnimation(CircleWidth: Integer);
    procedure MakeRotatingArcCWAnimation(ArcWidth: Integer);
    procedure MakeRotatingLineCWAnimation(LineWidth: Integer);
    procedure MakeWeirdLineAnimation(LineWidth: Integer);
    procedure FPS;
  end;

var
  MainForm: TMainForm; // Variable de la fiche
  ANIMWIDTH, ANIMHEIGHT: Integer; // Taille de l'animation
  IMGCENTER: TPoint; // Centre de l'image
  Thrd: TAnimThread; // Variable pour le thread d'animation
  Lines: array of PRGBARRAY; // Tableau de pointeurs sur l'image
  Bmp: TBitmap; // Bitmap de dessin (les pointeurs pointent sur lui !)
  Time: Int64; // Représente le temps qui passe :o
  BlurInc: Cardinal; // Etat incrementatif du flou
  UpTime: Double; // Définit si on doit augmenter le temps de 1
  AnimParams: array [TAnimation] of TAnimParams; // Paramètres des différentes animations qui en ont besoin (pour garder le fil)
  Animations: TAnimations; // Les animations à effectuer sur l'image ;)
  LastT: Integer; // Le dernier temps de calcul FPS (GetTickCount)
  FPSCount: Integer; // Nombre de frames comptées actuellement
  FramesPerSecond: Integer; // Les FPS
  Pause: Boolean; // En pause ou pas ?
  Blacked: Boolean; // A été noirci ou pas ?

implementation

{$R *.dfm}

procedure TMainForm.FPS; // Calcul des FPS
var
  T: Integer;
begin
  T := GetTickCount; // On récupère le temps "CPU"

  if T-LastT >= 1000 then  // Si la différence de temps entre le dernier temps et le temps CPU est égal ou supérieur à 1 seconde ...
  // ... il sera temps de recalculer !
   begin
    FramesPerSecond := FPSCount; // Le nombre de FPS est égal au nombre de frames comptées en 1 seconde
    LastT := T; // Dernier temps devient T
    fpsCount := 0; // On remet à 0 le compteur de FPS
   end
  else Inc(FPSCount); // Si ce n'est pas l'heure de recalculer, on augmente d'1 frame !
end;

{-------------------------------------------------------------------------------
----- LES FONCTIONS SUIVANTES NE SONT PAS DE MOI ET NE SONT PAS COMMENTEES -----
-------------------------------------------------------------------------------}

PROCEDURE RGBToHSV (CONST RGB: TRGB; VAR HSV: THSV); // Conversion RGB => HSV
  VAR
    Delta: Extended;
    Min : Extended;
BEGIN
  Min := MinValue( [RGB.R, RGB.G, RGB.B] );    // USES Math
  HSV.V := MaxValue( [RGB.R, RGB.G, RGB.B] );

  Delta := HSV.V - Min;

  // Calculate saturation: saturation is 0 if r, g and b are all 0
  IF       HSV.V = 0.0
  THEN HSV.S := 0
  ELSE HSV.S := Delta / HSV.V;

  IF       HSV.S = 0.0
  THEN HSV.H := NaN    // Achromatic: When s = 0, h is undefined
  ELSE BEGIN       // Chromatic
    IF       RGB.R = HSV.V
    THEN // between yellow and magenta [degrees]
      HSV.H := 60.0 * (RGB.G - RGB.B) / Delta
    ELSE
      IF       RGB.G = HSV.V
      THEN // between cyan and yellow
        HSV.H := 120.0 + 60.0 * (RGB.B - RGB.R) / Delta
      ELSE
        IF       RGB.B = HSV.V
        THEN // between magenta and cyan
          HSV.H := 240.0 + 60.0 * (RGB.R - RGB.G) / Delta;

    IF HSV.H < 0.0
    THEN HSV.H := HSV.H + 360.0
  END
END {RGBtoHSV};

// Based on C Code in "Computer Graphics -- Principles and Practice,"
// Foley et al, 1996, p. 593.
//
// H = 0.0 to 360.0 (corresponding to 0..360 degrees around hexcone)
// NaN (undefined) for S = 0
// S = 0.0 (shade of gray) to 1.0 (pure color)
// V = 0.0 (black) to 1.0 (white)

PROCEDURE HSVtoRGB (CONST HSV: THSV; VAR RGB: TRGB); // Conversion HSV => RGB
  VAR
    f : Extended;
    i : INTEGER;
    hTemp: Extended; // since H is CONST parameter
    p,q,t: Extended;
BEGIN
  IF       HSV.S = 0.0    // color is on black-and-white center line
  THEN BEGIN
    IF       IsNaN(HSV.H)
    THEN BEGIN
      RGB.R := HSV.V;           // achromatic: shades of gray
      RGB.G := HSV.V;
      RGB.B := HSV.V
    END
    ELSE Exit;
  END

  ELSE BEGIN // chromatic color
    IF       HSV.H = 360.0         // 360 degrees same as 0 degrees
    THEN hTemp := 0.0
    ELSE hTemp := HSV.H;

    hTemp := hTemp / 60;     // h is now IN [0,6)
    i := TRUNC(hTemp);        // largest integer <= h
    f := hTemp - i;                  // fractional part of h

    p := HSV.V * (1.0 - HSV.S);
    q := HSV.V * (1.0 - (HSV.S * f));
    t := HSV.V * (1.0 - (HSV.S * (1.0 - f)));

    CASE i OF
      0: BEGIN RGB.R := HSV.V; RGB.G := t;  RGB.B := p  END;
      1: BEGIN RGB.R := q; RGB.G := HSV.V; RGB.B := p  END;
      2: BEGIN RGB.R := p; RGB.G := HSV.V; RGB.B := t   END;
      3: BEGIN RGB.R := p; RGB.G := q; RGB.B := HSV.V  END;
      4: BEGIN RGB.R := t;  RGB.G := p; RGB.B := HSV.V  END;
      5: BEGIN RGB.R := HSV.V; RGB.G := p; RGB.B := q  END
    END
  END
END {HSVtoRGB};

function Rad(Deg: Extended): Extended; // Radian => Degré
begin
 Result := Deg * RadConst; // Conversion radian => degré
end;

function Deg(Rad: Extended): Extended; // Degré => Radian
begin
 Result := Rad * DegConst; // Conversion radian => degré
end;

procedure TMainForm.FormCreate(Sender: TObject); // Création de la fiche
Var
 I: Integer;
 HSV: THSV;
 Res: TPoint;
 Temp: TBitmap;
begin
 // On demande pour la haute qualité
 if MessageDlg('High quality?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
 then DoubleBuffered := True
  else DoubleBuffered := False;
  case MessageDlg('Quelle résolution ?' + chr(13) + chr(13)
   + 'Click OK to set resolution at 512x512.' + chr(13)
   + 'Click Yes to set resolution at 256x256.' + chr(13)
   + 'Click No to set resolution at 128x128.' + chr(13)
   , mtConfirmation, [mbOK, mbYes, mbNo], 0) of
   mrOK: Res := Point(512, 512);
   mrYes: Res := Point(256, 256);
   mrNo: Res := Point(128, 128);
  end; // On demande pour la résolution d'affichage

 ANIMWIDTH := Res.X - 1; // On définit la résolution selon le choix de l'utilisateur
 ANIMHEIGHT := Res.Y - 1; // Idem
 IMGCENTER := Point(ANIMWIDTH div 2, ANIMHEIGHT div 2); // On calcule alors le centre de l'image
 SetLength(Lines, ANIMHEIGHT - 1); // On définit le nombre de lignes de l'image, et on définit la taille du tableau
 ClientWidth := ANIMWIDTH; // On redimensionne la fiche
 ClientHeight := ANIMHEIGHT; // Idem

 Temp := TBitmap.Create; // On crée un bitmap temporaire
 Temp.PixelFormat := pf1Bit; // Format 1 bit
 Temp.Width := ANIMWIDTH + 1; // On lui donne une taille correspondante à la taille de l'image
 Temp.Height := ANIMHEIGHT + 1; // Idem
 Temp.PixelFormat := pf1Bit; // On lui redonne le format 1 bit
 Img.Picture.Bitmap.Assign(Temp); // On donne au composant TImage l'image blanche ainsi obtenue
 Img.Picture.Bitmap.PixelFormat := pf1Bit; // On passe le composant TImage en mode 1 bit
 Temp.Free; // On libère le bitmap temporaire

 sleep(100); // On attend un petit peu
 Application.ProcessMessages; // On redessine la barre de titre de la fiche (sinon elle se fait bouffer par le thread)

 BlurInc := 0; // On place le BlurInc à 0
 randomize; // Initialisation du générateur de nombres aléatoires
 Animations := [aCircle, aRotatingArcCW, aRotatingLineCW, aWeirdLine]; // On place toutes les animations par défaut
 for I := 0 to AnimCount - 1 do // Pour chaque animation
  begin
   AnimParams[TAnimation(I)].Angle := 0; // Initialisation des paramètres
   AnimParams[TAnimation(I)].RGB.R := random(192) + 64; // Couleur aléatoire (mais pas égale à noir, quand même)
   AnimParams[TAnimation(I)].RGB.G := random(192) + 64; // Idem
   AnimParams[TAnimation(I)].RGB.B := random(192) + 64; // Idem
   RGBTOHSV(AnimParams[TAnimation(I)].RGB, HSV); // On calcule le HSV de tout ça
   AnimParams[TAnimation(I)].HSV := HSV; // On place le HSV obtenu dans le champ HSV de l'enregistrement
  end;
 Time := 0; // On initialise le temps
 UpTime := 0.0; // On initialise le compteur de temps
 Img.Picture.Bitmap.PixelFormat := pf32Bit; // On passe tout de suite l'image ...
 // ... visible en format 32 bits.
 // ... et il faut changer maintenant, sinon problème de compatibilité format de pixels ...
 // ... lors du dessin du bitmap sur l'image visible.
 Bmp := TBitmap.Create; // Création du bitmap de dessin
 Bmp.Width := ANIMWIDTH; // Définition de la largeur
 Bmp.Height := ANIMHEIGHT; // Définition de la hauteur
 Bmp.PixelFormat := pf32Bit; // Définition du format des pixels
 InitLines; // On construit les lignes de pointeurs sur l'image
 FillBitmap(0, 0, 0); // On remplit l'image en noir
 Draw; // On dessine, pour commencer !
 Thrd.Resume; // On lance le thread !
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction); // Fermeture de la fiche
begin
 Thrd.Suspend; // On arrête le thread
 Bmp.Free; // On libère le bitmap
end;


procedure TMainForm.ManageAnimationSet; // Cette procédure va gérer les animations en cours
Var
 A, B: Integer; // Variables qui contiennent les animations choisies
 AnimSrc, AnimDest: TAnimation;
begin
 A := random(300); // Détermine si on va changer quelque chose
 if A <> 7 then Exit; // Une chance sur 300 de changer (ça arrive vite n'empeche !)

 A := random(AnimCount); // Détermine quel objet va être changé
 B := random(AnimCount); // Détermine par quel objet il va être change (aucun changement si A = B)

 AnimSrc := TAnimation(A); // On trouve l'animation choisie
 AnimDest := TAnimation(B); // Idem

 Animations := Animations - [AnimSrc]; // On retire
 Animations := Animations + [AnimDest]; // Et on ajoute

 if Animations = [] then Animations := Animations + [TAnimation(random(AnimCount))];
 // Si vide, on en rajoute 1 d'urgence
end;

procedure TMainForm.InitLines; // Construction des lignes de pointeurs sur l'image
var
 I: Integer; // Variable de boucle pour passer sur toutes les lignes
begin
 for I := 0 to ANIMHEIGHT - 1 do // Pour chaque ligne ...
  Lines[I] := Bmp.ScanLine[I]; // On attribue le pointeur de la ligne en cours au tableau de pointeurs
end;

procedure TMainForm.Draw; // Dessin dans l'image
begin
 Img.Canvas.Draw(0, 0, Bmp); // On dessine !
end;

procedure TMainForm.FillBitmap(R, G, B: Byte); // On remplit le bitmap totalement avec 1 seule couleur
var
 I, J: Integer; // Variables de boucle
begin
 for I := 0 to ANIMHEIGHT - 1 do // Pour chaque ligne
  for J := 0 to ANIMWIDTH - 1 do // Pour chaque colonne
   SetPixel(J, I, R, G, B); // On définit le pixel en cours (les boucles parcourent tous les pixels du bitmap)
end;

procedure TMainForm.SetPixel(X, Y: Cardinal; R, G, B: Byte); // Définition d'un pixel selon sa position, et une couleur RGB
begin
 try
   if Thrd.Suspended then Exit; // Si thread arrêté, on ne continue pas
   Lines[Y][X].rgbBlue := B; // On définit la composante B
   Lines[Y][X].rgbGreen := G; // On définit la composante G
   Lines[Y][X].rgbRed := R; // On définit la composante R
   Lines[Y][X].rgbReserved := 0; // On définit la composante Alpha (ici 0, on ne s'en sert pas)
 except
 end;
end;

function TMainForm.GetPixel(X, Y: Integer): TRGBQUAD; // Récupère un pixel à la position donnée
begin
 try
  if not Thrd.Suspended then Result := Lines[Y, X]; // On donne le résultat
 except
 end;
end;

function TMainForm.AsByte(X: Integer): Byte; // Renvoie un Byte tronqué sur un Integer
begin
 if X < 0 then X := 0; // On s'arrête à 0
 if X > 255 then X := 255; // On s'arrête à 255
 Result := X; // On donne le résultat
end;

procedure TMainForm.Blur; // Appliquage d'un petit flou sur l'image
var
 I, J: Integer; // Variables de boucle
 R, G, B: Cardinal; // Variables de flou
begin
 asm INC BlurInc end;
 if BlurInc > 1000000 then BlurInc := 0; 
 for I := 0 to ANIMHEIGHT - 2 do // Pour chaque ligne
  begin
    case Odd(BlurInc) of
     False: if Odd(I) then Continue;  // Technique pour aller plus vite
     True: if not Odd(I) then Continue;
    end;
    for J := 0 to ANIMWIDTH - 2 do // Pour chaque colonne
     begin
       R := (GetPixel(J, I).rgbRed + GetPixel(J + 1, I).rgbRed + GetPixel(J, I + 1).rgbRed + GetPixel(J + 1, I + 1).rgbRed) div 4;
       G := (GetPixel(J, I).rgbGreen + GetPixel(J + 1, I).rgbGreen + GetPixel(J, I + 1).rgbGreen + GetPixel(J + 1, I + 1).rgbGreen) div 4;
       B := (GetPixel(J, I).rgbBlue + GetPixel(J + 1, I).rgbBlue + GetPixel(J, I + 1).rgbBlue + GetPixel(J + 1, I + 1).rgbBlue) div 4;
       // On calcule la moyenne des composantes RGB des 4 pixels du carré 2x2

       SetPixel(J, I, AsByte(R), AsByte(G), AsByte(B));
       SetPixel(J + 1, I, AsByte(R), AsByte(G), AsByte(B));
       SetPixel(J, I + 1, AsByte(R), AsByte(G), AsByte(B));
       SetPixel(J + 1, I + 1, AsByte(R), AsByte(G), AsByte(B));
      // On applique cette couleur moyenne aux 4 pixels du carré de 2x2 pixels
     end;
  end;
end;

procedure TMainForm.PlaceRandomPixel(R, G, B: Byte); // Placement d'un pixel aléatoire
begin
 SetPixel(random(ANIMWIDTH), random(ANIMHEIGHT), R, G, B); // On place un pixel aléatoire
end;

function TMainForm.ScaleTo(X: Extended; Scale: Extended): Extended; // Replacement de X dans Scale
begin
 X := Abs(X); // On prend la valeur absolue
 while X >= Scale do X := X - 360; // On diminue X jusqu'à ce qu'il soit dans 0..Scale
 Result := X; // On donne ça au résultat
end;

function TMainForm.ScaleTo(X: Int64; Scale: Int64): Int64; // Replacement de X dans Scale
begin
 X := Abs(X); // On prend la valeur absolue
 while X >= Scale do X := X - 360; // On diminue X jusqu'à ce qu'il soit dans 0..Scale
 Result := X; // On donne ça au résultat
end;

procedure TMainForm.IncColor(Animation: TAnimation); // On augmente la couleur de l'animation choisie.
Var
 ARGB: TRGB; // Variable pour contenir la couleur RGB
begin
 with AnimParams[Animation] do // On prend comme référence les paramètres de l'animation choisie
  begin
   HSV.H := HSV.H + 1; // On augmente le "Hue" de la couleur HSV
   HSV.H := ScaleTo(HSV.H, 360); // On replace le "Hue" dans son intervalle de définition (0..360)
   HSVTORGB(HSV, ARGB); // On convertit le tout en RGB
   RGB := ARGB; // On donne la conversion RGB à l'enregistrement                                        
  end;
end;

procedure TMainForm.CreateCircle(R, G, B: Byte; Radius: Extended; Center: TPoint); // Création d'un cercle !
Var
 A: Integer; // Variable angle
 S, C: Integer; // Variables sinus et cosinus
begin
 for A := 0 to 359 do // Pour chaque angle de 0 à 359
  begin
   S := Round(Sinus[A] * Radius); // Calcul sinus (on va chercher dans la table des sinus)
   C := Round(Cosinus[A] * Radius); // Calcul cosinus (on va chercher dans la table des cosinus)

   SetPixel(Center.X + C, Center.Y + S, R, G, B); // On dessine le cercle ...
  end;
end;

procedure TMainForm.CreateArc(R, G, B: Byte; Radius: Extended; Center: TPoint; ArcValue: Integer; ArcStart: Integer); // Dessine un arc de cercle
Var
 Start, A, Angle: Integer; // Variable angle
 S, C: Integer; // Variables sinus et cosinus
begin
 ArcValue := ScaleTo(ArcValue, 360); // On redéfinit ArcValue en cas de débordement (pas de problème :p)
 ArcStart := ScaleTo(ArcStart, 360); // On redéfinit ArcStart en cas de débordement


 Start := ArcStart; // Le début : ArcStart

 case ArcStart of // Selon la position de départ ...
  asTop: Start := 270;
  asRight: Start := 0;
  asBottom: Start := 90;
  asLeft: Start := 180;
 end;

 for A := Start to Start + ArcValue do // Pour chaque angle de Start à Start + ArcValue
  begin
   Angle := A; // On récupère l'angle en cours

   Angle := ScaleTo(Angle, 360); // On remet Angle dans l'ensemble de définition de Sinus et de Cosinus

   S := Round(Sinus[Angle] * Radius); // Calcul sinus (on va chercher dans la table des sinus)
   C := Round(Cosinus[Angle] * Radius); // Calcul cosinus (on va chercher dans la table des cosinus)
   SetPixel(Center.X + C, Center.Y + S, R, G, B); // On dessine le demi-cercle ...
  end;
end;

procedure TMainForm.CreateLine(R, G, B: Byte; M, N: TPoint; Width: Extended); // On crée une ligne sur l'image !
const
 EPSILON=0.00000000001; // Evite de justesse une division par 0 :')
Var
 A, Bf: Extended; // On l'appelle Bf car B est en paramètre
 I, J: Integer;
begin
 // Cette technique interdit une droite verticale (puisqu'on se base sur une fonction)
 // Donc, si les deux points sont alignés verticalement, on s'en va !
 if M.X = N.X then Exit;

 // On va d'abord chercher l'équation de la droite
 // Calcul de A (la pente de la fonction affine, ou encore le coefficient directeur)
 A := (N.Y - M.Y) / ((N.X - M.X) + EPSILON);
 // Maintenant, on calcule B (le standard)
 Bf := -(A * N.X - N.Y);
 // Et voilà, on a notre équation y = ax+b
 for I := 0 to ANIMHEIGHT - 1 do // Pour chaque ligne ...
  for J := 0 to ANIMWIDTH - 1 do // Pour chaque colonne ....
   begin
    // On regarde si le point M(J;I) appartient à la droite (on vérifie par l'équation)
    if Abs(((A * J) + Bf) - I) <= Width then SetPixel(J, I, R, G, B);
    // On place une marge d'erreur.
    // Pour comparer f(x) et x, on étudie leur différence en valeur absolue (on travaille en distances) :
    // |f(x) - x| <= Width signifie que le point I est sur la droite d'épaisseur Width
   end;
end;

procedure TMainForm.MakeCircleAnimation(CircleWidth: Integer); // Dessiner un cercle au centre de l'image
Var
 R, G, B, I: Integer; // Variables intermédiaires
begin
 IncColor(aCircle); // On augmente la couleur de l'animation "Cercle"

 with AnimParams[aCircle] do // Référence aux paramètres de l'animation "Cercle"
  begin
   R := Round(RGB.R); // On prend la valeur approchée de la composante rouge
   G := Round(RGB.G); // On prend la valeur approchée de la composante verte
   B := Round(RGB.B); // On prend la valeur approchée de la composante bleue
  end;

 for I := 1 to CircleWidth do // On crée un cercle de rayon de plus en plus petit pour faire un cercle épais
     CreateCircle(R, G, B, (ANIMWIDTH div 2) - (I - 1), IMGCENTER);
end;

procedure TMainForm.MakeRotatingArcCWAnimation(ArcWidth: Integer); // Dessiner un arc au centre de l'image
Var
 R, G, B, I: Integer; // Variables intermédiaires
begin
 IncColor(aRotatingArcCW); // On augmente la couleur de l'animation "Arc tournant"

 with AnimParams[aRotatingArcCW] do // Référence aux paramètres de l'animation "Arc tournant"
  begin
   R := Round(RGB.R); // On prend la valeur approchée de la composante rouge
   G := Round(RGB.G); // On prend la valeur approchée de la composante verte
   B := Round(RGB.B); // On prend la valeur approchée de la composante bleue
   Inc(Angle, 10); // On augmente l'angle de 10
   Angle := ScaleTo(Angle, 360); // On replace l'angle dans son ensemble de définition (0..360)
  end;

 for I := 1 to ArcWidth do // On crée un arc de rayon de plus en plus petit pour faire un arc épais
  CreateArc(R, G, B, (ANIMWIDTH div 3) - (I - 1), IMGCENTER, AnimParams[aRotatingArcCW].Angle, AnimParams[aRotatingArcCW].Angle + randomrange(135, 225));
end;

procedure TMainForm.MakeRotatingLineCWAnimation(LineWidth: Integer); // Dessiner une ligne qui tourne
Var
 R, G, B: Integer; // Variables intermédiaires                                 
 X, Y: Integer; // Position du 2eme point de la droite (le premier point est le centre de l'image)
begin
 IncColor(aRotatingLineCW); // On augmente la couleur de l'animation "Ligne tournante"

 with AnimParams[aRotatingLineCW] do // Référence aux paramètres de l'animation "Ligne tournante"
  begin
   R := Round(RGB.R); // On prend la valeur approchée de la composante rouge
   G := Round(RGB.G); // On prend la valeur approchée de la composante verte
   B := Round(RGB.B); // On prend la valeur approchée de la composante bleue
   Inc(Angle, 10); // On augmente l'angle de 10
   Angle := ScaleTo(Angle, 360); // On replace l'angle dans son ensemble de définition (0..360)
   X := Round(IMGCENTER.X + Deg(Cosinus[Angle])); // On trouve la positon X du point
   Y := Round(IMGCENTER.Y + Deg(Sinus[Angle])); // On trouve la position Y du point
  end;

 // On dessine la ligne
 CreateLine(R, G, B, Point(X, Y), Point(ANIMWIDTH - X, ANIMHEIGHT - Y), LineWidth);
end;

procedure TMainForm.MakeWeirdLineAnimation(LineWidth: Integer); // Dessiner une ligne qui tourne bizarrement ...
Var
 R, G, B: Integer; // Variables intermédiaires
 X, Y: Integer; // Position du 2eme point (le 1er point est le centre de l'image)
begin
 IncColor(aWeirdLine); // On augmente la couleur de l'animation "Ligne bizarre"

 with AnimParams[aWeirdLine] do // Référence aux paramètres de l'animation "Ligne bizarre"
  begin
   R := Round(RGB.R); // On prend la valeur approchée de la composante rouge
   G := Round(RGB.G); // On prend la valeur approchée de la composante verte
   B := Round(RGB.B); // On prend la valeur approchée de la composante bleue
   Inc(Angle, 10); // On augmente l'angle de 10
   Angle := ScaleTo(Angle, 360); // On replace l'angle dans son ensemble de définition (0..360)
   X := Round(IMGCENTER.X + Deg(Cosinus[Angle])); // On trouve la positon X du point
   Y := Round(IMGCENTER.Y + Deg(Sinus[Angle])); // On trouve la position Y du point
  end;

 // On dessine la ligne
 CreateLine(R, G, B, Point(X, Y), Point(ANIMWIDTH - X, ANIMHEIGHT - X), LineWidth);
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; // Relâchement d'une touche
  Shift: TShiftState);
begin
 // Si touche espace, on pause ou on relance
 if Key = VK_SPACE then Pause := not Pause;
end;

initialization // Au début de l'application
Thrd := TAnimThread.Create(True); // On crée le thread

finalization // A la fin de l'application
Thrd.Free; // On détruit le thread

end.
