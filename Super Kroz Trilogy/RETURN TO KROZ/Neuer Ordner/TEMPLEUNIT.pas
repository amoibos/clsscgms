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
{*** TEMPLE OF KROZ levels are defined here.  By Scott Miller 08/31/89 ***}

unit TempleUnit;

interface 

const Bottom   = 20;  {1472 objects max. / play field }
      XBot     = 2;
      XTop     = 65;
      YBot     = 2;
      YTop     = 24;
      Null     = 0;
      YSize    = 23;
      XSize    = 64;
      TMax     = 9;


type  Field    = string[192];
      StrXSize = string[XSize];

var   DF       : array [1..Bottom] of Field;
      PF       : array [1..66,1..25] of byte;
      FP       : array [1..YSize] of StrXSize;
      BX, BY   : array [1..1300] of byte;
      SX, SY,
      MX, MY,
      FX, FY   : array [1..1000] of byte;
      T        : array [1..TMax] of integer; { 1=Slow, 2=Medium, 3=Fast }
      ch,                                    { 4=SlowTime, 5=invisible  }
      Slow,                                  { 6=SpeedTime, 7=Freeze    }
      Medium,                                { 8=MBlock, 9=Statue       }
      Fast     : char; 
      x,y,i,                                 
      PX, PY,                                
      GenNum,
      BNum,
      SNum,
      MNum,
      FNum,
      LavaRate,     { 10=slow, 90=fast }
      GemColor,
      ArtColor : integer;
      FastPC,
      LavaFlow,
      HideOpenWall,
      HideCreate,
      Color    : boolean;

procedure ClearKeys;
procedure Cur(Num:byte);
procedure Sign_Off;
procedure Col(Num1,Num2:byte);
procedure Bak(Num1,Num2:byte);
procedure Bor(Num:byte);
procedure Shareware(Wait: boolean);
procedure New_Gem_Color;
procedure Level1;
procedure Level3;
procedure Level5;
procedure Level7;
procedure Level9;
procedure Level11;
procedure Level13;
procedure Level15;
procedure Level17;
procedure Level19;
procedure Level20;
procedure Define_Levels;
procedure FootStep;
procedure GrabSound;
procedure NoneSound;
procedure BlockSound;
procedure Static;

implementation { ---------------------------------------------------------- }

uses CRT, DOS;

procedure ClearKeys;
 begin
  while keypressed do ch:=readkey;
 end;

procedure Cur(Num:byte);
 var Result : Registers;
 begin
  Result.AX := $100;
  with Result do
   if Color then
    case Num of
     1:CX:=$707;   { Underline   }
     2:CX:=$8;     { Solid Block }
     3:CX:=$2000;  { Invisible   }
    end
   else
    case Num of
     1:CX:=$C0D;
     2:CX:=$E;
     3:CX:=$2000;
    end;
   intr($10,Result);
 end; { Cur }

procedure FootStep;
  var x:integer;
 begin
  for x:=1 to ord(FastPC)*50+ord(not FastPC)*23 do sound(random(550)+350);
  nosound;delay(120);
  for x:=1 to ord(FastPC)*60+ord(not FastPC)*30 do sound(random(50)+150);
  nosound;
 end;

procedure GrabSound;
  var x:integer;
 begin
  for x:=1 to ord(FastPC)*160+ord(not FastPC)*65 do
   sound(random(1000)+1000);nosound
 end;

procedure BlockSound;
  var x:integer;
 begin
  for x:= 60 downto 30 do begin sound(x);delay(1+ord(FastPC)*2);end;
  nosound;
 end;

procedure NoneSound;
  var x:integer;
 begin
  for x:=1 to 5 do
   begin
    sound(400);delay(10);nosound;delay(10);
    sound(700);delay(10);nosound;delay(10);
   end;
 end;

procedure Static;
  var x,y:integer;
 begin for x:= 1 to 15 do bor(random(16));bor(4);
  for x:=1 to 33 do
   case random(2) of
    0:for y:=1 to random(60)+10 do sound(random(4000)+3000);
    1:begin nosound;delay(random(30)); end;
   end; nosound;
 end; { Static }

procedure Col(Num1,Num2:byte);
 begin if Color then textcolor(Num1) else textcolor(Num2) end;

procedure Bak(Num1,Num2:byte);
 begin if Color then textbackground(Num1) else textbackground(Num2) end;

procedure Bor(Num:byte);
 var Result : Registers;
 begin
  if Color then
    begin
      with Result do begin AX:=$B00;BX:=Num; end;
      intr($10,Result);
    end;
 end;

