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
{*** CRUSADE OF KROZ levels are defined here.  By Scott Miller 08/31/89 ***}

unit CRUSADEUNIT;

interface 

const Bottom   = 25;  {1472 objects max. / play field }
      XBot     = 2;
      XTop     = 65;
      YBot     = 2;
      YTop     = 24;
      Null     = 0;
      YSize    = 23;
      XSize    = 64;
      TMax     = 9;


type  Field    = string[201];
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
      HideTrap,
      HideRock,
      HideStairs,
      HideOpenWall,
      HideCreate,
      HideMBlock,
      HideLevel,
      HideGems,
      Color    : boolean;

procedure ClearKeys;
procedure Cur(Num:byte);
procedure Sign_Off;
procedure Col(Num1,Num2:byte);
procedure Bak(Num1,Num2:byte);
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
procedure Level21;
procedure Level22;
procedure Level23;
procedure Level24;
procedure Level25;
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
begin
    case Num of
     1:cursoron;   { Underline   }
     2:cursorbig;     { Solid Block }
     3:cursoroff;  { Invisible   }
     end;
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
 begin for x:= 1 to 15 do ;;
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

procedure Sign_Off;
 begin
  Shareware(false);
  ClearKeys;
  col(7,7);
  ;
  bak(0,0);
  clrscr;
  gotoxy(28,1);write('THE FINAL CRUSADE OF KROZ');
  gotoxy(26,2);writeln('An Apogee Software Production');
  writeln;
  writeln('Other new games available from Scott Miller:');
  writeln;col(15,15);
  writeln('* THE LOST ADVENTURES OF KROZ - The latest, most advanced, largest, and');
  writeln('     most unique of all Kroz games.  75 all-new levels ($20 + $2 P&H)');
  writeln;col(7,7);
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
  writeln('     RETURN TO KROZ and TEMPLE OF KROZ.  Each $7.50, or order all six');
  writeln('     for $35!  This is the most popular game series in shareware.');
  cur(1);
  ClearKeys;
  HALT;
 end; { Sign_Off }

procedure Shareware(Wait: boolean);
 begin
  bak(1,0);;clrscr;cur(3);col(15,15);
  gotoxy(19,1);
  writeln('THE FINAL CRUSADE OF KROZ � HOW TO REGISTER');
  gotoxy(1,2);
  for x:=1 to 80 do write('�');
  gotoxy(1,3);
  col(7,7);
  writeln('  This is Volume III of the Super Kroz Trilogy.  Crusade of Kroz is a shareware');
  writeln('game, which means it is user supported.  If you enjoy this game you are asked');
  writeln('by the author to please send an appreciation check of $7.50 to Apogee Software.');
  writeln('This minimal amount will help compensate the many months of work that went into');
  writeln('the creation of this game.');
  writeln('  Also, this registration fee will allow you to order the two shareware');
  write  ('sequels:  ');col(15,9);
  write  ('Return to Kroz');col(7,7);
  write  (' (Volume I) and ');col(15,9);
  write  ('Temple of Kroz');col(7,7);
  writeln(' (Volume II).');
  writeln('Each sequel can be ordered for $7.50 each, or all three for $20.  Registered');
  writeln('players will also get a secret code that makes this game easier to complete,');
  writeln('plus a "Hints, Tricks and Scoring Secrets" guide and "The Domain of Kroz" map.');
  writeln;col(15,9);
  write('  The Lost Adventures of Kroz');
  col(11,15); writeln(' will be available by the start of 1990.  It will');
  writeln('have 75 all-new screens to explore, with new objects and a new level type.');
  writeln('This newest, largest and most feature-packed Kroz game came about as a direct');
  writeln('result of players'' comments for more Kroz games!  (Don''t say I don''t deliver!)');
  writeln('Advance orders will be accepted.  Price: $20 plus $2 postage, disk & handling.');
  writeln;col(7,7);
  write('Please make checks payable to:');
  col(14,7);
  writeln('   Apogee Software    (phone: 214/240-0614)');gotoxy(31,21);
  writeln('   4206 Mayflower');gotoxy(31,22);
  writeln('   Garland, TX 75043');
  writeln;
  col(7,7);
  write('Thank you and enjoy the game.  -- Scott Miller');
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
  bak(0,0);;clrscr;cur(3);
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
'200      200 20  1  1  7 20    25         100 50                               10                                    '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'                                                                            50      ';

DF[4]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'             80  2  2    50    12                             2                    5                           999   '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'                          1  1  1  1                                                ';

DF[6]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'                 2          25 12              9     1                    2    80  3                       3         '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'     1              1     1  1  1  1                                          620   ';

DF[8]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'             50 10  2    70    15           3 20     1        5           6   100    50 50                           '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'     1                                                                     100100   ';

DF[10]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'             40  5       50     5                    1500500 22                50  1                       1         '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'     1           1        1  1  1  1                                                ';

DF[12]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
' 25 20 10        3  3               700                      15          20   100 20      100                        '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'     1                    1  1  1  1                                                ';

DF[14]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
' 20              2                                                            100  1                       3         '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'     1                    1  1  1  1                                       500640   ';

DF[16]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
'   600           2                                                            100 25                                 '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'                                                                        600         ';

