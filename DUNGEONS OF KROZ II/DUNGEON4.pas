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
{*** DUNGEONS OF KROZ II title stuff.  By Scott Miller 08/31/89 ***}

unit DUNGEON4;

interface

procedure Screen;
procedure Init_Screen;
procedure Parse_Field;
procedure Create_Playfield;
procedure Display_Playfield;
function  GetKey:byte;
procedure Hit(X, Y:integer;ch:char);
procedure Secret_Message;
procedure Shoot_Right(XWay,YWay:integer; Human:boolean);
procedure Shoot_Left(XWay,YWay:integer; Human:boolean);
procedure Tome_Message;
procedure Tome_Effects;

implementation {--------------------------------------------------------------}

uses CRT, DOS, DUNGEON1, DUNGEON2, DUNGEON3;

procedure Screen;
 begin
  ClearKeys;
  Color := true;
  bak(0,0);
  clrscr;
  ;
  cur(3);
  col(9,9);
  gotoxy(31,2);
  write('DUNGEONS OF KROZ II');
  gotoxy(18,10);
  col(15,7);
  write('Is your screen Color or Monochrome (C/M)? C');
  gotoxy(wherex-1,wherey);cur(2);
  ch:=readkey;sound(500);delay(30);nosound;
  if upcase(ch)='M' then
   begin
    textmode(BW80);
    Color := false;
   end
  else Color := true;
  bak(0,0);
  gotoxy(18,10);
  delline;
  gotoxy(9,17);
  textcolor(7);
  write('If you have an older PC (like an XT model) choose "S" for Slow.');
  gotoxy(10,19);
  write('If you have a PC AT, 80386 chip, etc., choose "F" for Fast.');
  gotoxy(32,21);
  write('(Default = Slow)');
  col(15,15);
  gotoxy(28,14);
  write('Slow or Fast PC (S/F)? S');
  gotoxy(wherex-1,wherey);
  ch:=readkey;sound(300);delay(30);nosound;
  if upcase(ch) = 'F' then FastPC := true else FastPC := false;
  clrscr;
 end;

procedure Init_Screen;
 begin
  Slow     := #142;
  Medium   := #153;
  Fast     := #234;
  Restart  := false;
  Score    := 0;
  Level    := 1;
  Whips    := 0;
  Teleports:= 0;
  Keys     := 0;
  WhipPower:= 2;
  case Difficulty of
    9:begin Gems:=250;Whips:=100;Teleports:=50;Keys:=1;WhipPower:=3; end;
    8:begin Gems:=20;Whips:=10;end;
    5:Gems:=15;
    2:Gems:=10
  end;
  FloorPattern:=false;
  Replacement:= Null;
  Bonus      := 0;
  LavaFlow   := false;
  LavaRate   := 0;
  Evaporate  := 0;
  MagicEWalls:= false;
  GravOn     := false;
  GravRate   := 20;
  GravCounter:= 0;
  TreeRate   := -1;
  HideRock   := false;
  HideStairs := false;
  HideLevel  := false;
  HideCreate := false;
  HideOpenWall:=false;
  HideTrap   := false;
  HideGems   := false;
  HideMBlock := false;
  FoundSet   := [];
  if Difficulty in [2,9] then FoundSet:=[0..255];
  GenNum     := 0;
  Sideways   :=false;
  OneMove    := false;
  if FastPC then GenFactor := 28
  else           GenFactor := 17;
  if MixUp then
   begin
    Gems     :=60;
    Whips    :=30;
    Teleports:=15;
    Keys     :=2;
    FoundSet :=[0..ToTObjects];
   end;
  PX       := random(XSize)+XBot;
  PY       := random(YSize)+YBot;
  if FastPC then BTime := 9  else BTime := 2;
  if FastPC then STime := 10 else STime := 3;
  if FastPC then MTime := 8  else MTime := 2;
  if FastPC then FTime := 6  else FTime := 1;
  SkipTime := 0;
  for x:=1 to TMax do T[x]:=-1; {***** reset timers *****}
  T[1]     := 5;
  T[2]     := 6;
  T[3]     := 7;
  T[8]     := 6;
  if Color then
   begin
    window(67,1,80,25);
    bak(1,0);
    clrscr;
    window(1,1,80,25);
   end;
  col(14,7);
  print(71,1,'Score');
  print(71,4,'Level');
  print(71,7,'Gems');
  print(71,10,'Whips');
  print(69,13,'Teleports');
  print(71,16,'Keys');
  col(11,7);bak(4,0);
  print(70,19,'OPTIONS');
  bak(1,0);
  gotoxy(70,20);col(15,15);write('W');col(7,7);write('hip');
  gotoxy(70,21);col(15,15);write('T');col(7,7);write('eleport');
  gotoxy(70,22);col(15,15);write('P');col(7,7);write('ause');
  gotoxy(70,23);col(15,15);write('Q');col(7,7);write('uit');
  gotoxy(70,24);col(15,15);write('S');col(7,7);write('ave');
  gotoxy(70,25);col(15,15);write('R');col(7,7);write('estore');
 end; { Init_Screen }