procedure Sign_Off;
 begin
  Shareware(false);
  ClearKeys;
  col(7,7);
  bor(0);
  bak(0,0);
  clrscr;
  gotoxy(33,1);write('TEMPLE OF KROZ');
  gotoxy(26,2);writeln('An Apogee Software Production');
  writeln;
  writeln('Other new games available from Scott Miller:');
  writeln;
  writeln('* SUPERNOVA - An epic adventure, with 16 colors, graphics and sound effects.');
  writeln('     Understands full-sentence input.  Game takes up an entire disk!  ($10)');
  writeln;
  writeln('* BEYOND THE TITANIC - A fantastic adventure of exploration and survival.');
  writeln('     What really happened?  Sound effects and 16 color screens.  ($8)');
  writeln;
  writeln('* TREK TRIVIA - VOLUMES 1 through 10 -  Each volume has 100 Star Trek trivia');
  writeln('     questions, and is played like a game.  16-colors and sound effects, too.');
  writeln('     $4 per volume (plus $2 per order for postage and disks), order all 10');
  writeln('     volumes and pay only $30, a $12 savings!');
  writeln;
  writeln('* Five more Kroz games!  KINGDOM OF KROZ, CAVERNS OF KROZ, DUNGEONS OF KROZ,');
  writeln('     RETURN TO KROZ and THE LAST CRUSADE OF KROZ.  Each $7.50, or order all');
  writeln('     six for $35!  This is the most popular game series in shareware.');
  writeln;
  writeln('* ADVENTURE FUN-PAK and PUZZLE FUN-PAK - Each contain four unique graphics-');
  writeln('     based games not available anywhere else.  ($10 each)');
  cur(1);
  ClearKeys;
  HALT;
 end; { Sign_Off }

procedure Shareware(Wait: boolean);
 begin
  bak(1,0);bor(1);clrscr;cur(3);col(15,15);
  gotoxy(24,1);
  writeln('TEMPLE OF KROZ � HOW TO REGISTER');
  gotoxy(1,2);
  for x:=1 to 80 do write('�');
  gotoxy(1,3);
  col(7,7);
  writeln('  This is Volume II of the Super Kroz Trilogy.  Temple of Kroz is a shareware');
  writeln('game, which means it is user supported.  If you enjoy this game you are asked');
  writeln('by the author to please send an appreciation check of $7.50 to Apogee Software.');
  writeln('This minimal amount will help compensate the many months of work that went into');
  writeln('the creation of this game.');
  writeln('  Also, this registration fee will allow you to order the two shareware');
  write  ('sequels:  ');col(15,9);
  write  ('Return of Kroz');col(7,7);
  write  (' (Volume I) and ');col(15,9);
  write  ('The Last Crusade of Kroz');col(7,7);
  writeln(' (Volume III).');
  writeln('Each sequel can be ordered for $7.50 each, or all three for $20.  Registered');
  writeln('players will also get a secret code that makes this game easier to complete,');
  writeln('plus a "Hints, Tricks and Scoring Secrets" guide and "The Domain of Kroz" map.');
  writeln('  The three original Kroz games are also available and have been updated with');
  write  ('improved features.  All three of the original Kroz games (');col(15,9);
  write  ('Kingdom of Kroz');col(7,7);
  writeln(',');col(15,9);
  write  ('Caverns of Kroz');col(7,7);
  write  (', ');col(15,9);
  write  ('Dungeons of Kroz');col(7,7);
  writeln(') are $7.50 each or $15 for all three. Kingdom');
  writeln('of Kroz recently won "Best Game" in a national contest.  These first three');
  writeln('Kroz games feature 95 new levels to explore.');
  writeln;
  write('Please make checks payable to:');
  col(14,7);
  writeln('   Apogee Software    (phone: 214/240-0614)');gotoxy(31,20);
  writeln('   4206 Mayflower');gotoxy(31,21);
  writeln('   Garland, TX 75043');
  writeln;
  col(7,7);
  writeln('Thank you and enjoy the game.  -- Scott Miller (author)');
  if Wait then delay(0);
  bak(random(6)+1,7);
  gotoxy(1,25);
  insline;
  gotoxy(27,25);
  col(16,16);
  write('Press any key to continue.');
  ClearKeys;
  repeat x:=random(maxint) until keypressed;
  ClearKeys;
  bak(0,0);bor(4);clrscr;cur(3);
 end; { Shareware }

procedure New_Gem_Color;
 begin
  repeat
   GemColor:=random(15)+1;
   if not Color then GemColor := 7;
  until GemColor <> 8;
  repeat
   ArtColor:=random(15)+1;
  until (ArtColor<>8) and (ArtColor<>GemColor);
  if not Color then ArtColor := 7;
 end;

procedure Define_Levels;
 begin
{ Levels 1,3,5,7,9,11,13,15,17,19,20 are pre-defined }

DF[2]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
' 20          60  2       60  4                       1640570  4                10                    2               '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'     1  1                 1  1  1  1                                       ';

DF[4]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'   333       40  2       40     2                                              20                                    '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'     1                                                                  700';

DF[6]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'             40  1                            14                                    760                              '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'                      10  1  1  1  1                                       ';

DF[8]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'600          20  1     5 20     5                                              20  5                           700   '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'                                                                           ';

DF[10]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
' 50          25  2       30     2                    1         130             80  1         200200        1         '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'     4                    1  1  1  1                                       ';

DF[12]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'              5  2        5                  999                               15  1                       5         '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'     1                    1  1  1  1      425                              ';

DF[14]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'         535 25  1  1    20                                   2                10  1                   18  3   100   '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'                    1  1  1  1  1  1                                    650';

