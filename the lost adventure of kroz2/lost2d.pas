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
{*** THE LOST ADVENTURES OF KROZ level layouts.  By Scott Miller 11/12/89 ***}

unit LOST2D;

interface

procedure Level1;
procedure Level2;
procedure Level4;
procedure Level6;
procedure Level8;
procedure Level9;
procedure Level11;
procedure Level13;
procedure Level14;
procedure Level15;
procedure Level18;
procedure Level20;
procedure Level22;
procedure Level24;
procedure Level26;
procedure Level28;
procedure Level30;
procedure Level32;
procedure Level33;
procedure Level34;
procedure Level35;
procedure Level37;
procedure Level40;
procedure Level42;
procedure Level44;
procedure Level46;


implementation { ---------------------------------------------------------- }

uses CRT, DOS, Lost1D;

procedure Level1;
 begin
  FP[1]:= '//\///////\///\////////\////////\//#the#lost#adventures#of#kroz#';
  FP[2]:= '//\//////////////\//\////////\////////\///\/\\/\\/\/\\/\\\\\\\/\';
  FP[3]:= '\###your#hut###////\///\/////////\/////\/\\//\\/\\/\\\\\\\\\\\\\';
  FP[4]:= '/##           D---/////////\//\///\//\/\/\/\/\/\/\/\\\\\\\###\\\';
  FP[5]:= '/##  P ####  ##///-\//\//\/----\///\////\//\//RRR/\\\\\\\##L##\\';
  FP[6]:= '/##      K#**##/\\/-//--/\-\//\--\//\//\////RRRRR//\\\\\\\#0#\\\';
  FP[7]:= '\##############/////--\/--//\////-///////\////RRRRRRR/\\\\#!#\\\';
  FP[8]:= '////\\///\/\\///\//\//////////\//\---\//\////RRRRRR/\\/\\\\-\\\\';
  FP[9]:= '/\//////\/////\////////\///\/////////--/////\///RRRRR\\\\\\\-\\\';
  FP[10]:='///////\////////\///////////////\/////\---/////RRRRR/\/\\\\\\-\\';
  FP[11]:='////\/////\\\//\////\/////\//////\////////-//\/\/RRRRRR\/\\\-\\\';
  FP[12]:='/////////\\\\\///\////\////////\///\///////-//\///RRRR\//\/-\/\/';
  FP[13]:='\//////\//\\////\////////\//\//////////\///-\////RRRRRR\\/\-/\/\';
  FP[14]:='//\\//////\/###storage###///////\--//\\///-////RRRRRRRRR/\/\-/\/';
  FP[15]:='////////\///##WWWWWWWWW##/\////--//-//\\/-///\RRRRRRRRR/\/\/-/\/';
  FP[16]:='/\////////\/##WWWWWWWWW--------//\//-----//\///RRRRRRRR\\//\-\//';
  FP[17]:='\/////\/////#############\///\-/\\\/\/\\/\////RRRRRRRR//\/\/-//\';
  FP[18]:='///\////\//////\\////\////\///-////\/\\/\///\RRRRRRR/\/\//\-/\//';
  FP[19]:='/\///\/////\////\///\//\//\////------\///\////\////\//--/\-\\//\';
  FP[20]:='\//\///\/\//\/\/\///\//\/\///\////\//------\/\//\///\-\/--//\/\/';
  FP[21]:='/\///\////\//\///\////\///\//\/\////\///\/\-----/\\/-/\//\/\//\/';
  FP[22]:='\//\////\/\///\//\///\/\///\//\/////\///\/////\/----\\//\///\//\';
  FP[23]:='#by#scott#miller#\///\/////\/\////\////\////\//\//\/\//\/\\///\�';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level1 }

procedure Level2;
 begin
  FP[1]:= 'XXXXXXXXXXXXXXXXXXX#XXXXXXXXXXXXXXXXXXXXXXXX#XXXXXXXXX### P ###X';
  FP[2]:= 'XXXXX##XXXXXXXXXXXXXXXXXXX##XXXXXXXXXXXXXXXXXXXXXXXXXXXX##  ##XX';
  FP[3]:= 'XXXXXXXXXXXXXXX&-XXXXXXXXXXXXXXXXXX#XXXXXXXXXXXXXXXX#XXXXX#  #XX';
  FP[4]:= '#XXXXXXXXXXXXXXXX-XXXX--XXXXXXXXXXXXXXXX##XXXXXXXXXXXXXXXX  XXXX';
  FP[5]:= 'XXXXXXXXX#XXXXXXXX-XX-XX-XXXXXXX#XXXXXXXXXXXXXXXXXXXXX##   #XXXX';
  FP[6]:= 'XXX#XXXXXXXXXXX#XXX+-XX#X--XXXXXXXXX#XXXXX#XXXX##XXXX##  ##XXXXX';
  FP[7]:= 'XXXXXXXXXXXXXXXXXXXXXXXXXXX--XXXXXXXXXXXXXXXXXXXXXXX##XX##XXXXXX';
  FP[8]:= 'XXXXXXXXXXX##XXXXXXXXXXXXX#XX+XXXXXXXXXXXXXXXXXXXXX##  ##XXXX##X';
  FP[9]:= 'XXXXX#XXXXXXXXXXXX#XXXXXXXXXXX--XXXX##XXXXXX#XXXXX##  ##XXXXXXXX';
  FP[10]:='XXXXXXXXXXXXXXXXXXXXXXXX#XXXXXXX-#XXXXXXXXXXXXX   +  XXXX#XXXXXX';
  FP[11]:='XXXXX##XXXXXX#XXXXXXX#XXXXXXXXXX#X##XXXXX       XXXXXXXXXXXXXXXX';
  FP[12]:='XXXXXXXXXXXXXXXXXXXXXXXXXXXX##XXX#  +0    XXXXXXXX!XXXXXXXXXXXXX';
  FP[13]:='XXXXXXXXXXXXXX#XXXXXXX===XXXXXXX#  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  FP[14]:='XXXXXXX#XXXXXXXXXXXX=======XXXXX  XXXXXXXX#XXXXX#XXXXXXXXXX##XXX';
  FP[15]:='XXXXXXXXXXXXXXXXX=========       XX=====XXXXXXXXXXXXX#XXXXXXXXXX';
  FP[16]:='XX#XXXXXXX##XXX==========  ===========XXXXXXXXXXXXXXXXX#XXXXXXXX';
  FP[17]:='XXXXXXXXXXXXXX==========  ===========XXXXXXXXX##XXXXXXXXXXXXXXXX';
  FP[18]:='XXXX#XXXXXXX            +===========XX#XXXXXXXXXXXXXXXXXXXXX#XXX';
  FP[19]:='XXXXXXXX+   XX#XXXX================XXXXXXXX#XXXXXX#XXXXXXXXXXXXX';
  FP[20]:='XXX     XX#XXXXXXXXXX===========XXXXXXXXXXXXXXXXXXXX##the#secret';
  FP[21]:='XXXXXXXXXXXXXXXXXX#XXXXXX=====XXXXXXXXXX#XXXXXXXXXXX#tunnel#into';
  FP[22]:='X  XX#XXXXXX##XXXXXXXXXXXXXXXXXX#XXXXXXXXXXXXXXXXXXX#the#kingdom';
  FP[23]:='LLXXXXXX#XXXXXXXXXXXXX#XXXXXXXXXXXXXX#4XXXXXX##XXXXX#####of#kroz';
  Fast:=#234;{or #1}
  Convert_Format;
  HideStairs:=true;
 end; { Level2 }

