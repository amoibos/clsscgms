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
{*** CAVERNS OF KROZ II title screens.  By Scott Miller 11/12/89 ***}

unit CAVERNS3;

interface 

procedure Title;

implementation {--------------------------------------------------------------}

uses CRT, DOS, CAVERNS1, CAVERNS2;

procedure Title;
 var StartGame : boolean;
 label DESCENT;
 begin
  nosound;
  ClearKeys;Cur(3);
  col(15,15);bak(0,0);clrscr;Cur(3);
  gotoxy(28,2);
  writeln('Apogee Software Presents');
  ClearKeys;
  repeat
   gotoxy(1,5);
   col(random(15)+1,7);
   writeln('     ���     ���     ����������         �����������        �������������  (R)');
   writeln('     ��۱�  ��۱��   ��۱������۱      ��۱��������۱        ���������۱��');
   writeln('     ��۱� ��۱��    ��۱�   ��۱�     ��۱�     ��۱�            ��۱���');
   writeln('     ��۱���۱��     ��۱�   ��۱�    ��۱��      ��۱           ��۱��');
   writeln('     ��۱��۱��      ���������۱��    ��۱�       ��۱�         ��۱��');
   writeln('     �����۱��       ��۱���۱���     ��۱�       ��۱�        ��۱��');
   writeln('     ��۱��۱        ��۱� ��۱        ��۱      ��۱��       ��۱��');
   writeln('     ��۱���۱       ��۱�  ��۱       ��۱�     ��۱�      ���۱��');
   writeln('     ��۱� ��۱      ��۱�   ��۱       ����������۱��     �������������');
   writeln('     ��۱�  ��۱       ���     ���        �����������        �������������');
   writeln('     ��۱�   ��۱');       
   writeln('     ��۱�    �����������������������������������������������������������');
   writeln('       ���      �����������������������������������������������������������');
   writeln;
   col(14,15);gotoxy(11,wherey);
   writeln('CAVERNS OF KROZ II -- UPDATED VOLUME ONE OF THE KROZ SERIES');
   writeln;gotoxy(24,wherey);col(14,7);
   writeln('Copyright (C) 1990 Scott Miller');
   writeln;
   writeln('           User-Supported Software -- $7.50 Registration Fee Required');
   col(11,7);gotoxy(27,25);
   write('Press any key to continue.');
   delay(300);
  until keypressed;
  ClearKeys;
  bak(1,0);;
  clrscr;cur(3);
  gotoxy(30,1);
  col(4,7);bak(1,0);
  write('��������������������');
  gotoxy(30,3);
  write('��������������������');
  gotoxy(25,5);col(15,15);
  write('An Apogee Software Production');
  gotoxy(28,7);
  write('Created by Scott Miller');
  gotoxy(1,9);col(11,7);
  writeln('  Caverns of Kroz is a game of adventure, exploration and survival.  You''re a');
  writeln('  feerless archaeologist in search of the Priceless Amulet,  hidden somewhere');
  writeln('  deep in the vast and dangerous underground caverns.   You enter the caverns');
  writeln('  through a secret tunnel and ignite your brass lantern. Your only protection');
  writeln('  is a worn leather whip and your ingenuity.  Sweat beading on your forehead,');
  writeln('                you embark on a journey that may be your last...');
  gotoxy(1,17);col(10,7);
  write('         Use the cursor keys to move yourself (');
  col(14,15);write(#2);col(10,7);
  writeln(') through the Caverns.');
  writeln('            Use your whip (press W) to destroy all nearby creatures.');
  writeln('       You are on your own to discover what other mysteries await--some');
  writeln('                           helpful, others deadly...');
  col(14,7);
  gotoxy(13,22);
  write('Are you a ');col(15,15);write('N');col(14,7);
  write('ovice, an ');col(15,15);write('E');col(14,7);
  write('xperienced or an ');col(15,15);write('A');col(14,7);
  write('dvanced player?');
  col(28,16);write(#219);
  sound(220);delay(100);nosound;
  bak(4,7);
  repeat
   repeat
    gotoxy(30,2);col(random(16),0);write(' CAVERNS OF KROZ II ');delay(50);
   until keypressed;
   ch:=readkey;
   sound(300);delay(100);nosound;
  until upcase(ch) in [#13,'N',' ','E','A','X'];
  sound(700);delay(100);nosound;
  gotoxy(13,22);col(0,0);bak(1,0);
  for x:=1 to 28 do write('  ');
  col(30,31);bak(1,0);
  case upcase(ch) of
   'N',' ',#13:begin Difficulty:=8;gotoxy(37,22);write('NOVICE');end;
   'E':begin Difficulty:=5;gotoxy(34,22);write('EXPERIENCED');end;
   'A':begin Difficulty:=2;gotoxy(36,22);write('ADVANCED');end;
   'X':begin Difficulty:=9;gotoxy(34,22);write('SECRET MODE');end;
  end;
  ClearKeys;
  gotoxy(33,25);
  col(7,7);
  write('Press any key.');
  bak(4,7);
  repeat
   gotoxy(30,2);col(random(16),0);write(' CAVERNS OF KROZ II ');delay(50);
  until keypressed;
  ClearKeys;
  
  Shareware(true);
  
  { New menu screen starts here. }
  StartGame := false;
  repeat
   ;
   bak(0,0);
   clrscr;
   cur(3);
   col(15,9);
   gotoxy(31,2);
   write('CAVERNS OF KROZ II');
   gotoxy(17,4);
   col(6,7);
   write('Copyright (c) 1990 Apogee Software Productions');
   gotoxy(25,6);
   write('Version 2.0 -- by Scott Miller');
   gotoxy(4,8);
   col(2,7);
   writeln('THIS GAME MAY NOT BE DISTRIBUTED BY SHAREWARE OR PUBLIC DOMAIN LIBRARIES,');
   gotoxy(5,9);
   writeln('OR BULLETIN BOARD SYSTEMS.  ONLY KINGDOM OF KROZ II MAY BE DISTRIBUTED.');
   gotoxy(1,10);
   col(4,7);
   for x := 1 to 80 do write(#196);
   col(14,15);
   gotoxy(28,12);
   write('B');
   col(11,7);
   write('egin your descent into Kroz...');
   col(14,15);
   gotoxy(28,14);
   write('I');
   col(11,7);
   write('nstructions');
   col(14,15);
   gotoxy(28,16);
   write('M');
   col(11,7);
   write('arketing Kroz');
   col(14,15);
   gotoxy(28,18);
   write('S');
   col(11,7);
   write('tory Behind Kroz');
   col(14,15);
   gotoxy(28,20);
   write('O');
   col(11,7);
   write('riginal Kroz Games');
   col(14,15);
   gotoxy(28,22);
   write('A');
   col(11,7);
   write('bout the Author');
   gotoxy(26,24);
   col(15,0);bak(1,7);
   write('Your choice (B/I/M/S/O/A)? B');gotoxy(wherex-1,wherey);
   cur(2);
   ClearKeys;
   ch:=readkey;
   if upcase(ch)='R' then MixUp:=true else MixUp:=false;
   ClearKeys;
   cur(3);
   case upcase(ch) of
    'B':begin
         DESCENT:
         for x:=100 downto 20 do
          for y := 10 downto 1 do
           begin sound(x*y*y);delay(y div 2);end;
         nosound;
         StartGame := true;
        end;
    'I':begin
         bak(1,0);
         ;
         clrscr;
         cur(3);
         ClearKeys;
         gotoxy(32,2);col(14,7);writeln('THE INSTRUCTIONS');
         gotoxy(32,3);          writeln('����������������');
         writeln;
         col(15,7);
         writeln('   Caverns of Kroz is a game of exploration and survival.  Your journey will');
         writeln(' take you through 40 very dangerous chambers, each riddled with diabolical');
         writeln(' traps and hideous creatures.   Hidden in the deepest chamber lies a hidden');
         writeln(' treasure of immense value. Use the cursor pad to move 8 directions.');
         writeln('   The chambers contain dozens of treasures, spells, traps and other unknowns.');
         writeln(' Touching an object for the first time will reveal a little of its identity,');
         writeln(' but it will be left to you to decide how best to use it--or avoid it.');
         writeln('   When a creature touches you it will vanish, taking with it a few of your');
         writeln(' gems that you have collected. If you have no gems then the creature will');
         writeln(' instead take your life!  Whips can be used to kill nearby creatures, but');
         writeln(' they''re better used to smash through "breakable walls" and other terrain.');
         writeln('   Laptop and PCjr players can');
         writeln(' use the alternate cursor             U I O      ( NW N NE )');
         writeln(' pad instead of the cursor             J K       (   W E   )');
         writeln(' keys to move your man, plus          N M ,      ( SW S SE )');
         writeln(' the four normal cursor keys.');
         writeln('   It''s a good idea to save your game at every new level, therefore, if you die');
         writeln(' you can easily restore the game at that level and try again.');
         writeln('   Registered users will get a "secret code" that makes this game much easier!');
         flash(27,25,'Press any key to continue.');
         bak(1,0);
         clrscr;
         cur(3);
         ClearKeys;
         gotoxy(32,2);col(14,7);writeln('THE INSTRUCTIONS');
         gotoxy(32,3);          writeln('����������������');
         writeln;
         col(15,7);
         writeln('   Caverns of Kroz will present you with many challenges. You will venture deep');
         writeln(' underground and probably not make it out alive!');
         writeln;
         writeln(' Hints:  � Don''t forget to use the Home, End, PgUp, and PgDn keys to move your');
         writeln('           on-screen character diagonally (along with the marked cursor keys).');
         writeln;
         writeln('         � Use your player to touch each new object to find out about it.  When');
         writeln('           you first touch an object a message appears at the bottom of the');
         writeln('           screen that describes it.');
         writeln;
         writeln('         � Collect keys to unlock doors, which usually block the stairs.');
         writeln;
         writeln('         � The faster monsters are the most dangerous to touch--they will knock');
         writeln('           off three of your valuable gems.  The slowest creatures only take a');
         writeln('           single gem from you, and the medium speed monsters take two.');
         writeln;
         flash(27,25,'Press any key to continue.');
         bak(1,0);
         clrscr;
         cur(3);
         ClearKeys;
         gotoxy(32,2);col(14,7);writeln('THE INSTRUCTIONS');
         gotoxy(32,3);          writeln('����������������');
         col(15,7);
         writeln('   Here are some brief descriptions of the most common objects that you are');
         writeln(' likely to find in the Caverns of Kroz:');
         writeln;
         write(  '      ');col(14,15);write(Player);col(15,7);
           writeln(' - this is you, a dauntless archaeologist without peer');
         write(  '      ');col(12,7);write(#142);col(15,7);
           writeln(' - red creatures move slow and only knock off 1 gem when touched');
         write(  '      ');col(10,7);write(#153);col(15,7);
           writeln(' - green creatures move faster and knock off 2 gems when touched');
         write(  '      ');col(9,7);write(#234);col(15,7);
           writeln(' - blue creatures move fastest and knock off 3 gems when touched');
         write(  '      ');col(random(13)+2,7);write(Gem);col(15,7);
           writeln(' - collect all the gems you can to survive creature attacks');
         write(  '      ');write(Whip);
           writeln(' - whips are used to wipe out creatures and smash certain walls');
         write(  '      ');col(13,7);write(Teleport);col(15,7);
           writeln(' - teleport spells will magically transport you to a random place');
         write(  '      ');col(14,7);bak(4,0);write(Chest);bak(1,0);col(15,7);
           writeln(' - chests contain a random number of gems and whips');
         write(  '      ');col(12,15);write(Key);col(15,7);
           write(' - collect keys to go through doors (');col(3,0);bak(5,7);
           write(door);col(15,7);bak(1,0);
           writeln(')');
         write(  '      ');write(Power);
           writeln(' - collect these power rings to make your whips more powerful');
         write(  '      ');col(16,16);bak(7,7);write(Stairs);col(15,7);bak(1,0);
           writeln(' - stairs take you to the next level deeper in Kroz');
         writeln;
         writeln('   There are dozens and dozens of other objects to discover.  The best way');
         writeln(' to learn the usefulness of any new object is to touch it and read the brief');
         writeln(' message that appears at the bottom of the screen.');
         flash(27,25,'Press any key to continue.');
         bak(1,0);
         clrscr;
         cur(3);
         ClearKeys;
         gotoxy(33,2);col(14,7);writeln('MISCELLANEOUS');
         gotoxy(33,3);          writeln('�������������');
         writeln;
         col(15,7);
         writeln;
         writeln('  � You can now save three different levels during a single game.  When you');
         writeln('    select the "save" command you will also be asked to enter a letter, either');
         writeln('    A, B or C.  If you just hit the space bar then A is the default selection.');
         writeln('    These letters do not refer to disk drives!  They actually refer to the file');
         writeln('    names used by the game.  The restore command lets use pick from A, B or C.');
         writeln;
         writeln('  � If you are tired of seeing the descriptions at the bottom of the screen');
         writeln('    that appear whenever you touch a new object, you can disable most of the');
         writeln('    messages by pressing the minus (-) key.  The plus key (+) resets messages.');
         flash(27,25,'Press any key to continue.');
        end;
    'M':begin
         ;
         bak(1,0);
         clrscr;
         ClearKeys;
         cur(3);
         gotoxy(29,2);col(14,7);writeln('THE MARKETING OF KROZ');
         gotoxy(29,3);          writeln('���������������������');
         writeln;
         col(15,7);
         writeln('   Caverns of Kroz II is a user-supported game.  This means that the creator of');
         writeln(' this program relies on the appreciation of honest players to pay the game''s');
         writeln(' registration fee--$7.50.');
         writeln('   Payment of this fee entitles you to all the free help and hints you might');
         writeln(' need to enjoy the game.  All letters from registered users are answered');
         writeln(' within two days.  (Try to get this kind of support from commercial games!)');
         writeln('   Also, players can order the other Kroz sequels ONLY if this registration');
         writeln(' fee is paid.  ($7.50 each or $20 for The Lost Adventures of Kroz.)');
         writeln('   Everyone who orders (or registers) any of the other six Kroz games will also');
         writeln(' get a "Hints, Tricks and Scoring Secrets" guide, and "The Domain of Kroz" map.');
         writeln('   A single Kroz game takes several months to create, up to 200 hours per game!');
         writeln(' I can''t afford to devote this much time without receiving something in return.');
         writeln(' That is why I ask for this small fee, which is only necessary if you enjoy');
         writeln(' this game.  In other words, try before you buy.');
         writeln('   Even if you buy this game from a public domain or shareware library, I don''t');
         writeln(' receive any of that money.  You''re simply paying for "storage, distribution,');
         writeln(' disk, and handling."');
         writeln('   Note:  The current Apogee Software address will ALWAYS BE VALID.  Foreign');
         writeln(' orders are always welcome, please send U.S. funds/money orders only.');
         flash(27,25,'Press any key to continue.');
        end;
    'S':begin
         ;
         bak(1,0);
         clrscr;
         ClearKeys;
         cur(3);
         gotoxy(29,2);col(14,7);writeln('THE STORY BEHIND KROZ');
         gotoxy(29,3);          writeln('���������������������');
         writeln;
         col(15,7);
         writeln('   The original Kroz Trilogy (consisting of Caverns of Kroz, Dungeons of Kroz,');
         writeln(' and Kingdom of Kroz) was developed after I spent many hours playing another');
         writeln(' explore-the-levels type game titled Rogue.  I never could finish Rogue,');
         writeln(' though, because the game relied too much on luck and random occurrences.');
         writeln('   The name "Kroz" is actually Zork (an Infocom text adventure) spelled in');
         writeln(' reverse.  Many players still inquire about this bit of trivia.  The game was');
         writeln(' first designed without predefined level layouts, meaning every level was a');
         writeln(' random placement of creatures and play field objects.  New objects, like');
         writeln(' spells, lava, doors, etc., were added quickly as the first Kroz game took');
         writeln(' shape, including the ability to have predefined level floor plans.');
         writeln('   My main objective was to create a game that wasn''t all fast paced action,');
         writeln(' but also included strategy and puzzle solving.  Kingdom of Kroz was entered');
         writeln(' in a national programming contest in 1988 and took top honors in the game');
         writeln(' category, and number two overall (beaten by a spreadsheet program.)');
         writeln('   The latest Kroz games have been greatly re-designed and re-programmed, but');
         writeln(' the familiar appearance has been mostly maintained.  You will discover new');
         writeln(' dangers, creatures and objects in your adventures below.');
         writeln('   Thanks to all the players of Kroz who contributed dozens of suggestions,');
         writeln(' ideas and improvements that were incorporated in later versions of Kroz.');
         flash(27,25,'Press any key to continue.');
         bak(1,0);
         clrscr;
         cur(3);
         ClearKeys;
         gotoxy(29,2);col(14,7);writeln('THE STORY BEHIND KROZ');
         gotoxy(29,3);          writeln('���������������������');
         writeln;
         col(15,7);
         writeln('   Kroz is a hobby that''s gotten out of control!');
         writeln('   Kroz is truly a phenomenon in the user-supported software market.  The');
         writeln(' overwhelming success of the original Kroz games was completely unexpected.');
         writeln(' Most (probably 99%) of all "shareware" games are not profitable for their');
         writeln(' creator.  This is a well-known fact among the community of shareware game');
         writeln(' authors, and one that I''ve verified by speaking to many other games de-');
         writeln(' signers.  Most people simply don''t register games.');
         writeln('   Through my research the Kroz games are the only user-supported games that');
         writeln(' generate a substantial amount of registrations and orders for it''s creator,');
         writeln(' namely, Scott Miller (me).  I don''t know what cord I''ve struck with players,');
         writeln(' but everyday I receive fascinating and appreciative letters from players');
         writeln(' telling me how much they enjoy the Kroz games.');
         writeln('   Thanks to Kroz I now know what a mutual fund is, but on the downside my');
         writeln(' taxes require a book two inches thick to figure out.');
         writeln('   Will Kroz ever end?  I thought that THE FINAL CRUSADE would be the closing');
         writeln(' chapter--but a flood of letters demanding more proved that I''m a pushover.');
         writeln(' I guess as long as the letters keep coming, I''ll continue to make Kroz games.');
         writeln(' After all, Kroz is like my second home now, one that I like to visit often...');
         writeln('                                                        -- Scott Miller');
         flash(27,25,'Press any key to continue.');
        end;
    'O':begin
         ;
         bak(1,0);
         clrscr;
         ClearKeys;
         cur(3);
         gotoxy(28,2);col(14,7);writeln('THE ORIGINAL KROZ GAMES');
         gotoxy(28,3);          writeln('�����������������������');
         writeln;
         col(15,7);
         writeln('   The Lost Adventures of Kroz is the latest addition to the Kroz family of');
         writeln(' games.  Before this game there are six more Kroz volumes, separated into two');
         writeln(' triligies:  The Kroz Trilogy and The Super Kroz Trilogy.');
         writeln('   The original Kroz Trilogy was such a surprising success that I decided to');
         writeln(' created a second "Super Kroz" trilogy.  The first three original Kroz');
         writeln(' games are:   � Kingdom of Kroz  � Caverns of Kroz  � Dungeons of Kroz.');
         writeln(' All three are still available and are constantly being updated and improved.');
         writeln('   The original Kroz Trilogy games can be purchased for $7.50 each, or all 3');
         writeln(' for $20 (these prices include postage, disks, and handling).');
         writeln('   Only Kingdom of Kroz can be placed in a shareware library for distribution,');
         writeln(' and the other two can only be ordered from Apogee Software Productions.');
         writeln('   The Super Kroz Trilogy volumes are revamped and greatly improved.  They are');
         writeln(' � Return to Kroz  � Temple of Kroz  � The Final Crusade of Kroz.  The last');
         writeln(' three volumes were supposed to be the end of Kroz, but the mail kept coming');
         writeln(' and again I was impelled to create another Kroz adventure.');
         writeln('   All Kroz games work on all monitors, either graphics or monochrome systems.');
         writeln(' Plus, they only rely on keyboard control, and have slow-down routines that');
         writeln(' permit them to function correctly on any speed IBM PC compatible computer.');
         flash(27,25,'Press any key to continue.');
        end;
    'A':begin    
         ;
         bak(1,0);
         clrscr;
         ClearKeys;
         cur(3);
         gotoxy(32,2);col(14,7);writeln('ABOUT THE AUTHOR');
         gotoxy(32,3);          writeln('����������������');
         col(15,7);
         writeln('   Scott Miller, the creator of all the Kroz games, along with Supernova, Trek');
         writeln(' Trivia and Beyond the Titanic (all shareware games) began programming in high');
         writeln(' school in 1975.  Since then he''s created over 100 games and has had dozens');
         writeln(' publishered by BIG BLUE DISK, I.B.Magazette and Keypunch Software.');
         writeln;
         writeln('   For over three years he wrote two weekly computer columns for the Dallas');
         writeln(' Morning News, one of the nation''s largest newspapers.  He also co-authored');
         writeln(' a video game strategy book titled, "Shootout: Beating the Video Games."');
         writeln(' Scott has written articles for COMPUTE!''s PC and PCjr Magazine and is a');
         writeln(' software reviewer with COMPUTE! Publications.');         
         writeln;
         writeln('   Hobbies include softball, running, tennis, karate (1st degree black belt),');
         writeln(' drumming, rock music, science fiction, and creating new computer games.');
         writeln(' Favorite computer games are M.U.L.E., Jumpman, Planetfall, Enchanter, Zork,');
         writeln(' Spelunker, and Archon.  All are games of strategy, with action secondary.');
         writeln;
         writeln('   Scott creates all Apogee Software programs on an AST Premium 80386 (20 Mhz)');
         writeln(' equipped with VGA graphics, a NEC MultiSync II and an HP LaserJet series III.');
         writeln(' The cost to market each Kroz game to the many shareware libraries and BBS''s');
         writeln(' is over $10,000 per game.  All of the appreciative letters make it worth it!');
         flash(27,25,'Press any key to continue.');
        end
    else goto DESCENT;
   end;
  until StartGame;
  bak(0,0);
  clrscr;
 ;
 end; { Title }

begin
end.