(*-title went here-*)

procedure Parse_Field;
  var Slot,
      Counter : integer;
      Fetch : string[4];
 begin
  Slot:=1;
  Counter:=1;
  repeat
   Fetch:=copy(DF[Level],Slot,3);
   if Fetch[1] = ' ' then begin Fetch:=Fetch[2]+Fetch[3];end;
   if Fetch[1] = ' ' then Fetch:=Fetch[2];
   Slot:=Slot+3;
   Counter:=Counter+1;
  until Counter > ToTObjects;
 end; { Parse_Field }

procedure Create_Playfield;
  var x,y,
      Obj,
      Loop,
      XSpot,
      YSpot : integer;
 begin
  SNum:=0; MNum:=0; FNum:=0; BNum:=0; GenNum:=0; LavaFlow := false;
  T[9]:=-1;
  for x:=1 to 999 do
   begin
    SX[x]:=0;SY[x]:=0;    {* reset monster's X, Y *}
    MX[x]:=0;MY[x]:=0;
    FX[x]:=0;FY[x]:=0;
   end;
  New_Gem_Color;
  for x:=XBot to XTop do
   for y:=YBot to YTop do PF[x,y]:=0;
  PF[PX,PY]:=40;
  Parse_Field;
  for Obj:=1 to ToTObjects do
    if Parsed[Obj] > 0 then
     for Loop:=1 to Parsed[Obj] do
      begin
       Done:=false;
        repeat
         XSpot:=random(XSize)+XBot;
         YSpot:=random(YSize)+YBot;
         if PF[XSpot,YSpot] = 0 then
          begin
           PF[XSpot,YSpot]:=Obj;Done:=true;
           case obj of
            1: begin SNum:=SNum+1;SX[SNum]:=XSpot;SY[SNum]:=YSpot;end;
            2: begin MNum:=MNum+1;MX[MNum]:=XSpot;MY[MNum]:=YSpot;end;
            3: begin FNum:=FNum+1;FX[FNum]:=XSpot;FY[FNum]:=YSpot;end;
            36:GenNum:=GenNum+1;
           end;
          end;
        until Done;
      end;
 end; { Create_Playfield }

procedure Display_Playfield;
  var XLoop,
      YLoop : integer;
 begin
  for XLoop:=XBot to XTop do
   for YLoop:=YBot to YTop do
    if ((PF[XLoop,YLoop] > 0 )or(FloorPattern)) and (not HideLevel) then
     begin
      gotoxy(XLoop,YLoop);
      case PF[XLoop,YLoop] of
       {Floor}     0:begin col(CF1,CF2);bak(BF1,BF2);write(Tile);bak(0,0)end;
       {Slow}      1:begin col(12,7);write(Slow)end;
       {Medium}    2:begin col(10,7);write(Medium)end;
       {Fast}      3:begin col(9,7);write(Fast)end;
       {Block}     4:if Level <> 71 then begin col(6,7);write(Block)end;
       {Whip}      5:begin col(15,7);write(Whip)end;
       {Stairs}    6:if not HideStairs then
                      begin bak(7,7);col(16,16);write(Stairs);bak(0,0)end;
       {Chest}     7:if random(20)=0 then begin col(15,7);write(Chance)end
                     else begin col(14,7);bak(4,0);write(Chest);bak(0,0)end;
       {SlowTime}  8:if random(35)=0 then begin col(15,7);write(Chance)end
                     else begin col(11,7);write(SlowTime)end;
       {Gem}       9:if not HideGems then begin col(GemColor,7);write(Gem)end;
       {Invisible} 10:begin col(2,7);write(Invisible)end;
       {Teleport}  11:begin col(13,7);write(Teleport)end;
       {Key}       12:if random(25)=0 then begin col(15,7);write(Chance)end
                      else begin col(12,15);write(Key)end;
       {Door}      13:begin bak(5,7);col(3,0);write(Door);bak(0,0)end;
       {Wall}      14:begin col(6,7);write(Wall)end;
       {SpeedTime} 15:if random(10)=0 then begin col(15,7);write(Chance)end
                      else begin col(11,7);write(SpeedTime)end;
       {Trap}      16:if not HideTrap then begin
                       col(7,7);write(Trap);
                      end;
       {River}     17:if level=56 then begin col(12,16);bak(4,7);write(Lava);bak(0,0)end
                      else begin col(9,0);bak(1,7);write(River);bak(0,0)end;
       {Power}     18:if random(15)=0 then begin col(15,7);write(Chance)end
                      else begin col(15,7);write(Power)end;
       {Forest}    19:begin col(2,7);write(Forest);bak(0,0)end;
       {Tree}      20,252:begin col(6,0);bak(2,7);write(Tree);bak(0,0)end;
       {Bomb}      21:if random(40)=0 then begin col(15,7);write(Chance)end
                      else begin col(15,7);write(Bomb)end;
       {Lava}      22:begin col(12,16);bak(4,7);write(Lava);bak(0,0)end;
       {Pit}       23:begin col(7,7);write(Pit)end;
       {Tome}      24:begin col(31,31);bak(5,0);write(Tome);bak(0,0);end;
       {Tunnel}    25:begin col(15,7);write(Tunnel)end;
       {Freeze}    26:begin col(11,7);write(Freeze)end;
       {Nugget}    27:begin col(14,7);write(Nugget)end;
       {Quake}     28:if random(15)=0 then begin col(15,7);write(Chance)end;
       {IBlock}    29:;
       {IWall}     30:;
       {IDoor}     31:;
       {Stop}      32:;
       {Zap}       34:begin col(12,7);write(Zap)end;
       {Create}    35:if not HideCreate then begin col(15,7);write(Chance)end;
       {Generator} 36:begin col(30,31);write(Generator)end;
       {MBlock}    38:if not hideMBlock then begin col(6,7);write(MBlock)end;
       {Trap2-13}  33,37,39,67,224..231:;
       {Player}    40:begin bak(7,7);col(16,16);write(Stairs);bak(0,0)end;
       {ShowGems}  41:;
       {ZBlock}    43:begin col(6,7);write(ZBlock)end;
       {BlockSpell}44:;
       {Chance}    45:begin col(15,7);write(Chance)end;
                  222:begin col(15,0);bak(6,7);write('!');bak(0,0);end;
       {Statue}    46:begin col(31,23);write(Statue)end
       {LETTERS} else begin
                       col(15,0);bak(6,7);
                       write(upcase(chr(PF[XLoop,YLoop])));bak(0,0);
                      end;
      end;
     end;
  FloorPattern:=false;  
 end; { Display_Playfield }

function GetKey:byte;
      procedure BadKeySound;
       begin
        sound(540);delay(40);
        for x:=1 to 4 do
         begin sound(100);delay(15);nosound;delay(15) end;
        nosound;
       end;
  var key:char;
 begin
  if keypressed then
   begin
    key:=readkey;
    if key=#27 then
     if keypressed then { key must be an extended character }
      begin
       key:=readkey;
       if key in [#72,#80,#77,#75,#71,#79,#73,#81] then
        GetKey:=ord(key)+100
       else begin BadKeySound;GetKey:=0;end;
      end
     else GetKey:=81
    else { key must be an alpha character }
     case ord(key) of
      40:if Difficulty=9 then
          begin PF[PX+1,PY]:=6;sound(2000);delay(40);nosound;GetKey:=0;end;
      41:if Difficulty=9 then
          begin Gems:=150;Whips:=99;Teleports:=99;Keys:=9;GetKey:=0;Update_Info;end;
      43:begin
          FoundSet:=[];
          Flash(13,25,'Newly found object desciptions are reset.');
         end; 
      45:begin
          FoundSet:=[0..255];
          Flash(10,25,'References to new objects will not be displayed.');
         end; 
      119,87:GetKey:=87;       { Whip     }
      116,84:GetKey:=84;       { Teleport }
      112,80:GetKey:=80;       { Pause    }
      113,81:GetKey:=81;       { Quit     }
      115,83:GetKey:=83;       { Save     }
      114,82:GetKey:=82;       { Restore  }
      117,85:GetKey:=171;      { U-NW     }
      105,73:GetKey:=172;      { I-North  }
      111,79:GetKey:=173;      { O-NE     }
      106,74:GetKey:=175;      { J-West   }
      107,75:GetKey:=177;      { K-East   }
      110,78:GetKey:=179;      { N-SW     }
      109,77:GetKey:=180;      { M-South  }
      44    :GetKey:=181       { ,-SE     }
      else begin BadKeySound;GetKey:=0;end;
     end;
   end
  else GetKey:=0;
 end; { GetKey }

procedure Hit(X, Y:integer;ch:char);
  var i : integer;
      Thing : char;
 begin
  Thing:=char(PF[x,y]);
  bak(0,0);
  for i:=1 to ord(FastPC)*150+ord(not FastPC)*45 do
   begin col(random(16),15);gotoxy(x,y);write(ch);end;
  gotoxy(x,y);
  case integer(Thing) of
   1..3: begin
          PF[x,y]:=0;write(' ');Score:=Score+integer(Thing);
          sound(400);delay(20);sound(90);
         end;
   4,19,20,252:
         begin
          i:=WhipPower;if integer(Thing) = 19 then i:=8;
          case integer(Thing) of
           4:Thing:=Block; 19:Thing:=Forest; 20,252:Thing:=Tree;
          end;
          if random(7) < i then
           begin write(' ');PF[x,y]:=0;
            for i:=ord(FastPC)*5700+ord(not FastPC)*3300 downto 20 do sound(random(i));sound(90);
           end
          else
           begin
            sound(130);delay(25);sound(90);
            col(6,7);
            if Thing=Tree then begin col(6,0);bak(2,7);end
            else if Thing=Forest then col(2,7);
            write(Thing);
            if Thing=Tree then bak(0,0);
           end;
         end;
   6:    begin col(16,16);bak(7,7);write(Stairs);bak(0,0);end;
   10,15,16,18,36,48..51:
         begin
          PF[x,y]:=Null;write(' ');
          sound(400);delay(20);sound(90);
          if integer(Thing) = 36 then
           begin
             for i:=ord(FastPC)*5700+ord(not FastPC)*3300 downto 20 do
              sound(random(i));sound(90);
             AddScore(36);GenNum:=GenNum-1;
           end;
         end;
       5:begin col(15,7);write(Whip)end;
       7:begin col(14,7);bak(4,0);write(Chest);bak(0,0) end;
       8:begin col(11,7);write(SlowTime)end;
       9:begin col(GemColor,7);write(Gem)end;
      11:begin col(13,7);write(Teleport)end;
      12:begin col(12,15);write(Key)end;
      13:begin col(3,0);bak(5,7);write(Door);bak(0,0)end;
      14,52,53:begin col(6,7);write(Wall)end;
      54:begin col(7,7);write(Wall)end;
      17:begin col(9,0);bak(1,7);write(River);bak(0,0)end;
      21:begin col(15,7);write(Bomb)end;
      22:begin col(12,16);bak(4,7);write(Lava);bak(0,0)end;
      23:begin col(7,7);write(Pit)end;
      24:begin col(31,31);bak(5,0);write(Tome);bak(0,0);end;
      25:begin col(15,7);write(Tunnel)end;
      26:begin col(11,7);write(Freeze)end;
      27:begin col(14,7);write(Nugget);end;
      28..31,33,37,39,41,44,67,224..231:begin col(0,0);bak(0,0);write(' ')end;
      32:begin PF[x,y]:=Null;write(' ')end;
      34:begin col(12,7);write(Zap)end;
      35:begin col(14,7);write(Create)end;
      45:begin col(15,7);write(Chance)end;
      58..60:begin col(11,7);write(OSpell1)end;
      66:begin col(12,0);bak(4,7);write(EWall);bak(0,0)end;
      47,55..57,61..63,68..74:write(' ');
      76..80:begin col(7,7);write(DropRope)end;
      75:begin col(7,7);write(Rope)end;
      81:begin col(31,31);write(Amulet)end;
      82:begin col(7,7);write(ShootRight)end;
      83:begin col(7,7);write(ShootLeft)end;
      38,43,64:begin
          if random(7) < WhipPower then
           begin write(' ');PF[x,y]:=Null;
            for i:=ord(FastPC)*5700+ord(not FastPC)*3300 downto 20 do
             sound(random(i));sound(90);
            AddScore(38);
           end
          else
           begin
            sound(130);delay(25);sound(90);
            if integer(Thing) = 64 then col(7,7) else col(6,7);
            write(Block);
           end;
         end;
      0:write(' ')
   else begin
         col(15,0);bak(6,7);
         write(upcase(chr(PF[x,y])));bak(0,0);
        end;
  end;
 end; { Hit }

procedure Secret_Message;
 begin
 end; { Secret_Message }

procedure Shoot_Right(XWay,YWay:integer; Human:boolean);
 begin
 end; {Shoot_Right}

procedure Shoot_Left(XWay,YWay:integer; Human:boolean);
 begin
 end; {Shoot_Left}

procedure Tome_Message;
 begin
  Flash(6,25,' You reach out to grab the object of your long quest... ');
  Flash(19,25,' the Magical Staff of Kroz. ');
  Flash(7,25,' Your body surges with electricity as you clutch it! ');
 end; { Tome_Message }

procedure Tome_Effects;
 begin
  bak(0,0);
  for b:=14 downto 0 do
   for x := XBot to XTop do
    for y := YBot to YTop do
     if PF[x,y] = Null then
      begin
       sound(x*y*(b+1));
       gotoxy(x,y);
       col(b*2,ord(odd(b))*7+ord(not odd(b))*0);
       write(Wall);
      end; nosound; 
 end; { Tome_Effects }


BEGIN
END.