procedure Level4;
 begin
  FP[1]:= '                                   1          ++            1  &';
  FP[2]:= ' ####shop####         1                       ++              � ';
  FP[3]:= ' ##++++++++##                            1    ++                ';
  FP[4]:= ' ##++++++++##                                 ##4444444444444444';
  FP[5]:= ' #####OO#####                                 ##   1   1   1  1 ';
  FP[6]:= '                          ###spells###        ## 1 1  1  1   1  ';
  FP[7]:= '     1                    ##�EF�T� @##     1  ##    1   1  1  1 ';
  FP[8]:= '                          ##I@ �S  T##        ##11   1 1    1   ';
  FP[9]:= '                     1    ##Z�T�  ] ##        ##   1   1 1  1 1 ';
  FP[10]:='                          #########X##        ## 1   1  1  1 1  ';
  FP[11]:='@@         1                                  ##1 1    1  1    1';
  FP[12]:='1@W                            P              ## 1  1 1 1  1 1 1';
  FP[13]:='1@W                                           ##1  11  1 1   1  ';
  FP[14]:='1@W   1                                     1 ##  1   1     1   ';
  FP[15]:='1@W                 1                         ##1    1  1  1  1 ';
  FP[16]:='1@W                                     #.#OXX## 1 1  1   1    1';
  FP[17]:='1@W          ###lair#of#kroz###         #.#XOX##1    1  1   1 1 ';
  FP[18]:='1@W          77------------�K##         #.#XXO##  1 1  1   1   1';
  FP[19]:='1@W          ####1111111111####         #.#XOX## 1 1  1 1 1   1 ';
  FP[20]:='1@W    1      Z##############           #H#X!X##1  1 1  1  1 1  ';
  FP[21]:='1@W                                     ######## 1   1 1  1   1 ';
  FP[22]:='1@@@@@@@@@@@@@@@                  ########@       1   1   1 1  1';
  FP[23]:='111111111111111@                1 ##LLWWWD@         1   1    1 1';
  Fast:=#234;{or #1}
  Convert_Format;
  HideGems:=true;
 end; { Level4 }

procedure Level6;
 begin
  FP[1]:= '#diary�#day#one�################################################';
  FP[2]:= '################################################################';
  FP[3]:= '#you#finally#discover#the#twisty#tunnel#that#you#noticed#during#';
  FP[4]:= '################################################################';
  FP[5]:= '#your#last#exploration#of#kroz�#in#the#final#crusade�##with#a###';
  FP[6]:= '################################################################';
  FP[7]:= '#few#swings#of#your#thick#leather#whip#the#small#tunnel#opened�#';
  FP[8]:= '################################################################';
  FP[9]:= '#giving#you#passage�##you#sip#lightly#from#your#water#pouch#and#';
  FP[10]:='################################################################';
  FP[11]:='#flick#the#whip#in#the#air�#snapping#in#half#an#annoying#bug�###';
  FP[12]:='################################################################';
  FP[13]:='#you#again#wonder#what#new#surprises#await#you#in#the#vast#and##';
  FP[14]:='################################################################';
  FP[15]:='#dangerous#kingdom#of#kroz�##only#one#way#to#find#out���########';
  FP[16]:='����������������������������������������������������������������';
  FP[17]:='##############################Q 2       W#######################';
  FP[18]:='P #####################+#########---#### ########## # ##########';
  FP[19]:='## # ###+########### # # # ######222#### #####+### # # # ###+###';
  FP[20]:='### # # # ######### # ### # ###+##2## ## #### # # ## ## # # #E##';
  FP[21]:='###### ### # ### # ## ### ## # # ### # # ### ### ### ## ## ###&#';
  FP[22]:='###### #### # # # ### ### ### ### # ### # # #### ###2## ##7####L';
  FP[23]:='######2####!##W##2###2###2###2####W####2##W#####2###C##2##�#####';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=3;HideStairs:=true;
 end; { Level6 }

procedure Level8;
 begin
  FP[1]:= ' P !XC-----------##-----XXX-------7  1    7           ------DDLL';
  FP[2]:= 'XXXXXX-----------##�----X�X----�---###�###             -W#�#####';
  FP[3]:= '    --------�----##�###########�---##+�+##             --4�-----';
  FP[4]:= '     -------XXXX�##�-----------�---##+�+##             -74   1  ';
  FP[5]:= '   T ----------W-##�-----------�---##+�+##              "######�';
  FP[6]:= '     ----------W-##�7  1        7--##+�+##                    4 ';
  FP[7]:= '    -----------W-##� XXXXXXXXXXX---###X###              �     4 ';
  FP[8]:= '      ---------W-##� XXXXXXXXXXX------�                       4 ';
  FP[9]:= '  T  -----7 1    ##� XXXXXKXXXXX------�                 �     4 ';
  FP[10]:='     -----�XXXXXX##�          --------�1 1 1 7                4 ';
  FP[11]:='     -----�          1     WWWW#######�######           �     4 ';
  FP[12]:='     -----�#############XXX######   71�                       4 ';
  FP[13]:='   T -----�--------##---------##     #�17    W          �     4 ';
  FP[14]:='          �--------##---------##    71�#     W  7      1   7  4 ';
  FP[15]:='          �--------##---------##     #��7    W   000000000#   4 ';
  FP[16]:=' #        �--------##---------##    71�#     W     � WWWWW#   4 ';
  FP[17]:='X#  T     �--------##---------##     #�17    W     � ######   4 ';
  FP[18]:='W#        �   ##XXX##---------##    71�#           �          4 ';
  FP[19]:='W#        �   ##WW[##---------##     #�17          �          4 ';
  FP[20]:='W#        �   ##WWW##---------##    71�#           �          4 ';
  FP[21]:='W# <      �   ##XXX##----K----##     #�17  7      1           4 ';
  FP[22]:='W#        �        ##---------##|     �#    ####################';
  FP[23]:='W#             1   ##       1 44          1 #a#�sideways�#level#';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level8 }

procedure Level9;
 begin
  FP[1]:= '+++++++�--------44---�������������---������������------K---�;-U-';
  FP[2]:= 'XXXXXXX-XXX-----44---      -----------------    ----#######-;---';
  FP[3]:= '--------------71#####       ---------------      #####�-----;;;;';
  FP[4]:= 'K------------71###           -------------          #####�##; P ';
  FP[5]:= '#17---------71####****        -----------       ****##----�W;   ';
  FP[6]:= '##17-------71#####*###         --+-K-+--        ###*##�#####; + ';
  FP[7]:= '###17-----71######*#             #####            #*## 1   7;   ';
  FP[8]:= '####17---71#######*;     W    W    W    W    W    :*#######�;   ';
  FP[9]:= '#####17-71########*#444444444444444444444444444444#*##�     ;   ';
  FP[10]:='######---#########*#                              #*##444�##; + ';
  FP[11]:='#######�##########U#                              #!##�    �;   ';
  FP[12]:='----------------####                              ######�###;   ';
  FP[13]:='----------------##VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV## �   �;   ';
  FP[14]:='----------------##VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV###�####; + ';
  FP[15]:='��-------------�######################################�    �;   ';
  FP[16]:='5555555555555555#############the#lava#pit#################�#;   ';
  FP[17]:='            -------         ------------***********-##+�   C;   ';
  FP[18]:='              000            ---�######-###########-####�###; + ';
  FP[19]:='                                ------7�##LLWDWDWDW�##�     ;   ';
  FP[20]:='                                     ##-###########�#######�;   ';
  FP[21]:='                                     ##-7  1   TTT7�##�    �;   ';
  FP[22]:='�                                    ##--#########��###�####; + ';
  FP[23]:='        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1##111111111  �C##�       � ';
  Fast:=#234;{or #1}
  Convert_Format;
  LavaFlow:=true; LavaRate:=75;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level9 }

