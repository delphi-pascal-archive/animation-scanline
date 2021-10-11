unit AnimThread;

interface

uses Windows, Classes, SysUtils, Forms, Graphics, Dialogs, Math;

type
  TAnimThread = class(TThread)
  private
    procedure CentralControl;
  public
    constructor Create(CreateSuspended:boolean);
  protected
    procedure Execute; override;
  end;

implementation

uses Main;

constructor TAnimThread.Create(CreateSuspended:boolean); // Création du thread
begin
  inherited Create(CreateSuspended); // On crée le thread
  FreeOnTerminate := False; // On le libérera nous-même c'est plus sûr
  Priority:=tpTimeCritical; // Priorité critique pour un affichage plus ou moins fluide ...
end;

procedure TAnimThread.CentralControl; // Procédure principale
begin
 if (Suspended) or (Pause) then Exit; // Si le thread est arrêté, ou si on est en mode pause alors on n'execute pas

 if not Blacked then // Si l'image n'est pas encore noircie (tout au début de l'application)
  begin
   MainForm.FillBitmap(0, 0, 0); // On noircit l'image
   Blacked := True; // L'image a été noircie
  end;

 MainForm.ManageAnimationSet; // On gère les animations

 UpTime := UpTime + 0.004 * random(100); // On augmente un petit peu le temps secondaire
 if UpTime >= 1 then // Si le temps secondaire atteint 1 ...
  begin
   UpTime := 0; // On remet le temps secondaire à 0
   Inc(Time); // On augmente le temps réel de 1
   if Time > 10000000 then Time := 0; // Si le temps réel a dépassé 10 millions, on le remet à 0
   if (aCircle in Animations) then MainForm.MakeCircleAnimation(10); // Si on a le cercle en animations, on dessine le cercle
   if (aRotatingArcCW in Animations) then MainForm.MakeRotatingArcCWAnimation(10); // Si on a l'arc en animations, on dessine l'arc
   if (aRotatingLineCW in Animations) then MainForm.MakeRotatingLineCWAnimation(3); // Si on a la ligne en animations, on dessine la ligne
   if (aWeirdLine in Animations) then MainForm.MakeWeirdLineAnimation(3); // Si on a la ligne bizarre en animations, on dessine la ligne bizarre
  end;

 MainForm.Blur; // On applique le flou sur l'image
 MainForm.Draw; // On dessine sur le composant TImage
end;

procedure TAnimThread.Execute; // Boucle principale
begin
  repeat  // On répète l'execution du thread ...
    sleep(1); // On attend un peu
    Application.ProcessMessages;  // On laisse l'application traiter ses messages
    MainForm.FPS; // On calcule les FPS                                                  
    if FramesPerSecond <> 0 then MainForm.Caption := '[' + IntToStr(FramesPerSecond) + ' FPS]'
     else MainForm.Caption := '[Démarrage]'; // On affiche les FPS
    Synchronize(CentralControl); // On synchronise
  until Terminated; // ... jusqu'à ce que le thread soit terminé
end;

end.