DF[18]:=
{  1  2  3  X  W  L  C  S  +  I  T  K  D  #  F  .  R  Q  /  \  B  V  =  A  U  Z  *  E  ;  :  `  -  @  %  ]  G  (  M  )}
' 60         130300     9                             1            250    20        6                           100   '+
{  P  &  !  O  H  ?  >  N  <  [  |  "  4  5  6  7  8  9  �  �  �  �  �  �  Y  0  ~  $}
'     4              1                                                               ';

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
     'Y':PF[XLoop+1,YLoop+1]:=64;
     '0':PF[XLoop+1,YLoop+1]:=65;
     '~':PF[XLoop+1,YLoop+1]:=66;
     '$':PF[XLoop+1,YLoop+1]:=67
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
  FP[1]:= '###the#final####  *    ##                      *##              ';
  FP[2]:= 'crusade#of#kroz#       ##                       ##     T        ';
  FP[3]:= '                       ##|                      ##              ';
  FP[4]:= '       ##              ###########  #########   ##              ';
  FP[5]:= '   !   ##                              ##TT##   ##            B ';
  FP[6]:= '       ##              ##  W           ##TT###  #####]]####OO###';
  FP[7]:= '#########################              ##                ##OOOOO';
  FP[8]:= '       ##TTTTT##                       ##         *      ##OOOOO';
  FP[9]:= '  &    ##     ##                   W   ##                ##OOOOO';
  FP[10]:='     & ##     ###########################  *             ##OO###';
  FP[11]:='                   ##1111111@      ## H####################     ';
  FP[12]:=' &    *##          ##11111@@@      @                <##         ';
  FP[13]:='#########          ##1111@@  ...   ##                ## *       ';
  FP[14]:='*      ##         *##11@@@   .P.   ##                ##         ';
  FP[15]:='       ##   #########@@@     ...   ####################         ';
  FP[16]:='           [##*    ##                ##*             ##         ';
  FP[17]:='       #######      @                ##          W   ##        *';
  FP[18]:='            ##     #############@@#####              ##         ';
  FP[19]:='            ##         ##*           ##          ###########  ##';
  FP[20]:='###  #########         ##                        ##            T';
  FP[21]:=' +   + ##              ##            ##                         ';
  FP[22]:='+  +   ]               ##            #######  #####    ##apogee#';
  FP[23]:='  +   +##             W##        *   ##LL        ##"   #software';
  Slow:=#142;{or #154} Medium:=#153;{or #148} Fast:=#234;{or #1}
  Convert_Format;
  HideTrap:=true;HideCreate:=true;
 end; { Level1 }

procedure Level3;
 begin
  FP[1]:= '                              P          F                H1##LL';
  FP[2]:= '#.#############0###########-############-##########O#0########DD';
  FP[3]:= '#.####@@@@@@@2@@@@@@@@@@@###-###+-222YYY-YYY222-+##S#1-1-1-1##22';
  FP[4]:= '#.#W##@@@2@@@@@@@@@@@@2@@##-############-##########O#-1-1-1-##22';
  FP[5]:= '#. ###@@@@@@@@@@2@@@@@@@@###-###+-222YYY-YYY222-+##O#1-1-1-1##))';
  FP[6]:= '#.####@@@@@2@@VVV@@2@@@@@####-##########-##########O#-1-1-1-##))';
  FP[7]:= '#.#W##2@@@@@VVVVVVV@@@@@2###-###+-222YYY-YYY222-+##O#1-1-1-1##))';
  FP[8]:= '#. ###@@@@2@VVVVVVV@@@@@@##-############-##########O#-1-1-1-##))';
  FP[9]:= '#.####@2@@@@@@VVV@@@@@@2@###-###+-222YYY-YYY222-+##O#1-1-1-1##))';
  FP[10]:='#.#W##@@@@@@2@@@@@@@2@@@@##-############-##########O#-1-1-1-##))';
  FP[11]:='#. ###0000000000000000000###-###--------S4---4---2#O#1-1-1-1##))';
  FP[12]:='#.####T********T********T####-##-444444444-4-4-4�##O#-1-1-1-##))';
  FP[13]:='#.#W########################-###-----------4---4C##O#1-1-1-1##))';
  FP[14]:='#. ##!T(M(((M(((((M((((M((M(####2424242424242424C##O#;::::::##))';
  FP[15]:='#.###TTM((M(((M(M(((M((((M((#######################O#<F[F|F"##))';
  FP[16]:='   ###############################-----------------O##########))';
  FP[17]:='   ##11111111111111111############-#####################++YYYY))';
  FP[18]:='2  ##-----------------##S-------##-------------------Q##++YYYY))';
  FP[19]:='  Z##  #############--#########-########################++YYYY))';
  FP[20]:='             0--------X+++++K##---------------?TTTTTT2##++YYYY))';
  FP[21]:='   ############################-##############################))';
  FP[22]:='   ##-----------------------------------------------------------';
  FP[23]:='+  I--1111111111111111111111111111111111111111111111111111111111';
  Slow:=#154; Medium:=#148; Fast:=#234;
  Convert_Format;
  LavaFlow:=true; LavaRate:=35;
 end; { Level3 }

procedure Level5;
 begin
  FP[1]:= '"2              2     XXCRRRRRRR@@@@1@@@@@@@@@1@@@@@@@@@1@@@@1@<';
  FP[2]:= '     P   2           WRRRRRRRRR1@@@@@@@@@@@@@@@@@1@@@1@@@@@@@@@@';
  FP[3]:= '               2 RRRRRRRRRRRK-@@@@@@@1@@@@1@@@@@@@@@@@@@@1@@1@1@';
  FP[4]:= '    2  TRRRRRRRRRRRRRRRRRRRRR-1@@@@1@@@@@@@@@@1@@@@@@@@@@@######';
  FP[5]:= '2  TRRRRRRRRRRRRRRRR###RRRRRRRR@@@@@@@@1@@@@@@@@@@@@1@@@@@DDD&LL';
  FP[6]:= 'RRRRRRRRRR#################RRRRRRRR1@@@@@@@1@@@1@@@@@@@1@@######';
  FP[7]:= 'RRRRR 2   - T  2 -   2 -   2 KRRRRRRRRR@@1@@@@@@@@@1@@@@@@@@@@1@';
  FP[8]:= 'RRT   -    2 -    2 -   2  -   -  -RRRRRRRRR@1@@@@@@@@@1@@@1@@@@';
  FP[9]:= '     - 2 -    2  -   2   -  2   2  2  TRRRRRRRR@1@@@@@@@@@@@@@@1';
  FP[10]:='O## 2 -   2-   -  2   2   2   -  -   -    2RRRRRRRR1@@@@@1@@@1@@';
  FP[11]:='O##7772 -   2-  2  -    -   T  2  2   2 -  -2 RRRRRRRRR@@@@@@@@@';
  FP[12]:='O##�77   2    2  T  2    2  -  -   -  -  2  2 - 2  RRRRRRRRR!---';
  FP[13]:='O##find#the#hidden#spell#    2  2   2  2       2   2 XHRRRRRRRRU';
  FP[14]:='O##########################################################RRRRR';
  FP[15]:='OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO?UR';
  FP[16]:='####W##########W##########W##########W##########W##########W####';
  FP[17]:=';;;;-;;;;##XXXXXXXXX##---------##2-2-2-2-2##���������##2226-----';
  FP[18]:=';T;;;-;;##XXXXXXXXXXX##;;;;;;-##2-2-2-2-2-2##�������##222266666-';
  FP[19]:='-;-;;;-;;##XXXXXXXXX##---------##2-2-2-2-2##���������##22222226-';
  FP[20]:='-;;-;;;-;B##XXXXXXX##B---------B##2-2-2-2##B����S����B##2222226-';
  FP[21]:=';-;;-;-;;##XXXXXXXXX##VVVVVVVVV##2-2-2-2-2##���������##22222226-';
  FP[22]:=';-;;;-;;##XXXXXXXXXXX##VVVVVVV##2-2-----2-2##�������##222222226�';
  FP[23]:='|;;;;;;;+##XXXXCXXXX##CT+TCT+TC##2-2-K-2-2##****Q****##22222226[';
  Slow:=#255; Medium:=#153; Fast:=#234;
  Convert_Format;
 end; { Level5 }

procedure Level7;
 begin
  FP[1]:= '!+-----+----+------+##%VVOOOOO44U44OOOOVV%##3333333333333333333K';
  FP[2]:= '-----+--+-----+-----##VVVOOOOO44444OOOOVVV##66666666666666666663';
  FP[3]:= '+--+------+--------+##OOOOOOOO##5##OOOOOOO##                  63';
  FP[4]:= '-----+-------+----+-##OOOOOOOO##?##OOOOOOO##                  63';
  FP[5]:= '---+-----+------+---##VVVOOOOOO###OOOOOVVV##XXXXX             63';
  FP[6]:= '-+----+-------+-----##CVVOOOOOOO#OOOOOOVVC##XXXXX             63';
  FP[7]:= '+-------+--------+-U##CVVOOOOOOOOOOOOOOVVC##UXXXX             63';
  FP[8]:= '###############################OOO##############################';
  FP[9]:= 'MMMMMMMMMMMMMMMMMMMM##S                  S##11111111111111111111';
  FP[10]:='MMMMMMMMMMMMMMMMMMMM##                    ##11111111111111111111';
  FP[11]:='@@@@@@@@@@@@@@@@@@@@##         000        ##11111111111111111111';
  FP[12]:='K@@@@@@@@@@@@W                 0P0        HB11111111111B1111111�';
  FP[13]:='@@@@@@@@@@@@@@@@@@@@##         000        ##11111111111111111111';
  FP[14]:='MMMMMMMMMMMMMMMMMMMM##                    ##11111111111111111111';
  FP[15]:='MMMMMMMMMMMMMMMMMMMM##S                  S##11111111111111111111';
  FP[16]:='###############################~~~##############################';
  FP[17]:='111111111111111111-U##C00000000---0-000---##U-))I)))))))333))))-';
  FP[18]:='1(((((((((((((((((--##-0000H---0000---0-0-##--)I)))))))333))))-*';
  FP[19]:='1(((((((TTT((((((((1##00000000 00000000000##))I)))))))333))))-*I';
  FP[20]:='1(((((((TTT((((((((1##-0-00000000000000-00##)I)))))))333))))-*I*';
  FP[21]:='1(((((((TTT((((((((1##00-0-----0000000<[|"##I)))))))333))))-*I*I';
  FP[22]:='1((((((((((((((((((1##-#####################)))))))333))))-*I*I*';
  FP[23]:='�1111111111111111111##C-------D-D-D]]E�&LL##K)))))333))))-*I*I*I';
  Slow:=#142;{or #154} Medium:=#153;{or #148} Fast:=#234;{or #1}
  Convert_Format;
  HideMBlock:=true; HideGems:=true;
 end; { Level7 }

procedure Level9;
 begin
  FP[1]:= '    ~~~~~~~~~~1144\\XMMMMMMMMMX55//2266033U-YYYD-DDDDDDDDDDDDDDL';
  FP[2]:= ' 0 0~~~~~~~~~~1144\\XMMMMMMMMMX55//2266033U-YYYDDDDDDD-DDDD-DDD-';
  FP[3]:= '    ~~~~~~~~~~1144\\XMMMMMMMMMX55//2266033U-YYYDDD-DDDDDDDDDDDDD';
  FP[4]:= '   0~~~~~~~~~~1144\\XMMMMMMMMMX55//2266033U-YYYDDDDD-DDD-DDDD-DD';
  FP[5]:= '   #############################################################';
  FP[6]:= ' 0 ##!�   TT          I  .            .     . ;;Q   .      . 88K';
  FP[7]:= '  0  0  0 ##7777P  .  I           .       .   ;;;;;     .    88�';
  FP[8]:= ' 0  0 0   ##��77      I     .                    .           88�';
  FP[9]:= '9999999999##K�77      I   .         .        .        .     .88K';
  FP[10]:='############@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
  FP[11]:='KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[12]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[13]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[14]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM�MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[15]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[16]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[17]:='K@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@K';
  FP[18]:='MMMMMMMMMMMMMMMM�MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM�MMMMMMMMMMMMMMMM';
  FP[19]:='MMMMMMBMMMMMMMMMMMMMMMMMMMMMMMMMBMMMMMMMMMMMMMMMMMMMMMMMMBMMMMMM';
  FP[20]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[21]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[22]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[23]:='KMMMMMMMMMMMMWWWWWWWMMMMMMMMMMMMKMMMMMMMMMMMWWWWWWWMMMMMMMMMMMMK';
  Slow:=#154; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideMBlock:=true;HideTrap:=true;
 end; { Level9 }

procedure Level11; 
 begin
  FP[1]:= '334  X~~~~~~  ~ ~~~~~~ P ~~ ~ ~~~ ~  ~ K~##U====U##U-~~*~~~2222K';
  FP[2]:= '334  ~ ~~~~ ~~ ~ ~~~~    ~ ~ ~ ~ ~ ~~~~~~~## ==== ##~-~~--~@@@@2';
  FP[3]:= '334  ~~ ~ ~~ ~~~ ~ ~ ~~~~ ~~~~~U~~~~~ ~~~~## ==== ##-~~-~~-@@@@2';
  FP[4]:= '334  ~~~ ~ ~~ ~~~ ~ ~~~~~~~~~~~-~~~~~ ~~~## ==== ##~~-~~-~~~~~~~';
  FP[5]:= '334  ~~~~~~  ~~~~~~~~~II~~~~~~II~~~~~ ~~## ==== ##~~-~~-~~999999';
  FP[6]:= '334  ~~~~~~~~~I~I~II~I~~I~II~I~I~~~~~ ~~~## ==== ##-~~~-~-DDDDKL';
  FP[7]:= '334  ~~!YGIIII~I~I~~I~~~~I~~I~~I~~~~~0~~## ==== ##~~-~-~~-999999';
  FP[8]:= '334  ~~~~~~~~~~~~~~~~~~~~~~~~~~I~1111111## ==== ##~*~-~~~�######';
  FP[9]:= '334  ~K-U-7�0~0~0~0~0~0~0~XXXK~I~11111111##0==== ##~~~~~33333333';
  FP[10]:='334  ~~~~~~~~~~~~~~~~~~~~~~~~~~I~111111111##-==== ##~~~333333333';
  FP[11]:='444��~~~~~~~~~~~~~333333~~~111~I~1111B11111##-==== ##~3333333333';
  FP[12]:='     ~~~~~~~~"~~~~333333~|~1110I~1111111111##-==== ##~~~~~~~~~~-';
  FP[13]:='     ~~~~~~~~~~~~~333333~~~111~I~111111111##-==== ##~~  000    -';
  FP[14]:='~0~0~~   ~~~~~~ ~~((((((~~~~~~~I~1111111111##-==== ##~          ';
  FP[15]:='~ ~ ~ ~~~ ~*~~~~ 0      0 ~~~~~2~111111111##-====0##Z           ';
  FP[16]:='~ ~ ~ ~ ~~ ~*~~~ 0      0 ~~ ~~K~~~~~-~~~##-====-##-~YYYYYYYYYY~';
  FP[17]:='~ ~ ~~ ~ ~~~*~~~ 0      0 ~ ~ ~~~~~~-~~~##-====-##~-~YYYYYYYYYY~';
  FP[18]:='~ ~ ~~~~~ ~~~~~~           ~~ ~~~~~~-~~##-====-##~-~~YCYYYYYYCY~';
  FP[19]:='~ ~ ~    C~~~~~~~~((((((~~~~ ~~ ~~~-~~~##-====-##~~-~~~~~~~~~~~~';
  FP[20]:='~ ~  ~~~~~~~~~~~~~((((((~~~ ~~ ~ ~-~~~##-====-##~~-~~-~~-----U-[';
  FP[21]:='~ ~ ~~   Q~~~~~~~~((((((~~ ~~ ~~ ~U~~~~##-====-##-~~-~-~-~#chasm';
  FP[22]:='~     ~~~~~~~~~~~~******~ ~~ ~~ ~~ ~~~~~##-====-##--~~-~-~####of';
  FP[23]:='~ ~~~~~~~~~~~~~~~~TTTTTT~~  ~~*~U~+++++++##C====C##~~~~-~~##fate';
  Slow:=#143; Medium:=#148; Fast:=#234;
  Convert_Format;
  HideOpenWall:=true; HideCreate:=true;
 end; { Level11 }

procedure Level13;
 begin
  FP[1]:= 'LLL##U##@@@@@@@@@@@|000---0000000000000000-0--00000000VVV000Y-0V';
  FP[2]:= '```##6##@00000000000000---0000222222220---0000-00000000000--Y-0V';
  FP[3]:= '```##6##@@022222222K000---0000-0000000000-0000-0)))))YYYW-W0Y-0V';
  FP[4]:= '```##6##@@@222222222000---000U*******00000000000)))0000000000-00';
  FP[5]:= '```##6##@@@222222222000---000000000000000000000000222222--000---';
  FP[6]:= '```##6##@@0222222222000---(((((((((((((((�(((((000222222-C00000-';
  FP[7]:= '333##6##@00000000000000---00004444444444444444(0000000000000000-';
  FP[8]:= '333##6##3CCC....0---------00022222222222222222(K(---------------';
  FP[9]:= '$$$##6##000000000000000---00000000000000000000000000000000000000';
  FP[10]:='   0--00000000000000000---000000000000000000000===============--';
  FP[11]:=' P 00-00+02222222220--------------------------0="===-=--===-==-=';
  FP[12]:='$$$00-00+02222222220-00---0000000000000000000-0==I=-=-==-=-=-==-';
  FP[13]:=' ! 00-00+02222222220-00-Z-0000000000000000000-0=H==-===T==-==--=';
  FP[14]:='00000-00[02222B22220-00---00----03333333CC----0==I==-===-==-====';
  FP[15]:='0--00-00+02222222220-00---00-0000000000000000-0===--==-==-==--==';
  FP[16]:='-0000-00+02222222220-00---00-0000000000000000-0==-===-=-=-====-=';
  FP[17]:='00000-00+02222222220W00---00-----0--------000-0=-==--==-=-=--=T=';
  FP[18]:='0--00-00000000000000000---000000000001110-000-0==T-===-===-==-==';
  FP[19]:='00000-00000000000000000---000000000001110-00000=======-=========';
  FP[20]:='--000----------------- ---0WWWWWWWWW01110-000-000000000000000000';
  FP[21]:='00000-00000000000000000---000-00000001110-000K--<000OO000OOOOO�*';
  FP[22]:='--000-000000~~~0000000#---#00-00000000000-000000000000OOOO000000';
  FP[23]:='00K000000********3000##VVV##0-------------00000triskaidekaphobia';
  Slow:=#142; Medium:=#148; Fast:=#255;
  Convert_Format;
  LavaFlow:=true; LavaRate:=112; HideOpenWall:=true;
 end; { Level13 }

procedure Level15;
 begin
  FP[1]:= 'LL.......CCC0~0~0~01UU-D-D-D-D3.......C.....-OOOOOO%K66636363636';
  FP[2]:= '66666666666666666666666666666666666666666666;6666666666363636363';
  FP[3]:= ']]]]]]]]?6633##�##33-=-===--=Z=663333333-K66-----\\\H66636363636';
  FP[4]:= '0000000066(((##T##(66-=-=-==-=6622222222-66------\\\\66$6$6$6$6$';
  FP[5]:= '00000000066((##T##((66=-==-==-=6611111111166-----\\\\666$6$6$6$6';
  FP[6]:= '----------66(##T##(((66=-=-=-==-66)))))))))66------0066$6$6Q6$6$';
  FP[7]:= '-----------(((((((((66|-=-===--=-)))))))))---------0"666$6$6$6$6';
  FP[8]:= '66666666-6666666666666666666666666666666666666666666666$6$6$6$6$';
  FP[9]:= '22222222266+~+~+~+~+~IMMMMMMMMM66*0*0*0*0*66K~-VVVVCC666T6T6T6T6';
  FP[10]:='2222222266+~+~+~+~+~+66MMMMMMM66--0-0-0-0--66~--VVVVC66$6$6$6$6$';
  FP[11]:='55555555566+~+~+~+~+66MMMMMMMMM66-0-0-0-0-66-----VVVV666$6$6$6$6';
  FP[12]:='XXXXXXXXXX66+~+~+~+66MMMMMMMMMMM660-0-0-066-------VVV66$6$6$6$6$';
  FP[13]:='XXXXXXXXX66+~+~+~+~+66MMMMMMMMM66-0*0*0*0---------!VV666$6$6$6$6';
  FP[14]:='�666666666666666666066666DDD66666-6666666666I6666666666$6$6$6$6$';
  FP[15]:='.........66C7--;----66---------66-YYYYYYYY66W;W;W;W;W666$6$6$6$6';
  FP[16]:='..........667--;-----66---------66YYYYYYYYY66W;W;W;W;66$6$6$6$6$';
  FP[17]:='.........66----;----66--00000--66-YYYYYYYY66W;W;W;W;W66$$$$$$$$$';
  FP[18]:='..........-----;--�66---00B00-66--YYYYYYY66W;W;W;W;W;66;;;;;;;;;';
  FP[19]:='.........66----;--�[66--00T00-----YYYYYYY<66W;W;W;W;W;          ';
  FP[20]:='4666666666666666666666666666666666666666666666666666666 ###crazy';
  FP[21]:=';:       ==+ == W== +==W     == +== W==      ==     W== cubicals';
  FP[22]:=';:P  ==  ==          ==  ==  ==      ==  ==      ==  == one#last';
  FP[23]:='K:   ==W     ==  ==     +==      ==     +== W== +==     ####time';
  Slow:=#154; Medium:=#153; Fast:=#1;
  Convert_Format;
  HideMBlock:=true; HideOpenWall:=true;
 end; { Level15 }

procedure Level17;
 begin
  FP[1]:= 'KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM�MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK';
  FP[2]:= '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
  FP[3]:= '2222222222222222222222222222222222222222222222222222222222222222';
  FP[4]:= '2222222222222222222222222222222222222222222222222222222222222222';
  FP[5]:= '2222222222222222222222222222222222222222222222222222222222222222';
  FP[6]:= '2222222222222222222222222222222222222222222222222222222222222222';
  FP[7]:= '5555555555555555555555555555555555555555555555555555555555555555';
  FP[8]:= '------B---------B---------B----------B---------B---------B------';
  FP[9]:= '4444444444444444444444444444444444444444444444444444444444444444';
  FP[10]:='~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[11]:='0000000000000000000000000000000000000000000000000000000000000000';
  FP[12]:='3(                           T    T                           )3';
  FP[13]:='3(                    ####################                    )3';
  FP[14]:='3(                    ##  )  ]�##�]  (  ##                    )3';
  FP[15]:='3(       P            ##;;############;;##           !        )3';
  FP[16]:='3(                    ##  ##T##LL##T##  ##                    )3';
  FP[17]:='3(                    ##00##;##DD##;##00##                    )3';
  FP[18]:='3(                    ##  ##E##DD##E##  ##                    )3';
  FP[19]:='3(                    ##;;##66666666##;;##                   &)3';
  FP[20]:='######                0+++            +++0                ######';
  FP[21]:='3333##                ####################                ##<[|"';
  FP[22]:='U333##                          0                         U-I--C';
  FP[23]:='YYYY##;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;######';
  Slow:=#142; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideRock:=true; HideMBlock:=true; HideCreate:=true;
 end; { Level17 }

procedure Level19;
 begin 
  FP[1]:= 'KMMMMMMMM----MMMMMMMMMMM-MMMMMMM##LL&DDDDDDD-MMMMMMMMMMMMMMMMMMM';
  FP[2]:= 'MMMMMMMM-MMMM--MMMMMMMM-M-MMMMMM############-------------------M';
  FP[3]:= 'MMMMMMM-MMMMMMM-MMMMMM-MMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-M';
  FP[4]:= 'MMMMMM-MMMMMMMMM--MMM-MMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-M';
  FP[5]:= 'MMMMM-MMMMM!MMMMMM---MMMMMM-MMMMMMMKMMMMMMMM**********MMMMMMMM-M';
  FP[6]:= 'MMMM-MMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-';
  FP[7]:= 'MMM-MMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MMM-M';
  FP[8]:= 'MM-MMMMMMMMM-------------MMMMMMMMMMMMM------------------M-M-M-MM';
  FP[9]:= 'M-MMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMM-MMM-MMM';
  FP[10]:='-MMMMMMMMM-MMMWWWWWWWWWWWMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[11]:='-MMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[12]:='-M---MMMMMMM-M-M-M-M-M-M-MMMMMMMMMMM-MMMMM-MMM-MMM-MMMMMMMMMMMMM';
  FP[13]:='M-MMM-MMMMMMM-M-M-M-M&M-M-MMMMMMMMMMM---M-M-M-M-M-M---------MMMM';
  FP[14]:='MMMM-MMMMMMMMMMMMMMMMMMMMM-MMMMMKMMMMMMM-MMM-MMM-MMMMMMMMMMM-MMM';
  FP[15]:='MMM-MMMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MMM+';
  FP[16]:='MM-MMMMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MMMM+';
  FP[17]:='M-MMMMMKMMMMM-------------MMMMMMMMMMMMMMMMMMMMMMMMMMKMMMMM-MMMM+';
  FP[18]:='M-MMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MMMMMMMMM-M-MMM+';
  FP[19]:='M-MMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMM-MMMMMMM-M-MMMMMMM-MMM-MMM';
  FP[20]:='M-MMMMMMMMMM-MMMMMMKMMMMMMMMMMM-MMMMM-M-MMMMM-MMM-MMMMM-MMMMM-MM';
  FP[21]:='@@@MMMMMMMM-MMMMMMMMMMMMMM-MMM-M-MMM-MMM-MMM-MMMMM-MMM-MMMMMMM-M';
  FP[22]:='@P@MMMMMMMMM-MMMMMMMMMMMM-M-M-MMM-M-MMMMM-M-MMMMMMM-M-MMMMMMMMM-';
  FP[23]:='@@@MMMMMMMMMM--M-M-M-M---MMM-MMMMM-MMMMMMM-MMMMMMMMM-MMMMMKMMMMM';
  Slow:=#143; Medium:=#148; Fast:=#234;
  Convert_Format;
 end; { Level19 }

procedure Level20;
 begin
  FP[1]:= 'K333333333333333333333333333333333333333333333333K##VVC?CVVVVVVV';
  FP[2]:= '3                                                3##VVVVVVVVAVVV';
  FP[3]:= '3   .     .           .          .     .         3##VVVVVVVVVVVV';
  FP[4]:= '3            ;::               .             .   3##++VVVVVVVVVV';
  FP[5]:= '3      .     :�:.                                3##++++++VVVVVV';
  FP[6]:= '3            :::               :::      .        3##---!----VVVV';
  FP[7]:= '3               .         .    :>:.              3##---------&VV';
  FP[8]:= '3    .                         :::               3##DDDDDDDDDDDD';
  FP[9]:= '3                             .    .      .      3##DDDDDDDDDDDD';
  FP[10]:='3                    FFFFFFF                     3##DDDDDDDDDDDD';
  FP[11]:='3           .        F.   .F            .     .  3##DDDDDDDDDDDD';
  FP[12]:='3  .                 F  P  F  .                  3##000000000000';
  FP[13]:='3                    F.   .F          .    .     3##------------';
  FP[14]:='3                    FFFFFFF                     3##............';
  FP[15]:='3       .    .                                   3##           %';
  FP[16]:='3                 .              .  .      .     3## .      .  V';
  FP[17]:='3     ;;;                 .                      3##    .     VV';
  FP[18]:='3   . ;%;       .                    ;;;         3##         VVV';
  FP[19]:='3     ;;;              .       .    .;Z;         3##        VVVV';
  FP[20]:='3                                    ;;;   .     3## .     VVVVV';
  FP[21]:='3  .       .         .      .                    3##      VVVVVV';
  FP[22]:='3                                                3##  .  VVVVVVV';
  FP[23]:='K333333333333333333333333333333333333333333333333K44    VVVV<[|"';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideGems:=true; HideTrap:=true;
 end; { Level20 }

procedure Level21;
 begin
  FP[1]:= '#######################################################)P)!#####';
  FP[2]:= '#######################################################))))#####';
  FP[3]:= 'L$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##########))))#####';
  FP[4]:= 'L$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##########))))#####';
  FP[5]:= '#########################################$$$$##########))))#####';
  FP[6]:= '######the#bones#of#######################$$$$##########))))#####';
  FP[7]:= '######scott#miller#######################$$$$##########))))#####';
  FP[8]:= '######rest#here##########################$$$$##########))))#####';
  FP[9]:= '#############################     #######$$$$##########))))#####';
  FP[10]:='#############################  ?  #######$$$$##########$$$$#####';
  FP[11]:='#############################     #######$$$$##########EEEE#####';
  FP[12]:='#########################################$$$$##########$$$$#####';
  FP[13]:='#########################################$$$$##########$$$$#####';
  FP[14]:='###$$$$E$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$]$$$$$##########$$$$#####';
  FP[15]:='###$$$$E$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$]$$$$$##########$$$$#####';
  FP[16]:='###$$$$################################################$$$$#####';
  FP[17]:='###$$$$##########################################>#####$$$$#####';
  FP[18]:='###$$$$################################################$$$$#####';
  FP[19]:='###@@@@################################################$$$$#####';
  FP[20]:='###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$$$$#####';
  FP[21]:='###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$$$$#####';
  FP[22]:='#######------------------------------------------------#########';
  FP[23]:='#######VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV#########';
  Slow:=#142; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideCreate:=true; LavaFlow:=true; LavaRate:=40; HideStairs:=true;
 end; { Level21 }

procedure Level22;
 begin
  FP[1]:= 'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  FP[2]:= 'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  FP[3]:= 'RRRRRRRR                  ]                                    P';
  FP[4]:= 'RRRRRRRR                  ]                                     ';
  FP[5]:= 'RRRRRRRR    RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  FP[6]:= 'RRRRRRRR    RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  FP[7]:= 'RRRRRRRR    RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  FP[8]:= 'RRRRRRRR                                   RRRRRRRRRRRRRRRRRRRRR';
  FP[9]:= 'RRRRRRRR         !                         RRRRRRRRRRRRRRRRRRRRR';
  FP[10]:='RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR             RRRRRRRRRRRR';
  FP[11]:='RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR             RRRRRRRRRRRR';
  FP[12]:='RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR    RRRRRRRRRRRR';
  FP[13]:='RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR    ;     RRRRRR';
  FP[14]:='RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR    ;     RRRRRR';
  FP[15]:='RRRRRRRRRRRRR@@OOOOOOOOOOOOOOOOOOOH   RRRRRRRRRRRRRRRR    RRRRRR';
  FP[16]:='RRRRRRRRRRRR@@@OOOOOOOOOOOOOOOOOOOH   RRRRRRRRRRRRRRRR    RRRRRR';
  FP[17]:='RRRRRRRRRRR@@@@RRRRRRRRRRRRRRRRRRRH   RRRRRRRRRRRRRRRR    RRRRRR';
  FP[18]:='RRRRRRRRRREEEERRRRRRRRRRRRRRRRRRRR    RRRRRRRRRRRRRRRR    RRRRRR';
  FP[19]:='RRRRRRRRREEEERRRRRRRRRRRRRRRRRRRRR    RRRRRRRRRRRRRRRR    RRRRRR';
  FP[20]:='RRRRRRRREEEERRRRRRRRRRRRRRRRRRRRRR                        RRRRRR';
  FP[21]:='RRRRRRR]]]]RRRRRRRRRRRRRRRRRRRRRRR                        RRRRRR';
  FP[22]:='RRRRRR&&&&RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  FP[23]:='RRRRRLLLLRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideStairs:=true; HideCreate:=true;
 end; { Level22 }

procedure Level23;
 begin
  FP[1]:= '~~~~ P  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[2]:= '~~~~ &  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[3]:= '~~~~    ~~~~~~~~~~~                            ~~~~~~~~~~~~~~~~~';
  FP[4]:= '~~~~    ~~~~~~~~~~~                            ~~~~~~~~~~~~~~~~~';
  FP[5]:= '~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~';
  FP[6]:= '~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~';
  FP[7]:= '~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~';
  FP[8]:= '~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~                ~~~~~';
  FP[9]:= '~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~                ~~~~~';
  FP[10]:='~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    ~~~~~';
  FP[11]:='~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    ~~~~~';
  FP[12]:='~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    ~~~~~';
  FP[13]:='~~~~    ~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    ~~~~~';
  FP[14]:='~~~~    ~~~~~~~~~~~               ~~~~~                    ~~~~~';
  FP[15]:='~~~~EEEE~~~~~~~~~~~               ~~~~~                    ~~~~~';
  FP[16]:='~~~~    ~~~~~~~~~~~~~~~~~~~~~~    ~~~~~    ~~~~~~~~~~~~~~~~~~~~~';
  FP[17]:='~~~~    ~~~~~~~~~~~~~~~~~~~~~~    ~~~~~    ~~~~~~~~~~~~~~~~~~~~~';
  FP[18]:='~~~~    ~~~~~~~~~~~~~~~~~~~~~~    ~~~~~    ~~~~~~~~~~~~~~~~~~~~~';
  FP[19]:='~~~~    ~~~~~~~~~~~~~~~~~~~~~~    ~~~~~    ~~~~~~~~~~~~~~~~~~~~~';
  FP[20]:='~~~~    ~~~~~~~~~~~~~~~~~~~~~~    ~~~~~                        L';
  FP[21]:='~~~~                              ~~~~~                        L';
  FP[22]:='~~~~                          <[|"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[23]:='~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideLevel:=true;
 end; { Level23 }

procedure Level24;
 begin
  FP[1]:= 'VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[2]:= 'VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[3]:= 'VV--------------------------------~~---------------------VVVVVVV';
  FP[4]:= 'VV--------------------------------~~---------------------VVVVVVV';
  FP[5]:= 'VV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV----VVVVVVV';
  FP[6]:= 'VV----VVVVVVVVVVVVVVVVVCCVVVVVVVVVVVVVVVVVVVVVVVVVVVV----VVVVVVV';
  FP[7]:= 'VV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV<[|"VV----VVVVVVV';
  FP[8]:= 'VV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV----VVVVVVV';
  FP[9]:= 'VV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV----VVVVVVV';
  FP[10]:='VV-----E----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV----VCVVVVV';
  FP[11]:='VV-----E----VVVVVVVVVVVVVV-----------------VVVVVVVVVV----VCVVVVV';
  FP[12]:='VVVVVVVV----VVVVVVVVVVVVVV-----------------VVVVVVVVVV----VVVVVVV';
  FP[13]:='VVVVVVVV----VVVVVVVVVVVVVV----VVVVVVVVV----VVVVVVVVVV----VVVVVVV';
  FP[14]:='VVVVVVVV----VVVVVVVVVVVVVV----VVVCCVVVV----VVVVVVVVVV----VVVVVVV';
  FP[15]:='VVVVVVVV----VVVVVVVVVVVVVV----VVVVVVVVV----VVVVVVVVVV----VVVVVVV';
  FP[16]:='VVVVVVVV----VVVVVVVVVVVVVV----VVVVVVVVV----VVVVVVVVVV----VVVVVVV';
  FP[17]:='VVVVVVVV-?--VVVVVVVVVVVVVV----VVVVVVVVV----VVVVCCVVVV----VVVVVVV';
  FP[18]:='VVVVVVVV----VVVVVVVVVVVVVV----VVVVVVVVV----VVVVVVVVVV----VVVVVVV';
  FP[19]:='VVVVVVVV----VVVVVVVVVVVVVV----VVVVVVVVV------------------VVVVVVV';
  FP[20]:='P-----------VVVVVVVVVVVVVV----VVVVVVVVV------------------VVVVVVV';
  FP[21]:='-----!------VVVVVVVVVVVVVV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[22]:='VVVVVVVVVVVVVVVVVVVVVVVVVV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[23]:='VVVVVVVVVVVVVVVVVVVVVVVVVVLLLLVVVVVVVVVVVVVVVtoo#h�o�tVVVVVVVVVV';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideStairs:=true; LavaFlow:=true; LavaRate:=15;
 end; { Level24 }

procedure Level25;
 begin
  FP[1]:= '&&-3 3CCCCK    ;      ;    P WW 4444444444444444444444444444444K';
  FP[2]:= '######4####################S####################################';
  FP[3]:= '<0[0|0"##�\\\\\##22222222)   N##C+++�~                3333333333';
  FP[4]:= '0000000##\\\\MM##)))))))))    #######~888888888~~~~~~~~~~K~~~~~ ';
  FP[5]:= 'MMMMMMM##\\MMMM##                                0    H�~~~CC]I ';
  FP[6]:= '*******##\MMMMM##     )RRR]                    ~~~~~~~~-~~~~~~~ ';
  FP[7]:= 'MMMMMMM#######--      )BRRRR                   ...TTT...~~>@@@@ ';
  FP[8]:= '*******##K]-##        RRRR]                    ~~~~~~~~~~~~~~~~ ';
  FP[9]:= 'MMMMMMM####0## G                          G                     ';
  FP[10]:='�������##---##                                       @@@@@@@@@@@';
  FP[11]:='7777777##0####                                       @2222222222';
  FP[12]:='OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO';
  FP[13]:='5555555555555555555555555555555555555555555555555555555555555555';
  FP[14]:='3333333333333333333333333333333333333333333333333333333333333333';
  FP[15]:='3333333333333333333333333333333333333333333333333333333333333333';
  FP[16]:='3333333333333333333333333333333K33333333333333333333333333333333';
  FP[17]:='U-$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$';
  FP[18]:='===========$   $    $      $       $       $    $   999#########';
  FP[19]:='~~~~~~=+======   $    $  YYYYYYYYYYYYY              ##�##K-U-3-U';
  FP[20]:='DDDD~~=-==0-===          YY666666666YY  $    $    $ ##+######the';
  FP[21]:='D~~D~~=-=-==-==    $     YY66VVVVV66YY              ##+#fountain';
  FP[22]:='D~~D~~=0==-==-=$       $ YY66VVAVV66YY$    $    $   ##+#######of';
  FP[23]:='�~~----=--====0$    $    YY66VV&VV66YY  $    $     $##!####youth';
  Slow:=#143; Medium:=#153; Fast:=#234;
  Convert_Format;
  HideMBlock:=true; LavaFlow:=true; LavaRate:=150; HideCreate:=true;
 end; { Level25 }


begin
end. { Levels }