procedure Level11;
 begin
  FP[1]:= '66666666666666666666----------------------------66WW---I-------K';
  FP[2]:= '-----------D D D-----66666666666666666666666666(6666666666666---';
  FP[3]:= '-666666666666666666-((((((((((((((((22222222222(-----------666-6';
  FP[4]:= '-666666666666666666-66((((((((((((((22222222222(6-66666666-----6';
  FP[5]:= '-66666666666066WYY6-66VVVVVVVVVVVVVVVVVVVVVVVVV66-66666666666666';
  FP[6]:= '------------0B6WYY--66T-W-W-*-W-W-C-W-W-*-W-W-T66-66666666663666';
  FP[7]:= '-66666666666066WYY6666666666666666666666666666666�66666666636666';
  FP[8]:= '-MMMMM6666666666666666666666666666666666666666666-66666666366666';
  FP[9]:= '-MMMMM............................3!66222222266----$$$$$$$666666';
  FP[10]:='-MMMMM6666666666666666666666666666666622222266~~~~~~~~~~~~-66666';
  FP[11]:='-MMMMM666666666666666666666666666666662222266------------~~-6666';
  FP[12]:='-MMMMM............................3H66222266-~~~~~~~~~~~~-~~-666';
  FP[13]:='-MMMMM6666666666666666666666666666666622266-~~----------~~-~~-66';
  FP[14]:='-66666666666666666666666666666666666@@@@66-~~-~~~~~~~~~~-~~-~~-6';
  FP[15]:='----666-OWOWOWOWOWOWOWOWOWO 66666666@66@666-~~-~~K�-----~~-~~-66';
  FP[16]:='-66-666-6666666666666666666 66666666@66-6666-~~-~~~~~~~~~-~~-666';
  FP[17]:='-66F666-666T-3)K)3-T66W         W666@66-66666-~~---------~~-666C';
  FP[18]:='-66F666-666T-3)))3-T66     G     666-66-666666-~~~~~~~~~~~-6666-';
  FP[19]:='-66666---666666-666666W         W666-66-6633666-----------666333';
  FP[20]:='-66YYYYYYYYY666-66666666666-66666666-66-66--6666666666666-666-66';
  FP[21]:='--     P    666-66+------66-66-------66----Y--D-D-D-LL 66-666-66';
  FP[22]:='666---------666-66666666-66-66Y66666-66666666666666666666-666-66';
  FP[23]:='666222222222666-------------66---Z66--------------------------66';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level11 }

procedure Level13;
 begin
  FP[1]:= 'P   ########Q##########################################1       L';
  FP[2]:= '#    #######X######H 1        H###########H    H######   W]H]W&L';
  FP[3]:= '##    ######O#####       �      #########        ####    #######';
  FP[4]:= '###    #####O####H   ####4###    #######   1##�   ###H   #######';
  FP[5]:= '####    ####O#####H   ###4####    V<[|"V    ###    ###    ######';
  FP[6]:= '####    ####O######    ##4####    ######    ###    ####    #####';
  FP[7]:= '####    ####O#####  1 ###4####  1 ######    ###    #####   H####';
  FP[8]:= '#####    ###O####    ####4#####     H###    ###  1 ####    #####';
  FP[9]:= '######    ##O###    #####4######      ##    ###    ### 1  ######';
  FP[10]:='#######            ######4#########   1    ####    ##    #######';
  FP[11]:='########  1       #######K##########      ######        ########';
  FP[12]:='����������������������������������������������������������������';
  FP[13]:='#diary�#day#two�################################################';
  FP[14]:='################################################################';
  FP[15]:='#the#journey#is#starting#to#wear#you#down�#but#you#will#never###';
  FP[16]:='################################################################';
  FP[17]:='#give#up�##you#have#discovered#new#items#in#kroz�##some#areas###';
  FP[18]:='################################################################';
  FP[19]:='#have#a#strange#magical#gravity#that#tugs#you#down�##you�ve#####';
  FP[20]:='################################################################';
  FP[21]:='#also#discovered#ropes#that#allow#you#to#swing#and#climb#over###';
  FP[22]:='################################################################';
  FP[23]:='#trouble#spots�##kroz#will#beat#you�#you#cannot#accept#defeat�##';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=3;HideStairs:=true;
 end; { Level13 }

procedure Level14;
 begin
  FP[1]:= 'VXVVVVVVVVXVVVVVVXVVVVV   P   VVVVVVVVVVXVVVVVXVVVVVXVVVVVVVVXVV';
  FP[2]:= 'VVVVXVVVXVVVVVXVVVVVVV       VVVXVVVVVVVVVXVVVVVVVXVVVVXVVVVVVVV';
  FP[3]:= 'VVVVVVXVVVXVVVVVVVVXVV         VVVXVVVVVVVVVVXVVVVVVVXVVVVVXVVVV';
  FP[4]:= 'VVXVVVVVVVVVVVVVXVVVVVV      VVVVVVVVXVVVXVVVVVVVXVVVVVVXVVVVVXV';
  FP[5]:= 'VVVVXVVVVXVVVVXVVVVXVVV     VVXVVVVVVVVXVVVVVXVVVVVVVXVVVVVXVVVV';
  FP[6]:= 'XVVVVVVVVVVXVVVVXVVVV       VVVVXVVVVVVVVVVXVVVXVVVVVVVVVVXVVVVV';
  FP[7]:= 'VVVVVVXVVVVVVVXVVVVVVV       VVVVVVVVXVVVXVVV#oh#no�#you�ve#VXVV';
  FP[8]:= 'VVXVVVVVXVVVVVVVVVXVV        VVVXVVVVVVVVVVXV#fallen#into#a#VVVV';
  FP[9]:= 'VVVVXVVVVVVXVVVVXVVVVV      VVVVVVVVVVXVVVVVV#volcano#pit�##VVXV';
  FP[10]:='VVVVVVVXVVVVVXVVVVVXVVV   CVVVXVVVXVVVVVVXVVVVVVVVVVVXVVVVVVVVVV';
  FP[11]:='VXVVVVVVVVXVVVVVVVVVVXV   VVXVVVVVVVVXVVVVVVVVVXVVVVVVVXVVVVVVXV';
  FP[12]:='VVVVXVVVVVVVVXVVXVVVVVV    VVVVVXVVVVVVVVVVXVVVVVVXVVVVVVVVXVVVV';
  FP[13]:='VVVXVVVVXVVVVVVVVVVXVVVV VVVVVVVVVXVVVVVXVVVVXVVVVVVVXVVVVVVVXVV';
  FP[14]:='VVVVVVXVVVXVVVVVVVVVVVV   VVVXVVVVVVVXVVVVVVVVVVVXVVVVVVVXVVVVVV';
  FP[15]:='XVVVVVVVVVVVVVVVXVVVVV  W  VVVVVXVVVVVVVVVXVVVXVVVVVXVVVVVVVVXVV';
  FP[16]:='VVVXVVVVVVVXVVVVVVVXVV   W  VVVVVVVXVVVVVVVVXVVVVXVVVVVVVVVXVVVV';
  FP[17]:='VVVVVVXVVVVVVXVVVVVVVVV W    VXVVVVVVVVXVVVVVVVVVVVVXVVVVXVVVVVV';
  FP[18]:='VVVVVVVVVXVVVVVVXVVVVVV  W   VVVVXVVVVVVVXVVVVXVVVVVVVVXVVVVVVXV';
  FP[19]:='VXVVXVVVVVVVXVVVVVXVVVC W   VVVVVVVVXVVVVVVVVXVVVVXVVVVVVVVXVVVV';
  FP[20]:='VVVVVVXVVVVVVVVXVVVVVVV  W   VXVXVVVVVVVXVVVVVVVXVVVVVXVVVVVVVXV';
  FP[21]:='VVXVVVVXVVVXVVVVVXVVVVVV      VVVVVXVVVVVVXVVVVVVVXVVVVXVVVVXVVV';
  FP[22]:='VVVVXVVVVVVVVXVVVVVVVVXVV      VVXVVVVVXVVVVVVVXVVVVVVVVVVXVVVVX';
  FP[23]:='VVXVVVVXVVVVVVVVVXVXVVVVVVLLLLLLLVVVXVVVVVVXVVVVVVVVXVVVVVVVVVXV';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;HideStairs:=true;
 end; { Level14 }