DF[16]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'   100        5  1  1      100  2            400                  400    10  5 30  1                                 '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'     3              1     1  1  1  1                                       ';

DF[18]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'333333333    40  1    10  40    5                            30           5  5 40  9                       2         '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y}
'     5                                                                     ';

 end; { Define_Levels }

procedure Convert_Format;
  var XLoop,
      YLoop  : integer;
      tempstr: string[1];
 begin
  SNum:=Null; MNum:=Null; FNum:=Null; BNum:=Null; GenNum:=Null;
  T[9]:=-1; LavaFlow:=false;
  for x:=1 to 66 do for y:=1 to 25 do PF[x,y]:=0;
  for x:=1 to 999 do
   begin                        {* reset monster's X, Y *}
    BX[x]:=0;BY[x]:=0;
    SX[x]:=0;SY[x]:=0;
    MX[x]:=0;MY[x]:=0;
    FX[x]:=0;FY[x]:=0;
   end;
  New_Gem_Color;
  for YLoop:=1 to YSize do
   for XLoop:=1 to XSize do
    begin
    tempstr := copy(FP[YLoop], XLoop, 1);
    case char(tempstr[1]) of
     ' ':PF[XLoop+1,YLoop+1]:=Null;
     '1':begin
          SNum:=SNum+1;SX[SNum]:=XLoop+1;SY[SNum]:=YLoop+1;
          PF[XLoop+1,YLoop+1]:=1;
         end;
     '2':begin
          MNum:=MNum+1;MX[MNum]:=XLoop+1;MY[MNum]:=YLoop+1;
          PF[XLoop+1,YLoop+1]:=2;
         end;
     '3':begin
          FNum:=FNum+1;FX[FNum]:=XLoop+1;FY[FNum]:=YLoop+1;
          PF[XLoop+1,YLoop+1]:=3;
         end;
     'X':PF[XLoop+1,YLoop+1]:=4;
     'W':PF[XLoop+1,YLoop+1]:=5;
     'L':PF[XLoop+1,YLoop+1]:=6;
     'C':PF[XLoop+1,YLoop+1]:=7;
     'S':PF[XLoop+1,YLoop+1]:=8;
     '+':PF[XLoop+1,YLoop+1]:=9;
     'I':PF[XLoop+1,YLoop+1]:=10;
     'T':PF[XLoop+1,YLoop+1]:=11;
     'K':PF[XLoop+1,YLoop+1]:=12;
     'D':PF[XLoop+1,YLoop+1]:=13;
     '#':PF[XLoop+1,YLoop+1]:=14;
     'F':PF[XLoop+1,YLoop+1]:=15;
     '.':PF[XLoop+1,YLoop+1]:=16;
     'R':PF[XLoop+1,YLoop+1]:=17;
     'Q':PF[XLoop+1,YLoop+1]:=18;
     '/':PF[XLoop+1,YLoop+1]:=19;
     '\':PF[XLoop+1,YLoop+1]:=20;
     'B':PF[XLoop+1,YLoop+1]:=21;
     'V':PF[XLoop+1,YLoop+1]:=22;
     '=':PF[XLoop+1,YLoop+1]:=23;
     'A':PF[XLoop+1,YLoop+1]:=24;
     'U':PF[XLoop+1,YLoop+1]:=25;
     'Z':PF[XLoop+1,YLoop+1]:=26;
     '*':PF[XLoop+1,YLoop+1]:=27;
     'E':PF[XLoop+1,YLoop+1]:=28;
     ';':PF[XLoop+1,YLoop+1]:=29;
     ':':PF[XLoop+1,YLoop+1]:=30;
     '`':PF[XLoop+1,YLoop+1]:=31;
     '-':PF[XLoop+1,YLoop+1]:=32;
     '@':PF[XLoop+1,YLoop+1]:=33;
     '%':PF[XLoop+1,YLoop+1]:=34;
     ']':PF[XLoop+1,YLoop+1]:=35;
     'G':begin PF[XLoop+1,YLoop+1]:=36;GenNum:=GenNum+1;end;
     '(':PF[XLoop+1,YLoop+1]:=37;
     'M':begin
          BNum:=BNum+1;BX[BNum]:=XLoop+1;BY[BNum]:=YLoop+1;
          PF[XLoop+1,YLoop+1]:=38;
         end;
     ')':PF[XLoop+1,YLoop+1]:=39;
     'P':begin PF[XLoop+1,YLoop+1]:=40;PX:=XLoop+1;PY:=YLoop+1;end;
     '&':PF[XLoop+1,YLoop+1]:=41;
     '!':PF[XLoop+1,YLoop+1]:=42;
     'O':PF[XLoop+1,YLoop+1]:=43;
     'H':PF[XLoop+1,YLoop+1]:=44;
     '?':PF[XLoop+1,YLoop+1]:=45;
     '>':begin PF[XLoop+1,YLoop+1]:=46;T[9]:=32000;end; 
     'N':PF[XLoop+1,YLoop+1]:=47;
     '<':PF[XLoop+1,YLoop+1]:=48;
     '[':PF[XLoop+1,YLoop+1]:=49;
     '|':PF[XLoop+1,YLoop+1]:=50;
     '"':PF[XLoop+1,YLoop+1]:=51;
     '4':PF[XLoop+1,YLoop+1]:=52;
     '5':PF[XLoop+1,YLoop+1]:=53;
     '6':PF[XLoop+1,YLoop+1]:=54;
     '7':PF[XLoop+1,YLoop+1]:=55;
     '8':PF[XLoop+1,YLoop+1]:=56;
     '9':PF[XLoop+1,YLoop+1]:=57;
     '�':PF[XLoop+1,YLoop+1]:=58;
     '�':PF[XLoop+1,YLoop+1]:=59;
     '�':PF[XLoop+1,YLoop+1]:=60;
     '�':PF[XLoop+1,YLoop+1]:=61;
     '�':PF[XLoop+1,YLoop+1]:=62;
     '�':PF[XLoop+1,YLoop+1]:=63;
     'Y':PF[XLoop+1,YLoop+1]:=64
     else
      begin
       tempstr := copy(FP[YLoop], XLoop, 1);
       PF[XLoop+1,YLoop+1]:=ord(char(tempstr[1]));
      end;
    end;
    end;
 end; { Convert_Format }

procedure Level1;
 begin
  FP[1]:= '+ + + + �               #temple#of#kroz#   1      XX ]-5--****-%';
  FP[2]:= ' + + + +#]   ]        1 #######by#######          XX  ]5--*TT*--';
  FP[3]:= '+ + + +%#  1        XX  ##scott#miller##         1    -5--****--';
  FP[4]:= '#########           XX                                -555555555';
  FP[5]:= '&;                             XX    1                ]-------]-';
  FP[6]:= ';;            XX    1          XX          XX    ]        ]   1 ';
  FP[7]:= '    XX    1   XX    ]        ]             XX        1   XX     ';
  FP[8]:= '    XX                             XX  ]                 XX     ';
  FP[9]:= ']           ]         ]            XX      1                   ]';
  FP[10]:='      1                        ]                    ]        1  ';
  FP[11]:='           XX                !     *            XX              ';
  FP[12]:='           XX        XX         P     ]         XX              ';
  FP[13]:='XX     ]         ]   XX      T     S                           1';
  FP[14]:='XX  1                                       ]          XX   ]   ';
  FP[15]:='             1            ]             XX       1     XX     XX';
  FP[16]:=']]]]]]]]]]                    XX        XX                    XX';
  FP[17]:='XXXXXXXXX]  ]     XX          XX   ]                ]   1       ';
  FP[18]:='XXXXXXXXX]        XX              1                        ]   1';
  FP[19]:='XXXXXXXXX]             1                     1       ]----------';
  FP[20]:='XXXXXXXXX]    1          XX   ]                   XX  -444444444';
  FP[21]:='XXXXXXXXX]  XX           XX              ]        XX ]-4W�W�W�W�';
  FP[22]:=']]XXXXXXX]  XX ]           ]    XX   1                -4�W�W�W�W';
  FP[23]:='L&XXXXXXX]    1     1           XX               1   ]-4W�W�W�W%';
  Slow:=#142;{or #154} Medium:=#153;{or #148} Fast:=#234;{or #1}
  Convert_Format;
  HideCreate := true; HideOpenWall:=true;
 end; { Level1 }

procedure Level3;
 begin
  FP[1]:= 'YYY11111111111111111111111166..LL..66111111111111111111111111YYY';
  FP[2]:= 'Y66(((((((((((((((((((((((((66....66@@@@@@@@@@@@@@@@@@@@@@@@@66Y';
  FP[3]:= '|66 +    WWW    %     T    (K66DD66K@    T     %    WWW    + 66"';
  FP[4]:= '666--66666666666666666666666666DD66666666666666666666666666--666';
  FP[5]:= '2222222222222222222222222222222222222222222222222222222222222222';
  FP[6]:= '2222222222222222222222222222222222222222222222222222222222222222';
  FP[7]:= '))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))';
  FP[8]:= 'WW                              P                             ++';
  FP[9]:= 'WW                                                            ++';
  FP[10]:='YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY';
  FP[11]:='))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))';
  FP[12]:='66W666666666666W666666666666666W666666666666W66666666666W6666666';
  FP[13]:='666 66666 666666  6666666 Q66  6 66  !6661  66666666  [66  66666';
  FP[14]:='66 6  66 6 6666666 6616  666 666 6 666666 66 666666 6666 66 6666';
  FP[15]:='6 6666 1666 <666  6  6 666  6666616666TT 6666 6666661   666 6666';
  FP[16]:='66W666666666666W666666666W666666666666666666W666666666666666W666';
  FP[17]:='                                                                ';
  FP[18]:='))))))))))))))))))))))))))))))WWWW))))))))))))))))))))))))))))))';
  FP[19]:=')2)))))))2)))))))2)))))))2))))WWWW))))2)))))))2)))))))2)))))))2)';
  FP[20]:='----------------------------------------------------------------';
  FP[21]:='1111111111111111111111111111111111111111111111111111111111111111';
  FP[22]:='                                                                ';
  FP[23]:='TTF+  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +FTT';
  Slow:=#154; Medium:=#148; Fast:=#234;
  Convert_Format;
 end; { Level3 }

procedure Level5;
 begin
  FP[1]:= '---###########RRRRR##W        ############W////1/C//\//\\\\\\\\\';
  FP[2]:= '-U---------Z###RRRRR##7######   ##KK�   Z##-//////\///1/\\\\\\U\';
  FP[3]:= '---###########RRRRR##7####### P ######## ###-////////\///\\1\\\\';
  FP[4]:= '@#############RRRRR#7####                ####-///\/////////\\\\\';
  FP[5]:= '@2#------.###RRRRR##7#W3; ############## #####-////1//\//1///\\\';
  FP[6]:= '@##;-;###.##RRRRR##7##W3; #WWWWWWWWWWW## #2####--//////////\///\';
  FP[7]:= '@2#-;;##..##RRRRR##7##W3; ######-####### ##2#####-/////\/////1//';
  FP[8]:= '@##;-;##..-##RRRRR##7#### #11111111111## ###2##2##-/////1/////\/';
  FP[9]:= '@2#;;-##..#D##RRRRR##7##T #11111111111## #2##2##2##--///////\///';
  FP[10]:='@##;;;##..#D###RRRRR##7####11111111111## ##2##2##2###---///////1';
  FP[11]:='@2#-;;##..#KK###RRRRR##7###11111111111## ###)##)##)#####--////\/';
  FP[12]:='@##-;;##..#KK##RRRRRRR#7###11111B11111----)))))))))))#####---///';
  FP[13]:='@2#;;;##22####RRRR#RRR##7##11111111111##############)########--/';
  FP[14]:='@##;;-##22###RRRR###RRR##7#11111111111#?#!#---#*YYYY-63333####D#';
  FP[15]:='@2#;-;##22##RRRR##L##RRR#7#11111111111#O#�#-#-#*YYYY-63333---#D#';
  FP[16]:='@##;;;##22#RRRR##DD##RRR#7#11111111111#O#-#-#-#*YYYY-63333-#-#-#';
  FP[17]:='@2#;-;##-##RRRR#DDD#RRR##7###########-#O#-#-#-#*YYYY-63333-#-#-#';
  FP[18]:='@##;;-##C#RRRR##DDD##RRR##7###+++++##-#O#-#-#-#*YYYY-63333-#-#-#';
  FP[19]:='@2#;;;##H##RRRR#DDDD##RRR##7##+++++##-#O#-#-#-#*YYYY-63333-#-#-#';
  FP[20]:='@##;-;####RRRR##44444##RRR##7###.####-#O#-#-#-#*YYYY-63333-#-#-#';
  FP[21]:='@2#-;;###RRRR##�������##RRR#7###.#K-#-#O#-#-#-#*YYYY-63333-#-#-#';
  FP[22]:='@###-###RRRR##X--------#RRR##�##.#--#-#-#---#-######-#####-#---#';
  FP[23]:='-----##RRRR##%X---U----##RRR#K##--------#111#--------------#111#';
  Slow:=#142; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideOpenWall:=true;
 end; { Level5 }

procedure Level7;
 begin
  FP[1]:= 'K@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@K';
  FP[2]:= '@@111111111111111111111111111111111111111111111111111111111111@@';
  FP[3]:= '@@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1@@';
  FP[4]:= '@@1@@222222222222222222222222222222222222222222222222222222@@1@@';
  FP[5]:= '@@1@@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2@@1@@';
  FP[6]:= '@@1@@2@@333333333333333333333333333333333333333333333333@@2@@1@@';
  FP[7]:= '@@1@@2@@366666666666666666666666666666666666666666666663@@2@@1@@';
  FP[8]:= '@@1@@2@@36L*   3                !           3       *L63@@2@@1@@';
  FP[9]:= '@@1@@2@@36**         3                            3 **63@@2@@1@@';
  FP[10]:='@@1@@2@@36                                            63@@2@@1@@';
  FP[11]:='@@1@@2@@364444444444444444444443334444444444444444444463@@2@@1@@';
  FP[12]:='<@1@@2@@36CC                   3P3                  �K63@@2@@1@[';
  FP[13]:='@@1@@2@@364444444444444444444443334444444444444444444463@@2@@1@@';
  FP[14]:='@@1@@2@@36                                       3    63@@2@@1@@';
  FP[15]:='@@1@@2@@36**            3                           **63@@2@@1@@';
  FP[16]:='@@1@@2@@36L*  3               ����     3            *L63@@2@@1@@';
  FP[17]:='@@1@@2@@36666666666666666666666DD66666666666666666666663@@2@@1@@';
  FP[18]:='@@1@@2@@333333333333333333333333333333333333333333333333@@2@@1@@';
  FP[19]:='@@1@@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2@@1@@';
  FP[20]:='@@1@@222222222222222222222222222222222222222222222222222222@@1@@';
  FP[21]:='@@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1@@';
  FP[22]:='@@111111111111111111111111111111111111111111111111111111111111@@';
  FP[23]:='K@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@K';
  Slow:=#254; Medium:=#240; Fast:=#9;
  Convert_Format;
  T[1]:=580;T[2]:=400;T[3]:=15;HideOpenWall:=true;
 end; { Level7 }

procedure Level9;
 begin
  FP[1]:= 'LL66?66�whip�it�out������������!WWWWWWWWWWWWWWWWWWW]��������� P ';
  FP[2]:= '&]66�66������������������������������������������������������   ';
  FP[3]:= '6D66]66���������������������������������������������������������';
  FP[4]:= 'D666766���������������������������������������������������������';
  FP[5]:= '6D66766��������U�����������������������-U������������������**���';
  FP[6]:= 'D666766��������-�������������������������������������������**���';
  FP[7]:= '2222266���������������������������������������������������������';
  FP[8]:= '2222266���������������������������������������������������������';
  FP[9]:= '(((((66��K������������������**����������������������������������';
  FP[10]:='+++++66���������������������**���������Q�����������U-�����������';
  FP[11]:='((G((66���������������������������������������������������������';
  FP[12]:='(((((66������������������������������������������������������K��';
  FP[13]:='(((((66���������������������������������������������������������';
  FP[14]:='(((((66�**�������������������������������K����������������������';
  FP[15]:='EEEEE66�**����������������������������������������������������sm';
  FP[16]:='2222266������������������-U����������������������������������was';
  FP[17]:='2222266����������K������������������������������������������here';
  FP[18]:=')))))66���������������������������������������������������������';
  FP[19]:='+++++66������������������������������������-��������������������';
  FP[20]:=')))))66������������������������������������U�������������**�����';
  FP[21]:=')))))66��������������������������������������������������**�����';
  FP[22]:='EEEEE66���������������������������������������������������������';
  FP[23]:='-----]-����������������������������WWWWW������������������������';
  Slow:=#154; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideCreate:=true;
 end; { Level9 }

procedure Level11; 
 begin
  FP[1]:= '|��            1               �                  1          ��[';
  FP[2]:= '��=========(              1    �      1             @=========��';
  FP[3]:= '  ========2(   #####           �           #####    @2========  ';
  FP[4]:= '  =======2((  ##C##    66666666666666666    ##!##   @@2=======  ';
  FP[5]:= '  ======2((  ##9##    6611111111111111166    ##�##   @@2======  ';
  FP[6]:= '  =====2((  ##9##    661111111111111111166    ##9## 1 @@2=====  ';
  FP[7]:= '  ====2((  ##9##    66111VVVVVVVVVVVVV11166    ##9##   @@2====  ';
  FP[8]:= '  ===2((1 ##9##    6611VVVVV+++++++VVVVV1166    ##9##   @@2===  ';
  FP[9]:= '  ==2((  ##9##    6611VVV++++RRRRR++++VVV1166    ##9##   @@2==  ';
  FP[10]:='  =(((  ##9##   -6611VVV++RRRRRRRRRRR++VVV1166-   ##9##   @@@=  ';
  FP[11]:='       ##9##   -66--VVV++RRRT III *RRR++VVV--66-   ##9##     1  ';
  FP[12]:='� 1   44444   -66K-VVV++RRR1  IPI  1RRR++VVV-K66-   44444      �';
  FP[13]:='       ##]##   -66--VVV++RRR* III TRRR++VVV--66-   ##9##        ';
  FP[14]:='  =���  ##]##   -6611VVV++RRRRRRRRRRR++VVV1166-   ##9##   ���=  ';
  FP[15]:='  ==2��  ##]##    6611VVV++++RRRRR++++VVV1166   1##9##  1��2==  ';
  FP[16]:='  ===2��  ##&##1   6611VVVVV+++++++VVVVV1166    ##9##   ��2===  ';
  FP[17]:='  ====2��  ##&##    66111VVVVVVVVVVVVV11166    ##9##   ��2====  ';
  FP[18]:='  =====2��  ##D##    661111111111111111166    ##9##   ��2=====  ';
  FP[19]:='  ======2��  ##D##    6611111111111111166    ##9##   ��2======  ';
  FP[20]:='  =======2��  ##L##    66666666666666666    ##G##   ��2=======  ';
  FP[21]:='  ========2�   #####           �           #####    �2========  ';
  FP[22]:='@@=========�                   �                    �=========((';
  FP[23]:='<@@          1           1     �     1          1            (("';
  Slow:=#143; Medium:=#148; Fast:=#234;
  Convert_Format;
  LavaFlow:=true; LavaRate:=30; HideCreate:=true;
 end; { Level11 }

procedure Level13;
 begin
  FP[1]:= '!                    @]]]@                               7�K� �3';
  FP[2]:= '       ]             @]K]@                               7��� �3';
  FP[3]:= '           VVV       @]]]@                               7    �3';
  FP[4]:= '            VVV      @@@@@                  ]            7    �3';
  FP[5]:= '))##         V             +VV+    +V+          VVV      7    �3';
  FP[6]:= '  ##                    +VVVVVVV++VVVV+         &VVV     7    �3';
  FP[7]:= '  ##                 +VVVVVVVVVVVVVVV+          VVV      7    �3';
  FP[8]:= '  ##             +VVVVVVVVVVVVVVVVVVVV+                  7    �3';
  FP[9]:= '  ##               +VVVVVVVVVVVVVVVVVVVVV+               7    �3';
  FP[10]:='))##                  +VVVVVVVVVVVVVVVV+                 7    �3';
  FP[11]:='MM##                 +VVVVVVVGVVVVVVV+                   7    �3';
  FP[12]:='))##         ]     +VVVVVVVV++VVVVVV+            ]       7    �3';
  FP[13]:='MM##                +V++VVV+   +VV+                      7    �3';
  FP[14]:='))##                                                     7    �3';
  FP[15]:='MM##                                                     7    �3';
  FP[16]:='))##                         ]                 VVVV      7    �3';
  FP[17]:='  ##     VV                                   VVVV       7    �3';
  FP[18]:='  ##    VVVV                                    VVV      7    �3';
  FP[19]:='  ##]]]  VV                                              7    �3';
  FP[20]:='@@##]K]########@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    7    �3';
  FP[21]:='++##]]]#I.]&&&#3333333333333333333333333333333333333@      P  �3';
  FP[22]:='44######-#################################################&   �3';
  FP[23]:='CC?LL�DD]DDDDD`            T                  Z               �3';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  LavaFlow := true; LavaRate:=105; HideCreate:=true;
 end; { Level13 }

procedure Level15;
 begin
  FP[1]:= 'U1111111111-K<66ZZ66U-DDDD-!-B-]-N-&-F�LLCCC66ZZ66[C-1111111111U';
  FP[2]:= '1111111111666666  ##--########################  6666661111111111';
  FP[3]:= '11111111666       ######      ##U##                  66611111111';
  FP[4]:= '111111666                                              666111111';
  FP[5]:= '1111666     +                                      W     6661111';
  FP[6]:= '11666      +++       @@@@@@@@@@@@@@@@@@@@@@       WWW      66611';
  FP[7]:= '666         +       @@33333333333333333333@@       W         666';
  FP[8]:= '33DDDD              @3333333333333333333333@              DDDD33';
  FP[9]:= '33DDBD              @33333333333G3333333333@              DBDD33';
  FP[10]:='33DDDD5555          @3333333333333333333333@          4444DDDD33';
  FP[11]:='33DD     5          @3333333333333333333333@          4     DD33';
  FP[12]:='33DDK B  5       H  @@33333333333333333333@@  H       4  B KDD33';
  FP[13]:='33DD     5       H   @@@@@@@@@@@@@@@@@@@@@@   H       4     DD33';
  FP[14]:='33DDDD5555       H       H            H       H       4444DDDD33';
  FP[15]:='33DDBD           HHHH           P          HHHH           DBDD33';
  FP[16]:='33DDDD                       HHHHHHH                      DDDD33';
  FP[17]:='666                                                          666';
  FP[18]:='11666       T                                      T       66611';
  FP[19]:='1111666                                                  6661111';
  FP[20]:='111111666         #############OO#############         666111111';
  FP[21]:='11111111666       ##111111111##OO##111111111##       66611111111';
  FP[22]:='1111111111666666**##444444444##@@##555555555##**6666661111111111';
  FP[23]:='U1111111111-C|66**##�@@@@@@@@@@@@@@@@@@@@@@�##**66"K-1111111111U';
  Slow:=#142; Medium:=#148; Fast:=#234;
  Convert_Format;
 end; { Level15 }

procedure Level17;
 begin
  FP[1]:= 'LLDDEEDD]##<;      ]##[;      ]##]      ;|##]      ;"##        �';
  FP[2]:= '########-##########-##########-##-##########-##########-########';
  FP[3]:= 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM++++MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[4]:= 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[5]:= 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[6]:= 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[7]:= 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[8]:= 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[9]:= '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
  FP[10]:='                                                                ';
  FP[11]:='                                                                ';
  FP[12]:='6666666666666666666666666666666 P 666666666666666666666666666666';
  FP[13]:='                                                                ';
  FP[14]:='                                                                ';
  FP[15]:='@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
  FP[16]:='33333333333333333333333333333333C3333333333333333333333333333333';
  FP[17]:='3333333333333333333333333333333333333333333333333333333333333333';
  FP[18]:='3333333333333333333333333333333333333333333333333333333333333333';
  FP[19]:='3333333333333333333333333333333333333333333333333333333333333333';
  FP[20]:='3333333333333333333333333333333333333333333333333333333333333333';
  FP[21]:='333333333333333333333333333333WWWW333333333333333333333333333333';
  FP[22]:='########-##########-##########-##-##########-##########-########';
  FP[23]:='K        ##KKKDD    ##Q;-;-;-; ##     G  !##  DDDKKKK##      DKK';
  Slow:=#142; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideCreate:=true;
 end; { Level17 }

procedure Level19;
 begin 
  FP[1]:= '             HC##K44444444444444444444444444444444443MMM4444444C';
  FP[2]:= ' P ##############################################4##############';
  FP[3]:= '                              �    !3333333333333333333333333333';
  FP[4]:= '               ##################### ##T+K+T################### ';
  FP[5]:= '   OOOOOOOOOOOO##<                   #########V  V VV  V  VVTV  ';
  FP[6]:= '   OOOOOOOOOOOO########################        VVZV  VV VV  V V ';
  FP[7]:= '               WWWW turn�back WWWW      #you#will#not#succeed# U';
  FP[8]:= '################################################################';
  FP[9]:= '111111111##222222222##333333333##333333333##222222222##111111111';
  FP[10]:='111---111##222---222##333---333##333---333##222---222##111---111';
  FP[11]:='111-U-111##222-U-222##333-U-333##333-U-333##222-U-222##111-U-111';
  FP[12]:='111---111##222---222##333---333##333---333##222---222##111---111';
  FP[13]:='111-K-111##222-K-222##333-[-333##333-|-333##222-K-222##111-K-111';
  FP[14]:='################################################################';
  FP[15]:='U##&@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W##"@@@@@@@---';
  FP[16]:='-@]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W########@@##-';
  FP[17]:='@@]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W##@@@@@@@@##-';
  FP[18]:='@@]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W##D#########-';
  FP[19]:='@@]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W##&&DDDDDL##-';
  FP[20]:='@@]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W############-';
  FP[21]:='@@]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W##@@@@@@@@@@@';
  FP[22]:=']]]@@]@@]@@@]@@@]@@@@@@]@@@@@]@@@@@]@@@@@]@@@@@]+]W##@@@@@@@@@@@';
  FP[23]:='***]***]***]***]***]***]***]***]***]***]***]***]+]W-]@@@@@@@@@@@';
  Slow:=#143; Medium:=#148; Fast:=#234;
  Convert_Format;
  HideCreate:=true;
 end; { Level19 }

procedure Level20;
 begin
  FP[1]:= 'U-3K##RRRR-2-&---RRRR##B//3///#222222222222222222222222222222222';
  FP[2]:= '-####RRRRK--->-2-QRRRR#///////##66666666666666666666666666666666';
  FP[3]:= '3<3#H#RRRR-2-----RRRR##//3////--(((((((((((((((((((((((((((((###';
  FP[4]:= '-###T###RRRR666RRRR####K////3/##(((((((((((((((((K((((((((((((-C';
  FP[5]:= 'U#3W-#####RR666RR###############((((((((((((((((((((((((((((((-�';
  FP[6]:= '-### OOOOOOOOOOOOOOOOOOOOOOOOOOO(((((((((((((((((((((((((((((###';
  FP[7]:= '3[3# V##########################66666666666666666666666666666666';
  FP[8]:= '-###V*##?�777777777777777777###222222222222222222222222222222222';
  FP[9]:= 'U#3W V#####################;####################################';
  FP[10]:='-###V ###33333333333333333#;##&]&]&##K55555555M.E--------#######';
  FP[11]:='3|3#*V#@@@@@@@@@@@@@@@@@@@@K##NVVV]#######D#############-#....3�';
  FP[12]:='-###V -@@@@@@@@@@@@@@@@@@@@@##&VAV!D``D``D*]++++++++++##-D.#####';
  FP[13]:='U#3W V###MMMMMMMMMMMMMMMMMMM##NVVV]#######D#############-#.#K;;;';
  FP[14]:='-###V*########################&]&]&##K55555555M.]--------#.#;;;;';
  FP[15]:='3"3#V #=II===II=I====II=II=I=#############################.#;;;;';
  FP[16]:='-### V#I==I=I==I=I==I==I==I=I#222222222222222222222222222#.#;;;;';
  FP[17]:='U#    #I==I==I===I===I======I#)))))))))))))))))))))))))))#.#;;;;';
  FP[18]:='-# ## #=I==I==I=K==I==I==III=#-------------------K-------#.#;;;;';
  FP[19]:='3# Z# #I==I==I==I=I=I=I=I====#-##################-######)#.####I';
  FP[20]:='-# ## I====II====I===I===III-------;222222222222222222C#C#.....-';
  FP[21]:='U# �###########################################################-';
  FP[22]:='   ##2222222222222222222222222##YYYYYYYYYYYYYYYYYYYYYYYYY#-#-##-';
  FP[23]:='P   444444444444444444444444444---------------------------#-#---';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideCreate:=true;
 end; { Level20 }

begin
end. { Levels }

{
  FP[1]:= '                                                                ';
  FP[2]:= '                                                                ';
  FP[3]:= '                                                                ';
  FP[4]:= '                                                                ';
  FP[5]:= '                                                                ';
  FP[6]:= '  L                                                             ';
  FP[7]:= '                                                                ';
  FP[8]:= '                                                                ';
  FP[9]:= '                                                                ';
  FP[10]:='                                                                ';
  FP[11]:='                                                                ';
  FP[12]:='                                                                ';
  FP[13]:='                                                                ';
  FP[14]:='                                                                ';
  FP[15]:='                                                                ';
  FP[16]:='                                                                ';
  FP[17]:='                                                                ';
  FP[18]:='                                                                ';
  FP[19]:='                                                                ';
  FP[20]:='                                                                ';
  FP[21]:='                                                                ';
  FP[22]:='                                                                ';
  FP[23]:='                                                                ';
}