{//-------------------------------------------------------------------------}
{/*                                                                         }
{Copyright (C) 1987, 2009 - Apogee Software, Ltd.                           }
{                                                                           }
{This file is part of Kroz. Kroz is free software; you can redistribute it  }
{and/or modify it under the terms of the GNU General Public License         }
{as published by the Free Software Foundation; either version 2             }
{of the License, or (at your option) any later version.                     }
{                                                                           }
{This program is distributed in the hope that it will be useful,            }
{but WITHOUT ANY WARRANTY; without even the implied warranty of             }
{MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                       }
{                                                                           }
{See the GNU General Public License for more details.                       }
{                                                                           }
{You should have received a copy of the GNU General Public License          }
{along with this program; if not, write to the Free Software                }
{Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.}
{                                                                           }
{Original Source: 1987-1990 Scott Miller                                    }
{Prepared for public release: 03/19/09 - Joe Siegler, Apogee Software, Ltd. }
{*/                                                                         }
{//-------------------------------------------------------------------------}
{*** KINGDOM OF KROZ II player movement.  By Scott Miller 11/12/89 ***}

unit KINGDOM5;

interface 

procedure Tablet_Message(Level: integer);
procedure Next_Level;
procedure Move(XWay,YWay:integer; Human:boolean);
procedure Prayer;

implementation {--------------------------------------------------------------}

uses CRT, DOS, Kingdom1, Kingdom2, Kingdom3, Kingdom4;

procedure Prayer;
 begin
  Flash(8,25,'On the Ancient Tablet is a short Mantra, a prayer...');
  Flash(8,25,'You take a deep breath and speak the words aloud...');
 end;

procedure Tablet_Message(Level: integer);
 begin
  case Level of
   1: Flash(5,25,'Once again you uncover the hidden tunnel leading to Kroz!');
   2: Flash(7,25,'Warning to all Adventurers:  No one returns from Kroz!');
   4: Flash(8,25,'Adventurer, try the top right corner if you desire.');
   6: Flash(6,25,'A strange magical gravity force is tugging you downward!');
   8,24: Flash(12,25,'You have choosen the greedy path Adventurer!');
   9: Flash(3,25,'A magical forest grows out of control in this region of Kroz!');
   10:Flash(9,25,'Sometimes, Adventurer, Gems can be crystal clear.');
   12:Flash(11,25,'The lava will block a slow Adventurer''s path!');
   14:Flash(9,25,'Follow the sequence if you wish to be successful.');
   18:begin
       Prayer;
       Flash(4,25,'"Barriers of water, like barriers in life, can always be..."');
       bak(0,0);
       for x := XBot to XTop do
        for y := YBot to YTop do
         if PF[x,y] = 17 then
          begin
           sound(x*y);
           PF[x,y] := 43;
           gotoxy(x,y);
           col(6,7);
           write(Block);
           delay(4);
          end; nosound; 
       Flash(26,25,'"...Overcome!"');
      end;
   20:Flash(16,25,'These walls will seek to entrap you!');
   22:begin
       Prayer;
       Flash(6,25,'"If goodness is in my heart, that which flows shall..."');
       bak(0,0);
       for x := XBot to XTop do
        for y := YBot to YTop do
         if PF[x,y] = 17 then
          begin
           sound(x*y);
           PF[x,y] := 27;
           gotoxy(x,y);
           col(14,7);
           write(Nugget);
           delay(1);
          end; nosound;
       Flash(25,25,'"...Turn to Gold!"');
      end;
  end;
 end; { Tablet_Message }

procedure Next_Level;
 begin
  case Level of
   1:Level1;
   2:Level2;
   4:Level4;
   6:Level6;
   8:Level8;
  10:Level10;
  12:Level12;
  14:Level14;
  16:Level16;
  18:Level18;
  20:Level20;
  22:Level22;
  24:Level24;
  25:Level25
  else Create_PlayField;
  end;
 end; { Next_Level }

procedure Move(XWay,YWay:integer; Human:boolean);
  var Killed,
      RXWay,RYWay,
      TryCounter : integer;
      Spot,
      Original   : byte;
      NoGo       : boolean;
   label JUMP_END;
 begin
  if (Sideways)and(YWay=-1)and(Replacement<>75)and(not(PF[PX+XWay,PY+YWay]in [75..80]))then
    goto JUMP_END;
  if (PX+XWay<XBot) or (PX+XWay>XTop) or
     (PY+YWay<YBot) or (PY+YWay>YTop) then
       begin
        if Human then
         begin
          Static;
          AddScore(20);
          ClearKeys;
          if not(0 in FoundSet) then
           begin
            FoundSet:=FoundSet+[0];
            Flash(16,25,'An Electrified Wall blocks your way.');
           end;
         end;
        exit;
       end;

  case PF[PX+XWay,PY+YWay] of
   {Null}      0:Go(XWay,YWay,Human);
   {Monsters}  1..3:
                 begin
                  Gems:=Gems-PF[PX+XWay,PY+YWay];
                  if Gems<0 then DEAD(true);
                  AddScore(PF[PX+XWay,PY+YWay]);
                  sound(200+200*PF[PX+XWay,PY+YWay]);delay(25);nosound;
                  Go(XWay,YWay,Human);
                  if keypressed then
                   begin
                    ch:=readkey;
                    if ch=#27 then ch:=readkey;
                   end;
                 end;
   {Block}     4,43,64:if Human then begin
                  BlockSound; AddScore(4); ClearKeys;
                  if not(4 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[4];
                    Flash(17,25,'A Breakable Wall blocks your way.');
                  end;
                 end;
   {Whip}      5:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  Whips:=Whips+1;
                  AddScore(5);
                  if not(5 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[5];
                    Flash(26,25,'You found a Whip.');
                   end;
                 end;
   {Stairs}    6:begin
                  Go(XWay,YWay,Human);
                  ClearKeys;

                  if Level=25 then End_Routine;

                  if MixUp then Level:=random(73)+2
                  else Level:=Level+1;
                  AddScore(6);
                  if not(6 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[6];
                    Flash(14,25,'Stairs take you to the next lower level.');
                    ClearKeys;
                   end;
                  FootStep;
                  T[1]:=5;T[2]:=6;T[3]:=7;T[8]:=7;
                  T[4]:=0;  { restore SlowTime   }
                  T[5]:=0;  { restore visibility }
                  T[6]:=0;  { restore SpeedTime  }
                  FoundSet:=FoundSet-[0,8,15,17,19..21,22,26,28,36,66];
                  GenNum:=0;
                  TreeRate:=-1;
                  LavaFlow:=false;
                  EvapoRate:=0;
                  MagicEWalls:=false;
                  HideLevel:=false;
                  HideOpenWall:=false;
                  HideRock:=false;
                  HideStairs:=false;
                  HideGems:=false;
                  HideMBlock:=false;
                  HideTrap:=false;
                  HideCreate:=false;
                  GravOn:=false;
                  GravRate:=0;
                  GravCounter:=0;
                  Bonus:=0;
                  Sideways:=false;
                  Replacement:=Null;

                  Next_Level;

          { NOTE: The lines below are special conditions }
                  if Level=9 then TreeRate:=40;
                  if Level=15 then begin LavaFlow:=true;LavaRate:=40;end;


                  FootStep;
                  bak(GemColor,7);
                  for x:=1 to 30 do
                   begin
                    window(32-x,12-(x div 3),35+x,14+(x div 3));
                    clrscr;
                   end;
                  bak(0,0);
                  for x:=1 to 30 do
                   begin
                    window(32-x,12-(x div 3),35+x,14+(x div 3));
                    clrscr;
                    sound(x*45);
                   end; nosound;
                  window(1,1,80,25);cur(3);
                  window(2,2,65,24);
                  clrscr;
                  window(1,1,80,25);cur(3);
                  Border;
                  FootStep;
                  Display_PlayField;
                  FootStep;
                  for x:=1 to 600 do
                   begin
                    gotoxy(PX,PY);
                    col(random(16),random(16));bak(random(8),0);
                    write(Player);sound(x div 2);
                   end;
                  gotoxy(PX,PY);col(14,15);bak(0,0);
                  write(Player);
                  nosound;
                  I_Score     := Score;   { SAVE/RESTORE VARIABLES }
                  I_Gems      := Gems;
                  I_Whips     := Whips;
                  I_Teleports := Teleports;
                  I_Keys      := Keys;
                  I_WhipPower := WhipPower;
                  I_Difficulty:= Difficulty;
                  I_PX        := PX;
                  I_PY        := PY;
                  I_FoundSet  := FoundSet;
                  if (Level=75) then
                   Flash(9,25,'You''ve finally reached the deepest chamber of Kroz!') 
                  else
                   if Sideways then Flash(13,25,'Press any key to begin this SIDEWAYS level.')
                   else Flash(17,25,'Press any key to begin this level.');
                 end;
   {Chest}     7:begin
                  Go(XWay,YWay,Human);
                  for xb:=3 to 42 do for yb:=3 to 42 do
                   begin sound(xb*yb);delay(1);end; nosound;
                  x:=random(3)+2;          {Whips}
                  i:=random(Difficulty)+2; {Gems}
                  Whips:=Whips+x;
                  Gems:=Gems+i;
                  AddScore(7);
                  bak(0,0);
                  ClearKeys;
                  repeat
                   col(random(2)+14,15);
                   gotoxy(11,25);
                   write('You found ',i,' gems and ',x,' whips inside the chest!');
                  until keypressed;
                  Restore_Border;
                 end;
   {SlowTime}  8:begin
                  Go(XWay,YWay,Human);
                  AddScore(5);
                  for x:=7 downto 1 do
                   begin sound(x*50+300);delay(x*10+40);end;nosound;
                  if FastPC then T[4] := 100 else T[4]:=70;
                  T[6]:=0;
                  if not(8 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[8];
                    Flash(18,25,'You activated a Slow Creature spell.');
                   end;
                 end;
   {Gem}       9:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  Gems:=Gems+1;
                  AddScore(9);
                  if not(9 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[9];
                    Flash(15,25,'Gems give you both points and strength.');
                   end;
                 end;
   {Invisible}10:begin
                  Go(XWay,YWay,Human);
                  AddScore(10);
                  for x:=1 to 4 do
                   begin sound(600);delay(50);nosound;delay(50);end;nosound;
                  gotoxy(PX,PY);write(' ');
                  if FastPC then T[5] := 120 else T[5]:=35;
                  if not(10 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[10];
                    Flash(16,25,'Oh no, a temporary Blindness Potion!');
                   end;
                 end;
   {Teleport} 11:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  Teleports:=Teleports+1;
                  AddScore(11);
                  if not(11 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[11];
                    Flash(20,25,'You found a Teleport scroll.');
                   end;
                 end;
   {Key}      12:begin
                  Go(XWay,YWay,Human);
                  Keys:=Keys+1;
                  GrabSound;
                  Update_Info;
                  if not(12 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[12];
                    Flash(22,25,'Use Keys to unlock doors.');
                   end;
                 end;
   {Door}     13:if Human then
                  begin
                   if Keys<1 then
                    begin
                     for x:=1 to 15 do
                      begin sound(random(99)+30);delay(15);nosound;delay(15);end;
                     Flash(18,25,'To pass the Door you need a Key.');
                    end
                   else
                    begin
                     Keys:=Keys-1;
                     AddScore(11);
                     for x:=10 to 90 do
                      begin sound(x);delay(15);end;
                     Go(XWay,YWay,Human);
                     ClearKeys;
                     if not(13 in FoundSet) then
                      begin
                       FoundSet:=FoundSet+[13];
                       Flash(12,25,'The Door opens!  (One of your Keys is used.)');
                      end else ClearKeys;
                     if (Level=75) and (PX=33) and (PY=14) then
                      Flash(13,25,'You unlock the door to the Sacred Temple!');
                    end;
                  end; 
   {Wall/River}14,17:if Human then begin
                  if PF[PX+XWay,PY+YWay]=14 then BlockSound
                  else
                   begin
                    for x:=1 to ord(FastPC)*2000+ord(not FastPC)*500 do sound(random(x*2+200)+x);nosound;
                   end;
                  AddScore(14);
                  ClearKeys;
                  if not(PF[PX+XWay,PY+YWay] in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[PF[PX+XWay,PY+YWay]];
                    case PF[PX+XWay,PY+YWay] of
                     14:Flash(20,25,'A Solid Wall blocks your way.');
                     17:Flash(18,25,'You cannot travel through Water.');
                    end;
                   end;
                 end;
   {SpeedTime}15:begin
                  Go(XWay,YWay,Human);
                  AddScore(15);
                  for x:=1 to 7 do
                   begin sound(x*50+300);delay(x*10+40);end;nosound;
                  if FastPC then T[6] := 80 else T[6]:=50;
                  T[4]:=0;
                  if not(15 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[15];
                    Flash(16,25,'You activated a Speed Creature spell.');
                   end;
                 end;
   {Trap}     16:begin
                  Go(XWay,YWay,Human);
                  AddScore(16);
                  for x:=1 to 500 do
                   begin
                    gotoxy(PX,PY);
                    col(random(16),random(16));bak(random(8),random(8));
                    write(Player);
                   end;
                  gotoxy(PX,PY);bak(0,0);col(0,0);write(' ');
                  for yb:= 60 downto 1 do
                   for x:= 550 downto 20 do sound(yb*x); nosound;
                  PF[PX,PY]:=Null;PX:=Null;
                  repeat
                   x:=random(XSize)+XBot;
                   y:=random(YSize)+YBot;
                   if PF[x,y] = Null then
                    begin
                     PX:=x; PY:=y; PF[PX,PY]:=40;
                    end;
                  until PX <> Null;
                  for x:=1 to ord(FastPC)*3000 + ord(not FastPC)*500 do
                   begin
                    gotoxy(PX,PY);
                    col(random(16),random(16));bak(random(8),random(8));
                    write(Player);
                   end;
                  if T[5]<1 then
                   begin
                    gotoxy(PX,PY);col(14,15);bak(0,0);
                    write(Player);bak(0,0);
                   end
                  else begin gotoxy(PX,PY);bak(0,0);write(' ');end;
                  ClearKeys;
                  if not(16 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[16];
                    Flash(19,25,'You activated a Teleport trap!');
                   end;
                 end;
   {Power}    18:begin
                  Go(XWay,YWay,Human);
                  WhipPower:=WhipPower+1;
                  for x:=3 to 35 do
                   for y:=45 to 52 do
                    begin
                     sound(x*y);delay(7);nosound;delay(15);
                     col(random(8),random(8));
                     gotoxy(PX,PY);
                     write(Player);
                    end;
                  bak(0,0);col(14,15);
                  gotoxy(PX,PY);
                  write(Player);
                  bak(0,0);
                  AddScore(15);
                  Flash(9,25,'A Power Ring--your whip is now a little stronger!');
                 end;
  {Forest/Tree} 19,20:if Human then
                 begin
                  BlockSound;AddScore(4);
                  ClearKeys;
                  if not(PF[PX+XWay,PY+YWay] in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[PF[PX+XWay,PY+YWay]];
                    case PF[PX+XWay,PY+YWay] of
                     19:Flash(14,25,'You cannot travel through forest terrain.');
                     20:Flash(24,25,'A tree blocks your way.');
                    end;
                   end;
                 end;
   {Bomb}     21:begin
                  Go(XWay,YWay,Human);
                  xr:=0;xl:=0;yr:=0;yl:=0;
                  for i:=70 to 600 do begin sound(i*2);delay(3);end;;
                  for i:=ord(FastPC)*8230+ord(not FastPC)*5000 downto 20 do
                   sound(random(i));
                   for width:=1 to 4 do
                    begin
                     sound(30);
                     if PX-width>1 then xl:=width;
                     if PX+width<66 then xr:=width;
                     if PY-width>1 then yl:=width;
                     if PY+width<25 then yr:=width;
                     for x:=PX-xl to PX+xr do
                      for y:=PY-yl to PY+yr do
                       if PF[x,y] in [Null..4,13,16,19,28..32,33,35,36..39,43,45,48..51,64,67,68..74,224..231] then
                        begin
                         gotoxy(x,y);
                         col(12,15);
                         write(#219);
                        end;
                    end;
                    delay(100);
                    for width:=1 to 4 do
                     begin
                      if PX-width>1 then xl:=width;
                      if PX+width<66 then xr:=width;
                      if PY-width>1 then yl:=width;
                      if PY+width<25 then yr:=width;
                      for x:=PX-xl to PX+xr do
                       for y:=PY-yl to PY+yr do
                        if PF[x,y] in [Null..4,13,16,19,28..32,33,35,36..39,43,45,48..51,64,67,68..74,224..231] then
                         begin
                          gotoxy(x,y);
                          col(0,0);
                          write(' ');
                          if PF[x,y] in [1..3] then Score:=Score+PF[x,y];
                          PF[x,y]:=Null;
                         end;
                     end;
                  nosound;
                  ;
                  Update_Info;
                  ClearKeys;
                  if not(21 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[21];
                    Flash(20,25,'You activated a Magic Bomb!');
                   end;
                 end;
   {Lava}     22:begin
                  Go(XWay,YWay,Human);
                  Gems:=Gems-10;
                  for x:=ord(FastPC)*2000+ord(not FastPC)*1400 downto 20 do
                   for y:= 9 downto 2 do sound(random(y*x+100)+y*x);nosound;
                  if Gems<0 then
                   begin
                    Gems:=0;
                    AddScore(22);
                    Dead(true);
                   end
                  else
                   AddScore(22);
                  ClearKeys;
                  if not(22 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[22];
                    Flash(8,25,'Oooooooooooooooooooh!  Lava hurts!  (Lose 10 Gems.)');
                   end;
                 end;
   {Pit}      23:begin
                  Go(XWay,YWay,Human);
                  ClearKeys;
                  Flash(22,25,'Oh no, a Bottomless Pit!');
                  bak(6,7);
                  window(2,2,65,24);
                  clrscr;
                  bak(0,0);
                  window(32,2,36,24);
                  clrscr;
                  window(1,1,80,25);
                  cur(3);
                  x:=3000;
                  col(14,15);
                  for i:=1 to 16 do
                   begin
                    if i=8 then
                     begin
                      col(15,15);
                      bak(6,7);
                      gotoxy(38,12);
                      write('<--- HALF WAY!!!');
                      bak(0,0);col(14,15);
                     end else
                    if i=9 then
                     begin
                      bak(6,7);
                      gotoxy(38,12);
                      write('                ');
                      bak(0,0);col(14,15);
                     end;
                    for y:=2 to 24 do
                     begin
                      x:=x-8;
                      sound(x);
                      gotoxy(34,y);
                      write(Player);
                      delay(52-(3*i));
                      gotoxy(34,y);
                      write(' ');
                     end; nosound;
                   end;  
                  gotoxy(34,24);
                  write('_');
                  for i:=8000 downto 20 do sound(random(i));nosound;
                  ClearKeys;
                  flash(29,1,'* SPLAT!! *');
                  Dead(false);
                 end;
   {Tome}     24:begin
                  Tome_Message;
                  for i:= 1 to 3 do Tome_Effects;
                  bak(0,0);
                  for x:=1 to 24 do
                   for y:=5 downto 1 do
                    begin
                     sound(x*45+y*10);delay(y*3);nosound;delay(40);
                     gotoxy(34,6);col(random(16),random(16));
                     write(Tome);
                    end;
                  gotoxy(34,6);
                  col(16,16);bak(2,7);
                  write(Stairs);bak(0,0);
                  PF[PX+XWay,PY+YWay]:=6;
                  Score:=Score+5000;
                  Update_Info;
                  ClearKeys;
                  Flash(5,25,'The Magical Amulet of Kroz is finally yours--50,000 points!');
                  Flash(9,25,'Congratualtions, Adventurer, you finally did it!!!');
                 end;
   {Tunnel}   25:begin
                  PXOld:=PX;PYOld:=PY;
                  Go(XWay,YWay,Human);
                  delay(350);FootStep;delay(500);FootStep;
                  PF[PX,PY]:=25;
                  gotoxy(PX,PY);
                  col(15,7);
                  write(Tunnel);
                  repeat
                   sound(random(3000)+100);
                   x:=random(XSize)+XBot;
                   y:=random(YSize)+YBot;
                  until (PF[x,y]=25)and((PXOld+XWay<>x)or(PYOld+YWay<>y));
                  Done:=false;
                  for i:=1 to 100 do
                   begin
                    sound(random(3000)+100);
                    a:=random(3)-1;
                    b:=random(3)-1;
                    if(PF[x+a,y+b] in [0,32,33,37,39,55..57,67,224..231]) and (Done=false)then
                     begin
                      if not((x+a<XBot)or(x+a>XTop)or(y+b<YBot)or(y+b>YTop)) then
                       begin
                        Done:=true;
                        x:=x+a;
                        y:=y+b;
                       end;
                     end;
                   end;
                  nosound;
                  if Done=false then
                   begin
                    x:=PXOld;
                    y:=PYOld;
                   end;
                  PX:=x;PY:=y;
                  if PF[PX,PY] in [55..57] then Replacement:=PF[PX,PY]
                  else                          Replacement:=Null;
                  PF[PX,PY]:=40;
                  for x:=1 to ord(FastPC)*2100+ord(not FastPC)*400 do
                   begin
                    sound(random(1000));
                    gotoxy(PX,PY);
                    col(random(16),random(16));bak(random(8),0);
                    write(Player);
                   end;nosound;
                  if T[5]<1 then
                   begin
                    gotoxy(PX,PY);col(14,15);bak(0,0);
                    write(Player);
                   end
                  else begin gotoxy(PX,PY);bak(0,0);col(0,0);write(' ');end;
                  ClearKeys;
                  if not(25 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[25];
                    Flash(16,25,'You passed through a secret Tunnel!');
                   end;
                 end;
   {Freeze}   26:begin
                  Go(XWay,YWay,Human);
                  AddScore(11);
                  GrabSound;
                  for x:=1 to ord(FastPC)*8000+ord(not FastPC)*5000 do 
                   sound(random(1000)+x+200);nosound;
                  if FastPC then T[7]:=60 else T[7]:=55;
                  if not(26 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[26];
                    Flash(13,25,'You have activated a Freeze Creature spell!');
                   end;
                 end;
   {Nugget}   27:begin
                  Go(XWay,YWay,Human);
                  AddScore(27);
                  GrabSound;
                  if not(27 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[27];
                    Flash(15,25,'You found a Gold Nugget...500 points!');
                   end;
                 end;
   {Quake}    28:begin
                  Go(XWay,YWay,Human);
                  for i:=1 to ord(FastPC)*5500 + ord(not FastPC)*2500 do
                    sound(random(i));nosound;
                  for i:=1 to 50 do
                   begin
                    Done:=false;
                    repeat
                     x:=random(XSize)+XBot;
                     y:=random(YSize)+YBot;
                     if PF[x,y] in [0..3,5,7..11,15..16,26,32,33,37,39,67,224..231] then
                      begin
                       Done:=true;
                       PF[x,y]:=65;
                       gotoxy(x,y);
                       col(7,7);
                       write(Rock);
                      end;
                    until (random(100)=0) or Done;
                    for x:=1 to ord(FastPC)*700 + ord(not FastPC)*400 do
                     sound(random(200));nosound;
                   end;
                  for i:=2500 downto 20 do sound(random(i));nosound;
                  if not(28 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[28];
                    ClearKeys;
                    Flash(15,25,'Oh no, you set off an Earthquake trap!');
                   end;
                 end;
   {IBlock}   29:begin
                  gotoxy(PX+XWay,PY+YWay);
                  col(6,7);
                  write(Block);
                  PF[PX+XWay,PY+YWay]:=4;
                  BlockSound;
                  ClearKeys;
                  if not(29 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[29];
                    Flash(13,25,'An Invisible Crumbled Wall blocks your way.');
                   end;
                 end;
   {IWall}    30:begin
                  gotoxy(PX+XWay,PY+YWay);
                  col(6,7);
                  write(Wall);
                  PF[PX+XWay,PY+YWay]:=14;
                  BlockSound;
                  ClearKeys;
                  if not(30 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[30];
                    Flash(17,25,'An Invisible Wall blocks your way.');
                   end;
                 end;
   {IDoor}    31:begin
                  gotoxy(PX+XWay,PY+YWay);
                  col(3,0);bak(5,7);
                  write(Door);
                  bak(0,0);
                  PF[PX+XWay,PY+YWay]:=13;
                  BlockSound;
                  ClearKeys;
                  if not(31 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[31];
                    Flash(17,25,'An Invisible Door blocks your way.');
                   end;
                 end;
   {Stop}     32:Go(XWay,YWay,Human);
   {Trap2}    33:begin
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = 33 then PF[x,y] := Null;
                 end;
   {Zap}      34:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  Killed := 0;
                  TryCounter := 0;
                  repeat
                   TryCounter:=TryCounter+1;
                    case random(3)+1 of
                    1:if SNum>1 then
                       begin
                        i:=random(SNum)+1;
                        if SX[i]<>Null then
                         begin
                          Killed:=Killed+1;
                          for x:=ord(FastPC)*230+ord(not FastPC)*80 downto 3 do
                           begin
                            sound(x*5);
                            gotoxy(SX[i],SY[i]);col(random(16),15);
                            write(Slow);
                           end; nosound;
                          col(0,0);gotoxy(SX[i],SY[i]);write(' ');
                          PF[SX[i],SY[i]]:=Null;
                          SX[i]:=Null;
                         end;
                       end;
                    2:if MNum>1 then
                       begin
                        i:=random(MNum)+1;
                        if MX[i]<>Null then
                         begin
                          Killed:=Killed+1;
                          for x:=ord(FastPC)*230+ord(not FastPC)*80 downto 3 do
                           begin
                            sound(x*5);
                            gotoxy(MX[i],MY[i]);col(random(16),15);
                            write(Medium);
                           end; nosound;
                          col(0,0);gotoxy(MX[i],MY[i]);write(' ');
                          PF[MX[i],MY[i]]:=Null;
                          MX[i]:=Null;
                         end;
                       end;
                    3:if FNum>1 then
                       begin
                        i:=random(FNum)+1;
                        if FX[i]<>Null then
                         begin
                          Killed:=Killed+1;
                          for x:=ord(FastPC)*230+ord(not FastPC)*80 downto 3 do
                           begin
                            sound(x*5);
                            gotoxy(FX[i],FY[i]);col(random(16),15);
                            write(Fast);
                           end; nosound;
                          col(0,0);gotoxy(FX[i],FY[i]);write(' ');
                          PF[FX[i],FY[i]]:=Null;
                          FX[i]:=Null;
                         end;
                       end;
                    end;
                  until (Killed=40) or (TryCounter=500);
                  ClearKeys;
                  Score:=Score+(Killed div 3)+2;
                  Update_Info;
                  if not(34 in FoundSet) then
                   begin
                    ClearKeys;
                    Flash(25,25,'A Creature Zap Spell!');
                    FoundSet:=FoundSet+[34];
                   end;
                 end;
   {Create}   35:if not Sideways then
                  begin
                   Go(XWay,YWay,Human);
                   if SNum < 945 then
                    for i:=1 to 45 do
                     begin
                      Done:=false;
                      repeat
                       x:=random(XSize)+XBot;
                       y:=random(YSize)+YBot;
                       if PF[x,y] in [0,224] then
                        begin
                         Done:=true;
                         PF[x,y]:=1;
                         gotoxy(x,y);
                         col(12,7);
                         write(Slow);
                         SNum:=SNum+1;
                         SX[SNum]:=x;
                         SY[SNum]:=y;
                         for x:=5 to 50 do
                          begin sound(x*12);delay(1);end;nosound;
                        end;
                      until (random(120)=0) or Done;
                     end;
                   AddScore(35);
                   ClearKeys;
                   if not(35 in FoundSet) then
                    begin
                     Flash(21,25,'A Creature Creation Trap!');
                     FoundSet:=FoundSet+[35];
                    end;
                  end
                 else  { is a Sideways level }
                   if Gems > 13 then
                    begin
                     Go(XWay,YWay,Human);
                     Gems:=Gems-3;
                     for x:=6000 downto 3000 do sound(random(x)+999); nosound;
                     Update_Info;
                     if random(2)=0 then
                      Flash(12,25,'A strong wind blows away three of your Gems!') else
                      Flash(11,25,'Three of your Gems dissolve before your eyes!');
                    end
                   else Flash(4,25,'You find nothing here!');  
  {Generator} 36:if Human then begin
                  BlockSound;
                  if not(36 in FoundSet) then
                   begin
                    Flash(14,25,'You have discovered a Creature Generator!');
                    FoundSet:=FoundSet+[36];
                   end;
                  end;
   {Trap3}    37:begin
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = 37 then PF[x,y] := Null;
                 end;
   {MBlock}   38:if Human then begin
                  BlockSound;AddScore(4);
                  ClearKeys;
                  if not(38 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[38];
                    Flash(19,25,'A Moving Wall blocks your way.');
                   end;
                  end;
   {Trap4}    39:begin
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = 39 then PF[x,y] := Null;
                 end;
   {ShowGems} 41:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  for i:=1 to ord(FastPC)*120+ord(not FastPC)*70 do
                    for x:=7 downto 1 do sound(i*x);nosound;
                  for i:=1 to (Difficulty*2)+5 do
                   begin
                    Done:=false;
                    repeat
                     x:=random(XSize)+XBot;
                     y:=random(YSize)+YBot;
                     if PF[x,y]=Null then
                      begin
                       sound(random(1200)+110);
                       Done:=true;
                       PF[x,y]:=9;
                       gotoxy(x,y);
                       col(GemColor,7);
                       write(Gem);
                       delay(7);nosound;delay(99);
                      end;
                    until (random(100)=0) or Done;
                   end;
                  ClearKeys;
                  Flash(11,25,'Yah Hoo! You discovered a Reveal Gems Scroll!');
                 end;                   
   {Tablet}   42:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  Score:=Score+Level+250;
                  Update_Info;
                  if not(42 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[42];
                    Flash(7,25,'You found an Ancient Tablet of Wisdom...2,500 points!');
                   end;ClearKeys;
                  Tablet_Message(Level);
                 end;
  {BlockSpell}44:begin
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = 43 then
                     begin
                      sound(200);
                      PF[x,y] := Null;
                      for i:=1 to 20 do
                       begin
                        gotoxy(x,y);
                        col(random(16),15);
                        write(Block);
                        delay(3);
                       end;
                      gotoxy(x,y);
                      col(0,0);
                      write(' ');
                      nosound;
                     end;
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = 44 then PF[x,y] := Null;
                  ClearKeys;
                  if not(44 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[44];
                    Flash(19,25,'You triggered Exploding Walls!');
                   end else ClearKeys;
                 end;
    {Chance}  45:begin
                  a:=random(Difficulty)+13;
                  Go(XWay,YWay,Human);
                  GrabSound;
                  Score:=Score+100;
                  Gems:=Gems+a;
                  Update_Info; 
                  ClearKeys;
                  b := 14;
                  repeat
                   b := b + 1;
                   if b > 15 then b := 13;
                   col(b,15);
                   delay(20);
                   gotoxy(15,25);
                   write('You found a Pouch containing ',a,' Gems!');
                  until keypressed;
                  Restore_Border;
                 end; 
    {Statue}  46:if Human then begin
                   BlockSound;
                   ClearKeys;
                   Flash(9,25,'Statues are very dangerous...they drain your Gems!');
                 end;
  {WallVanish}47:begin
                  Go(XWay,YWay,Human);
                  for i:=1 to 75 do
                   begin
                    Done:=false;
                    repeat
                     x:=random(XSize)+XBot;
                     y:=random(YSize)+YBot;
                     if PF[x,y] in [4,14] then
                      begin
                       sound(random(2500)+999);
                       Done:=true;
                       case PF[x,y] of
                        4:begin
                           gotoxy(x,y);
                           col(0,0);
                           write(' ');
                           PF[x,y] := 29;
                          end;
                       14:begin
                           gotoxy(x,y);
                           col(0,0);
                           write(' ');
                           PF[x,y] := 30;
                          end;
                       end; delay(5);nosound;   
                      end;
                    until (random(200)=0) or Done;
                   end;
                  ClearKeys;
                  Flash(4,25,'Yikes!  A trap has made many of the wall sections invisible!');
                 end;
      { K }   48:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  if Bonus = 0 then Bonus:=1;
                 end; 
      { R }   49:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  if Bonus = 1 then Bonus:=2;
                 end; 
      { O }   50:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  if Bonus = 2 then Bonus:=3;
                 end; 
      { Z }   51:begin
                  Go(XWay,YWay,Human);
                  GrabSound;
                  if Bonus = 3 then
                   begin
                    ClearKeys;
                    for x:=10 to 45 do
                     for y:=1 to 13 do
                      begin sound(x*x*y);delay(y+1);end; nosound;
                    Score:=Score+1000;
                    Update_Info; 
                    Flash(17,25,'Super Kroz Bonus -- 10,000 points!');
                   end; 
                 end; 
   {OWalls}52..54:If Human then begin
                  BlockSound;
                  AddScore(14);
                  ClearKeys;
                  if not(14 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[14];
                    Flash(20,25,'A Solid Wall blocks your way.');
                   end;
                 end;
    {CWalls}  55..57:Go(XWay,YWay,Human);
    {OSpells} 58..60:begin
                  Original := PF[PX+XWay,PY+YWay];
                  case Original of
                   58:Spot:=52;
                   59:Spot:=53;
                   60:Spot:=54;
                  end; 
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = Spot then
                     begin
                      PF[x,y] :=Null;
                      for i:=1 to 30 do
                       begin
                        gotoxy(x,y);
                        col(random(15),15);
                        write(chr(220+random(4)));
                       end;
                      for a:=60 downto 1 do
                       begin sound(a*40);delay(1);end;nosound; 
                      col(15,15);
                      gotoxy(x,y);
                      write(Wall);
                      delay(8);
                      gotoxy(x,y);
                      col(0,0);
                      write(' ');
                     end;
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = Original then
                     begin
                      PF[x,y] :=Null;
                      gotoxy(x,y);
                      write(' ');
                     end; 
                  ClearKeys;
                  if not(Original in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[Original];
                    Flash(14,25,'Magic has been released is this chamber!');
                   end;
                 end;
    {CSpells} 61..63:begin
                  Original := PF[PX+XWay,PY+YWay];
                  case Original of
                   61:Spot:=55;
                   62:Spot:=56;
                   63:Spot:=57;
                  end; 
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = Spot then
                     begin
                      PF[x,y]:=14;
                      for i:=1 to 30 do
                       begin
                        gotoxy(x,y);
                        col(random(15),15);
                        write(chr(220+random(4)));
                       end;
                      for a:=20 to 80 do
                       begin sound(a*50);delay(1);end;nosound; 
                      col(15,15);
                      gotoxy(x,y);
                      write(Wall);
                      delay(8); 
                      gotoxy(x,y);
                      col(6,7);
                      write(Wall);
                     end;
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = Original then
                     begin
                      PF[x,y] :=Null;
                      gotoxy(x,y);
                      write(' ');
                     end;
                  ClearKeys;
                  if not(Original in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[Original];
                    Flash(18,25,'New Walls have magically appeared!');
                   end;
                 end;
      {Rock}  65:if Human then begin
                  RXWay:=0; RYWay:=0; NoGo:=false;
                  if XWay= 1 then RXWay:= 2;
                  if XWay=-1 then RXWay:=-2;
                  if YWay= 1 then RYWay:= 2;
                  if YWay=-1 then RYWay:=-2;
                  RX:=PX+RXWay; RY:=PY+RYWay;
                  if (XWay= 1) and (RX>65) then NoGo:=true;
                  if (XWay=-1) and (RX<2)  then NoGo:=true;
                  if (YWay= 1) and (RY>24) then NoGo:=true;
                  if (YWay=-1) and (RY<2)  then NoGo:=true;
                  ClearKeys;
                  if not NoGo then
                   case PF[RX,RY] of
                    0,32,33,37,39,41,44,47,55..57,61..63,67,68..74,224..231:
                     if (Replacement<>75)or((Replacement=75)and(YWay=0)) then
                       MoveRock(XWay,YWay) else BlockSound;
                    1..3:begin
                        Score:=Score+PF[RX,RY]; MoveRock(XWay,YWay);
                        sound(600);delay(20);nosound;
                       end;
                    4,13,14,17,19,20,22,24,25,29..31,36,38,43,46,52..54,64,65,75:
                       BlockSound;
                    5,7..12,16,18,21,26,27,34,35,42,45,48..51,58..60,76..80,82,83:begin
                        MoveRock(XWay,YWay); GrabSound;
                       end;
                    66:begin
                        MoveRock(XWay,YWay);
                        PF[RX,RY]:=Null;
                        sound(90);
                        ClearKeys;
                        for i:=1 to 20 do
                         begin
                          gotoxy(RX,RY);
                          col(random(15)+1,15); bak(random(8),0); write(EWall);
                          ;
                         end;
                        ; bak(0,0);
                        gotoxy(RX,RY);col(0,0);write(' ');
                        for i:=30000 downto 20 do sound(random(i));nosound;
                        if not(0 in FoundSet) then
                         begin
                          FoundSet:=FoundSet+[0];
                          ClearKeys;
                          Flash(21,25,'The Boulder is vaporized!');
                         end;
                       end;
                    6,23:begin
                        for i:=1 to ord(FastPC)*500+ord(not FastPC)*330 do
                         begin sound(random(100)+20);delay(1);end; nosound;
                        gotoxy(PX+XWay,PY+YWay);
                        col(0,0);
                        write(' ');
                        Go(XWay,YWay,Human);
                        for i:= 130 downto 5 do
                         begin sound(i*8);delay(3);end; nosound;
                       end;
                   end
                  else BlockSound;
                  if not(65 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[65];
                    ClearKeys;
                    Flash(21,25,'You pushed a big Boulder!');
                   end;
                 end;
      {EWall} 66:if Human then begin
                  Gems:=Gems-1;
                  if Gems<0 then DEAD(true);
                  AddScore(20);
                  Static;
                  if not(66 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[66];
                    ClearKeys;
                    Flash(11,25,'You hit a Electrified Wall!  You lose one Gem.');
                   end else ClearKeys;
                 end;
   {Trap5-13}   67,224..231:begin
                  a:=PF[PX+XWay,PY+YWay];
                  Go(XWay,YWay,Human);
                  for x := XBot to XTop do
                   for y := YBot to YTop do
                    if PF[x,y] = a then PF[x,y] := Null;
                 end;
   {Triggers} 68..74:begin
                  a:=PF[PX+XWay,PY+YWay];
                  Go(XWay,YWay,Human);
                  case a of
                   68: begin i:=4;col(6,7);ch:=Block;end;
                   69: begin i:=65;col(7,7);ch:=Rock;end;
                   70: begin i:=9;col(GemColor,7);ch:=Gem;end;
                   71: begin i:=10;col(2,7);ch:=Invisible;end;
                   72: begin i:=5;col(15,7);ch:=Whip;end;
                   73: begin i:=27;col(14,7);ch:=Nugget;end;
                   74: begin i:=20;col(6,7);bak(2,7);ch:=Tree;end;
                  end;
                  for b:=1 to 10 do
                   begin
                    bak(random(8),random(8));
                    sound((b+25)*b*2);
                    Trigger_Trap(false,i,ch);
                    delay(5);
                   end;
                  nosound;
                  if i=20 then bak(2,7) else bak(0,0);
                  Trigger_Trap(true,i,ch);
                  bak(0,0);
                  ClearKeys;
                 end;
     {Rope}   75:if Human then begin
                  OneMove:=true;
                  Go(XWay,YWay,Human);
                  if not(75 in FoundSet) then
                   begin
                    FoundSet:=FoundSet+[75];
                    ClearKeys;
                    Flash(24,25,'You grabbed a Rope.');
                   end else begin end
                  end else begin end;
    {Message}252:Secret_Message;
  {ShootRight}82:Shoot_Right(XWay,YWay,Human);
  {ShootLeft} 83:Shoot_Left(XWay,YWay,Human);
    {RopeDrop} 76..80:begin
                 a:=PF[PX+XWay,PY+YWay];
                 if Human then OneMove:=true;
                 Go(XWay,YWay,Human);
                 for x := XBot to XTop do
                  for y := YBot to YTop do
                   if PF[x,y] = a then
                    begin
                     i:=y;
                     repeat
                      if PF[x,i] = 40 then Replacement:=75 else PF[x,i]:=75;
                      for b:=20 to 40 do
                       begin
                        gotoxy(x,i);
                        col(random(16),7);
                        write(DropRope);
                        sound(i*b*3);delay(4);
                       end; nosound;
                      if PF[x,i]<>75 then
                       begin
                        gotoxy(x,i);
                        col(14,15);
                        write(Player);
                       end
                      else
                       begin 
                        gotoxy(x,i);
                        col(7,7);
                        write(Rope);
                       end; 
                      inc(i);
                     until (i > 23) or 
                       (PF[x,i+1] in [4,13,14,17,19..25,29..31,42,43,
                        52..60,64..66,75,100..223,232..254]);
                    end;
                 end;
              81:WRITELN('ERROR!!!')
       else if Human then BlockSound;
  end;{case}
  JUMP_END:
  OneMove:=false;
 end; { Move }

 BEGIN
 END.