procedure Level15;
 begin
  FP[1]:= 'VV#VVVVV#VVVVV#VVVVVV#VVVV   P  �-----------I-------3-----�---LL';
  FP[2]:= 'VVVV#VVVVVVV#VVV#VVVVVVV#VV      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  FP[3]:= '#VVVVV#VVVVVVVVVVVVVV#VVVVV      VVVVVV�VVVVVVVV#VVVVVVVVVVV#VVV';
  FP[4]:= 'VVVVVVVVVV#VVVVVV#VVVVV#VVVV      VV#VV<VVVVV#VVVVVVVV#VVVVVVV#V';
  FP[5]:= 'VV#VVVVVVVVVVV#VVVVV#VVVVVVVV      VVVV[VVV#VVVVVV#VVVVVV#VVVVVV';
  FP[6]:= 'VVVVV#VVVVV#VVVVVV#VVVVVVV#V   WWWVVV#V|VVVVVVV#VVVVVV#VVVVVV#VV';
  FP[7]:= 'VV#VVVVV#VVVVVVVVVVVVV#VVVVVV  YYY VVVV"VVVVV#VVVVVVVVVVVV#VVVVV';
  FP[8]:= 'VVVVVVVVVVVVVV#VVVVVVVVVV#VVVV      VVV#VVVVVVVV#VVVVVVVVVVVVVV#';
  FP[9]:= 'VVV#VVVVVVVVVVVVV#VVV#VVVVVVVVV      VVVVV#VVVVVVVV#VVVVVVVV#VVV';
  FP[10]:='#VVVV#VVVVVVVVVVVVVVVVV#VVVVV#VV      VVVVVVV#VVVVVVV#VV#VVVVVVV';
  FP[11]:='VVVVVVV#VVVV#VVVVVV#VVVVVVVVVVV      VVV#VVVVVVVV#VVVVVVVVVVVV#V';
  FP[12]:='VV#VVVVVVVVVV#VVVVVVVVVVVVV#VV      VVVVVVV#VVVVVVVV#VVVVV#VVVVV';
  FP[13]:='VVVVVVVVVV#VVVV#VVVVVVVVV#VVV      VVV#VVVVVVVV#VVVVVVV#VVVV#VVV';
  FP[14]:='VVV#VVVVVVVVVVVVV#VVVV#VVVVVVV      VVVVV#VVVVVVVV#VVVVVV#VVVVVV';
  FP[15]:='VVVVV#VVVVVVV#VVVVVV#VVVVVVVV      VVVVVVVVV#VVV#VVVVVVVVVVVVVV#';
  FP[16]:='#VVVVVV#VVVVVVVVVVVVVVVV#VVV      VV#VVVVVVVVV#VVVVV#VVVVVVV#VVV';
  FP[17]:='VV#VVVVVVVVVVVVV#VV#VVVVVVV  �   VVVVVV#VVVVVVVVVV#VVVVV#VVVVVVV';
  FP[18]:='VVVVVVVVVV#VVVVVVVVVV#VVV#VV      VVV#VVVVV#VVVVVVVVV#VVVVVVVV#V';
  FP[19]:='VVVV#VVVVVVV#VVVVVVVVVV#VVVVV      VVVVV#VVVVVV#VVVVVVVVVV#VVVVV';
  FP[20]:='#VVVVVV#VVVVVVV#VVVV#VVVVVVVVV      VV#VVVVVV#VVVVV#VVVVVVVVV#VV';
  FP[21]:='VV#VVVVVV#VVVVVVVV#VVVVVVV#VV      VVVVVVV#VVVVVV#VVVVVV#VVVVVVV';
  FP[22]:='VVVVV#VVVVVVV#VVVVVVVVV#VVVVVVVVVVVVVVV#VVVVVVV#VVVVV#VVVVV#VVVV';
  FP[23]:='#VVVVVVVVV#VVVVVVVVVV#VVVVVVVVVVVVVV#VVVVVVV#VVVVVV#VVVVVVVVV#VV';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level15 }

procedure Level18;
 begin
  FP[1]:= 'K----------------------------YYY!YYY---------------------------K';
  FP[2]:= '-66666666666666666666666666666666666666666666666666666666666666-';
  FP[3]:= '-66�                           �+          DTDTDTDTLL 66   -"66-';
  FP[4]:= '-66                                        6666666666666   --66-';
  FP[5]:= '-6666666666666666666666666666666666                          66-';
  FP[6]:= '-66<-     )                   66 ..                          66-';
  FP[7]:= '-66--     #############       66 66      ##$$$$$$$$$$$##     66-';
  FP[8]:= '-66      ##11111111111##      66 66      ###MMMMMMMMM###     66-';
  FP[9]:= '-66     ##1111111111111(      66 66      ####MMMMMMM####     66-';
  FP[10]:='-66     ##1111111111111(      66(66      ##W##MMMMM##W##     66-';
  FP[11]:='-66      ##11111111111(       66 66      ##WW##MMM##WW##     66-';
  FP[12]:='-44)))))))############(       66P66      ##WWW##&##WWW##     55-';
  FP[13]:='-66      )11111111111##       66 66      ##....###....##     66-';
  FP[14]:='-66     )1111111111111##      66 66      ##     #     ##     66-';
  FP[15]:='-66     )1111111111111##      66 66      ##     �     ##     66-';
  FP[16]:='-66     ##11111111111##       66 66      ##           ##     66-';
  FP[17]:='-66      #############        66 66      ##]]]]]]]]]]]##   --66-';
  FP[18]:='-66                           .. 66                        -[66-';
  FP[19]:='-66                           666666666666666666666666666666666-';
  FP[20]:='-66--   6666666666666         +�                             66-';
  FP[21]:='-66|-   66 LLWDWDWDWD                                       �66-';
  FP[22]:='-66666666666666666666666666666666666666666666666666666666666666-';
  FP[23]:='K----------------------------3333333---------------------------K';
  Fast:=#234;{or #1}
  Convert_Format;
  HideMBlock:=true;HideCreate:=true;TreeRate:=70;
 end; { Level18 }

procedure Level20;
 begin
  FP[1]:= '<33333333333333333333333333333333333333333333333333333333333333[';
  FP[2]:= '3                                                              3';
  FP[3]:= '3                                                              3';
  FP[4]:= '3                                                              3';
  FP[5]:= '3           YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY           3';
  FP[6]:= '3           YC     F        F   Z         W    F �KY           3';
  FP[7]:= '3           Y          W           F     F       ��Y           3';
  FP[8]:= '3           Y    F            �����          F   F Y           3';
  FP[9]:= '3           YW         F      �   �  F             Y           3';
  FP[10]:='3           Y                 � P �             W  Y           3';
  FP[11]:='3           Y    W F      F   �F  �   F    F       Y           3';
  FP[12]:='3           Y                 �����   W        F   Y           3';
  FP[13]:='3           Y F              F                     Y           3';
  FP[14]:='3           Y��       F   W       F       F      F Y           3';
  FP[15]:='3           YK� F               Z           W     CY           3';
  FP[16]:='3           YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY           3';
  FP[17]:='3                                                              3';
  FP[18]:='3                                                              3';
  FP[19]:='3                                                              3';
  FP[20]:='"33333333333333333333333333333333333333333333333333333333333333|';
  FP[21]:='5##############################444#############################5';
  FP[22]:='--~~-~--~-~--~~-~~--~--~-D-D-++-L-WW-D-D-~--~--~-~~-~--~~-~~-~--';
  FP[23]:='-~--~-~~-~-~~--~--~~-~~--D-D-++�L�WW-D-D--~~-~~-~--~-~~--~--~-~-';
  Fast:=#234;{or #1}
  Convert_Format;
  HideOpenWall:=true;
 end; { Level20 }

