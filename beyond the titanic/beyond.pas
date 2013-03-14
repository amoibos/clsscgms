{//-------------------------------------------------------------------------}
{/*                                                                         }
{Copyright (C) 1990, 2009 - Apogee Software, Ltd.                           }
{                                                                           }
{This file is part of Supernova.  Supernova is free software; you can       }
{redistribute it and/or modify it under the terms of the GNU General Public }
{License as published by the Free Software Foundation; either version 2     }
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
{Original Source: 1990 Scott Miller                                         }
{Prepared for public release: 03/19/09 - Joe Siegler, Apogee Software, Ltd. }
{*/                                                                         }


{//-------------------------------------------------------------------------}
{/*                                                                         }
{Copyright (C) 1990, 2009 - Apogee Software, Ltd.                           }
{                                                                           }
{This file is part of Supernova.  Supernova is free software; you can       }
{redistribute it and/or modify it under the terms of the GNU General Public }
{License as published by the Free Software Foundation; either version 2     }
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
{Original Source: 1990 Scott Miller                                         }
{Prepared for public release: 03/19/09 - Joe Siegler, Apogee Software, Ltd. }
{*/                                                                         }
program beyond;
uses crt,dos;

const
     Q        = '#';
     VMax     = 65;
     NMax     = 89;
     RMax     = 76;
     Null     = -1;

type
     ComSet         = set of 0..VMax;
     CharSet        = set of Char;
     PlayersObjects = set of 0..NMax;
     Str15          = string[15];
     Str80          = string[80];
     Str240         = string[240];
     SaveGame       = record
       aInven,
       aKitSet,
       aCabiSet  :PlayersObjects;
       aPanelCon,
       aSlotCon,
       aCompCon,
       aRopeCon,
       aTic,
       aYearDial,
       aPrm,
       aMnRm,
       aSc,
       aShots,
       aShRm,
       aRx       :integer;
       aEv       :CharSet;
       aCode,
       aLoc      :Str15;
       aKeyHole  :boolean;
      end;

var
     WordList       : file of Str15;
     Things         : file of integer;
     Objects        : file of PlayersObjects;
     GameSave       : file of SaveGame;
     DiskSave       : SaveGame;
     Input,
     Again,
     Line           : Str80;
     V{erb}         : array [0..VMax,1..5] of Str15;
     N{oun}         : array [0..NMax,1..5] of Str15;
     R{oom}         : array [0..NMax] of integer;
     P{lace}        : array [0..RMax] of PlayersObjects;
     RmSh           : set of 0..14;
     OneWordCommands: Comset;
     Mov{able},
     Inven{tory},
     KitSet,
     CabiSet        : PlayersObjects;
     Word,
     LastNoun,
     {Drive,}
     Code,
     Loc{ation},
     SepWord        : Str15;
     Rooms1, Rooms2,
     Special1, Special2 : file of Str240;
     Text1, Text2   : Str240;
     Line1          : file of Str80;
     Verb,
     Noun, Noun2,
     PanelCon,
     RopeCon,
     CompCon,
     SlotCon,
     RopeOld,
     Tic,
     YearDial,
     DayDial,
     Prm,  {Player Room}
     MnRm, {Monster Room}
     Sc{ore},
     Shots,
     DialNum,
     Stuff,
     ShRm, {Shuttle Room}
     m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,
     Rx, {deserted road}
     Ox, {ocean bottom}
     x, y, o        : integer;
     Flag,
     FlagSA         : char;
     Ev{ent}        : CharSet;
     Attack,
     Skip,
     Back,
     KeyHole,
     Verbose        : boolean;



procedure  RR(RoomNum : integer);
    begin FlagSA:='s';
      seek(rooms1,RoomNum);seek(rooms2,RoomNum);
      READ(rooms1,text1);READ(rooms2,text2);
      writeln(text1,text2);
    end; {of RoomRead}


procedure  RS(RoomNum : integer);
   begin
     FlagSA:='s';
     seek(Special1,RoomNum);seek(Special2,RoomNum);
     READ(Special1,text1);READ(Special2,text2);
     writeln(text1,text2);
   end;  {of SpecialRead}

procedure RL(RoomNum : integer);
   var text1 : str80;
   begin
     FlagSA:='s';
     seek(Line1,RoomNum);
     READ(Line1,text1);
     writeln(text1);
   end;  {of LineRead}


procedure Format(var input : Str80);
 procedure D(A:Str15; B: Byte);
  begin while pos(A,input)<>0 do delete(input,pos(A,input),B) end;
   begin input:=input+' '; insert(' ',input,1);
    d(' of ',3); d(' go ',3); d('''',1); d('"',1); d(',',1);
    d(' a ',2); d('?',1);  d('!',1); d(';',1); d('#',1);
    d(' the ',4); d('fly ',4); d('drive ',6); d('run ',4);
    d('walk ',5); d('travel ',7); d('please ',7); d('room ',5);
    d('crawl se',6); d('crawl nw',6); d('steer ',6); d('crawl n ',6);
    d('crawl s ',6); d('crawl e',6); d('crawl w',6); d('that ',5);
    d('first ',6); d('second ',7); d('number ',7);
    d('this ',5); d('game ',5); d('i want to ',10); d(' my ',3); d('big ',4);
    d('those ',6); d('them ',5); d('broken ',7); d('large ',6);
    d('huge ',5); d('small ',6); d('tiny ',5);d('little ',7); d('within ',4);
    d('yes ',3); d('no ',2); d('wade ',4); d('swim ',4);
    while pos('examine ',input)>0 do delete(input,pos('examine ',input)+2,5);
    while pos('into ',input)>0 do delete(input,pos('into ',input)+2,2);
    while pos('. ',input)>0 do delete(input,pos('. ',input)+1,1);
    while pos('inside ',input)>0 do delete(input,pos('inside ',input)+2,4);
    d(' .',1); d('  ',1); d('..',1);
    if(input[1]='.')then delete(input,1,1);
    while(length(input)>0)and(input[1]=' ')do delete(input,1,1);
    while(length(input)>0)and(input[length(input)]=' ')do
     delete(input,length(input),1);
    if(input='')or(input[1]='.')then writeln('Whoops!')
   end;  {of Format}


procedure Chop(var input : Str80);
   var Word : Str80;
       j, l : integer;
   begin
     if length(input) >0 then
       begin
         input:=input+' ';
         j:=1;
         repeat
           Word:='';
           while(input[j]<>' ')and(input[j]<>'.')do begin
             Word:=Word+input[j];
             j:=j+1
           end;
           if length(Word) >7 then
             begin
               l:=pos(Word,input);
               j:=j+(7-length(Word));
               delete(input,l,length(Word));
               delete(Word,8,120);
               insert(Word,input,l)
             end;
           j:=j+1;
         until (j-1)=length(input);
         delete(input,length(input),1)
       end
   end;  {of Chop}


procedure LowerCase(var input : Str80);
    var j:byte;
   begin
     if length(input) > 0 then
      for j:=1 to length(input) do
       if(input[j] in ['A'..'Z'])then
        input[j]:=chr(ord(input[j])+32)
   end;   {of LowerCase}


procedure FindVerb (var input:Str80;var Word:Str15;var Verb:integer);
   var j, k, r : integer;
   begin
   j:=1;
   input:=input+' ';
   Word:='';
   while input[j]<>' ' do begin
     Word:=Word+input[j];
     j:=j+1
   end;
   if length(Word+' ')<length(input)then begin
     Word:=Word+' '; j:=j+1;
     while input[j]<>' ' do begin
       Word:=Word+input[j];
       j:=j+1
     end
   end;

   Verb:=Null;
   for r:= 0 to VMax do
     begin
       k:=0;
       repeat
         k:=k+1;
         if v[r,k]=Word then
           Verb:=r;
       until (v[r,k]=Q)or(k=5)
     end;

   if(pos(' ',Word)<>0)and(Verb=Null)then
     begin
       delete(Word,pos(' ',Word),8);
       for r:=0 to VMax do
         begin
           k:=0;
           repeat
             k:=k+1;
             if v[r,k]=Word then
               Verb:=r;
           until (v[r,k]=Q)or(k=5)
         end
     end;
     delete(input,length(input),1);
     if Verb<>Null then delete(input,1,length(Word));
     if input[1]=' 'then delete(input,1,1)
   end;  {of FindVerb}


procedure FindNoun(var input:Str80;var Word:Str15;var Noun:integer);
   var j, k, t  : integer;
   begin
   j:=1;
   input:=input+' ';
   Word:='';
   while input[j]<>' ' do begin
     Word:=Word+input[j];
     j:=j+1
   end;
   if length(Word+' ')<length(input)then begin
     Word:=Word+' ';j:=j+1;
     while input[j]<>' ' do begin
       Word:=Word+input[j];
       j:=j+1
     end
   end;

   Noun:=Null;
   for t:=0 to NMax do
     begin
       k:=0;
       repeat
         k:=k+1;
         if n[t,k]=Word then
           Noun:=t;
       until (n[t,k]=Q)or(k=5)
     end;

   if(pos(' ',Word)<>0)and(Noun=Null)then
     begin
       delete(Word,pos(' ',Word),8);
       for t:=0 to NMax do
         begin
           k:=0;
           repeat
             k:=k+1;
             if n[t,k]=Word then
               Noun:=t;
           until (n[t,k]=Q)or(k=5)
         end
     end;
     delete(input,length(input),1);
     if Noun<>Null then delete(input,1,length(Word));
     if input[1]=' 'then delete(input,1,1)
   end;  {of FindNoun}


procedure FindSep(var input : Str80; var h : Str15);
   var j  : integer;
   begin
     input:=input+' ';
     j:=1;
     h:='';
     while input[j]<>' ' do begin
       h:=h+input[j];
       j:=j+1
     end;
     if pos(' '+h+' ',' crawl on at to in off with within into '+
            ' above against through beside behind around across '+
            ' inside from by under using near over onto down ') >0 then
       begin
         delete(input,length(input),1);
         delete(input,1,length(h));
         if input[1]=' ' then delete(input,1,1);
         if(h='on')or(h='around')or(h='above')or(h='over')or(h='onto')
           then h:='to';
         if(h='inside')or(h='within')or(h='through')or(h='into')or(h='down')
           then h:='in';
         if(h='using')then h:='with';
         if(h='beside')or(h='by')then h:='near';
         if(h='against')then h:='at';
         if(h='across')then h:='over'
       end
     else
       begin
         h:='s';
         delete(input,length(input),1)
       end
   end;  {of FindSep}


procedure Check(var SepWord : Str15);
   var j  : integer;
   begin
   Verb:=Null; Noun:=Null; Noun2:=Null; DialNum:=Null; Flag:='?';
   SepWord:='s';
   if length(input)>0then
    begin
     FindVerb(input,Word,Verb);
     if Verb<>Null then
      if(length(input)>0)and not(Verb in [31,53,63])then
       begin
        FindNoun(input,Word,Noun);
        If(Noun<>Null)then LastNoun:=n[noun,1];
        if Noun<>Null then
         if(Verb in[0,8,9,21,36,6,7,15,17,32,26])and(length(input)=0)then
          begin
           Flag:='g';
           if(Verb in[36,15])then Verb:=9
          end
         else
         if(Verb in[0,8,21,36,37,29,9,39,6,15,7,17,32,26,40])then
          if length(input)>0 then
           begin
            if(Verb=9)then Verb:=29 else ;
            FindSep(input,SepWord);
            if SepWord<>'s' then
             if length(input)>0 then
              if Verb=39 then
               begin
                val(input,DialNum,j);
                Flag:='g'
               end
              else
               begin
                FindNoun(input,Word,Noun2);
                if Noun2<>Null then
                 if length(input)>0 then
                  Flag:='r'
                 else
                  Flag:='g'
                else
                 begin
                  FindVerb(input,Word,Verb);
                   if Verb=Null then Flag:='n'
                   else Flag:='b'
                 end
               end
             else
              if(Verb=39)and((SepWord='to')or(SepWord='off'))then
               Flag:='g' else Flag:='e'
            else
             Flag:='r'
           end
          else
           Flag:='s'
         else
          if length(input)>0 then
           begin FindVerb(input,Word,j);if j<>Null then Flag:='b' else
           begin FindSep(input,SepWord);if SepWord<>'s' then Flag:='b' else
           begin FindNoun(input,Word,j);if j<>Null then Flag:='h' end end;
            if Flag='?' then Flag:='v'
           end
          else
           Flag:='g'
        else
         begin
          FindVerb(input,Word,Verb);
           if Verb=Null then Flag:='n'
           else Flag:='b'
         end
       end
      else
       if Verb in OneWordCommands then Flag:='g'
       else Flag:='m'
     else
      begin
       FindNoun(input,Word,Noun2);
        If Noun2=Null then Flag:='v'
        else Flag:='a'
      end
    end;
   case flag of
   'v','n':if pos(' '+Word+' ',' crawl on at to in off with within into '+
                  ' above against through beside behind around down '+
                  ' inside by under using near over onto top below '+
                  ' from away want across ')>0 then begin
             write('The word ''',Word);RL(393)end
           else writeln('I don''t understand the word ''',Word,'.''');
     'b'  :begin
            if pos(' ',Word)>0 then delete(Word,pos(' ',Word),9);
            writeln('You can''t use the word ''',Word,''' here.')
           end;
     's'  :RL(129);
     'r'  :RL(130);
     'e'  :RL(131);
     'm'  :RL(132);
     'a'  :RL(316);
     'h'  :begin write(Word);RL(392)end
   end;
   Skip:=True;
   if flag<>'g' then begin Attack:=False;Line:='';Skip:=False end
  end;  {of Check}



procedure SA;
   begin FlagSA:='s' end;

function En(c : char) : boolean;
   begin
     if(c in Ev)then En:=True else En:=False
   end;

function Here(noun : integer): Boolean;
   begin
     if(noun in Inven)or(r[noun]=Prm)or(noun in p[Prm])then Here:=True
     else Here:=False
   end;

procedure Crazy;
   begin SA;
    if(random(2)=1)then RL(107+random(7))else RL(300+random(6));
   end;

procedure DEAD;
var b,c: integer;
    {FileName : file;}
   begin SA; NoSound;
     gotoxy(1,25);for x:=1 to 7 do writeln;
     Textcolor(1);Textbackground(m9);
     gotoxy(1,18);
     write('*********************************************************',
           '***********************');writeln;
     gotoxy(1,19); for x:=1 to 3 do
     write('*                                                        ',
             '                      *');writeln;
     gotoxy(1,22);
     write('*********************************************************',
           '***********************');writeln;
     TextColor(m0);gotoxy(32,20);writeln('YOU HAVE DIED!!!');
     Textcolor(m2);Textbackground(0);
     for c:=700 downto 20 do for b:=70 downto 1 do sound(b*c);nosound;
     close(Rooms1);close(rooms2);close(special1);close(special2);close(line1);
     gotoxy(1,23);DelLine;DelLine;writeln;{write('Do you wish to play again? ');
     flag:=readkey;
     if(upcase(flag)<>'N')then
      begin
      writeln('Restarting...');window(1,1,80,25);
        assign(rooms1,'BEYOND.com');exec('beyond.exe', '');end
     else
      begin}
       textcolor(7);
       textbackground(0);
       window(1,1,80,25);
       clrscr;
       writeln('    Beyond the Titanic');
       writeln('A Scott Miller Production');
       writeln('    Have a nice day...');
       delay(2000);
      { assign(FileName,'MENU.COM');
       $I-
       exec(FileName, '');
       $I+
       if IOResult <> 0 then }HALT;
      {end  }
   end;

procedure Home;
  var b,c:integer;
   begin SA;
     gotoxy(1,25);for x:=1 to 7 do writeln;
     Textcolor(25);Textbackground(m7);
     gotoxy(1,18);
     write('#########################################################',
           '#######################');writeln;
     gotoxy(1,19); for x:=1 to 3 do
     write('#                                                        ',
             '                      #');writeln;
     gotoxy(1,22);
     write('#########################################################',
           '#######################');writeln;
     TextColor(31);gotoxy(25,20);writeln('Y O U   H A V E   W O N ! ! !');
     Textcolor(m2);Textbackground(0);
     gotoxy(1,23);DelLine;DelLine;writeln;
     for x:=150 downto 1 do begin sound(x*55);delay(8);nosound;delay(20)end;
     if(Sc>1000)then Sc:=1000;
     write('You finished with a score of ',Sc,', which makes you a ');
     if(Sc=1000)then
      begin writeln('Perfect Adventurer!!!');
        for y:=1 to 7 do
         for o:=0 to 20 do
           for x:= 99+(o*430)to 998+(o*430)do begin sound(25);sound(x)end
      end
     else writeln('Master Adventurer!');
     for c:=1 to 999 do for b:=1 to 61 do sound(b*c);nosound;
     writeln;nosound;
     writeln('Reboot your computer to regain control...')
  end;

procedure Say(o : integer; p : Str15);
   begin
     writeln('The ',n[o,1],' is already ',p,'.'); SA
   end;

procedure Diagnose;
   begin
     RL(191);
     if((tic>42)and not(en('c')))or((tic>146)and not(en('n')))or(en('r'))then
      begin
       if(tic>42)and (not(en('c')))then RL(192)
        else if(tic>146)and not(en('n'))then RL(192);
       if(en('r'))then RL(51)
      end
     else RL(207)
   end;

procedure Monster(var NewRm : integer);
   begin
    if(NewRm=MnRm)and(MnRm=25)then begin Attack:=False;RL(384)end else
    if(NewRm<>35)or not(en('v'))then
     begin
      p[Prm]:=p[Prm]-[23];p[NewRm]:=p[NewRm]+[23];MnRm:=NewRm;Attack:=False;
       if not((NewRm=30)and(Verb in[27,28]))then
        case random(7) of
         0:RS(71);1:RS(72);2:RL(359);3:RL(360);4:RL(361);5:RL(362);6:RL(363)
        end
     end
    else begin RL(383);Attack:=False end
   end;

procedure DescribeRm;
   var o : integer;
  procedure s(r : Str15);
     begin TextColor(m8);writeln(r);TextColor(m2);loc:=r;end;
   begin SA;
if((en('a'))and(here(29)))or not(Prm in [6..24])then begin
     case Prm of
0:s('Ship''s Fore');1:s('Ship Mid-Deck');2:s('Rear of Ship');
3:s('Life Boat');4:s('Ocean Surface');5:s('Huge Cavern');
6:s('Cave of Pins');7:s('Ocean Bottom');8:s('Squeaky Cave');
9:s('Stream Bend');10:s('Waterfall');13:s('Sloppy Cave');
11:s('Hex Cave');12:s('Shallow Cleft');20:s('Zoo');
14:s('Winding Tunnel');15:s('Chasm');17:s('Chasm Bottom');
18:s('Tiny Opening');19:s('Etched Stairs');
21:s('Edge of Saucer');22:s('Side of Saucer');
23:s('Top of Saucer');24:s('Airlock');16:s('End of Rope');
76:s('Locked Cabin');25:s('Central Entry');
26:s('Lower Entry');27:s('Ship''s Systems');
30:s('Time Chamber');28:s('Ship''s Lab');34:s('Bridge');
29:s('Inside Tube');31:s('Life Support');58,69:s('Inside Shuttle');
32:s('Supply Chamber');33:s('Sleep Chamber');
35:s('Engine Room');36:s('Cargo Deck #1');37:s('Cargo Deck #2');
38:s('Cargo Deck #3');39:s('Cargo Deck #4');40:s('Large Cage');
41:s('Wooden Bridge');42:s('Broken End');43:s('South End');
44..46:s('Deserted Road');47:s('Crater Edge');48:s('Crater Floor');
49:s('Building Front');50:s('Lobby');51..54:s('Office Room');
55:s('Basement');56:s('Ladder Room');57:s('Building Roof');
59:case ShRm of 0:s('Above Mud Lake');
1:s('Above Rubble');2:s('Above Desert');3:s('Above Pits');
4:s('Above River');5:s('Above Stream');6:s('Above Town');
7:s('Above Mountain');8:s('Above Crator');9:s('Above Hills');
10:s('Above Canyon');11:s('Above Flatland');12:s('Above Dry Lake');
13:s('Above Desert');14:s('Above Bridge')end;{of Above Rooms}
63,64:s('Above Clouds');65..68:s('Outside City');70:s('Landing Bay');
71:s('Power Plant');72..74:s('Dark Corridor');75:s('Food Supply')
     end; {of case}

    if Verbose then begin FlagSA:='r';
      case Prm of
       2 :if(40 in p[2])then begin RR(2);RL(416)end;
       4 :if(en('B'))then RR(4)else begin RR(4);
           writeln('There is a safety harness here.')end;
       11:if(en('C'))then RS(15);
       40:if(en('g'))then RS(17);
       12:if not(en('G'))then begin RR(12);RL(146)end;
       31:if not(en('I'))then begin RR(31);RL(156)end;
       34:if(74 in p[34])then begin RR(34);RL(273)end;
       35:if(77 in p[35])then begin RR(35);RL(381);RL(382)end else
           if(en('W'))then begin RR(35);RL(381)end;
       42:if(13 in p[42])then begin RR(42);RL(214)end;
       48:if(27 in p[48])then begin RR(48);RL(276)end;
       59..69:begin SA;
               if(Prm=59)and not(ShRm in RmSh)then
                begin RmSh:=RmSh+[ShRm];RS(ShRm+46)end
               else if(Prm<>59)then RR(Prm);
               if KeyHole and here(63)then
                writeln('The shiny key is in the keyhole.')
              end
       else RR(Prm)
      end; {of case}
      if(FlagSA='r')and(Prm<>59)then RR(Prm)end;

     for o:= 0 to NMax do begin
       if(o in Mov)then
         if(r[o]=Prm)then
          if not((Prm in[59..69])and(KeyHole)and(o=63))then
           begin writeln('There is a ',n[o,1],' here.');
            if(here(ropecon))and(o=ropecon)and not(ropecon in inven)then
             writeln('  The rope is attatched to the ',n[o,1],'.');
            if(en('d'))and(o=70)and(here(70))then RL(147);
            if(o=SlotCon)and(here(o))then RL(388);
            if(o in CabiSet)and(here(o))then RL(389);
            if(o=PanelCon)and(here(o))then RL(390);
            if(o in KitSet)and(here(o))then RL(391);
           end
     end end
    else RL(54)
   end;  {of DescribeRm}

procedure SAVE;
{var buflen:integer;}
   begin SA; for x:=1 to 24 do writeln; nosound;
   window(1,3,80,25);
   gotoxy(1,4);      {
   if(Drive='A:')then
    writeln('Remove the GAME disk and insert your SAVE/RESTORE disk ',
            'in drive A:')else
    writeln('Make sure your SAVE/RESTORE disk is in drive B:');
   writeln('  (Press any key to continue...)');flag:=readkey;
   writeln;writeln; }
   write('Save under what name? ');{BufLen:=8;}readln(input);
   while pos(' ',input)>0 do delete(input,pos(' ',input),1);
   while pos('.',input)>0 do delete(input,pos('.',input),1);
   if(input='')then input:='LastRoom';
   writeln;writeln;input:={Drive+}input;
   writeln({'If your SAVE/RESTORE disk is in drive ',Drive,  }
            'then press any key to start.');
   flag:=readkey;
   with DiskSave do
    begin
     aInven:=Inven;aKitSet:=KitSet;aCabiSet:=CabiSet;aPanelCon:=PanelCon;
     aSlotCon:=SlotCon;aCompCon:=CompCon;aRopeCon:=RopeCon;aTic:=Tic;
     aYearDial:=YearDial;aPrm:=Prm;aMnRm:=MnRm;aSc:=Sc;aShots:=Shots;
     aShRm:=ShRm;aRx:=Rx;aEv:=Ev;aCode:=Code;aLoc:=Loc;aKeyHole:=KeyHole;
    end;
   assign(GameSave,input+'.a');
   rewrite(GameSave);
   write(GameSave,DiskSave);
   close(GameSave);
   assign(Objects,input+'.b');
   rewrite(Objects);
   for x:=0 to RMax do write(Objects,p[x]);
   close(Objects);
   assign(WordList,input+'.c');
   rewrite(Wordlist);
   for x:= 0 to NMax do
    for y:= 1 to 5 do
     write(WordList,n[x,y]);
   for x:= 0 to VMax do
    for y:= 1 to 5 do
     write(WordList,v[x,y]);
   close(WordList);
   assign(Things,input+'.d');
   rewrite(Things);
   for x:= 0 to NMax do write(Things,r[x]);
   close(Things);
   writeln; delete(input,1,2);
   writeln('Your present game location is now',
           ' SAVED to disk under the name ''',input,'.''');
 {  if(Drive='A:')then begin writeln;
    writeln('Remove the SAVE/RESTORE disk and insert your GAME disk.')end;}
   writeln('  (Press any key to continue...)');flag:=readkey;
   writeln;writeln;
   if(Verb<>54)then writeln('You may now resume your game...');
   if(Line='')then Line:='look';Tic:=Tic-2;Back:=True;
   if(Prm in[59..68])then sound(20);
   window(1,2,80,25)
   end; {of Save}

procedure RESTORE;
 {var buflen:integer;}
 function Exist:Boolean;
 begin
 assign(GameSave,input+'.a');
 {$I-}
 Reset(GameSave);
 {$I+}
 Exist:=(IOresult=0)
 end;
   begin SA; for x:=1 to 24 do writeln; nosound;
   window(1,3,80,25);gotoxy(1,4);
   {if(Drive='A:')then
    writeln('Remove the GAME disk and insert your SAVE/RESTORE disk ',
            'in drive ',Drive)else
    writeln('Make sure your SAVE/RESTORE disk is in drive B:');
   writeln('  (Press any key to continue...)');flag:=readkey;
   writeln;writeln; }
   write('Which file name do you want to RESTORE? ');{BufLen:=8;}readln(input);
   while pos(' ',input)>0 do delete(input,pos(' ',input),1);
   while pos('.',input)>0 do delete(input,pos('.',input),1);
   if(input='')then input:='LastRoom';
   writeln;writeln;input:={Drive+}input;
   writeln({'If your SAVE/RESTORE disk is now in drive ',Drive,   }
           ' then press any key to start.');
   flag:=readkey;
   if Exist then
    begin
     close(GameSave);
     assign(GameSave,input+'.a');
     reset(GameSave);
     read(GameSave,DiskSave);
     close(GameSave);
     with DiskSave do
      begin
       Inven:=aInven;KitSet:=aKitSet;CabiSet:=aCabiSet;PanelCon:=aPanelCon;
       SlotCon:=aSlotCon;CompCon:=aCompCon;RopeCon:=aRopeCon;Tic:=aTic;
       YearDial:=aYearDial;Prm:=aPrm;MnRm:=aMnRm;Sc:=aSc;Shots:=aShots;
       ShRm:=aShRm;Rx:=aRx;Ev:=aEv;Code:=aCode;Loc:=aLoc;KeyHole:=aKeyHole;
      end;
     assign(Objects,input+'.b');
     reset(Objects);
     for x:=0 to RMax do read(Objects,p[x]);
     close(Objects);
     assign(WordList,input+'.c');
     reset(Wordlist);
     for x:= 0 to NMax do
      for y:= 1 to 5 do
       read(WordList,n[x,y]);
     for x:= 0 to VMax do
      for y:= 1 to 5 do
       read(WordList,v[x,y]);
     close(WordList);
     assign(Things,input+'.d');
     reset(Things);
     for x:= 0 to NMax do read(Things,r[x]);
     close(Things);
     writeln; delete(input,1,2);
     writeln('Your previously SAVED game location is now',
             ' RESTORED from the file ''',input,'.''');
    { if(Drive='A:')then begin writeln;
      writeln('Remove the SAVE/RESTORE disk and insert your GAME disk.')end;}
     writeln('  (Press any key to continue...)');flag:=readkey;
    end
   else
    begin writeln;TextColor(28);
     writeln('             That name does not exist on this',
             ' SAVE/RESTORE disk.',^g);
     TextColor(m2);writeln;
     {if(Drive='A:')then
      writeln('Put your GAME disk back in the disk drive and press any key.')
     else writeln('  (Press any key to continue...)');
     flag:=readkey;      }
    end;
   writeln;writeln;writeln('You may now resume you game...');
   if(Line='')then Line:='look';Tic:=Tic-2;Back:=True;
   if(Prm in[59..68])then sound(20);
   window(1,2,80,25)
   end; {of Restore}

procedure Vanish(o : integer);
   begin SA;
     inven:=inven-[o];
     r[o]:=Null;
     p[Prm]:=p[Prm]-[o];
     if(o=7)and not(en('I'))then Ev:=Ev+['I'];
     if(o=13)and(13 in p[42])then p[42]:=p[42]-[13];
     if(o=PanelCon)then PanelCon:=Null;
     if(o=SlotCon)then SlotCon:=Null;
     if(o in CabiSet)then CabiSet:=CabiSet-[o];
     if(o in kitset)then kitset:=kitset-[o];
     if(o=63)and KeyHole then KeyHole:=False;
     if(o=74)then Ev:=Ev-['p'];
     if(o=89)then Ev:=Ev-['i'];
     if(o=RopeCon)and(verb=36)then begin RopeCon:=Null;RL(402)end;
     if(o=RopeCon)and not(Verb in[9,14])then RopeCon:=Null
   end;

procedure Play( Start, Stop, Wait: integer);
   var x : integer;
   begin
    if(Start<=Stop)then
     for x:= Start to Stop do
      begin sound(x); delay(Wait); end
    else
     for x:= Start downto Stop do
      begin sound(x); delay(Wait); end;
    if(Prm in[59..68])then sound(20)else nosound
   end; {of Play}

procedure DropAll;
   var o : integer;
   begin
     for o:= 0 to NMax do
       if(o in inven)then
         begin
           r[o]:=Prm;
           inven:=inven-[o];writeln(n[o,1],': Dropped.');
         end;
     RL(106);
   end;  {of DropAll}

function FlasOff : Boolean;
   begin
     if not(En('a'))then FlasOff:=True
     else
       if(r[29]=Prm)or(29 in inven)then FlasOff:=False
       else FlasOff:=True;
   end;

procedure MoveTo(NewRm : integer);
 var o : integer;
 begin
   if(57 in inven)and(ropecon<>Null)and not(ropecon in inven)
     and(ropecon in mov)and not(ropecon=70)then
      begin r[ropecon]:=Prm;RL(158);end
   else if(57 in inven)and(ropecon<>Null)and(not(ropecon in mov)or
        ((ropecon=70)and(en('d'))))then
          begin RL(55);inven:=inven-[57];r[57]:=Prm;end
   else if not(57 in inven)and((ropecon in inven)or
          (ropecon in[60,56,44]))then r[57]:=NewRm
   else if not(57 in inven)and(r[57]=Prm)and(r[ropecon]=NewRm)then
          begin r[57]:=NewRm;RopeOld:=Prm;end
   else if not(57 in inven)and(r[57]=Prm)and(NewRm=RopeOld)and
              (r[ropecon]=Prm)then
          begin r[57]:=RopeOld;RopeOld:=Null;end;
   if(ropecon=Null)or((NewRm<>RopeOld)and(Prm<>RopeOld))then RopeOld:=Null;
   if(MnRm<>Null)then Monster(NewRm);
   if(Prm in[63..68])and not(NewRm in[59,69])then RL(343);
   if(Prm in[59,63..68])then for o:=0 to NMax do if(r[o]=Prm)then r[o]:=NewRm;
   Prm:=NewRm;
   DescribeRm
 end;  {of MoveTo}

procedure Time;
   begin
     Tic:=Tic+1;
  case Tic of
    3:RL(280);
    4:RS(1);
    17:if not(en('A'))then begin RS(3);DEAD end else RS(5);
    19:RL(4);
    20:RL(5);
    21:RL(6);
    23:RS(6);
    24:if(en('B'))then begin RS(8);writeln;RL(16);moveto(5);Sc:=Sc+25;
         n[64,5]:='ship';v[26,2]:='pick' end
       else begin RS(7);DEAD;end;
    43:if(not(en('c'))and not(en('n')))then RL(31);
    73:if(not(en('c'))and not(en('n')))then RL(32);
    93:if(not(en('c'))and not(en('n')))then begin RL(33); DEAD end;
    99:if(Prm in[6..24])and(here(29))and not(flasoff)and(not(en('s')))then
         begin RL(41);Ev:=Ev+['s'] end;
    147:if not(en('n'))then RL(31);
    149:if(here(29))and not(flasoff)then RL(59);
    153:if(Prm in[6..23])and(here(29))and not(flasoff)then
          begin RS(14);vanish(29) end;
    170:if not(en('n'))then RL(32);
    181:if not(en('n'))then begin RL(33); DEAD end;
    549:RL(281);
    586:RL(282);
    598:RL(283);
    607:begin RL(284);DEAD;end;
  end; {of case}

case Prm of
    1..3:if(tic>4)and(random(4)=1)then RL(405);
  36..39:if(random(5)=2)then RL(219);
     7  :if(random(8)=2)then RL(266);
     8  :if(random(3)=2)then begin RL(265);play(6666,7000,0);end;
  13..24:if(random(16)=2)then RL(246);
  25..35:if(random(30)=2)then RL(267);
   47,48:if(random(5)=2)and(inven <>[])then
           begin
            if(Prm=48)then begin writeln;RS(40)end
            else begin writeln;RS(44);moveto(48)end;
            o:=1;flag:='?';
            repeat o:=o+1;
             if(o in inven)then
             begin vanish(o);r[o]:=random(9)+41;flag:='g';end;
            until Flag = 'g';
           end;
end;
case Prm of
  5,6,9,10:if(random(9)=2)then RL(268);
  7..8, 11..40:if(here(84))and(random(20)=2)then RL(269)
        else if(random(75)=2)then RS(36)
        else if(Prm in[5..22])and(random(33)=2)then
         begin RL(265);play(6500,6950,0)end;
  41..49:if(random(27)=2)then RL(285);
    59  :if(random(15)=1)then RL(406);
end;
if Attack and(MnRm=Prm)and(not Back)then
 begin case random(3) of 0:RS(80); 1:RS(81); 2:RS(82)end;DEAD end
else if(MnRm=Prm)then Attack:=True
   end;  {of Time}

function Present : Boolean;
   begin
    if(noun<>Null)and(noun<>1)then
     if(here(noun))then
      if(noun2<>Null)then
       if(here(noun2))then Present:=true
       else begin
         writeln('You can''t see any ',n[noun2,1],' here.');Present:=false end
      else Present:=true
     else begin
       writeln('You can''t see any ',n[noun,1],' here.');Present:=false end
    else Present:=true
   end;

procedure Initialize;
 procedure Cn(S : Str80);
 begin
  gotoxy(40-(length(S)div 2),wherey);writeln(S);
 end;
  begin
   textcolor(15);
   writeln('Prepare to engage yourself in a most exciting adventure.');
   writeln('But first, two simple questions:');
   gotoxy(1,4);write('Are you using a COLOR screen (Y/N)? ');
   nosound; play(72,80,45);
   flag:=readkey; play(2500,2490,6);
   m0:=20;m1:=14;m2:=11;m3:=4;m4:=15;m5:=28;m6:=1;m7:=4;m8:=10;m9:=10;
   if upcase(flag)='N' then
    begin
     writeln('No, I don''t have a color screen.');
     m0:=31;m1:=15;m2:=15;m3:=7;m4:=0;m5:=31;m6:=7;m7:=8;m8:=7;m9:=0;
    end else writeln('Yes, I do have a color screen.');writeln;
   {write('How many disk drives do you have (1/2)? ');
   play(80,88,30);
   flag:=readkey;play(2500,2490,6);
   Drive:='B:';
   if(upcase(flag)='O')or(flag='1')then
    begin Drive:='A:';writeln('I have ONE disk drive.')end else
    writeln('I have TWO disk drives.');
   delay(999);}clrscr;textcolor(15);gotoxy(1,5);writeln;textcolor(7);
   cn('Beyond the Titanic');textcolor(6);cn('------------------');writeln;
   textcolor(7);
   cn('A Text & Sound Adventure Fantasy');writeln;writeln;
   cn('An Apogee Software Production');writeln;writeln;writeln;
   cn('Written and Programmed by Scott Miller');
   textcolor(11);
   gotoxy(32,24);textcolor(7);
   write('Press any key...');flag:=readkey;clrscr;

   {                      *** SHAREWARE SCREEN ***                            }
  {
   textcolor(15);
   writeln('Please note that Beyond the Titanic is a SHAREWARE game.');
   writeln;
   textcolor(7);
   writeln('This game has been placed in the public domain for your enjoyment.');
   writeln;
   writeln('If you like the game the author (Scott Miller) asks that you please');
   writeln('contribute $5 or $10 (your discretion) to him.  This minimal payment');
   writeln('will help compensent the author for the year of work that went into');
   writeln('Beyond the Titanic.  It will also encourage the author to make new and');
   writeln('better games, like Supernova and Kingdom of Kroz, both of which are');
   writeln('also shareware games recently released.');
   writeln;
   writeln('This fee also registers the payer for telephone support and clues.');
   writeln;writeln;
   writeln('Please make checks payable to Scott Miller.');
   writeln;
   textcolor(15);
   writeln('        Scott Miller           (214) 240-0614');
   writeln('        4206 Mayflower Dr.');
   writeln('        Garland, TX  75043');
   writeln;
   textcolor(7);
   writeln('Thanks, enjoy the game...');
   gotoxy(23,25);
   delay(12000);
   while keypressed do flag:=readkey;
   write('Press any key to start the game...');
   flag:=readkey;
   while keypressed do flag:=readkey;
   clrscr; }
   {                      ************************                            }

   gotoxy(1,25);
   TextColor(m1);
cn('APRIL 14, 1912    11:43 PM');
cn('You never knew the black canvas of the night was so full'+
   ' of twinkling detail.');
cn('Standing on deck of the White Star''s new super luxury liner, deep at sea,');
cn('where the bright lights of San Francisco don''t fade the night, you');
cn('can view thousands of stars you never realized existed.');
cn('Looking out over the icy sea you can barely see small pieces of'+
   ' broken ice');
cn('bobbing in the water.  Rumor has it that icebergs the size of small');
cn('mountains can be found in this region.  You don''t feel');
cn('too worried, though, the Titanic has been touted as');
cn('"unsinkable," and every single passenger knows');
cn('that White Star, the premier ship builder,');
cn('knows their stuff...');
for x:= 1 to 3 do writeln;
Line        :='';
LastNoun    :='';
KitSet      :=[2,29,57];
CabiSet     :=[89,63];
CompCon     :=Null;
PanelCon    :=8;
RopeCon     :=Null;
SlotCon     :=Null;
RopeOld     :=Null;
RmSh        :=[];
Mov         :=[2,7,8,13,27,29,32,34,40,52,51,57,63,70,74,77,89];
OneWordCommands:=[1,4,5,7,8,16,18,19,22,31,33..35,41,43..54,56..59,61..65];
Ev          :=[];
Inven       :=[];
Prm         :=0;
MnRm        :=Null;
Tic         :=Prm;
Sc          :=0;
Shots       :=6;
KeyHole     :=false;
Verbose     :=true;
Attack      :=False;
YearDial    :=135;
DayDial     :=60;
assign(rooms1,'rooms1');assign(rooms2,'rooms2');
assign(special1,'special1');assign(special2,'special2');assign(line1,'line');
reset(rooms1);reset(rooms2);reset(special1);reset(special2);reset(line1);
Str(Random(9998)+1,Code);
   DescribeRm; writeln; randomize;
   gotoxy(1,1);TextBackGround(m6);
   for x:=1 to 80 do write(' ');writeln;TextColor(m4);
   gotoxy(4,1);writeln('Move');gotoxy(68,1);writeln('Score');TextColor(m2);
   TextBackGround(0); Window(1,2,80,25);
  end; {of Initialize}

procedure Assign0;
begin
                      {INITIALIZE OBJECT'S ROOMS}
for o:=0 to NMax do r[o]:=Null;
p[0]:=[53,73,80,6,26,64,36];
p[1]:=[53,6,57,73,80,64,36];
p[2]:=[40,53,14,6,66,46,73,80,57,64,36];
p[3]:=[6,73,80,39,59,57,64,36];
p[4]:=[6,73,80,39,35,59,64,36];
p[5]:=[73,80,71];
p[6]:=[73,80,71];
p[7]:=[36,73,80,6];
p[8]:=[47,46];
p[9]:=[73,80];
p[10]:=[80,73,17];
p[11]:=[72];
p[12]:=[70];
p[13]:=[17,47,73,80];
p[14]:=[];
p[15]:=[17,73,80];
p[16]:=[17,57];
p[17]:=[17];
p[18]:=[];
p[19]:=[69];
p[20]:=[12,69,67,43];
p[21]:=[64,71,37];
p[22]:=[64,71,37];
p[23]:=[64,26,71,37];
p[24]:=[64,69,41,26,55];
p[25]:=[64,69,41,26,84];
p[26]:=[41,12,69,84];
p[27]:=[20,21,26,10,58,38,86];
p[28]:=[21,10,78,33,49,85];
p[29]:=[78,10,21,33,49,85];
p[30]:=[21,10,24,25,82,16,59,49,76,38,86];
p[31]:=[75,21,10,84,7,22];
p[32]:=[61,75,21,14];
p[33]:=[61,75,4,21,10,59,84];
p[34]:=[16,5,21,68,58,10,0,20,74,25,86];
p[35]:=[62,21,10,54,55];
p[36]:=[85,83,21,14,12,64,43];
p[37]:=p[36];
p[38]:=p[36]+[28];
p[39]:=p[36];
p[40]:=p[36]+[26,67];
p[41]:=[87,73,19,47,53,37];
p[42]:=p[41]+[13];
p[43]:=p[41];
p[44]:=[41,19,87];
p[45]:=[41,19];
p[46]:=[41,19];
p[47]:=[3,41,19,17,22];
p[48]:=[3,19,17,22,27,35];
p[49]:=[9,26,37,72];
p[50]:=[9,26,88,46,66,37,68];
p[51]:=[9,37];
p[52]:=[9,37];
p[53]:=[9,69,37];
p[54]:=[9,37];
p[55]:=[9,69,11,45,26,61,37,68];
p[56]:=[9,69,37];
p[57]:=[9,19,37,41,65,22,31,73,87];
p[58]:=[9,10,16,19,20,21,25,36,41,46,58,59,65,66,68,81,86];
p[59]:=p[58]+[17,18,22,31,71,73,87];
p[63]:=[9,10,16,18,19,20,21,25,36,41,46,58,59,65,66,68,81,86,88];
p[64]:=p[63];
p[65]:=p[63];
p[66]:=p[63];
p[67]:=p[63];
p[68]:=p[63];
p[69]:=p[63]+[9,14,37,53];
p[70]:=p[69]+[69]-[10,16,20,36,46,58,59,66,68,81,86];
p[71]:=[10,20,21,25,36,38,41,54,58,69];
p[72]:=[85];
p[73]:=p[72];
p[74]:=p[72];
p[75]:=[23,14,61];
p[76]:=[26,45];
for x:=0 to 76 do p[x]:=p[x]+[15,30,42,44,50,56,60,79]
end;

procedure Assign1;
begin
for x:= 0 to VMax do for y:= 1 to 5 do v[x,y]:=Q;
v[0,1]:='attack'; v[0,2]:='kill';v[0,3]:='beat up';
v[1,1]:='descrip';v[1,2]:='rd';v[1,3]:='r d';
v[2,1]:='climb';v[2,2]:='climb on';v[2,3]:='climb onto';v[2,4]:='climb in';
   v[2,5]:='climb over';
v[3,1]:='close';v[3,2]:='shut';v[3,3]:='fasten';v[3,4]:='connect';
   v[3,5]:='hook';
v[4,1]:='crawl ne';v[4,2]:='duck ne';v[4,3]:='crawl northea';
   v[4,4]:='climb ne';
v[5,1]:='crawl sw';v[5,2]:='duck sw';v[5,3]:='crawl southwe';
   v[5,4]:='climb sw';
v[6,1]:='cut';v[6,2]:='slice';v[6,3]:='cut out';v[6,4]:='saw';
   v[6,5]:='chop';
v[7,1]:='dig';v[7,2]:='dig in';v[7,3]:='shovel';
v[8,1]:='drink';v[8,2]:='drink from';v[8,3]:='drink some';
   v[8,4]:='drink lot';
v[9,1]:='drop';v[9,2]:='get rid';v[9,3]:='put down';
v[10,1]:='eat';v[10,2]:='swallow';
v[11,1]:='examine';v[11,2]:='ex';v[11,3]:='search';
   v[11,4]:='read';v[11,5]:='look at';
v[12,1]:='find';v[12,2]:='look for';v[12,3]:='where is';v[12,4]:='check';
   v[12,5]:='chech for';
v[13,1]:='repair';v[13,2]:='fix';
v[14,1]:='get';v[14,2]:='take';v[14,3]:='grab';v[14,4]:='steal';
   v[14,5]:='pick up';
v[15,1]:='give';v[15,2]:='offer';v[15,3]:='show';v[15,4]:='pay';
   v[15,5]:='give away';
end;

procedure Assign2;
begin
v[16,1]:='help';v[16,2]:='pray';
v[17,1]:='hit';v[17,2]:='punch';v[17,3]:='knock';v[17,4]:='break';
   v[17,5]:='destroy';
v[18,1]:='invento';v[18,2]:='i';
v[19,1]:='jump';v[19,2]:='jump onto';v[19,3]:='jump on';v[19,4]:='jump off';
   v[19,5]:='jump in';
v[20,1]:='launch';v[20,2]:='sail';v[20,3]:='row';
v[22,1]:='look';v[22,2]:='l';v[22,3]:='look around';v[22,4]:='ex area';
v[23,1]:='look above';v[23,2]:='ex on';v[23,3]:='look on';
   v[23,4]:='ex top';v[23,5]:='ex above';
v[24,1]:='look in';v[24,2]:='ex in';v[24,3]:='look down';v[24,4]:='look up';
   v[24,5]:='search in ';
v[25,1]:='look under';v[25,2]:='ex underne';v[25,3]:='ex under';
   v[25,4]:='look underne';v[25,5]:='ex below';
v[21,1]:='burn';v[21,2]:='ignite';v[21,3]:='light';
v[26,1]:='open';v[26,2]:='unfaste';v[26,3]:='peel';v[26,4]:='hatch';
   v[26,5]:='untie';
v[27,1]:='pull';v[27,2]:='flick';v[27,3]:='pull on';v[27,4]:='flip';
   v[27,5]:='flip on';
v[28,1]:='push';v[28,2]:='move';v[28,3]:='press';v[28,4]:='turn on';
   v[28,5]:='turn off';
v[29,1]:='put';v[29,2]:='pour';v[29,3]:='lay';v[29,4]:='fill';
   v[29,5]:='insert';
v[30,1]:='reach';v[30,2]:='reach in';v[30,3]:='feel in';
v[31,1]:='say';v[31,2]:='yell';v[31,3]:='shout';v[31,4]:='compute';
   v[31,5]:='think';
end;

procedure Assign3;
begin
v[32,1]:='shoot';v[32,2]:='blast';v[32,3]:='fire at';v[32,4]:='fire';
   v[32,5]:='shoot at';
v[33,1]:='sit';v[33,2]:='sit in';v[33,3]:='get in';v[33,4]:='sit down';
   v[33,5]:='sit on';
v[34,1]:='sleep';v[34,2]:='lie down';v[34,3]:='sleep on';v[34,4]:='sleep in';
v[35,1]:='stand';v[35,2]:='stand up';v[35,3]:='get up';v[35,4]:='stand in';
v[36,1]:='throw';v[36,2]:='toss';
v[37,1]:='tie';v[37,2]:='hook';v[37,3]:='wrap';
v[38,1]:='touch';v[38,2]:='feel';v[38,3]:='touch in';v[38,4]:='rub';
v[39,1]:='turn';v[39,2]:='rotate';v[39,3]:='set';
v[40,1]:='unlock';
v[41,1]:='wait';v[41,2]:='z';v[41,3]:='rest';
v[42,1]:='wear';v[42,2]:='put on';
v[43,1]:='north';v[43,2]:='n';v[43,3]:='fore';v[43,4]:='f';v[43,5]:='across';
v[44,1]:='south';v[44,2]:='s';v[44,3]:='aft';v[44,4]:='a';
v[45,1]:='east';v[45,2]:='e';v[45,3]:='starboa';v[45,4]:='st';
v[46,1]:='west';v[46,2]:='w';v[46,3]:='port';v[46,4]:='p';
v[47,1]:='north east';v[47,2]:='ne';v[47,3]:='northea';
v[48,1]:='north west';v[48,2]:='nw';v[48,3]:='northwe';
v[49,1]:='south east';v[49,2]:='se';v[49,3]:='southea';
v[50,1]:='south west';v[50,2]:='sw';v[50,3]:='southwe';
v[51,1]:='up';v[51,2]:='u';v[51,3]:='climb up';v[51,4]:='climb u';
v[52,1]:='down';v[52,2]:='d';v[52,3]:='climb down';v[52,4]:='climb d';
   v[52,5]:='lower';
v[53,1]:='type';v[53,2]:='type in';
v[54,1]:='quit';v[54,2]:='stop';v[54,3]:='give up';v[54,4]:='i quit';
v[55,1]:='take off';v[55,2]:='remove';
v[56,1]:='shake';v[56,2]:='bogie';v[56,3]:='dance';
end;

procedure Assign4;
begin
v[57,1]:='enter';v[57,2]:='in';v[57,3]:='land in';v[57,4]:='land on';
   v[57,5]:='land';
v[58,1]:='exit';v[58,2]:='out';v[58,3]:='leave';v[58,4]:='retreat';
   v[58,5]:='escape';
v[59,1]:='diagnos';
v[60,1]:='look behind';v[60,2]:='ex behind';v[60,3]:='examine behind';
   v[60,4]:='ex beside';v[60,5]:='look beside';
v[61,1]:='restart';v[61,2]:='let';v[61,3]:='fall from';v[61,4]:='drop from';
   v[61,5]:='fall';
v[62,1]:='score';v[62,2]:='rank';
v[63,1]:='creatur';v[63,2]:='alien monster';v[63,3]:='monster';
   v[63,4]:='alien creatur';
v[64,1]:='save';
v[65,1]:='restore';v[65,2]:='resume';

                     {NOUN LIST:  GROUPS ALL OBJECTS}

for x:= 0 to NMax do for y:= 1 to 5 do n[x,y]:=Q;
n[0,1]:='alien';n[0,2]:='dead alien';n[0,3]:='body';n[0,4]:='alien body';
n[1,1]:='all';n[1,2]:='everyth';n[1,3]:='object';n[1,4]:='objects';
n[2,1]:='banana';n[2,2]:='food';
n[3,1]:='bat';n[3,2]:='bats';
n[4,1]:='bed';n[4,2]:='bunk';n[4,3]:='beds';n[4,4]:='bunks';
n[5,1]:='blue button';n[5,2]:='blue';
n[6,1]:='boat';n[6,2]:='life boat';n[6,3]:='titanic';n[6,4]:='lifeboa';
   n[6,5]:='ship';
end;

procedure Assign5;
begin
n[7,1]:='bottle';n[7,2]:='brown bottle';n[7,3]:='brown';
n[8,1]:='black box';n[8,2]:='box';n[8,3]:='black';n[8,4]:='switch';
   n[8,5]:='box switch';
n[9,1]:='building';n[9,2]:='buildin';n[9,3]:='tower';n[9,4]:='towers';
n[10,1]:='button';n[10,2]:='buttons';
n[11,1]:='cabinet';n[11,2]:='file';n[11,3]:='blue cabinet';
n[12,1]:='cages';n[12,2]:='bars';
n[13,1]:='coin';n[13,2]:='quarter';n[13,3]:='25';n[13,4]:='money';
n[14,1]:='containers';n[14,2]:='crate';n[14,3]:='crates';n[14,4]:='cargo';
   n[14,5]:='contain';
n[15,1]:='ceiling';n[15,2]:='roof';
n[16,1]:='chair';n[16,2]:='time chair';n[16,3]:='time';n[16,4]:='seat';
   n[16,5]:='metal chair';
n[17,1]:='chasm';n[17,2]:='canyon';
n[18,1]:='city';n[18,2]:='floatin city';n[18,3]:='floatin';n[18,4]:='town';
n[19,1]:='clouds';n[19,2]:='cloud';
n[20,1]:='computer';n[20,2]:='termina';n[20,3]:='compute';n[20,4]:='typewri';
n[21,1]:='controls';n[21,2]:='machine';n[21,3]:='equipme';n[21,4]:='devices';
   n[21,5]:='control';
n[22,1]:='crater';n[22,2]:='pit';n[22,3]:='stove';
n[23,1]:='creature';n[23,2]:='creatur';n[23,3]:='monster';
   n[23,4]:='alien creatur';n[23,5]:='it';
n[24,1]:='silver dial';n[24,2]:='day dial';n[24,3]:='day';n[24,4]:='silver';
n[25,1]:='dial';n[25,2]:='knob';n[25,3]:='dials';n[25,4]:='knobs';
n[26,1]:='door';n[26,2]:='hatch';n[26,3]:='saucer hatch';n[26,4]:='ship door';
   n[26,5]:='sliding';
n[27,1]:='piece of wire';n[27,2]:='wire';n[27,3]:='mangled wire';
   n[27,4]:='mangled';n[27,5]:='piece wire';
n[28,1]:='egg';n[28,2]:='eggs';
n[29,1]:='flashlight';n[29,2]:='light';n[29,3]:='flashli';n[29,4]:='hook';
   n[29,5]:='ring';
end;

procedure Assign6;
begin
n[30,1]:='ground';n[30,2]:='floor';n[30,3]:='earth';n[30,4]:='deck';
   n[30,5]:='bay';
n[31,1]:='trees';n[31,2]:='tree';n[31,3]:='forest';
n[32,1]:='piece of fur';n[32,2]:='fur';n[32,3]:='piece fur';n[32,4]:='piece';
   n[32,5]:='blue fur';
n[33,1]:='green button';n[33,2]:='green';
n[34,1]:='gun';n[34,2]:='ray gun';n[34,3]:='gauge';n[34,4]:='orange';
   n[34,5]:='laser gun';
n[35,1]:='safety harness';n[35,2]:='safety';n[35,3]:='belt';
   n[35,4]:='harness';n[35,5]:='strap';
n[36,1]:='ice';n[36,2]:='ocean bottom';n[36,3]:='bottom';n[36,4]:='ocean';
n[37,1]:='debris';n[37,2]:='trash';n[37,3]:='rubble';n[37,4]:='wood';
n[38,1]:='numeric keypad';n[38,2]:='keypad';n[38,3]:='numeric';
   n[38,4]:='numbers';
n[39,1]:='survival kit';n[39,2]:='kit';n[39,3]:='surviva';n[39,4]:='red kit';
   n[39,5]:='surviva kit';
n[40,1]:='knife';n[40,2]:='blade';
n[41,1]:='concrete';n[41,2]:='concrete wall';n[43,3]:='cement';n[41,4]:='pad';
   n[41,5]:='landing pad';
n[42,1]:='dirt';n[42,2]:='dust';n[42,3]:='desert';n[42,4]:='sand';
   n[42,5]:='landing bay';
n[43,1]:='cage';n[43,2]:='large';n[43,3]:='large cage';
n[44,1]:='left hand';n[44,2]:='left';n[44,3]:='hand';
n[45,1]:='rusty lock';n[45,2]:='lock';n[45,3]:='rusty';
n[46,1]:='message';n[46,2]:='chisele';n[46,3]:='writing';n[46,4]:='marking';
   n[46,5]:='chisele marking';
n[47,1]:='mud';n[47,2]:='sloppy';n[47,3]:='slop';
n[48,1]:='chain';n[48,2]:='thick chain';n[48,3]:='metal chain';
n[49,1]:='panel';n[49,2]:='compart';
n[50,1]:='path';n[50,2]:='passage';n[50,3]:='tunnel';n[50,4]:='road';
   n[50,5]:='tubes';
n[51,1]:='banana peel';n[51,2]:='peel';n[51,3]:='skin';
n[52,1]:='glowing pill';n[52,2]:='pill';n[52,3]:='glowing';
n[53,1]:='rail';n[53,2]:='railing';n[53,3]:='wooden';n[53,4]:='wooden rail';
n[54,1]:='reactor';n[54,2]:='core';
n[55,1]:='red button';n[55,2]:='red';n[55,3]:='lower door';n[55,4]:='mangled';
   n[55,5]:='mangled door';
n[56,1]:='right arm';n[56,2]:='right';n[56,3]:='arm';n[56,4]:='arms';
end;

procedure Assign7;
begin
n[57,1]:='rope';n[57,2]:='thick';n[57,3]:='thick rope';
n[58,1]:='screen';n[58,2]:='monitor';n[58,3]:='tv';n[58,4]:='screens';
n[59,1]:='bench';n[59,2]:='chairs';n[59,3]:='seats';n[59,4]:='benches';
   n[59,5]:='metalli';
n[60,1]:='player';n[60,2]:='self';n[60,3]:='waist';n[60,4]:='me';
   n[60,5]:='myself';
n[61,1]:='shelf';n[61,2]:='shelves';
n[62,1]:='reactor shield';n[62,2]:='barrier';n[62,3]:='shield';
   n[62,4]:='plate';n[62,5]:='radiati shield';
n[63,1]:='shiny key';n[63,2]:='shiny';n[63,3]:='key';
n[64,1]:='alien saucer';n[64,2]:='alien ship';n[64,3]:='hull';
   n[64,4]:='saucer';
n[65,1]:='shuttle';n[65,2]:='car';n[65,3]:='vehicle';n[65,4]:='engine';
n[66,1]:='sign';n[66,2]:='note';n[66,3]:='red sign';
n[67,1]:='bones';n[67,2]:='bone';n[67,3]:='skeleto';n[67,4]:='animals';
   n[67,5]:='remains';
n[68,1]:='slot';n[68,2]:='opening';n[68,3]:='hole';n[68,4]:='key hole';
   n[68,5]:='keyhole';
n[69,1]:='steps';n[69,2]:='stair';n[69,3]:='stairs';n[69,4]:='ladder';
   n[69,5]:='step';
n[70,1]:='metal stake';n[70,2]:='stake';n[70,3]:='metal';n[70,4]:='pole';
   n[70,5]:='rod';
n[71,1]:='rock feature';n[71,2]:='stalagt';
n[72,1]:='strange wall';n[72,2]:='strange';n[72,3]:='hexagon';
   n[72,4]:='shapes';
end;

procedure Assign8;
begin
n[73,1]:='water';n[73,2]:='river';n[73,3]:='stream';n[73,4]:='gusher';
   n[73,5]:='lake';
n[74,1]:='alien suit';n[74,2]:='suit';n[74,3]:='space suit';
   n[74,4]:='uniform';
n[75,1]:='table';n[75,2]:='tables';
n[76,1]:='tan button';n[76,2]:='tan';
n[77,1]:='tape';n[77,2]:='future';n[77,3]:='future tape';
n[78,1]:='healing tube';n[78,2]:='tube';n[78,3]:='healing';
   n[78,4]:='glass tube';n[78,5]:='glass';
n[79,1]:='walls';n[79,2]:='wall';n[79,3]:='north wall';
   n[79,4]:='east wall';n[79,5]:='west wall';
n[80,1]:='waterfall';n[80,2]:='waterfa';
n[81,1]:='white button';n[81,2]:='white';
n[82,1]:='gold dial';n[82,2]:='year';n[82,3]:='gold';n[82,4]:='year dial';
n[83,1]:='slime';n[83,2]:='jelly';
n[84,1]:='vent';n[84,2]:='vents';
n[85,1]:='lamp';
n[86,1]:='microphone';n[86,2]:='mic';n[86,3]:='speaker';n[86,4]:='microph';
n[87,1]:='bridge';n[87,2]:='wooden bridge';n[87,3]:='wooden';
n[88,1]:='beams';n[88,2]:='orange beams';n[88,3]:='beam';
   n[88,4]:='electri';n[88,5]:='orange';
n[89,1]:='helmet';n[89,2]:='control helmet';n[89,3]:='hat';
end;

{//-------------------------------------------------------------------------}
{****************************************************************************}
{*                          BEYOND THE TITANIC                              *}
{*    Written by Scott Miller with Turbo Pascal V.2.  Began May 12, '84.    *}
{*                           Shareware Version                              *}
{*                             Copyright 1987                               *}
{$C-,V-,R-****************************************************************}

{ Last modified: July 23, 1987 }

{===================}
  procedure DefaultAnswers1;
var o : integer;
begin

CASE VERB OF

22        :begin if(Prm in[59..68])then
                  begin RmSh:=RmSh-[ShRm];RS(84)end;
            if flasoff and (Prm in [6..24])then RL(54) else
             if Verbose then DescribeRm
              else begin Verbose:=true;DescribeRm;Verbose:=false;end;
            if(23 in p[Prm])and(MnRm=Prm)then RL(357);
            if Back then begin Attack:=False; Back:=False;end
           end;

18        :if inven=[] then RL(116)
             else
               begin
                 writeln('You have in your possession...');
                   for o:= 0 to NMax do
                    begin
                     if(o in inven)then
                      if(o=74)then
                       writeln('an ',n[o,1])else writeln('a ',n[o,1]);
                     if(ropecon in inven)and(o=ropecon)then
                      writeln('  The rope is tied to the ',n[o,1],'.');
                     if(o=74)and(en('p'))then RL(174);
                     if(o=89)and(en('i'))then RL(321);
                    end;
               end;

11     :case noun of
       60:Diagnose;
       2:if(en('b'))then RL(198) else RL(199);
       29:begin RL(89);if(en('a'))then RL(200) else RL(201);end;
       57:if(ropecon<>Null)then
            writeln('The rope is tied to the ',n[ropecon,1],'.')
          else RL(133);
       65:if(Prm in[59..68])then RS(84)else Line:='l';
       8:RL(202);
       7:RL(163);
       70:RL(164);
       52:RL(165);
       74:RL(166);
       23:RS(70);
       32:RL(253);
       13:RL(167);
       22:RL(226);
       1:if(Prm=42)and(13 in p[42])then RL(167);
       21:RL(227);
       9:if(Prm=49)then RL(228)else if(Prm>62)then RS(68)else RL(229);
       69:RL(355);
       77:RL(403);
       37:RL(295);
       27:RL(394);
       89:RL(338);
       18:if(Prm in[63..70])then RS(68)else RL(348);
       46,66:If(Prm in[58,59,63,69])then begin
       TextColor(12);RS(83);TextColor(m2)end;
       87:RL(230);
       84:RL(231);
       34:begin RL(189);
           if(Shots>0)then writeln('is about ',Shots*10,' percent full.')
           else Writeln('is empty.')end;
       15:if(84 in p[Prm])then RL(180)else If(71 in p[Prm])then RL(182)
          else RL(181);
    56,44:if(en('r'))then RL(51) else RL(52)
       else if not(noun in[1,12,14,15,17,18,19,22,31,36,50,
             54,67,69,73,79,80,84,87,88])and(random(3)=1)then
            case random(3) of
             0  :RL(407);
             1  :writeln('Yea, it''s definitely a ',n[noun,1],'!');
             2  :writeln('It looks like any other ',n[noun,1],'.');
            end
            else writeln('You see nothing special about the ',n[noun,1],'.')
       end;

41         :begin writeln('Time passes');y:=wherey;for o:=1 to 6 do
              begin gotoxy(11+o,y-1);writeln('.');sound(o*99);delay(30)end;
              if(Prm in[59..68])then sound(20)else nosound end;

43..52     :if(Prm in[6..24])and(FlasOff)then RL(14)else
             if(Prm=69)then RL(358)else RL(144);

57,58      :begin Attack:=False;
             if(Prm in[6..24])and(FlasOff)then RL(14)else RL(190);end;

  end {of case}
end;  {of DefaultAnswers1}
{-------------------}
  procedure DefaultAnswers2;
{var o : integer;}
begin

CASE VERB OF

29    :if(noun in Mov)then
        if(noun in inven)then
         begin FlagSA:='r';
          case Noun2 of
        39:if(en('o'))then begin RL(186);Vanish(noun);
            kitset:=kitset+[noun];r[noun]:=Prm;end
           else RL(185);
        68:if(Prm=34)then
            if(SlotCon=Null)then begin RL(186);Vanish(noun);
             SlotCon:=Noun;r[noun]:=Prm;end
            else Say(68,'being used')
           else
            if(noun=63)and(Prm=58)then
             begin RL(337);KeyHole:=True;r[63]:=Prm;inven:=inven-[63];end
            else RL(327);
        88:begin RL(293);vanish(noun);r[noun]:=random(4)+51;end;
        47,53,73:if(Prm in[0..6,9,10,13,41..43])then
           begin RL(307);vanish(noun);end;
        11:if(en('k'))then begin RL(186);Vanish(noun);
            CabiSet:=CabiSet+[noun];r[noun]:=Prm;end
           else RL(187);
        26:if(Prm=76)and(noun=57)then begin RL(409);Vanish(57)end;
        49:if(PanelCon=Null)and(noun in[2,7,8,13,27,32,51,52,63,77])then
            begin RL(186);Vanish(noun);PanelCon:=Noun;r[noun]:=Prm;end
           else RL(188);
        30:if(noun=70)then
            if not(en('d'))then
             begin Ev:=Ev+['d'];RL(69);Vanish(70);r[70]:=Prm;end
            else Say(70,'in the dirt')
           else Crazy
          end;{of case}

          if(FlagSA<>'s')then
           begin
            if(SepWord='to')then
             if(noun2 in[4,6,9,11,14,16,22,30,50,59,61,64,65,69,75])then
              begin RL(186);Vanish(noun);r[noun]:=Prm;end
             else RL(197);
            if(SepWord='at')or(SepWord='near')or(SepWord='behind')then
             if(noun2 in[0,4,6,9,11,12,14,16,17,20..23,26,28,30,35,39,43,
                         50,53,54,59,61,62,64..69,72,73,75,78..80])then
              begin RL(186);Vanish(noun);r[noun]:=Prm;end
             else RL(197);
            if(SepWord='under')then
             if(noun2 in[4,15,16,20,23,59,60,61,75])then
              begin RL(186);Vanish(noun);r[noun]:=Prm;end
             else RL(197);
            if(SepWord='in')then
             if(noun2 in[6,16,43,47,30,50,59,64,65,72,78,80,84])then
              begin RL(186);Vanish(noun);r[noun]:=Prm;end
             else RL(197);
            if(FlagSA<>'s')then Crazy;
           end
          end
         else writeln('First you must have the ',n[noun,1],'.')
        else Crazy;

  end {of case}
end;  {of DefaultAnswers2}
{-------------------}
  procedure DefaultAnswers3;
{var o : integer;}
begin

CASE VERB OF

31,63      :if(Verb=63)and(Prm<>MnRm)then RL(395)
            else
             if(Prm=MnRm)then
              begin Attack:=False;
               if(input='hi')or(input='hello')or(input='bye')then RL(396)else
               if(copy(input,1,6)='follow')then RL(397)else
                case random(5) of
                 0:RL(365);1:RL(398);2:RL(399);3:RL(400);4:RL(401)
                end
              end
             else RL(123);

33         :RL(124);

38         :case noun of
             83:RL(262);
             23:begin RL(366);DropAll;Ev:=Ev+['r'];Attack:=False end
             else RL(125);
            end;

16         :if(MnRm=Prm)then begin Attack:=False;RL(372)end else
            if(en('r'))then RL(373)else
            if(Prm<15)and(70 in p[12])then RL(374)else  RL(371);

19         :if(noun=Null)then RL(136)else Crazy;
24         :if(noun=7)then RL(422)else
            if(noun in[26,6,7,22,36,17,50,65,73,74,80,79,30,84])then RL(126)
            else Crazy;
21         :RL(127);
40         :Crazy;

8          :if(noun in[73,80])or(noun=Null)then
             if(noun<>Null)then RL(36)
             else if(here(73))or(here(80))then RL(36)else RL(37)
            else RL(53);

12         :RL(38);
2          :if(noun in[4,35,39,8,11,12,14,20,21,30,57,43,59,67,70,75])then
              RL(43)else RL(44);

15         :if(noun in mov)then
             if(sepword='to')then
              if(noun2=23)then
               begin RL(62);Vanish(noun);Attack:=False end
              else Crazy
             else RL(60)
            else RL(61);

1          :if(verbose)then
              begin verbose:=false;RL(134);end
             else begin verbose:=true;RL(135);end;

13         :RL(77);
23         :RL(78);

60         :case noun of
            43,12:RL(252);
            35:RL(288)
            else RL(78);
            end;

25         :if(Prm>62)and(Noun in[9,18,19,41])then RL(350)else RL(78);
34         :RL(79);

  end {of case}
end;  {of DefaultAnswers3}
{-------------------}
  procedure DefaultAnswers4;
{var o : integer;}
begin

CASE VERB OF

20         :RL(81);
35         :RL(82);

6          :if(noun=23)and(here(40))then begin vanish(40);RL(84);end
             else
              if here(40)then
               if(noun2=Null)or(noun2=40)then
                case noun of
                 57:RL(259);
                 60:RL(260)
                 else writeln('At the last moment you decide to spare',
                       ' the ',n[noun,1],'''s life!')
                end
               else Crazy
              else RL(83);

30         :if(noun in [39,43,12,26,6,22,47,49,68,78,17,11,
               50,65,73,74,80,79,30])then RL(93) else RL(94);

54         :begin write('Would you like to SAVE your game first (Y or N)?  ');
             flag:=readkey;if(upcase(flag)<>'N')then SAVE else writeln('No.');
             write('Are you still sure you want to quit? ');
             flag:=readkey;if(upcase(flag)='Y')then
              begin RL(367);delay(999);window(1,1,80,25);clrscr;close(rooms1);
               close(rooms2);close(special1);close(special2);close(line1);
              HALT end else RL(264)end;
53         :if(Prm in[27,30])then RL(123) else RL(145);
59         :If(noun=23)then RL(368)else Diagnose;

55         :if(noun=74)then
              if(en('p'))then
                begin Ev:=Ev-['p'];RL(169);end
              else RL(168)
            else
            if(noun=89)then
              if(en('i'))then
                begin
                 Ev:=Ev-['i'];RL(322);
                 if(Prm in[59,63..68])then begin RS(66);DEAD;end;
                end
              else RL(323)
            else Crazy;

56     :if(noun=Null)or(noun in[60,23])or(noun in Mov)then
         case noun of
          23:RL(369);
          60,Null:RL(193);
          7:RL(194)
          else RL(195);
         end
        else RL(196);

3       :case noun of
         7:RL(235);
         2:if(en('b'))then RL(236)else RL(237);
         62:RL(238);
         65:RL(239);
         74:RL(240);
         78:RL(241);
         84,40,50,68,85:RL(242)
         else Crazy;
        end;

7      :begin if(noun=Null)then noun:=30;
         if(noun in[30,36,47,50,71,72,79])then
          case noun of
           30,47,50,71:if(Prm in[5..22,44..49])then RL(247) else RL(248);
           36:RL(249);
           72:RL(250);
           79:RL(251);
          end
         else Crazy;
        end;


  end   {of CASE.}
end;    {of DefaultAnswers4}
{-------------------}
  procedure DefaultAnswers5;
{var o: integer;}
begin

CASE VERB OF

9         :if noun<>1 then
             if(noun in Inven)then
               if(noun=74)and(en('p'))then RL(170)
          else if(noun=89)and(en('i'))then RL(335)
          else begin
                 inven:=inven-[noun];writeln(n[noun,1],': Dropped.');
                 R[noun]:=Prm;
               end
             else
               writeln('You don''t have the ',n[noun,1],'.')
           else
             begin
              if(74 in inven)and(en('p'))then RL(170)else
              if(89 in inven)and(en('i'))then RL(335)else
              DropAll;
            end;

26        :case noun of
         2:if not(en('b'))then
              begin
                Ev:=Ev+['b'];
                RL(3);end
            else Say(noun,'peeled');
         7:RL(162);
        57:if(ropecon<>Null)then
              begin
                ropecon:=Null;
                RL(117);end
            else Say(noun,'untied');
        62:RL(238)
         else Crazy;
         end; {end of OPEN }

  end {of case}
end;  {of DefaultAnswers5}
{-------------------}
  procedure DefaultAnswers6;
{var o : integer;}
begin

CASE VERB OF

28,27     :case noun of
           23:RL(369);
           29:if not(en('a'))then
                begin Ev:=Ev+['a'];
                RL(120);end
              else begin Ev:=Ev-['a'];
                RL(121);end;
           57:if(ropecon<>Null)and not(ropecon in inven)
                    and(r[ropecon]<>Prm)then
                  if(ropecon in mov)then begin
                    RL(57);writeln('...it''s a ',n[ropecon,1],'!');
                    r[ropecon]:=Prm;Ev:=Ev-['u'];
                    if(ropecon=29)and not(flasoff)then DescribeRm;end
                  else RL(56)
               else RL(122);
           8:begin RL(243);RL(244);play(9999,3500,0);play(3499,2000,1);
              play(1999,1000,2);play(999,200,5);play(199,8,16);Ev:=Ev+['e'];
              n[36,5]:=Q;n[78,5]:='glass';n[68,1]:='slot';n[66,4]:=Q;
              Ev:=Ev-['j'];
              moveto(30);
              if(MnRm=Prm)then RS(73);
             end;
           81:if not(en('j'))then
               if KeyHole then
                begin Ev:=Ev+['j'];RL(326);play(2000,2001,200);end
               else RL(123)
              else
               begin Ev:=Ev-['j'];
                if Keyhole then begin RL(326);play(2001,2000,200)end
                else RL(123);
                if(Prm in[59..68])then begin nosound;RS(62);DEAD;end;
               end;
           36:begin
               if(Prm > 57)then if(Prm = 58)then RL(123)else
                begin RS(63);DEAD;end;
              end
             else RL(122);
           end; {of case}

62         :begin write('You have ',Sc,' of 1000 points',
                        ', giving you the rank of ');Tic:=Tic-1;
              case Sc of
              0..99:writeln('beginner.');
              100..249:writeln('novice adventurer.');
              250..399:writeln('adventurer third class.');
              400..549:writeln('adventurer second class.');
              550..699:writeln('adventurer first class.');
              700..849:writeln('expert adventurer.');
              850..999:writeln('master adventurer.')
              else writeln('dead adventurer!')
              end;
            Attack:=False;
            if(MnRm=Prm)then RL(370)
            end;

  end {of case}
end;  {of DefaultAnswers6}
{-------------------}
  procedure DefaultAnswers7;
var o : integer;
begin

CASE VERB OF

14      :if(noun<>1)then
          if(noun in Mov)then
           if not(noun in inven)then
            begin
            Stuff:=0;
            for o:=0 to NMax do if(o in inven)then Stuff:=Stuff+1;
            if(Stuff < 6)then
             if(en('r'))and(inven<>[])then RL(87)
             else begin
                   Vanish(Noun);inven:=inven+[noun];
                   writeln(n[noun,1],': Taken.');
                   if(noun=70)then Ev:=Ev-['d'];
                  end
            else RL(234)
            end
           else writeln('You already have the ',n[noun,1],'.')
          else Crazy
         else if(en('r'))then RL(88) else
            begin flag:='0';Stuff:=0;
             for o:=0 to NMax do if(o in inven)then Stuff:=Stuff+1;
             if(Stuff < 7)then
              for o:=0 to NMax do
               begin
                if r[o]=Prm then
                 if(Stuff+1 < 7)then
                  begin
                   vanish(o);inven:=inven+[o];Stuff:=Stuff+1;
                   writeln(n[o,1],':  Taken.');flag:='1';
                   if(o=70)then Ev:=Ev-['d'];
                  end
                 else
                  begin flag:='1';
                  writeln(n[o,1],': You have too many objects already!');end
               end
             else RL(234);
             if(flag='0')then RL(49)
            end; {of 14}

4,5       :RL(420);

64        :SAVE;

  end {of case}
end;  {of DefaultAnswers7}
{-------------------}
  procedure DefaultAnswers8;
{var o : integer;}
begin

CASE VERB OF

10         :if(noun in [2,52])then
              if(noun=2)then
                if(en('b'))then begin
                  RL(45); Ev:=Ev+['c'];inven:=inven+[51];
                  Vanish(2);Sc:=Sc+10;end
                else RL(46)
              else begin RL(47);Ev:=Ev+['n'];Sc:=Sc+15;Vanish(52);end
            else writeln('I don''t think the ',n[noun,1],
                         ' would do much for your digestive system!');

42         :case noun of
            74:if not(en('p'))then
                if not(en('i'))then
                 begin RL(20);inven:=inven+[74];r[74]:=Null;Ev:=Ev+['p'];end
                else RL(320)
               else Say(74,'on');
            89:if not(en('i'))then
                if not(en('p'))then
                 begin RL(319);vanish(89);inven:=inven+[89];Ev:=Ev+['i'];end
                else RL(318)
               else Say(89,'on your head')
            else RL(128);
            end;

17,0       :if(noun2=Noun)then Crazy else
            if(noun2 in Mov)or(Noun2=Null)then
            case Noun of
             2:begin RL(21);Vanish(2);Sc:=Sc+25;r[51]:=Prm;end;
             60:begin RL(22);DEAD;end;
             52:begin RL(34);Vanish(52);end;
             23:if(noun2=null)then RL(369)
                else begin Vanish(noun2);Attack:=False;
                 writeln('The monster grabs the ',n[noun2,1],' and eats it!');
                     end;
             7:begin RL(35);Vanish(7);r[52]:=Prm;Ev:=Ev+['I'];end
             else if(verb=0)then writeln('At the last moment you decide to',
                 ' spare the ',n[noun,1],'''s life!')
                  else RL(216);
             end{of case}
             else Crazy;

39         :if((SepWord='to')or(SepWord='off'))and(Noun2=Null)then
             case Noun of
              29:if(SepWord='to')then begin Ev:=Ev+['a'];RL(120);end
                 else begin Ev:=Ev-['a'];RL(121);end;
              13:RL(148);
              20:RL(149);
              65:RL(150)
             else Crazy end
            else RL(80);

  end {of case}
end;  {of DefaultAnswers8}
{-------------------}
  procedure DefaultAnswers9;
{var o : integer;}
begin

CASE VERB OF

32    :if(34 in inven)then
        if(shots>0)then
         begin
         Shots:=Shots-1;
         for x:=1 to (26-(4*(6-Shots))) do
            begin play(300,350,11-Shots*2);play(320,370,11-Shots*2);end;
          if(noun=34)and(noun2<>34)and(noun2<>Null)and(SepWord='at')then
             begin noun:=noun2; noun2:=34; SepWord:='with';end;
          if((noun2=34)and(noun<>34)and(SepWord='with'))or
            ((noun<>34)and(SepWord='s'))then
      case noun of
       1:begin;Crazy;Shots:=Shots+1;end;
       2,7,8,13,27,29,32,40,51,52,63,74,77,89:begin vanish(noun);
          writeln('The ',n[noun,1],' vanishes in an explosion of light!');
            if(noun=74)and(en('p'))then begin RL(232);DEAD;end;
         end;
       48:begin RL(222);RL(223);Ev:=Ev+['g'];p[40]:=p[40]-[48];
           if not(en('P'))then begin Ev:=Ev+['P'];Sc:=Sc+25;end;end;
       12,26:RL(224);
       23:begin case random(4)of 0:RL(375);1:RL(376);2:RL(377);3:RL(378)end;
           Attack:=False;
          end;
       45:RL(315);
       60,56,44:begin RL(233);DEAD;end
       else writeln('A blinding ray strikes the ',n[noun,1],', but it is',
                      ' only slightly blackened.');
      end {of shoot case}
          else if(noun=34)and(noun2=Null)then RL(213)
          else begin;Crazy;Shots:=Shots+1;end;
         end
        else begin writeln('...click!');play(25,32,9);end
       else RL(208);

  end {of case}
end;  {of DefaultAnswers9}
{-------------------}
  procedure DefaultAnswers10;
{var o : integer;}
begin

CASE VERB OF

36         :if(noun in mov)then
             if(noun in inven)then
              if((noun in[2,7,52,29])or
                 (noun2 in[2,7,23,29,47,52,53,73,88]))and(noun<>noun2)then
               begin
                if(noun=2)or(noun2=2)then begin RL(95);vanish(2);
                  r[51]:=Prm;end;
                if(noun=7)or(noun2=7)then begin RL(35);vanish(7);
                  Ev:=Ev+['I'];r[52]:=Prm;end;
                if(noun=29)or(noun2=29)then begin RL(96);vanish(29);end;
                if(noun=52)or(noun2=52)then begin RL(34);vanish(52);end;
                if(noun2=88)then begin RL(293);vanish(noun);
                  if(noun=2)then noun:=51;if(noun=7)then noun:=52;
                  r[noun]:=random(4)+51;end;
                if(Prm in[0..6,9,10,13,41..43])and(noun2 in[73,53,47])then
                  begin RL(306);vanish(noun);end;
                if(noun2=23)then begin Attack:=False;Vanish(noun);RL(379);
                  writeln(n[noun,1],' out of mid-flight and eats it',
                        ' in one giant gulp!')end;
               end
              else begin writeln('The ',n[noun,1],' collides with the ',
                n[noun2,1],' but nothing interesting happens.');
                Vanish(noun);r[noun]:=Prm;end
             else writeln('First you must have the ',n[noun,1],'.')
            else Crazy;

37         :if(noun=57)then
             if(sepword='to')then
              if not(noun2 in[1,15,17,22,30,46,47,50,52,72,73,79,80,83])then
               if(ropecon=Null)then begin
                ropecon:=noun2;
                writeln('The rope is firmly tied to the ',n[noun2,1],'.');
                if(noun2=57)then RL(48);end
               else writeln('It is already tied to the ',n[ropecon,1],'.')
              else RL(50)
             else Crazy
            else Crazy;

61         :begin RL(245);flag:=readkey;
             if(upcase(flag)<>'N')then
              begin RL(380);delay(999);window(1,1,80,25);clrscr;close(rooms1);
               close(rooms2);close(special1);close(special2);close(line1);
              { assign(rooms1,'BEYOND.com');}exec('beyond.exe', '')end
             else RL(264)
            end;

65        :RESTORE;

  end {of case}
end;  {of DefaultAnswers10}
{===================}
  procedure SpecialAnswers1;

begin
FlagSA:='r';
if Present then
CASE Prm OF

3       :case verb of
  44,58 :moveto(1);
  20,52 :if(noun=6)then RL(40);
    14  :if(noun=57)and not(en('o'))then RL(419);
   6    :if(noun=57)and(here(40))and((noun2=Null)or(noun2=40))then
             begin
               RS(4); tic:=15; moveto(4); Ev:=Ev+['A']; Sc:=Sc+25;
               if(en('o'))then
                 for o:= 0 to 57 do begin
                   if(o in kitset)then r[o]:=Prm;
                   if(r[o]=3)then r[o]:=Prm;end
             end;
   26   :if(noun=39)then
             if not(en('o'))then
               begin Ev:=Ev+['o'];RL(328); for o:=2 to 57 do
                 if(o in kitset)then r[o]:=Prm;end
             else Say(noun,'opened');
   3  :if(noun=39)then
             if(en('o'))then
               begin Ev:=Ev-['o'];RL(186); for o:=2 to 57 do
                 if(o in kitset)then r[o]:=Null;end
             else Say(noun,'shut');
  17,28,27 :if(noun in [6,57,39,59])then RL(29);
  24,11   :case noun of
       39  :if(en('o'))then
               if kitset=[] then begin RL(329);end
               else begin RL(330);for o:= 0 to 57 do
                   if(o in kitset)then writeln(' a ',n[o,1]);end
             else RL(331);
       57 :RL(10);
       73 :RL(19);
       6 :DescribeRm;
           end;
         end; {of 3}

4      :case verb of
   43..52,20:RL(7);
    55  :if(noun=35)then begin RL(332);Ev:=Ev-['B'];end;
  42,3:if noun=35 then begin RL(8); Ev:=Ev+['B'];end
           else if(noun=39)then
             if(en('o'))then
               begin Ev:=Ev-['o'];RL(186); for o:=0 to 57 do
                 if(o in kitset)then r[o]:=Null;end
             else Say(noun,'shut');
  29,37 :if(noun=35)and(noun2=60)then begin
             RL(8);Ev:=Ev+['B'];end;
   26   :if(noun=35)and(en('B'))then begin RL(332);Ev:=Ev-['B'];end
           else if(noun=39)then
             if not(en('o'))then
               begin Ev:=Ev+['o'];RL(328); for o:=0 to 57 do
                 if(o in kitset)then r[o]:=Prm;end
             else Say(noun,'opened');
   19,2:if(noun in[6,64])or(noun=Null)then
             if(en('B'))then RL(9)
             else begin RL(0);DEAD;end;
    24,11:case noun of
       39  :if(en('o'))then
               if kitset=[] then begin RL(329);end
               else begin RL(330);for o:= 0 to 57 do
                   if(o in kitset)then writeln(' a ',n[o,1]);end
             else RL(331);
       35 :RL(12);
       73 :RL(19);
       6 :DescribeRm;
           end;  {of case}
         end; {of 4}

end {of case}
else SA
end; {of SP1}
{-------------------}
  procedure SpecialAnswers2;

begin
FlagSA:='r';
if Present then
Case Prm of

5       :case verb of
   45   :moveto(6);
   2    :if(noun=79)then RL(263);
           end;

6       :case verb of
   46   :moveto(5);
  51..52:if FlasOff then RL(14)
         else case verb of
           43:begin Ox:=0;RL(286);moveto(7);end;
           45:moveto(9); 49:moveto(8);
              end;
             end; {of 6}

7       :case verb of
  23..25,11:if(noun in[6,36,73,0,15,64,67])then RS(9);
  43..50 :if FlasOff then RL(14)
          else
           begin
            If(Verb in[43,47,48])then Ox:=Ox+1;
            If(Verb in[44,49,50])then Ox:=Ox-1;
            if(Ox<1)then begin RL(286);moveto(6)end
            else
             begin
              RL(333);
              if(random(20)=2)then begin writeln;RS(9);
               if not(en('K'))then begin Ev:=Ev+['K'];Sc:=Sc+15;end;end;
             end;
           end;
  28,17,6:if(noun=36)or(noun=15)then begin RS(10);DEAD;end;
  31   :if(input='help')then begin RL(334);moveto(6)end;
         end;  {of 7}

8       :case verb of
   48,58:if FlasOff then RL(14) else moveto(6);
  43..47, 49..52:if FlasOff then RL(14);
  11:if(noun in [46,79])then RS(12)
         else if(noun in [15,30])then RL(28);
   38 :if(noun=46)then begin SA;writeln('It feels jagged.');end;
         end; {of 8}

9         :case verb of
   43..52 :if FlasOff then RL(14)
         else case verb of
           46:moveto(6);47:moveto(10);49:moveto(11);
              end;
           end; {of 9}

10        :case verb of
   50,58 :if FlasOff then RL(14)
         else moveto(9);
{   43..52:if FlasOff then RL(14);      }
  19,2:if(noun in[17,80])then begin RL(0);DEAD;end;
           end; {of 10}

end {of case}
else SA
end; {of SP2}
{-------------------}
  procedure SpecialAnswers3;

begin
FlagSA:='r';
if Present then
Case Prm of

14       :case verb of
   46,48 :if FlasOff then RL(14)
          else if(verb=46)then moveto(11) else moveto(15);
  43..45, 49..52 :if FlasOff then RL(14);
          end; {of 14}

15     :case Verb of
   52,2 :if(en('d'))and(en('t'))then
           begin RL(63);moveto(16);end else RL(64);
  19   :RL(64);
  7    :RL(65);
  14    :if(noun in[57,70])then begin inven:=inven+[noun];r[noun]:=Null;
           if(noun=70)then Ev:=Ev-['d']
           else Ev:=Ev-['t'];SA;writeln(n[noun,1],':  Taken.');end;
  45,49  :if(flasoff)then RL(14) else moveto(14);
   44    :RL(73);
  24,11:if(noun=17)and not(en('u'))then RL(74)
           else if(noun=17)and(en('a'))then RL(75);
  17,36,29,9:case noun of
   70:if((noun2 in[30,42])or(noun2=Null))and(verb<>9)then
         if not(en('d'))then
          begin RL(69);Ev:=Ev+['d'];r[70]:=Prm;inven:=inven-[70];end
         else RL(67)
        else if(verb=9)then begin end else RL(66);
   57:if(noun2=17)and(verb<>17)then begin
          if(here(ropecon))and(ropecon<>57)then begin
            RL(71);inven:=inven-[57];r[57]:=Prm;
            if(ropecon=70)then Ev:=Ev+['t'];end
          else begin RL(70);vanish(57); end;
         end else begin end
   else if(verb in[9,29,36])and(noun2=17)and(noun in mov)then
         if(here(ropecon))and(noun=ropecon)then begin RL(76);
          inven:=inven-[noun];r[noun]:=Null;
          if(ropecon=29)then Ev:=Ev+['u'];end
         else begin RL(72);inven:=inven-[noun];r[noun]:=17;end
      end;{of noun case}
         end;{of 15}

16       :case verb of
   51,2   :moveto(15);
   52    :RL(85);
  0,3..18,20..21,26..40,42,53,55,56,60:RL(86);
   19,61:begin RS(18);Ev:=Ev-['a'];Ev:=Ev+['r'];Sc:=Sc+60;
          moveto(17);dropall;if(here(2))then begin r[2]:=Null;
          r[51]:=Prm;end;r[57]:=Null;end;
         end;{of 57}

end  {of Case}
else SA
end; {of SP3}
{-------------------}
  procedure SpecialAnswers4;

begin
FlagSA:='r';
if Present then
Case Prm of

19      :case verb of
   48,51,58:if(flasoff)then RL(14)else begin RL(311);moveto(18);end;
   47,52,57:if(flasoff)then RL(14)else begin RL(309);moveto(20);end;
         end;{of stairs}

20      :case verb of
   50,51,58:if(flasoff)then RL(14)else begin RL(310);moveto(19);end;
   11,24,25,23:if(noun=67)then RL(90)
     else if(noun in[12,43])and not(en('E'))then begin RL(92);
            r[32]:=20;Sc:=Sc+15;Ev:=Ev+['E'];end;
  14,38:if(noun in[67,12])then RL(91);
  43..49,57:if(noun=Null)or(noun in[12,43])then RL(215);
        end;{of 20}

21       :case verb of
    50   :if(flasoff)then RL(14)else moveto(18);
    47   :if(flasoff)then RL(14)else moveto(22);
   2,51:if(flasoff)then RL(14)else
            if(noun=64)or(noun=Null)then moveto(23);
    45   :RL(97);
    49,44,43:RL(258);
  11     :if(noun in[30,64])then begin RL(255);RL(256);RL(257)end;
        end;

22       :case verb of
    50   :if(flasoff)then RL(14)else moveto(21);
    2,51 :if(flasoff)then RL(14)else
            if(noun=64)or(noun=Null)then moveto(23);
    44   :RL(97);
    47,45,49:RL(258);
    11     :if(noun in[30,64])then begin RL(255);RL(256);RL(257)end;
        end; {of 22}

23      :case verb of
   46,50 :if(flasoff)then RL(14)else moveto(21);
   43,48 :if(flasoff)then RL(14)else moveto(22);
   44..45,47, 49:RL(258);
   26,27 :if(noun=26)then
           if(en('l'))then Say(26,'open')
           else begin RL(98);Ev:=Ev+['l'];p[23]:=p[23]+[69];end;
    3    :if(noun=26)then
           if(en('l'))then begin RL(171);Ev:=Ev-['l'];p[23]:=p[23]-[69];end
           else Say(26,'closed');
  2,52,57:if(en('l'))and((noun=69)or(noun=Null))then moveto(24)else RL(99);
  24,25  :if(noun=26)then RL(151);
   11    :if(noun=26)then if(en('l'))then RL(217)else RL(218)
          else if(noun in[30,64])then begin RL(255);RL(256);RL(257)end;
        end; {of 23}

24      :case verb of
   51,58:if(en('l'))then moveto(23) else RL(99);
   52,57:moveto(25);
  24,25 :if(noun=26)then RL(151);
   3    :if(noun=26)then begin RL(171);Ev:=Ev-['l'];end else
         if(noun=55)then RL(411);
   2    :if(noun=69)then Moveto(25);
   26   :if(noun=26)then begin RL(98);Ev:=Ev+['l'];end else
         if(noun=55)then RL(412);
   11   :if(noun=26)then if(en('l'))then RL(217)else RL(218)else
         if(noun=55)then RL(410);
   27,28:If(noun=55)then RL(411);
       end;

end   {of case}
else SA
end;  {of SP4}
{-------------------}
  procedure SpecialAnswers5;

begin
FlagSA:='r';
if Present then
Case Prm of

25     :case verb of
     43:begin writeln('The door slides open...');play(55,70,40);moveto(27);
         writeln('The door slides shut behind you.');play(70,55,40);
         if not(en('Y'))then begin Ev:=Ev+['Y'];Sc:=Sc+30 end end;
     44:moveto(32); 45:moveto(30);
     46:moveto(34); 47:moveto(28); 49:moveto(31);
     48:if(en('v')and not(en('p')))then begin Verbose:=False;moveto(35);
          RS(25);DEAD; end else moveto(35);
     50:moveto(33); 51,58:moveto(24);
     52,2:if(noun=69)or(noun=Null)then moveto(26);
     17,27,28,38:if(noun=26)then
          begin RL(413);play(55,70,45);play(69,54,45)end;
   26,40:if(noun=26)then RL(414);
        end;

27      :case verb of
   44,58:begin writeln('The door slides open...');play(55,70,40);moveto(25);
          writeln('The door slides shut behind you.');delay(999);play(70,55,40)
         end;
     17,27,28,38:if(noun=26)then
          begin RL(413);play(30,40,25);play(40,30,25)end;
   26,40:if(noun=26)then RL(414);
   11  :if(noun in[20,21])then RL(103)
      else if(noun=58)then case compcon of
        Null:RL(155); 1:RS(21); 2:RS(22); 3:RS(23);
        4:begin RS(24);compcon:=Null;gotoxy(1,wherey-1);
           writeln('. tim. chamb.r c.de: ',Code,'.. ..tel.port...  .  .',
                   '... . .. ime .  p.n.l ....... ...');
           RL(105);play(29,29,40);end;end;{of case}
   53  :begin
         if(input='1')or(input='one')then begin RL(104);compcon:=1;end;
         if(input='2')or(input='two')then begin RL(104);compcon:=2;end;
         if(input='3')or(input='three')then begin RL(104);compcon:=3;end;
         if(input='4')or(input='four')then begin RL(104);compcon:=4;end;
         for y:=1 to random(40)+9 do
          begin x:=random(6000)+99;play(x,x,50);delay(9)end
       end;
   31   :if(compcon=null)then begin
          play(9,999,0);sound(999);RS(20);play(999,9,0);if not(en('J'))then
          begin Ev:=Ev+['J'];Sc:=Sc+40;end;end;
       end;

28     :case verb of
   50,58:moveto(25);
   45,57:moveto(29);
   28   :if(noun in[33,10])then begin RL(137);play(31,31,450);end;
       end;

29    :case verb of
   46,58:moveto(28);
   36   :if(noun2 in[33,10])and(noun in Mov)then
           if(en('M'))then
             begin RS(27);Ev:=Ev-['M','r'];Vanish(noun);r[noun]:=28;
               if not(en('N'))then begin Ev:=Ev+['N'];Sc:=Sc+55;end;
             play(28,34,600)end
           else begin Vanish(noun);r[noun]:=28;RL(179);
             if(noun in[7,8,29,34,40,51])then Ev:=Ev+['M'];end;
       end;

33     :case verb of
   47,58:moveto(25);
    34  :RL(272);
   28,38:if(noun=10)then begin RL(421);x:=random(9999);case random(3) of
          0:play(x,random(9999),random(3));
          1:for y:=1 to random(300)+60 do
             begin x:=random(9999);play(x,x,2);delay(7)end;
          2:begin y:=9999;o:=0;
             repeat x:=random(9999);play(x,y,0);
                    y:=random(9999);play(y,x,0);o:=o+1;
             until o>7 end end end
       end;

end {of case}
else SA
end; {of SP5}
{-------------------}
  procedure SpecialAnswers6;

begin
FlagSA:='r';
if Present then
Case Prm of

30   :case verb of
   46,58:if(en('e'))then RL(212) else moveto(25);
   26,27,28,40:if(noun=49)then if(en('h'))then Say(49,'open') else RL(159)
               else
                if(noun in[10,76])and(verb=28)then
                 begin
                 if(MnRm=30)then begin RS(76);DEAD;end;
                  if(en('e'))then
                   begin RS(29);writeln;
                    play(1,700,7);play(701,8000,1);Ev:=Ev-['e'];
       case YearDial of
              1933:begin Loc:='Civilization!';Sc:=Sc+80;RS(78);HOME;END;
        2111..2679:begin
                     Verbose:=False;moveto(41);RS(30);Verbose:=True;
                     if not(en('O'))then begin Sc:=Sc+55;Ev:=Ev+['O'];end;
               n[78,5]:=Q;n[37,5]:='glass';n[72,1]:='fence';
               n[70,1]:='hooded figure';n[70,2]:='hooded';n[70,3]:='figure';
               n[70,4]:='mutant';n[70,5]:=Q;n[3,1]:='footprints';
               n[3,2]:='footpri';n[57,1]:='parachute';n[57,2]:='parachu';
               n[35,1]:='boulder';n[35,2]:='rock';n[35,3]:='rocks';
               n[66,4]:='red';
                   end;
        0..1111   :begin writeln;RS(31);DEAD;end;
        1112..1932, 1934..2110:begin writeln;RS(32);DEAD;end;
        2680..3789:begin writeln;RS(33);DEAD;end
             else  begin writeln;RS(34);DEAD;end;
       end; {of YearDial case}
                   end
                  else begin RL(209);play(1,9999,0)end;
                 end;
   33   :if(noun in[16,59])or(noun=Null)then begin Ev:=Ev+['e'];RL(210);end;
   35   :if(en('e'))then begin Ev:=Ev-['e'];RL(211);Attack:=False end;
   17,0,6:if(noun=49)then RL(160);
   53  :if(input=Code)then
         If(en('h'))then Say(49,'open')
         else
          begin Ev:=Ev+['h'];RL(173);play(23,24,250);Sc:=Sc+30;
            if(PanelCon<>Null)then begin r[PanelCon]:=30;Code:='R';
             writeln('Sitting inside the panel compartment is a ',
                      n[PanelCon,1],'.');end
            else RL(183);
          end
        else RL(172);
   3   :If(noun=49)then RL(159);
   39  :if(noun=25)then RL(115) else
        case noun of
        24:if(DialNum>0)and(DialNum<377)then begin RL(176);DayDial:=DialNum;end
           else RL(178);
        82:if(DialNum>-1)and(DialNum<5000)then begin RL(177);
             YearDial:=DialNum;end else RL(178);
        end;
 11,24:case noun of
   49:begin SA;if(en('h'))then if(PanelCon=Null)then RL(183)
                 else writeln('Inside the compartment is a ',n[PanelCon,1],'.')
               else RL(184);end;
   82:begin SA;writeln('The year dial is set to ',YearDial,'.');end;
   24:begin SA;writeln('The day dial is set to ',DayDial,'.');end;
   16:begin RL(203);RL(204)end;
   25:RL(115);
   38:RL(161);
      end;
       end; {of 30}

end  {of case}
else SA
end; {of SP6}
{-------------------}
  procedure SpecialAnswers7;

begin
FlagSA:='r';
if Present then
Case Prm of

26     :case verb of
  51,58,2:if(noun=69)or(noun=Null)then moveto(25);
  43,48 :moveto(36); 44,49 :moveto(38); 45,47 :moveto(39); 46,50 :moveto(37);
        end;

35      :case verb of
   49,58:moveto(25);
  11:case noun of
    54:RL(100);
    62:if(en('v'))then RL(205)else RL(206);
    end;
  28  :if(noun in[55,10])then
        if(en('v'))then begin RL(101);Ev:=Ev-['v'];play(40,65,80)end
        else
         begin RL(102); Ev:=Ev+['v'];play(65,40,80);
          if not(en('p'))then begin RS(28);DEAD;end
          else if(MnRm=35)then
           begin n[23,1]:='melted monster';n[23,4]:='melted';MnRm:=Null;
            RS(74);p[35]:=p[35]+[77];
            if not(en('W'))then begin Sc:=Sc+65;Ev:=Ev+['W'] end
           end
         end;
  14  :if(noun in[1,77])and(77 in p[35])then begin Sc:=Sc+10;noun:=77;end;
  55  :if(noun=74)then
        if(en('v'))then begin RS(26);DEAD end;
  38 :RL(30);
       end;

36     :case verb of
  44,49,58:moveto(26);
    45  :moveto(39);
    46  :moveto(37);
    57  :if(noun=12)then RL(215);
        end;

37     :case verb of
  45,47,58:moveto(26);
    43  :moveto(36);
    44  :moveto(38);
    57  :if(noun=12)then RL(215);
        end;

38     :case verb of
  43,48,58:moveto(26);
    45  :moveto(39);
    46  :moveto(37);
    57  :if(noun=12)then RL(215);
   0..42,44,47,49..56,59..99:if(noun=28)or(noun2=28)then
          begin RS(35);RL(220);p[40]:=p[40]+[48];moveto(40);Ev:=Ev-['g'];
           if(MnRm=Prm)then begin RS(79);DEAD end
          end;
        end;{of 38}

39     :case verb of
  46,50,58:moveto(26);
    45  :if(en('g'))then moveto(40);
    3   :if(noun=26)then if(en('g'))then RL(225) else Say(26,'shut');
    43  :moveto(36);
    44  :moveto(38);
    57  :if(noun=12)then RL(215);
        end;

40     :case verb of
  46,58 :if(en('g'))then moveto(39) else RL(221);
   26   :if(noun=26)then if(en('g'))then Say(26,'open') else RL(221);
   3    :if(noun=26)then if(en('g'))then RL(225) else Say(26,'shut');
  11,14 :if(noun in[12,43,83])then RL(261);
       end;

end  {of case}
else SA
end; {of SP7}
{-------------------}
  procedure SpecialAnswers8;

begin
FlagSA:='r';
if Present then
Case Prm of

41     :case verb of
    43  :moveto(42);
    44  :moveto(43);
  2,19  :if(noun in[53,73,87])then
           begin RS(39);RL(287);moveto(46);Rx:=4;end;
       end;

42     :case verb of
    44  :moveto(41);
    43  :RL(296);
    14  :if(noun in[13,1])and(13 in p[42])then
          begin Sc:=Sc+10;noun:=13;end;
  2,19  :if(noun in[53,73,87])then
           begin RS(39);RL(287);moveto(46);Rx:=4;end;
       end;

43     :case verb of
    43  :moveto(41);
    44  :moveto(44);
  2,19  :if(noun in[53,73,87])then
           begin RS(39);RL(287);moveto(46);Rx:=4;end;
        end;

44     :case verb of
    43  :moveto(43);
    46  :moveto(47);
    45  :begin RL(274);Rx:=0;moveto(46);end;
  47..51,2,19:if(noun=Null)or(noun in[41,79])then RL(275);
       end;

45     :case verb of
    44  :moveto(49);
    46  :begin RL(274);Rx:=8;moveto(46);end;
    45  :begin Rx:=9;RL(274);moveto(46);end;
  47..51,2,19:if(noun=Null)or(noun in[41,79])then RL(275);
        end;

46     :case verb of
    45  :begin Rx:=Rx+1;RL(274);
          if(Rx=9)then begin
          if not(en('T'))then begin Ev:=Ev+['T'];Sc:=Sc+30;end;
          moveto(45)end;
          if(Rx>86)then begin RL(340);moveto(47)end
         end;
    46  :begin Rx:=Rx-1;RL(274);
          if(Rx=8)then moveto(45);
          if(Rx<1)then moveto(44);
         end;
  43,44,47..51,2,19:if(noun=Null)or(noun in[41,79])then RL(275);
        end;

47     :case verb of
  46,52,2,19:begin if(random(2)=1)then begin RS(37);DropAll;moveto(48)end
                   else begin RL(277);moveto(48)end;end;
    45  :moveto(44);
  43..44,47,49..50:RL(278);
        end;

48     :case verb of
  45,51,2:if(random(3)=2)and(noun<>35)then begin RS(38);moveto(47)end
          else if(noun<>35)then RL(279);
   43,44,46..50:RL(279);
     14  :if(noun in[27,1])and(27 in p[48])then
           begin Sc:=Sc+20;noun:=27;end;
     11 :if(noun=35)then RL(289)
        end;

end  {of case}
else SA
end; {of SP8}
{-------------------}
  procedure SpecialAnswers9;

begin
FlagSA:='r';
if Present then
Case Prm of

50     :case verb of
  43,58 :begin RL(290);moveto(49);end;
  44,57 :if(noun=Null)or(noun in[88,26,50])then
          begin RS(41);if not(en('L'))then
           begin Ev:=Ev+['L'];Sc:=Sc+25;end;moveto(51);end;
    11  :case noun of
          35,50:RL(292);
          88,68:RS(42);
          46,66:RS(43);
         end;
  30,28,38,17,14:if(noun=88)then RL(294);
        end;

51     :case verb of
    44  :moveto(52);
    46  :moveto(52);
    48  :moveto(53);
        end;

52     :case verb of
    43  :moveto(51);
    47  :moveto(53);
    46  :moveto(51);
        end;

53     :case verb of
   52,2,57:if(noun=Null)or(noun=69)then begin if not(en('Q'))then
            begin Ev:=Ev+['Q'];Sc:=Sc+30;end;moveto(55);end;
    47  :moveto(52);
    45  :moveto(53);
    49  :moveto(54);
        end;

54     :case verb of
    43  :moveto(52);
    49  :moveto(53);
    44  :moveto(51);
    50  :begin if not(en('R'))then
          begin Ev:=Ev+['R'];Sc:=Sc+20;end;moveto(56);end;
        end; {verb case}

55     :case verb of
  51,2,58,44:if(noun=Null)or(noun=69)then moveto(53);
   11   :if(noun in[11,45])then
          begin RL(297);if(en('k'))then RL(298) else RL(299)end;
   26,40:if(noun in[45,26,11,68])and(noun2=27)and(SepWord='with')then
           if not(en('k'))then
            begin Ev:=Ev+['k'];RS(45);for o:=2 to NMax do
             if(o in cabiset)then r[o]:=55;
             if not(en('R'))then begin Ev:=Ev+['R'];Sc:=Sc+55;end;
            end
           else Say(11,'open')
          else if(SepWord='s')then RL(317);
   29   :if(noun=27)and(noun2 in[45,26,11,68])and(SepWord='in')then
          if not(en('k'))then
           begin Ev:=Ev+['k'];RS(45);for o:=2 to NMax do
            if(o in cabiset)then r[o]:=55;
            if not(en('R'))then begin Ev:=Ev+['R'];Sc:=Sc+55;end;
           end
          else RL(216);
   3    :if(noun in[45,26,11])then
          if(en('k'))then
           begin RL(314);play(30,32,30);Ev:=Ev-['k'];
            for o:= 2 to NMax do if(o in cabiset)then r[o]:=Null;
           end
          else Say(11,'shut & locked');
  24,30 :if(noun in[26,11])then
          if(en('k'))then
           begin RL(324);
            if(cabiset=[])then RL(339)else
             for o:=0 to NMax do if(o in Cabiset)then writeln('a ',n[o,1])
           end
          else RL(299);
       end; {of 55}


end  {of case}
else SA
end; {of SP9}
{-------------------}
  procedure SpecialAnswers10;

begin
FlagSA:='r';
if Present then
Case Prm of

56     :case verb of
    47  :moveto(54);
  2,51,58:if(noun=Null)or(noun=69)then moveto(57);
        end;

57     :case verb of
   46,57,2,33:if(noun=Null)or(noun=65)then
          begin n[68,1]:='keyhole';n[68,4]:='slot';moveto(58)end;
   52   :moveto(56);
        end;

58     :case verb of
   45,58:moveto(57);
   43..44, 51,20:if(en('i'))and(en('j'))and KeyHole then
         begin sound(38);RS(61);ShRm:=2;moveto(59);sound(20);
         for o:=0 to NMax do if(r[o]=58)then r[o]:=59;
         if not(en('S'))then begin Ev:=Ev+['S'];Sc:=Sc+60 end end else RL(325);
   28   :if(noun=10)then noun:=81;
   11   :if(noun=68)then if KeyHole then RL(336)else RL(404);
        end;

65     :case verb of
   43,47:moveto(66);
   44,49:moveto(68);
   45,57:begin if not(en('w'))then begin Ev:=Ev+['w'];RL(346);end
               else begin RL(347);DEAD end end;
   46,48, 50:moveto(63);
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(38);RL(344);delay(999);sound(20)end;
    52  :begin sound(30);RL(345);ShRm:=13;moveto(59);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end;

66     :case verb of
    43  :RL(343);
  46,50 :moveto(65);
  45,49 :moveto(67);
    47  :moveto(64);
    48  :moveto(63);
  57,44 :begin sound(25);if not(en('V'))then begin Ev:=Ev+['V'];Sc:=Sc+30;end;
          RS(67);writeln;moveto(69);nosound;
         end;
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(38);RL(344);delay(999);sound(20)end;
    52  :begin sound(30);RL(345);ShRm:=13;moveto(59);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end; {of 66}

67     :case verb of
    46  :begin RL(347);DEAD;end;
  43,48 :moveto(66);
  44,50 :moveto(68);
  45,47,49:moveto(64);
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(38);RL(344);delay(999);sound(20)end;
    52  :begin sound(30);RL(345);ShRm:=13;moveto(59);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end; {of 67}

end  {of case}
else SA
end; {of SP10}
{-------------------}
  procedure SpecialAnswers11;

begin
FlagSA:='r';
if Present then
Case Prm of

63     :case verb of
   45   :moveto(65);
   47   :moveto(66);
   49   :moveto(68);
  43..44,46,48,50:RL(343);
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(38);RL(344);delay(999);sound(20)end;
    52  :begin sound(30);RL(345);ShRm:=13;moveto(59);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end;

64     :case verb of
   46   :moveto(67);
   48   :moveto(66);
   50   :moveto(68);
  43..45, 47, 49:RL(343);
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(38);RL(344);delay(999);sound(20)end;
    52  :begin sound(30);RL(345);ShRm:=13;moveto(59);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end;

68     :case verb of
    43  :begin RL(347);DEAD;end;
    44  :RL(343);
    50  :moveto(63);
    49  :moveto(64);
  46,48 :moveto(65);
  45,47 :moveto(67);
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(38);RL(344);delay(999);sound(20)end;
    52  :begin sound(30);RL(345);ShRm:=13;moveto(59);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end;

69     :case verb of
  28,27 :if(noun in[10,21,81,36])then RL(351);
   11   :if(noun in[10,21,81,36,20,25])then RL(352)else
         if(noun=65)then RL(353);
  43,58 :moveto(70);
        end;

70     :case verb of
  44,57,2,33:if(noun=Null)or(noun=65)then moveto(69)else
         if(noun in[69,50])then moveto(71);
  43,47,48:RL(354);
  49,52 :moveto(71);
    11  :if(noun=65)then RL(353)
         else if(noun=68)then if KeyHole then RL(336)else RL(404);
       end;

71     :case verb of
  48,51,58:moveto(70);
    45  :moveto(72);
    11  :if(noun=58)then RL(386)else
         if(noun=25)then RL(418);
   28,27:if(noun in[10,36])then begin RL(387);
          for o:=1 to random(12)+4 do play(random(250),random(250),random(30))
         end;
    39  :if(noun=25)then begin RL(387);
          for o:=1 to random(99)+75 do
           begin x:=random(9999);play(x,x,random(19)+10);delay(5)end
         end
        end;{ of 71}

end  {of case}
else SA
end; {of SP11}
{-------------------}
  procedure SpecialAnswers12;

begin
FlagSA:='r';
if Present then
Case Prm of

11      :case verb of
   5,45,47,48,50:if FlasOff then RL(14)
          else case verb of
          48:moveto(9);47:moveto(13);
          5:if(29 in inven)or(40 in inven)or(2 in inven)then
                    RL(58)
                  else begin RL(18); moveto(12);end;
          50:RL(17);
          45:if(en('C'))then moveto(14) else RL(144);
            end;
   31   :if(input='nepo egassap')and not(en('C'))then
             begin Ev:=Ev+['C']; RS(11);Sc:=Sc+35;end;
  11 :if(noun in [79,72])then if(en('C'))then RL(270)else RS(13);
  27,28:if(noun in [79,72])then RL(26);
  17,0,6:if(noun in [79,72])then RL(27);
  38  :if(noun in [79,72])then RL(30);
          end; {of 11}

12     :case verb of
  4,47 :if FlasOff then RL(14)
           else case verb of
             4:begin RL(18); moveto(11);end;
               47   :RL(17);
                end;
  43..45,46,49,51,52  :if FlasOff then RL(14);
   14  :if(noun in[70,1])and not(en('G'))then
         begin noun:=70;Ev:=Ev+['G'];Sc:=Sc+40;end;
   7   :if not(en('G'))then begin Ev:=Ev+['G'];RL(157);
          FlagSA:='r';verb:=14;noun:=70;Sc:=Sc+40;end;
          end; {of 12}

13      :case verb of
   50    :if flasoff then RL(14)
            else begin moveto(11); Ev:=Ev-['q'];end;
   43    :if(en('q'))then begin RL(24); DEAD;end
            else begin RL(23); Ev:=Ev+['q'];end;
   52,19,33:RL(42);
  14    :if(noun=47)then RL(25);
  9   :begin RL(68);vanish(noun);end;
          end;{of 13}

17       :case verb of
   51,19,2:RL(15);
   45    :if(flasoff)then RL(14)else moveto(18);
          end;

18      :case verb of
   46    :if(flasoff)then RL(14)else moveto(17);
  49,52  :if(flasoff)then RL(14)else begin RL(308);moveto(19);end;
   47    :if(flasoff)then RL(14)else
           if not(en('F'))then begin RS(19);writeln;moveto(21);
            Ev:=Ev+['F'];Sc:=Sc+10;end
           else moveto(21);
  11     :if(noun in[79,50])then RL(254);
         end;{of 18}

end  {of case}
else SA
end; {of SP12}
{-------------------}
  procedure SpecialAnswers13;

begin
FlagSA:='r';
if Present then
Case Prm of

2         :case verb of
   46     :moveto(1);
   45, 44 :RL(1);
   19,2   :if(noun in[53,6,64,73])then begin RL(0);DEAD;end;
  14,27 :if noun=14 then RL(2)else
         if(noun in[1,40])and(40 in p[2])then
            begin noun:=40;Sc:=Sc+10;Verb:=14;RL(417);FlagSA:='r' end;
   11   :if(noun in[66,46])then RL(11);
   26   :if noun=14then RL(13);
         end;

31     :case verb of
   48,58:moveto(25);
   14   :if not(en('I'))and(noun in[7,1])then
           begin Ev:=Ev+['I'];noun:=7;Sc:=Sc+5 end;
 23,24,11:if(noun=84)then RL(152)else
          if(noun=22)then RL(415);
       end;

32     :case verb of
   43,58:moveto(25);
 11,23  :case Noun of
          61:if(en('H'))then RL(153) else begin Ev:=Ev+['H'];r[34]:=32;
               RL(154);Sc:=Sc+15;end;
         end;{of Noun case}
       end;

34    :case verb of
   45,58:moveto(25);
   14   :if(noun=74)and(74 in P[34])then begin P[34]:=P[34]-[74];
           inven:=inven+[74];RL(138);Sc:=Sc+25;end;
   42   :if(noun=74)and(74 in P[34])then RL(175);
   28,27:if(noun in[10,36])then begin RL(387);
          for o:=1 to random(12)+4 do play(random(250),random(250),random(30))
         end;
   39   :if(noun=25)then begin RL(387);
          for o:=1 to random(99)+75 do
           begin x:=random(9999);play(x,x,random(19)+10);delay(5)end
         end;
   11   :case noun of
          0:RL(139);
          25:RL(418);
          21:begin;RL(140);RL(141);end;
          68:if(SlotCon=Null)then RL(143) else
              begin SA;writeln('The slot contains a ',n[SlotCon,1],'.')end;
          58:if(SlotCon=77)and not(en('x'))then
              begin Ev:=Ev+['x'];Sc:=Sc+5;RS(75)end
             else if(SlotCon=77)then RS(77)else RL(385)
         end
       end;

0         :case verb of
   45     :MoveTo(1);
   44     :begin TextColor(m8);writeln('Casino Hall');TextColor(m2);RS(0)end;
  19,2    :if(noun in[53,6,64,73])then begin RL(0);DEAD;end;
  11    :if(noun=73)then RL(19);
         end;

1        :case verb of
   46     :moveto(0);
   45     :moveto(2);
   43,57  :moveto(3);
   6,17   :if(noun=57)and(here(40))and((noun2=40)or(noun2=Null))then
           begin RS(16);Sc:=-500;
            Loc:='Locked Cabin';Verbose:=True;inven:=[];KitSet:=KitSet-[57];
            n[57,1]:='plastic card';n[57,2]:='card';n[57,3]:='plastic';
            n[57,4]:='elevato card';n[57,5]:='elevato';r[57]:=76;moveto(76)
           end;
 33,19,2  :if(noun in[6,53,64])then moveto(3)
          end;

end  {of case}
else SA
end; {of SP13}
{-------------------}
procedure SpecialAnswers14;

begin
FlagSA:='r';
if Present then
Case Prm of

49     :case verb of
    43  :moveto(45);
  44,57 :begin RL(290);moveto(50);n[36,1]:='lever';n[36,2]:='handle';end;
  45..50:RL(291);
    11  :if(noun in[26,50])then RL(292)
        else if(noun =72) then RL(313);
    2   :if(noun=72)then RL(312);
        end;

59     :case verb of
   43..50:begin o:=random(8)+3;writeln('You travel about ',o,' miles...');
           if(random(4)=2)then ShRm:=13 else ShRm:=Random(15);moveto(59)end;
   52,57:RL(341);
    58  :if(noun=Null)or(noun=65)then begin RL(342);DEAD;end;
    51  :begin sound(30);
          if not(en('U'))then begin RS(64);writeln;Ev:=Ev+['U'];Sc:=Sc+45;end
          else RL(349);moveto(63);sound(20)end;
    14  :if(noun=63)then begin RS(65);DEAD;end;
    28  :if(noun=10)then noun:=81;
        end; {of case 59}

72     :case verb of
    46  :moveto(71);
  43,44,58:moveto(73);
    45  :moveto(74);
        end;

73     :case verb of
  43,45,58:moveto(72);
    46  :moveto(73);
    44  :begin moveto(74);if(MnRm=Null)then RL(356);end;
        end;

74     :case verb of
  43,45 :moveto(73);
  46,58 :moveto(74);
    44  :if(MnRm=Null)then begin Verbose:=False;Moveto(75);Verbose:=True;
          RS(69);MnRm:=75;Attack:=False end else moveto(75);
        end;

75     :case verb of
  43,58 :moveto(74);
   11   :if(noun in[14,61])then RL(364);
        end;

76     :case verb of
   43   :RL(114);
   11   :if(noun=26)then RL(271)else
         if(noun=57)then RL(408);
        end;

end  {of case}
else SA
end; {of SP14}
{===================}
procedure ScreenDraw_PlayerInput;
{var
        buflen:integer;}
  begin
   gotoxy(1,24);writeln;TextColor(m5);write(chr(175),' ');
   Window(1,1,80,25);
   gotoxy(1,1);textcolor(m4);TextBackGround(m6);
   gotoxy(10,1); writeln(Tic,'  '); gotoxy(75,1); writeln(Sc,' ');
   gotoxy(35-(length(Loc)div 2),1);writeln('     ',Loc,'     ');
   gotoxy(3,25);TextBackGround(0);Window(1,2,80,25);
   textcolor(m1);{BufLen:=77;}
   gotoxy(3,24);
   if(Loc<>'Civilization!')then READLN(LINE)else repeat;until false;
   if(Line='r')or(Line='repeat')then Line:=Again
   else Again:=Line;
   gotoxy(1,24);TextColor(m3);writeln(chr(175));TextColor(m2);
  end;
{-------------------}


BEGIN
clrscr;
assign0;
assign1;assign2;assign3;assign4;assign5;assign6;assign7;assign8;
Initialize;

                            {*****} repeat {*****}

if Skip then time; writeln;

if(length(Line)=0)then begin
 ScreenDraw_PlayerInput;
 while pos(' then ',Line)>0 do
  begin x:=pos('then ',Line);delete(Line,x,4);insert('.',Line,x)end;
 LowerCase(Line);
 Format(Line);
 Chop(Line);
end;
if(pos('.',Line)>0)then begin
  Input:=copy(Line,1,pos('.',Line));
  delete(Line,1,pos('.',Line));
  delete(Input,pos('.',Input),1);
end else
 begin
  Input:=Line;
  Line:=''
 end;
Input:=Input+' ';
while pos(' it ',Input)>0 do
 begin x:=pos(' it ',Input)+1;delete(Input,x,2);insert(LastNoun,Input,x);
 Format(Input);Chop(Input)end;
if(Input[length(Input)]=' ')then delete(Input,length(Input),1);



Check(SepWord);

if Flag = 'g' then
  begin
    case Prm of
      3..4                :SpecialAnswers1;
      5..10               :SpecialAnswers2;
      14..16              :SpecialAnswers3;
      19..24              :SpecialAnswers4;
      25,27..29,33        :SpecialAnswers5;
      30                  :SpecialAnswers6;
      26,35..40           :SpecialAnswers7;
      41..48              :SpecialAnswers8;
      50..55              :SpecialAnswers9;
      56..58,60..62,65..67:SpecialAnswers10;
      63,64,68..71        :SpecialAnswers11;
      11..13,17,18        :SpecialAnswers12;
      0..2,31,32,34       :SpecialAnswers13;
      49,59,72..76        :SpecialAnswers14
    end;

    if FlagSA <> 's' then
      case Verb of
       11,18,22,41,43..52,57,58    :DefaultAnswers1;
       29                          :DefaultAnswers2;
       1,2,8,12,13,15,16,19,21,
        23..25,31,33,34,38,40,60,63:DefaultAnswers3;
       3,6,7,20,30,35,53..56,59    :DefaultAnswers4;
       9,26                        :DefaultAnswers5;
       27,28,62                    :DefaultAnswers6;
       14,64,4,5                   :DefaultAnswers7;
       0,10,17,42,39               :DefaultAnswers8;
       32                          :DefaultAnswers9;
       36,37,61,65                 :DefaultAnswers10;
      end;
  end;

                         {*****} until False {*****}

END. {of program}