procedure Level22;
 begin
  FP[1]:= '###key#shop###MTMMMMMMMMMMMMMMMMMMMMM-----MMMMMMMMMMMM-MM--!##LL';
  FP[2]:= '##K��44@@@@@##MMMMMMMMMMMMMMMMMMMMMM-MMMMM-MMMMMMMMMM-M-M-P-##LL';
  FP[3]:= '##K�3##@@@@@@DMMMMMMCMMMMMMMMMMMMMM-MMMMMMM-MMM<MMMM-MMM----##DD';
  FP[4]:= '##K��##@@@@@##M-MMMMMMMMMMMMMMMM---MMMMMMMM-MMMMMMM-MMMMMMMM##DD';
  FP[5]:= '#######X######MM-MMMMMMMMMMM----MMMMMMMMMMMM-MMMMM-MMMMMMMMM##DD';
  FP[6]:= '##�-----##MMMMMMM-MMMMM-----MMMMMMMMMMMKMMMMM-MMM-MMMMMMMMMM##DD';
  FP[7]:= '##########MMMMMMTMMMMM-MMMMMMMMMMMMMMMMMMMMMMM-M-MMMMMMMMMMMMMMM';
  FP[8]:= 'MMMMMMMMMMMMMMMMMMMMM-MMMMMMMMMMMMMMMMMMMMMMMMM-MMMMMMCMMMMMM-MM';
  FP[9]:= 'MMMMMMMM-----MMMM----MMMMMMMM[MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MMM';
  FP[10]:='MMMM----MMMMM----MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMTMMMMMMMMMMM-MMMM';
  FP[11]:='MMM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MMM';
  FP[12]:='MM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MM';
  FP[13]:='MM-MMMMMMCMMMMMMMMMMMMMMMBWWWWWWWWWW-------------------------MMM';
  FP[14]:='MM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MM';
  FP[15]:='MM-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMTMMMMMMMMMMMMMMM-M';
  FP[16]:='MMM-------MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM-MM';
  FP[17]:='MMMMMMMMMM-----MMMMMMMMMMMMMMMM]MMMMMMMMM-M-MMMMMMMMMMMMMMMM-MMM';
  FP[18]:=')))))))))MMMMMM-MMMMMMMMMMMMMMMMMMMMMM-M-M-M-MMMMMMMMCMMMMM-MMMM';
  FP[19]:='22222222)MMTMMM-MMMMMCMMMMMMMMMMMMMMM-M-MMMMM-MMM-MMMMMMMM-MMMMM';
  FP[20]:='22222222)MMMMMM-MMMMMMMMMMMMMMM------MMMMMMM-MMM-M-MMMMMM-MMMMMM';
  FP[21]:='22222222)MMMMMM-MMMMMMMMMM-----MMMMMMMMMMMM-MMM-MM-MMMMM-MMMMMMM';
  FP[22]:='--222222)MMMMMM-----------MMMMMMMMMMMMMMMM-MM-M-MMM-M-M-MMMMM"MM';
  FP[23]:='K-222222)MMMMMMMMMMMMMMMMMMMMMMMMMM|MMMMMMM--M-MMMMM-M-MMMMMMMMM';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level22 }

procedure Level24;
 begin
  FP[1]:= 'T    P  #the#step#of#faith#-----�-~K�-------U-----#---D-D-D-D-LL';
  FP[2]:= '######----------------------�44444444-------�-K�--#�############';
  FP[3]:= '-----------------------------#       ------#####�-#-----�-------';
  FP[4]:= '-----------------------------#        -----:------#----�-�------';
  FP[5]:= '------###--------------------#        -----:------#--��---�-----';
  FP[6]:= '--------#--------------------#        -----:------#-#------�----';
  FP[7]:= '--------#--------------------#        -----#####--#-#-----------';
  FP[8]:= '--------#--------------------#        -----#---;--#-#------�----';
  FP[9]:= '--------#--------------------#        -----#<###--#-#-----------';
  FP[10]:='--------#---------�---------�#         ----#[#----#-#-----�-----';
  FP[11]:='--K-----#�########88888888888#         ----#|#----#-#----�--W---';
  FP[12]:='-XXX----#      #             #         ----#"#----#-#-------W---';
  FP[13]:='        #      #             #          ---#-#----#-#---�---W---';
  FP[14]:='        # �    #             #          ----------#-##-�----W---';
  FP[15]:='        #      #             #             ;;;;;- #�K#�-----W---';
  FP[16]:='        #      #             #                 +-+####------W---';
  FP[17]:='        #      #             #                 +-+----�-----W---';
  FP[18]:='    XXXX#      #             #                 +-+---�------W---';
  FP[19]:='         �     #             #                 +-+###-----------';
  FP[20]:='       ###     #             #    U            +-+#--------7----';
  FP[21]:='               #             #                 + +#   ##C.!.C## ';
  FP[22]:='               #             #                 + +#   ######### ';
  FP[23]:='VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;  LavaFlow:=true;LavaRate:=75;
 end; { Level24 }

procedure Level26;
 begin
  FP[1]:= '::::::::::::::::::::::::::::::::::::::::::::::::####amulet####::';
  FP[2]:= ':###########::::::::::::::::::::::::::::::::::::#55]-----]---#::';
  FP[3]:= ':#         #::::::::::::::::::::::::::::::::::::#�5----]--L-�#::';
  FP[4]:= ':#    P   HOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO::::::#55-]------]-#::';
  FP[5]:= ':#K        #::::::O::::::::::::-:::::::::O::::::###D##########::';
  FP[6]:= ':###########::::::O::::::::::::-:::::::::O:::::::::O::::::::::::';
  FP[7]:= '::::::::::::::::::O::::::::::::-:::::::::O:::::::::O::-----:::::';
  FP[8]:= '::::::::::::::::::O::::::::::::-:::::::::O:::::::::O::+++:-:::::';
  FP[9]:= '::::::::::::::::::O::::::::::::-:::::::::O:::::::::O::+++:-:::::';
  FP[10]:='::::::::::::::::::O::::::::::::-:::::::::O:::::::::O::::::-:::::';
  FP[11]:=':::::::::::OOOOOOOO::::::::::::-::::#####D###::::::O::::::-:::::';
  FP[12]:=':::::::::::O:::::::::::::::::::-::::#K;     #::::::OOOOO::-:::::';
  FP[13]:=':::::::::::O:::::::::::::::::::-::::#;;     #::::::::::O::-:::::';
  FP[14]:=':::::######D#############::::::-::::# W     #::::::::::O::-:::::';
  FP[15]:=':::::#!---...----T---I--#::::::-::::#       #::::::::::O::-:::::';
  FP[16]:=':::::#----K----F---�---�#::::::-::::#     * #::::::::::O::-:::::';
  FP[17]:=':::::#-S---I----------Z-#::::::-::::#       #::::::::::O::-:::::';
  FP[18]:=':::::####################::::::-::::#   W   #::::::::::O::-:::::';
  FP[19]:=':::::::::::::::::::::::::::::::-::::#       #::::::::::O::-:::::';
  FP[20]:=':::::::::::::::::::::::::::::::-::::#4444444#::::::::::O::-:::::';
  FP[21]:='::::::::::::::::::::::::+++::::-::::#K;-----DOOOOOOOOOOOOOOOOO::';
  FP[22]:='###rogue###:::::::::::::+++-----::::#########:::::::::::::::::::';
  FP[23]:='#was#here�#:::::::::::::::::::::::::::::::::::::::::::::::::::::';
  Fast:=#234;{or #1}
  Convert_Format;
  HideGems:=true; HideCreate:=true;
 end; { Level26 }

procedure Level28;
 begin
  FP[1]:= '#diary�#day#three�################## P #########################';
  FP[2]:= '###################################### ############�   #########';
  FP[3]:= '#you#slept#well#last#night#after#######  ########## ### ########';
  FP[4]:= '###################################### ## ######### #### #######';
  FP[5]:= '#the#unexpected#discovery#of#the###### ##;######### #####  #####';
  FP[6]:= '###################################### ##;######### ####### ####';
  FP[7]:= '#fabled#amulet#of#yendor�##the######## ##;######### ####### ####';
  FP[8]:= '###################################### ##;######### #######  ###';
  FP[9]:= '#amulet#was#long#thought#to#be######## ##;######### ######### ##';
  FP[10]:='###################################### ## ######### ######## ###';
  FP[11]:='#lost#in#a#land#stangely#called####### ###  ####### ######  ####';
  FP[12]:='######################################�#### ####### ###### #####';
  FP[13]:='#�rogue��##many#of#your#fellow########4### ##�      ##### ######';
  FP[14]:='######################################4#  ### ##### ### T#######';
  FP[15]:='#archaeologist#friends#have#spent#####4 ##### ##### ## #########';
  FP[16]:='###################################### ###### ##### ### ########';
  FP[17]:='#countless#hours#trying#to#get######## ###### ##### ####  ######';
  FP[18]:='###################################### ###### ##### ###### #####';
  FP[19]:='#the#amulet�##how#ironic#that######### ###### #####�####### ####';
  FP[20]:='###################################### ###### ##### ######## ###';
  FP[21]:='#you#should#stumble#across#it�######## ######X####====####### ##';
  FP[22]:='#######################################        �#=======###### #';
  FP[23]:='#what#other#mysteries#await#in#kroz�############=========#####L#';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true; HideStairs:=true; HideOpenWall:=true;
 end; { Level28 }

procedure Level30;
 begin
  FP[1]:= '1111144       ##C######locksmith#shoppe######C##         RRRRRRR';
  FP[2]:= '1111144       ##]##K#K#K#K#K#-3-3#K#K#K#K#K##]##        RRRRRRR�';
  FP[3]:= '1111144          ##:::::::::######::::::::;##         RRRRRRRCYY';
  FP[4]:= '1111144          ##------------------------##     666RRRRRRRR66 ';
  FP[5]:= '1111144          #############--#############     6666666666666 ';
  FP[6]:= '1111144                                           HOOOOOOOOH    ';
  FP[7]:= '1111144                                        6666666666666    ';
  FP[8]:= '1111144                                        66RRRRRRR6666    ';
  FP[9]:= '1111144                                        RRRRRRR          ';
  FP[10]:='1111144                                      RRRRRR           YY';
  FP[11]:='1111144               P                    RRRRRR             YZ';
  FP[12]:='1111144                                 RRRRRRRRRR            YY';
  FP[13]:='1111144                              RRRRR333RRRRR              ';
  FP[14]:='1111144                             RRR3333333RRRRR             ';
  FP[15]:='@@@@@##                           RRR3333333333RRRRR            ';
  FP[16]:='MMMMM##                           RRR333333333RRRRR             ';
  FP[17]:=')))))##                          RRR33333333RRRRR               ';
  FP[18]:='MMMMM##                        RRRR333333RRRRRRR        DDDDDDDD';
  FP[19]:='(((((##                       RRRR3LL3RRRRRRRR          DDDDDDDD';
  FP[20]:='MMMMM##                      RRRRRRRRRRRRRR             DDDDDDDD';
  FP[21]:='$$$$$##                     RRRRRRRRRRRR                DDDD7777';
  FP[22]:='MMMMM##                     RRRRRRRR                    DDDD77��';
  FP[23]:=']]K]]##�                   RRRRRRK]                     DDDD77�!';
  Fast:=#234;{or #1}
  Convert_Format;
  HideCreate:=true;
 end; { Level30 }

procedure Level32;
 begin
  FP[1]:= ' P                     I    � 9                     �         K ';
  FP[2]:= 'XXXXXXXXXXXXXXXXXXXXXXXXXX##77;XXXXXXXXXX##XXXXXXXXXXXXXXX##;;XX';
  FP[3]:= 'XXXXXXXXXXXXXX##XXXXXXXXXXXXIICXXXXXXXXXXXXXXXXX##XXXXXXXXXX;;XX';
  FP[4]:= 'XXX##XXXXX!XXXXXXXXXXXXX##XX---XXXXXXXXXXXXXXXXXXXXXXXXXXXXX;;##';
  FP[5]:= 'XXXXXXXXXXXOOOOOOOOOOOOOOOOO---X##XXXXXXXXXXXXXXXXXXXX##XXXX;;XX';
  FP[6]:= 'XXXXXXXX##XXXXXXXXXXXXXXXXXX---XXXXXXXXXXXXXX##XXXXXXXXXXXXX;;XX';
  FP[7]:= 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXW-+XXXXX##XXXXXXXXXXXXXXXXXXXX##;;XX';
  FP[8]:= 'XXXXXXXXXXXXXXXX##XXXXXXXXXXW-+XXXXXXXXXXXXXXXXXXXXXXXXXXXXX;;XX';
  FP[9]:= '##XXXXXXXXXXXXXXXXXXXXXXXXXXW-+XXXXXXXXXXXXXXXXOXXXXXXXXXXXX;;XX';
  FP[10]:='XXXXXXXXXXXXXXXXXXXXXXXXXXXXW-+XXX##XXXXXXXXXXXOXXXXXX##XXXX;;XX';
  FP[11]:='XXX##XXXXXXXXXXXXXXXXXXXX##XW-+XXXXXXXXXXX##XXOOOXXXXXXXXXXX;;XX';
  FP[12]:='XXXXXXXXXX##XXXXXXXXXXXXXXXXW-+XXXXXXXXXXXXXXXOQOXXXXXXXXXXX;;##';
  FP[13]:='XXXXXXXXXXXXXXXXX�XXXXXXXXXXW-+XXXXXXX##XXXXXXOOOXXXX##XXXXX��XX';
  FP[14]:='XXXXXX##XXX##rip##XXXXXXXXXXW-+XXXXXXXXXXXXXXXXOXXXXXXXXXXXX--XX';
  FP[15]:='XXXXXXXXXXXXXXXXXXXXXXXXXXXX�-�XXXXXXXXXXXXXXXXOX##XXXXXXXXXCCXX';
  FP[16]:='XXXXXXXXXXXX##XXXXXXXXXXXXXXXOXXXX##XXXXXXXXXXXXXXXXXXXXXXXX##XX';
  FP[17]:='XXXXXXXXXXXXXXXXXXXXXXXXX##XXOXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  FP[18]:='XX##XXXXXXXXXXXXXXXXXXXXXXXXXOXXXXXX##XXXXXXXXXXXXXXXXXX##XXXXXX';
  FP[19]:='XXXXXXXX##XXXXXXXXXXXXXXXXXXXOXXXXXXXXXXXXX##XXXXXXXXXXXXXXXXXXX';
  FP[20]:='XXXXXXXXXXXXXXXXXXXX##XXXXXXXOXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  FP[21]:='XCCXXXXXXXXXXX##XXXXXXXXXXXXXOXX##XXXXXXXXXXXXXXXXXXXX##XXXXXXXX';
  FP[22]:='XCCXX##XXXXXXXXXXXXXXXXXXXXXXOXXXXXXXXXXXXXXXXXXXXX#do#you#dare#';
  FP[23]:='XXXXXXXXXXXXXXXXXXXXXXXX##XXXLXXXXXXXXXX##XXXXXXXXX####go#down�#';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true; HideStairs:=true;
 end; { Level32 }

procedure Level33;
 begin
  FP[1]:= '##tunnels#of#kroz###########-P--################################';
  FP[2]:= '########################X###----######X##-------D--------##X####';
  FP[3]:= '############################----#########-------D--------#######';
  FP[4]:= 'L---N-----######�  � �######-----------------########----#######';
  FP[5]:= 'L---N-----##X###  CC  555555-----------------#####X##1111#######';
  FP[6]:= '######----######� �  �###############################----#####X#';
  FP[7]:= '######1111###########################################1111#######';
  FP[8]:= '#X####----##############X#######magic#####X##########----#######';
  FP[9]:= '######1111####################�-�-�-�-�##############----N-----#';
  FP[10]:='######----####################---------##############----N-----#';
  FP[11]:='######1111#######X############�-�-�-�-�#########X##########----#';
  FP[12]:='######----########################-########################1111#';
  FP[13]:='######1111################X#######-########################----#';
  FP[14]:='######----########################---------N-------------------#';
  FP[15]:='###X##----##########################################-----------#';
  FP[16]:='######----------------�########################X####----########';
  FP[17]:='######-----------------444444%######################1111########';
  FP[18]:='###################----#############################----#####X##';
  FP[19]:='###################1111#############X###############1111########';
  FP[20]:='############X######----#############################----########';
  FP[21]:='###################-------N-----------------------------########';
  FP[22]:='##X################-------N-----------------------------##X#####';
  FP[23]:='################################################################';
  Fast:=#234;{or #1}
  Convert_Format;
  HideStairs:=true; HideOpenWall:=true;
 end; { Level33 }

procedure Level34;
 begin
  FP[1]:= '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[2]:= '~~~~~~~~~~~~~W-----------E----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[3]:= '~~~~~~~~~~~~~------------E----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  FP[4]:= '~~~~~~~~~~~~~----~~~~~~~~~----~~~~~~~~~~W---E------------------P';
  FP[5]:= '~~~~~~~~~~~~~----~~~~~~~~~----~~~~~~~~~~----E-------------------';
  FP[6]:= '~~~~~~~~~~~~~----~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[7]:= '~~~~~~~~~~~~~----~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[8]:= '~~~~W------------~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[9]:= '~~~~-------------~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[10]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[11]:='~~~~----~~~~~~~~~~~~~~~~~~W---~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[12]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[13]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[14]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[15]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~';
  FP[16]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~--------------<~~~~~~~~~';
  FP[17]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~W-------------[~~~~~~~~~';
  FP[18]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~~---|~~~~~~~~~';
  FP[19]:='~~~~----~~~~~~~~~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~~---"~~~~~~~~~';
  FP[20]:='~~~~---W~~~~~~~~~~~~~~~~~~----~~~~~~~~~~~~~~~~~~~~~----~~~~~~~~~';
  FP[21]:='~~~~----~~~~~~~~~~~~~~~~~~-----------------------------~~~~~~~~~';
  FP[22]:='~~~~----~~~~~~~~~~~~~~~~~~W-------------------------W--~~~~~~~~~';
  FP[23]:='~~~~LLLL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  Fast:=#234;{or #1}
  Convert_Format;
  HideLevel:=true;
 end; { Level34 }

procedure Level35;
 begin
  FP[1]:= 'VVVV--P-VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[2]:= 'VVVV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[3]:= 'VVVV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  FP[4]:= 'VVVV----VVVVVVVVVVVVVVVVVVVVVVVVVVVVV-----------------------VVVV';
  FP[5]:= 'VVVV---------------VVVVVVVVVVVVVVVVVV-----------------------VVVV';
  FP[6]:= 'VVVV---------------VVVVVVVVVVVVVVVVVV----VVVVVVVVVVVVVVV----VVVV';
  FP[7]:= 'VVVVVVVVVVVVVVV----VVVVVVWWVVVVVVVVVV----VVVVVVVVVVVVVVV----VVVV';
  FP[8]:= 'VVVVVVVVVVVVVVV----VVVVVVWWVVVVVVVVVV----VVVVVVVVVVVVV?V----VVVV';
  FP[9]:= 'VVVVVVVVVVVVVVV----VVVVVVWWVVVVVVVVVV----VVVVVLLVVVVVVVV----VVVV';
  FP[10]:='VVVVVVVVVVVVV]V----VVVVVVWWVVVVVVVVVV----VVVVV--VVVVVVVV----VVVV';
  FP[11]:='VVVVVVVVVVVVVVV----VVVVVVWWVVVVVVVVVV----VVVVV--VVVVVVVV----VVVV';
  FP[12]:='VVVVVVVVVVVVVVV----VVVVVVWWVVVVVVVVVV----VVVVV--VVVVVVVV----VVVV';
  FP[13]:='VVVVVVVV-----------VVVVVVWWVVVVVVVVVV----VVVVV--VVVVVVVV----VVVV';
  FP[14]:='VVVVVVVV-----------VVVVVVWWVVVVVVVV]V----VVVVV--VVVVVVVV----VVVV';
  FP[15]:='VVVVVVVV----VVVVVVVVVVVVV++VVVVVVVVVV----VVVV----VVVVVVV----VVVV';
  FP[16]:='VVVVVVVV----VVVVVVVVVVVVV++VVVVVVVVVV----VVVV----VVVVVVV----VVVV';
  FP[17]:='VVVVVVVV----VVVVVVVVVVVVV++VVVVVVVVVV----VVVV----VVVVVVV----VVVV';
  FP[18]:='VVVVVVVV---------------------------------VVVV----VVVVVVV----VVVV';
  FP[19]:='VVVVVVVV---------------------------------VVVV----VVVVVVV----VVVV';
  FP[20]:='VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV----VVVVVVV----VVVV';
  FP[21]:='VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV---------------VVVV';
  FP[22]:='VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV---------------VVVV';
  FP[23]:='VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV';
  Fast:=#234;{or #1}
  Convert_Format;
  LavaFlow:=true; LavaRate:=15;
 end; { Level35 }

procedure Level37;
 begin
  FP[1]:= '"|[<-333333333---------------------------------`--D--D--D--D-&LL';
  FP[2]:= '##############�###XXX###########################################';
  FP[3]:= '�-�-�-�-�-�-�-----I----------------------F------------�#--�-----';
  FP[4]:= '###############################�###########�#############XXX###�';
  FP[5]:= '--------------------------#C$$2$2$2$2$2$2$2$2$$$$$$$$$$$$$$$$#1-';
  FP[6]:= '�############�###########�#####################################-';
  FP[7]:= '-#T�-M-----------------�#-----#-U-#--------------------------#1-';
  FP[8]:= '-##############777777�###-#####���#############################-';
  FP[9]:= '-P-W #+�------#222222C#+-------------------------------1-1-1-1-�';
  FP[10]:='-### ########�###########-#####888#�##################�#########';
  FP[11]:='-#+- #�-------------------4---#292#--1(T(((((MMMMMMMMMMMMMMMMMMK';
  FP[12]:='-### ####################-##�###-##############################�';
  FP[13]:='-#W- #�-------------------#1�1#292#-----------------------------';
  FP[14]:='-### #######################�###-##::;::::::::::::::::::::::::::';
  FP[15]:='-#T- #----------------------�1#292#--T--------------------333333';
  FP[16]:='X### ##�####################�###-#######################�#######';
  FP[17]:='X#*- #--@1@1@1@1@1@1@1@1@!#1�1#---000000---#------#-------#-----';
  FP[18]:='X### #######################�############�##--##�###�#######�##-';
  FP[19]:='--�------C--~-------------#1�1#K-DDD-----�1#--#---1---#*I*#1�1#K';
  FP[20]:='##############�#############�############�##--##########�###�##-';
  FP[21]:='�-)------------........)2K#1�1#K-DDD-----�1#--------------5---#�';
  FP[22]:='############################�############�#####################-';
  FP[23]:='Q-1;1;1;1;1;1;1;1-1-1-1-1-1-------B----#-----------------------U';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level37 }

procedure Level40;
 begin {NEEDS TWO KEYS FROM LEVEL 38}
  FP[1]:= '   00000000000000�-Y-----000000000-0-0000000000000000000000-0000';
  FP[2]:= ' P 0000000000000--000-00-000000000-0-----K000000000-000-----0000';
  FP[3]:= '   000000000000-0-0000-0-00000000-0000000000000000-0000000000-00';
  FP[4]:= '0-000000000000000-00000-00000000000000000-000000-0000-0000W0--00';
  FP[5]:= '00000000000000000I000000-000!000000-0000000-0000--00-00000W00000';
  FP[6]:= '0-0000000000000000000000000YYY000000------0-0---0000000000W000-0';
  FP[7]:= '0--000000000000-0000000000---------000-0--0000000000000000W-000-';
  FP[8]:= '0000000000000000-00000000000000000-00000000000000000000000-00000';
  FP[9]:= '000--0000000000000-000-0-000000000000000000000000000000000000-00';
  FP[10]:='00000000000000000-00000-0000000000000000000-0-666666666000000-00';
  FP[11]:='0-0000-00000000--000000000000000000000-0----00DDD�LL&6600000-000';
  FP[12]:='--00000000000-00-0000000000000000000000-0000-0666666666000--0000';
  FP[13]:='0-00000000000000�00000000-0000-0000-00000-0000-000000000000-0000';
  FP[14]:='-000000000000000-0000000-0-0000-00-00000--00000000000000-0000000';
  FP[15]:='0-00000000000000-0-0000000-00-00000000000000000000000000000000-0';
  FP[16]:='00-00000000000000-0000-00000-000-000-0--000000000000000000-0-000';
  FP[17]:='00000000000000000----0-00000T-000-000-000000000000-00000000-0000';
  FP[18]:='000--0000000000000000000000000000000000000000000000--0000000-000';
  FP[19]:='00-00-00000-000000000000000000000000000000000000--00000000000-00';
  FP[20]:='0-00000000-000000000000-00000000000000000000000-00-00000000000--';
  FP[21]:='-00000000-0-000000-00000-------------0++++++++++0000000000000000';
  FP[22]:='000--00000000---0-0-0--000000000000000000000000000--0-0-0-0-0-00';
  FP[23]:='---00---00000-00-000-000-00<0[0|0"0000000000000000-0-0-0-0-0-000';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level40 }

procedure Level42;
 begin
  FP[1]:= '###########klose#enkounters#of#the#krazy#kubikal#kind�##########';
  FP[2]:= '3                               P                              3';
  FP[3]:= '##-##############:########:#######:###########:##############:##';
  FP[4]:= 'XXXXXXXXX##~W~W~W~W~##�-M----M.--$$$$$$$$$-9/-/\--\-|##---��---';
  FP[5]:= '---------##*~*~*~*~*##-�.-�M-�-##$$$$$$$$$##\--/-\-/\##YYYYYYYYY';
  FP[6]:= 'MMMMMMMMM##~W~W~W~W~##M--�-.-M-##111111111##-/-\/--/-##(((((((((';
  FP[7]:= ')))))))))##*~*~*~*~*##.�-.-�-.�##222222222##/\--\-\-/##(((((((((';
  FP[8]:= 'C))))))))--~W~W~W~W~##�.-�--�-M##333333333##�-//-\-/-9-(((((((((';
  FP[9]:= '###################-################################9##55555555-';
  FP[10]:='�-�-�-�-�##YYYYYYYYY##222222222------0---W##RRRRRRRRR##MMMMMMMMM';
  FP[11]:='-----------YYYYYYYYY##@@@@@@@@@##---000---##RXXXXXXXR##MMMMMMMMM';
  FP[12]:='XXXXXXXXX##YYYYYYYYY##@@@@@@@@@##--00G00--##RXXXKXXXR##MMMMMMMMM';
  FP[13]:='---------##YYYYYYYYY##@@XXX@@@@##---000---##RXXXXXXXR##MMMMMMMMM';
  FP[14]:='���������##YYYYYYYYK##@@XZX@@@@##----0---W##RRRRRRRRR##MMMMMMMMK';
  FP[15]:='-#####################-##########�##################H##Z########';
  FP[16]:='~-~[~-~-~##WWW......�1:1:1:1:1:##-773C7--7##=--=I==-=##������Y0"';
  FP[17]:='-~-~-~-~-##WWW......##1:1:1:1:1##7-777-77-##!==-=--==##������Y00';
  FP[18]:='~-~-~-~-~##.........##:1:1:1:1:##-77--77-7##=======-=##������YYY';
  FP[19]:='-~-~-~-~-##.........##1:1:1:1:1##7-7-77-77##-==-=-==I##���������';
  FP[20]:='K-~-~-~-~-�..<......##:1:1:1:1�##77-7777---I=--=-=--=##222222222';
  FP[21]:='############################################################44##';
  FP[22]:='LL---V--V-VV-V--VV---D-----D--�--D--�--D--66333333333333333-WWWW';
  FP[23]:='LL--V-VV-V--V-VV--V--D-----D--�--D--�--D--66YYYYYYYYYYYYYYYYYYYY';
  Fast:=#234;{or #1}
  Convert_Format;
  TreeRate:=35;
 end; { Level42 }

procedure Level44;
 begin
  FP[1]:= '#diary�#day#four�###############################################';
  FP[2]:= '################################################################';
  FP[3]:= '#you�ve#discovered#ancient#tablets#that#have#magical#mantras####';
  FP[4]:= '################################################################';
  FP[5]:= '#written#on#them�##these#short#prayers#seem#to#awaken#a#magical#';
  FP[6]:= '################################################################';
  FP[7]:= '#force#that#pervades#the#entire#kroz#kingdom�##as#you#drink####';
  FP[8]:= '################################################################';
  FP[9]:= '#from#your#water#pouch#and#chew#on#a#stick#of#dried#beef#you####';
  FP[10]:='################################################################';
  FP[11]:='#wonder#who#built#this#strange#place#called#kroz�#and#why�##if##';
  FP[12]:='################################################################';
  FP[13]:='#only#you#could#find#this#�lost�#information���get#the#real#####';
  FP[14]:='################################################################';
  FP[15]:='#story#on#kroz�##a#welcome#burst#of#excitement#urges#you#on���##';
  FP[16]:='����������������������������������������������������������������';
  FP[17]:='----�-�-�-�-�-�-�-�------------------------#-----~--------------';
  FP[18]:='-----------------------------------�######�#-----~�#0000--------';
  FP[19]:='�����W-W-W-K-W-W-W-----------------�#-----�#-----~�#K----------K';
  FP[20]:=' P                ---------------�9�#-####.#-----~�####-########';
  FP[21]:='####                ####00000000000�#�-----------~�#K----------K';
  FP[22]:='###==================###----------0�#.#########--~�####-########';
  FP[23]:='###==================##############---#K-------0-~-----~DDDDDDLL';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=1;Sideways:=true;
 end; { Level44 }

procedure Level46;
 begin
  FP[1]:= '###<@@@@@@@@@@@@@@@@@@@@@@@@@#one#@@@@@@@@@@@@@@@@@@@@@@@@@FK###';
  FP[2]:= 'K�###@@@@@@@@@@@@@@@@@@@@@@@@@;!:@@@@@@@@@@@@@@@@@@@@@@@@@@###$[';
  FP[3]:= '��((###@@@@@@@@@@@@@@@@@@@@@@@:::@@@@@@@@@@@@@@@@@@@@@@@@###$$$$';
  FP[4]:= '((((((###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###$$$$$$';
  FP[5]:= '(((((((2###222222222222222222222222222222222222222222###2$$$$$$$';
  FP[6]:= '(((((((2((###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###$$2$$$$$$$';
  FP[7]:= '(((((((2((((###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###$$$$2$$$$$$$';
  FP[8]:= '(((((((2((((((###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###$$$$$$2$$$$$$$';
  FP[9]:= 'DD##(((2((((((((###@@@@@@@@@@@@@@@@@@@@@@@@@@###$$$$$$$$2$$$####';
  FP[10]:='DD#f(((2(((((((((##############77##############$$$$$$$$$2$$$##CC';
  FP[11]:='DD#o(((2((((((((�##2------------------------2##�$$$$$$$$2$$$t#��';
  FP[12]:='DD#u(((2((((((((�----------F---P----S--------88�$$$$$$$$2$$$w#MM';
  FP[13]:='&&#r(((2((((((((�##2------------------------2##�$$$$$$$$2$$$o#MM';
  FP[14]:='LL##(((2(((((((((##############99##############$$$$$$$$$2$$$##MM';
  FP[15]:='####(((2((((((((###)))))))))))����)))))))))))###$$$$$$$$2$$$##��';
  FP[16]:='(((((((2((((((###))))))))))))))))))))))))))))))###$$$$$$2$$$$$$$';
  FP[17]:='(((((((2((((###))))))))))))))))))))))))))))))))))###$$$$2$$$$$$$';
  FP[18]:='(((((((2((###))))))))))))))))))))))))))))))))))))))###$$2$$$$$$$';
  FP[19]:='(((((((2###))))))))))))))))))))))))))))))))))))))))))###2$$$$$$$';
  FP[20]:='((((((###2222222222222222222222222222222222222222222222###$$$$$$';
  FP[21]:='((((###))))))))))))))))))))))))))))))))))))))))))))))))))###$$��';
  FP[22]:='"(###))))))))))))))))))))))))))))))))))))))))))))))))))))))###�K';
  FP[23]:='###K�)))))))))))))))))))))))#three#))))))))))))))))))))))))F|###';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level46 }

begin
end. { Level Layouts }

