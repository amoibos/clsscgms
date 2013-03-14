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
(****************************************************************************)
(*                             SUPERNOVA VERSION B                          *)
(*     >> This file contains the special room routines for Supernova <<     *)
(*                         Programmer: Scott Miller                         *)
(*                       << Began February 2, 1985 >>                       *)
(*                       Copyright 1985 Scott Miller                        *)
(****************************************************************************)
program supernova;
uses crt, dos,video;
{$C-,R-,V-}

const
   VMax    = 95;     { Verbs   }
   NMax    = 133;    { Nouns   }
   PMax    = 11;     { Preps   }
   AMax    = 4;      { Adverbs }
   TMax    = 30;     { Timers  }
   RMax    = 109;    { Rooms   }
   MMax    = 29;     { Mov's   }
   Null    = 0;
   Legal   = 255;

type
   Str1    = string[1];
   Str9    = string[9];
   Str19   = string[19];
   Str29   = string[29];
   Str53   = string[53];
   Str77   = string[77];
   Str78   = string[78];
   Str130  = string[131];
   Str234  = string[234];
   Str255  = string[255];
   Entr    = record AX,BX,CX,DX,BP,SI,DI,DS,ES,Flags:integer;end;
   LSet    = set of 1..NMax;
   SaveSet = record
              aInv    : set of 1..MMax;
              aPStat  : set of 1..6;
              aEvents : set of 1..255;
              aSocket,
              aWear   : set of 1..MMax
             end;

var
   SetSave : SaveSet;
   Sets    : file of SaveSet;
   Objects : file of LSet;
   Things  : file of byte;
   Timers  : file of integer;
   V{erb}  : array [1..VMax] of Str29;
   N{oun}  : array [1..NMax] of Str29;
   P{rep}  : array [1..PMax] of Str29;
   A{dvb}  : array [1..AMax] of Str53;
   RN{ame} : array [1..RMax]   of Str19;{ Name of each room stored here.      }
   R{oom}  : array [1..MMax] of byte;   { Knows which room a Mov object is in.}
   L{ocate}: array [0..RMax] of LSet;   { Locates all non-Mov objects.        }
   T{imer} : array [1..TMax] of integer;
   Dir     : array [1..8]    of Str9;
   M{max}  : array [1..3]    of byte;    {******************}
   PStat        : set of 1..6;           {* Player Status: *}
   NoNounOnly   : set of 1..VMax;        {* [] = Healthy   *}
   OneNounMaybe : set of 1..VMax;        {*  2 = Hungry    *}
   ToNounOnly   : set of 1..VMax;        {*  3 = Sick      *}
   ToNounMaybe  : set of 1..VMax;        {*  4 = Injured   *}
   Events       : set of 1..255;         {*  5 = Tired     *}
   Mov{able objects},                    {*  6 = Thirsty   *}
   Inv{ventory},                         {******************}
   Socket,
   Wear         : set of 1..MMax;
   Brief        : set of 1..RMax;
   NounSet      : set of 1..NMax;
   MugCon,         { All -Con variables are containers. }
   FoodCon,
   SatchCon,
   HolstCon,
   NicheCon,
   PyraCon,
   HingeCon,
   PodumCon,
   RobotCon,
   CodeSet,
   ScrnSet,
   Vb,
   N1,
   N2,
   Pr,
   Md,
   VNP,
   Prm,      { Player Room }
   EFlag,    { Error Flag  }
   FFlag,    { Format Flag }
   TFlag,    { Timer Flag  }
   list,
   Num,
   Region,   { Knows what room to go in when exiting the player's ship }
   AlienRm,
   FriendRm,
   SinkRm,
   Serum,    { Begins at zero, dispenser jams at 2! }
   Weight,
   Old,      { for Block Reader }
   Old2,
   x,y,o   : byte;
   Code,     { dials, etc }
   Tic,
   StoreR,   { Knows if the previous Room that was read is the same as the  }
   StoreS,   { Room that is about to be read.  If so, then it simply writes }
   StoreL,   { that variable again! }
   StoreC,
   RC,       { Endless Room Counter }
   Sc,       { Score       }
   TestC,
   Floor,
   i,j     : integer;
   Input,
   Again,
   Line    : Str130;
   Text1,
   Text2,
   Text4   : Str234;
   Text3   : Str78;
   Text5   : Str77;
   R1,R2,S1: file of Str234;
   L1      : file of Str78;
   C1      : file of Str77;
   T1,T2   : text;{[2500];}
   Identity,
   VStr,
   NStr,
   LastNoun,
   Word    : Str29;
   Drive,
   CFlag   : char;
   Maze,
   Crawl,
   Color,
   QFlag,
   SFlag   : boolean;  { If TRUE then a Special action took place. }
{----------}





procedure Assign1;
begin
v[1]:='north\n\fore\f\';
v[2]:='south\s\aft\a\';
v[3]:='east\e\starboa\st\';
v[4]:='west\w\port\p\';
v[5]:='ne\northea\';
v[6]:='nw\northwe\';
v[7]:='se\southea\';
v[8]:='sw\southwe\';
v[9]:='up\u\climb up\climb u\';
v[10]:='down\d\climb down\climb d\';
v[11]:='enter\in\land in\land on\';       {cont}
v[12]:='land\cross\across\';
v[13]:='exit\out\leave\retreat\';         {cont}
v[14]:='escape\';
v[15]:='wait\z\rest\relax\';
v[16]:='invento\i\ex invento\inv\';
v[17]:='drop all but\drop all except\';
v[18]:='drop\get rid\put down\let go\';
v[19]:='take off\remove\';
v[20]:='l behind\ex behind\l beside\';
v[21]:='talk to\talk\speak to\greet\';
v[22]:='l above\ex on\l on top\';         {cont}
v[23]:='ex above\ex top\l on\';
v[24]:='l in\ex in\l through\l out\';
v[25]:='say\speak\';
v[26]:='l under\ex underne\ex under\';    {cont}
v[27]:='l underne\ex below\';
v[28]:='ex\search\l at\describ\';         {cont}
v[29]:='study\check\inspect\';
v[30]:='l around\l\';
v[31]:='read\';
v[32]:='stand up\get up\stand\';
v[33]:='put\pour\lay\fill\insert\';       {cont}
v[34]:='place\slide\stick\';
v[35]:='sit on\sit in\sit down at\';      {cont}
v[36]:='get in\sit at\sit\sit down\';
v[37]:='get all but\get all except\';     {cont}
v[38]:='take all but\get everyth but\';
v[39]:='get\take\grab\steal\pick up\';    {cont}
v[40]:='catch\grasp\snatch\';
v[41]:='open\unfaste\';
v[42]:='pull on\flick\pull\flip off\';    {cont}
v[43]:='flip\turn off\deactiv\';
v[44]:='push\move\press\turn on\';        {cont}
v[45]:='activat\flip on\push on\';
end; { Assign1 }
procedure Assign2;
begin
v[46]:='drink some\drink from\drink\';
v[47]:='eat\swallow\digest\consume\';
v[48]:='throw\toss\';
v[49]:='give\offer\show\hand\';
v[50]:='turn\rotate\set\spin\';
v[51]:='climb in\climb over\';            {cont}
v[52]:='climb on\climb\';
v[53]:='close\shut\fasten\connect\';
v[54]:='destroy\punch\knock on\break\';   {cont}
v[55]:='hit\knock\smash\strike\';
v[56]:='type in coordin\type coordin\';   {cont}
v[57]:='type in keyboar\type in\';        {cont}
v[58]:='type on\type on keyboar\type\';
v[59]:='jump in\jump over\jump on\';      {cont}
v[60]:='jump off\leap over\hop\';         {cont}
v[61]:='jump across\jump\leap\hop\';
v[62]:='sleep in\lie down\sleep on\';     {cont}
v[63]:='sleep\';
v[64]:='buy\purchas\pay for\order\';
v[65]:='listen to\listen\hear\';
v[66]:='bartend\waiter\';                  { Characters }
v[67]:='two aliens\alien\aliens\';
v[68]:='scienti\man\him\';
v[69]:='robot\droid\';
v[70]:='help me\pray\clue\help\';
v[71]:='compute\';
v[72]:='wear\don\';
v[73]:='find\where is\where\';
v[74]:='repair\fix\';
v[75]:='touch in\feel\touch\rub\';
v[76]:='reach in\reach under\reach\';
v[77]:='descrip\rd\r d\';
v[78]:='score\rank\';
v[79]:='quit\stop\q\';
v[80]:='hi\hello\bye\good bye\';
v[81]:='yes\no\maybe\';
v[82]:='save\';
v[83]:='smell\sniff\';
v[84]:='taste\lick\';
v[85]:='wake up\awaken\wake\';
v[86]:='restart\';
v[87]:='restore\resume\';
v[88]:='unlock\';
v[89]:='shoot at\shoot\blast\';
v[90]:='tie\untie\damn\shit\hell\';
v[91]:='follow\scott miller\scott\';
v[92]:='dig in\dig\shovel\';
v[93]:='attack\kill\fight\';
v[94]:='clean\wipe off\wipe\';
v[95]:='command\verbs\verb\words\';
end; { Assign2 }

                     {NOUN LIST:  GROUPS ALL OBJECTS}
procedure Assign3;
begin
n[1]:='clear crystal\clear\crystal\';
n[2]:='device\';
n[3]:='rusty key\rusty\';
n[4]:='shiney key\shiney\';
n[5]:='brown satchel\satchel\brown\';
n[6]:='dried food\food\dried\loaf\';
n[7]:='holster\gun strap\strap\';
n[8]:='goolaa\coin\money\';
n[9]:='red jewel\jewel\red\';
n[10]:='skull\skulls\head\heads\';
n[11]:='rod\thick rod\pole\';
n[12]:='plastic access card\';            {cont}
n[13]:='plastic access\card\';            {cont}
n[14]:='access card\plastic card\';       {cont}
n[15]:='access\plastic\';
n[16]:='worn cushion\cushion\worn\';
n[17]:='grey disk\disk\grey\';
n[18]:='dusty ball\ball\dusty\';          {changes to glass ball!}
n[19]:='paper\piece paper\piece\';
n[20]:='set of goggles\set goggles\';     {cont}
n[21]:='goggles\set\glasses\band\';
n[22]:='orange crystal\orange\';
n[23]:='green crystal\green\';
n[24]:='yellow crystal\yellow\';
n[25]:='blue crystal\blue\';
n[26]:='pair of gloves\pair gloves\';     {cont}
n[27]:='gloves\glove\pair\';
n[28]:='security suit\suit\badge\';       {cont at #31}
n[29]:='mug\cup\drink\';
n[30]:='all\everyth\object\objects\';
n[31]:='securit suit\securit\';
n[32]:='containers\crate\crates\';        {cont}
n[33]:='cargo\contain\storage\';
n[34]:='ceiling\roof\up\';
n[35]:='seat\command chair\chair\';       {cont}
n[36]:='chairs\seats\toilet\';
n[37]:='computer\termina\compute\';
n[38]:='controls\machine\';               {cont}
n[39]:='control panel\control\';
n[40]:='cyan button\cyan\';               { changes to socket }
n[41]:='tan button\tan\';
n[42]:='energy flow\energy\flow\';
n[43]:='purple button\purple\violet\';
n[44]:='button\white button\white\';      {cont}
n[45]:='buttons\';
n[46]:='robot\defense robot\defense\';    {cont at #133}
n[47]:='vines\vine\branche\branch\';
end; { Assign3 }
procedure Assign4;
begin
n[48]:='dial\knob\dials\knobs\tap\';
n[49]:='ground\floor\earth\deck\bay\';    {cont}
n[50]:='glass floor\rocks\down\';
n[51]:='equipment\equipme\';
n[52]:='numeric keypad\keypad\';          {cont}
n[53]:='numeric\numbers\keyboar\';
n[54]:='rail\railing\column\';
n[55]:='panel\compart\';
n[56]:='door\swingin door\doors\';        {cont}
n[57]:='swingin doors\hatch\swingin\';
n[58]:='key\keys\round recess\';
n[59]:='screen\monitor\screens\data\';
n[60]:='player\self\waist\me\myself\';    {cont}
n[61]:='hand\hands\arm\feet\foot\';
n[62]:='ship\my ship\shuttle\vehicle\';   {cont}
n[63]:='space ship\space craft\craft\';
n[64]:='slot\opening\hole\round\';        {cont}
n[65]:='niche\holes\recess\';
n[66]:='acid water\acid river\stream\';   {cont}
n[67]:='acid stream\river\acid\gap\';
n[68]:='pyramid\podium\structure\';
n[69]:='cryo tube\cryogen tube\';         {cont}
n[70]:='cryogen\cryo\tube\tubes\';
n[71]:='steps\step\stairs\ladder\';
n[72]:='picture\mural\drawing\';
n[73]:='bones\bone\skeleto\remains\';
n[74]:='flash\blindin flash\blindin\';    {object never here!}
n[75]:='creature\hairy creatur\hairy\';   {cont}
n[76]:='scaled creatur\creatur\';         {cont}
n[77]:='scaled\';
n[78]:='wheel\handle\';
n[79]:='water\';
n[80]:='bed\bunk\beds\bunks\';
n[81]:='sign\post\menu\message\note\';
n[82]:='solar map\map\solar\drawing\';    {changes to laser beam}
n[83]:='western table\western\';
n[84]:='middle table\middle\';
n[85]:='eastern table\eastern\';
n[86]:='table\tables\';
n[87]:='shelf\shelves\';
n[88]:='gun\ray gun\signpos\';
n[89]:='statue\dog statue\dog\';
n[90]:='serum dispenser\dispens\';        {cont}
n[91]:='serum dispens\';
n[92]:='serum\medicin\cure\liquid\';
n[93]:='platform\platfor\';
end; { Assign4 }
procedure Assign5;
begin
n[94]:='booth\transpo\';
n[95]:='wristband\wristba\transla\';
n[96]:='building\buildin\complex\';       {cont}
n[97]:='store\station\tavern\';
n[98]:='sink\basin\tap\faucet\spout\';
n[99]:='glunk lite\lite\glunk\beer\';
n[100]:='Drink\ambross\';                 {cont}
n[101]:='pink ztulctw\ztulctw\pink\';     {cont}
n[102]:='bloody foeboz\foeboz\bloody\';
n[103]:='red star\red\star\flare\';
n[104]:='telescope\telesco\eyepiec\';
n[105]:='outer planet\inner planet\';     {cont}
n[106]:='line planet\fifth planet\';      {cont}
n[107]:='ringed planet\ringed\';          {cont}
n[108]:='inner\fifth\line\outer\';        {cont}
n[109]:='planets\planet\last\';
n[110]:='keyhole\';              { changes to speaker }
n[111]:='bartender\bartend\waiter\';
n[112]:='trees\tree\forest\jungle\';
n[113]:='path\passage\tunnel\road\';      {cont}
n[114]:='corrido\lobby\chamber\air\';
n[115]:='antenna\dish\hollow\';
n[116]:='wall\south wall\north wall\';    {cont}
n[117]:='east wall\west wall\walls\';
n[118]:='ice\snow\';
n[119]:='writing\chart\list\';
n[120]:='swamp\quicksa\';
n[121]:='radio\transmi\';
n[122]:='dirt\sand\dust\desert\rocks\';
n[123]:='scientist\scienti\him\man\';
n[124]:='aliens\two aliens\alien\';
n[125]:='fence\wire fence\wire\';
n[126]:='bar\';                    { changes to hinge }
n[127]:='window\windows\alarm\siren\';
n[128]:='reactor\regulat\';
n[129]:='gas\fumes\icy mist\mist\icy\';
n[130]:='spears\spear\';
n[131]:='light\glow\lights\catwalk\';
n[132]:='drazil tracks\tracks\drazil\';
n[133]:='droid\sensor\probe\';


                {SEPWORD LIST:  GROUPS ALL PREPOSITIONS}

p[1]:='on top\around\above\over\';        {cont}
p[2]:='across\on\to\onto\';
p[3]:='against\at\toward\towards\';       {cont}
p[4]:='in directi\';
p[5]:='in\through\down\';
p[6]:='using\with\making use\by\';
p[7]:='beside\near\close to\next to\';    {cont}
p[8]:='leaning against\';
p[9]:='off\from\';
p[10]:='under\underne\beneath\below\';
p[11]:='a\for\';

                     {ADVERB LIST:  GROUPS ALL MOODS}

a[1]:='gently1careful2softly3calmly4quietly5lightly6easily7';
a[2]:='slowly1leisure2slow3with care4cautiou5closely6';
a[3]:='strongl1firmly2solidly3powerfu4with force5hard6';
a[4]:='quickly1fast2rapidly3speedil4very fast5';
end; { Assign5 }

                               {ROOM  NAMES}

procedure Names1;
begin
rn[1]:='Bridge';
rn[2]:='Forward Corridor';
rn[3]:='Rear Corridor';
rn[4]:='Ship''s Lab';
rn[5]:='Sanitary Facilities';
rn[6]:='Sleep Chamber';
rn[7]:='Cargo Area';
rn[8]:='Tavern';
rn[9]:='West Hallway';
rn[10]:='Central Hallway';
rn[11]:='East Hallway';
rn[12]:='Suite #4';
rn[13]:='Crossroads';
rn[14]:='Dusty Road';
rn[15]:='Dusty Road';
rn[16]:='Gravel Road';
rn[17]:='Gravel Road';
rn[18]:='Paved Road';
rn[19]:='Paved Road';
rn[20]:='General Store';
rn[21]:='Gravel Lot';
rn[22]:='Top of Ship';
rn[23]:='Deep Pit';
rn[24]:=rn[22];
rn[25]:='Sandy Clearing';
rn[26]:='Winding Path';
rn[27]:=rn[26];
rn[28]:=rn[26];
rn[29]:=rn[26];
rn[30]:='Top of Tree';
rn[31]:='Quicksand Pit';
rn[32]:=rn[26];
rn[33]:=rn[26];
rn[34]:='Front of Pyramid';
rn[35]:='Vestibule';
rn[36]:='Descending Stairs';
rn[37]:='Halcyon Hall';
rn[38]:='Departure Room';
rn[39]:='Holey Hall';
rn[40]:='Pyramid Lobby';
  end; { Names1 }
procedure Names2;
begin
rn[41]:='Treasure''s Keeper';
rn[42]:='Ladder Room';
rn[43]:='Shifting Room';
rn[44]:=rn[43];
rn[45]:=rn[43];
rn[46]:=rn[43];
rn[47]:=rn[43];
rn[48]:=rn[43];
rn[49]:=rn[43];
rn[50]:='Stairway Room';
rn[51]:='Lower Stairway';
rn[52]:='Misty Passage';
rn[53]:='Damp Passage';
rn[54]:='Dark Passage';
rn[55]:='Circular Chamber';
rn[56]:='The Erusaert';
rn[57]:='Solar Chamber';
rn[58]:='Eternal Trap';
rn[59]:='Overgrown Path';
rn[60]:='Antenna Building';
rn[61]:='Monitor Outpost';
rn[62]:='Booth';
rn[63]:='Booth';
rn[64]:='Lobby';
rn[65]:='North Corridor';
rn[66]:='Central Corridor';
rn[67]:='South Corridor';
rn[68]:='Decontamination';
rn[69]:='Waiting Room';
rn[70]:='Transporter Booth';
rn[71]:='Monitor Station';
rn[72]:='Reactor Control';
rn[73]:='Communications';
rn[74]:='Computer Station';
rn[75]:='Elevator  1st Floor';
rn[76]:='Elevator  2nd Floor';
rn[77]:='Observatory';
rn[78]:='Icy Platform';
rn[79]:='Confirmation Port';
rn[80]:='Inspection Lobby';
  end; { Names2 }
procedure Names3;
begin
rn[81]:='Circular Corridor';
rn[82]:=rn[81];
rn[83]:=rn[81];
rn[84]:=rn[81];
rn[85]:=rn[81];
rn[86]:=rn[81];
rn[87]:=rn[81];
rn[88]:=rn[81];
rn[89]:='Reactors West';
rn[90]:='Reactors East';
rn[91]:='Emergency Override';
rn[92]:='Climate Control';
rn[93]:='Elevator';
rn[94]:='Maintenance';
rn[95]:='Transmission Room';
rn[96]:='Station Control';
rn[97]:='Cryogenic Chamber';
rn[98]:='Indentity Booth';
rn[99]:='Security Tunnel #1';
rn[100]:='Security Tunnel #2';
rn[101]:='Security Tunnel #3';
rn[102]:='North Catwalk';
rn[103]:='East Catwalk';
rn[104]:='South Catwalk';
rn[105]:='West Catwalk';
rn[106]:='Junction';
rn[107]:='Conference Room';
rn[108]:='Reactor Regulators';
rn[109]:='Medical Quarters #6';
  end; { Names3 }


                               {ROOM  NAMES}
procedure Place1;
 begin
for x:=1 to RMax do L[x]:=[];
L[1]:=[16,35..41,43,44,52,55,56,59,62,112,120,125];
L[2]:=[38,56,62,64,71,78];
L[3]:=[38,55,81];
L[4]:=[38,44,51,52,55,62,64,81,90,119];
L[5]:=[35,38,48,62,98];
L[6]:=[38,62,69,80];
L[7]:=[32,51,62,87];
L[8]:=[29,35,56,71,81,83..86,96,99,100,111,119,126];
L[9]:=[56,71];
L[10]:=[56];
L[11]:=[56];
L[12]:=[7,48,56,80,87,98,110];
L[13]:=[56,81,88,96];
L[14]:=[81,96,125];
L[15]:=[125];
L[16]:=[81,96];
L[17]:=[]; {empty}
L[18]:=[81,125];
L[19]:=[]; {empty}
L[20]:=[5,6,32,38,51,86,87,96,132];
L[21]:=[62,71,81,125];
L[22]:=[56,62,71,78,81,96,125];
L[23]:=[73,81];
L[24]:=[56,62,71,78,112,120];
L[25]:=[62,71,112,120];
L[26]:=[66,112,120];
L[27]:=[66,112,120];
L[28]:=[112,120];
L[29]:=[112,120];
L[30]:=[68,112,120];
L[31]:=[47,112,120];
L[32]:=[112,120];
L[33]:=[112,120];
L[34]:=[56,64,68,71,81,89,112,119,120,126];
L[35]:=[56,71];
L[36]:=[71];
L[37]:=[71];
L[38]:=[10,51,73];
L[39]:=[129];
L[40]:=[56,68];
L[41]:=[18,73,56,68];
L[42]:=[71];
{ L[43] through L[49] are empty }
L[50]:=[71];
L[51]:=[71];
L[52]:=[64];
L[53]:=[];
L[54]:=[];
L[55]:=[11];
 end; { Place1 }
procedure Place2;
 begin
L[56]:=[66,68,110];
L[57]:=[56,72,82,103,109];
L[59]:=[112,120];
L[60]:=[56,96,112,115,120];
L[61]:=[37,38,44,56,59,93,94,96];
L[62]:=L[61];
L[63]:=L[61]+[20];
L[64]:=[35,56,72,81,86,109,127];
L[65]:=[56];
L[66]:=[56,64];
L[67]:=[56];
L[68]:=[44,56,131];
L[69]:=[35,56,131];
L[70]:=[40,41,43,44,56,93,94];
L[71]:=[59];
L[72]:=[37,38,44,46,55,128];
L[73]:=[28,35,38,48,56,115,121,127];
L[74]:=[37,38,44,52,59];
L[75]:=[44,56];
L[76]:=[44,56];
L[77]:=[56,104,127];
L[78]:=[54,56,93,96,115,118];
L[79]:=[44,56,64];
L[80]:=[35,55,56,72,86];
L[81]:=[56,72];       { Picture of a Grey Disk }
L[82]:=[56,72,103];   { Picture of the Red Star }
L[83]:=[56,72,115];   { Picture of an Antenna }
L[84]:=[46,56,72];    { Picture of a Robot }
L[85]:=[56,72];       { Picture of a Cloud }
L[86]:=[56,64,69,72]; { Picture of a Cryogenic Tube }
L[87]:=[56,72];       { Picture of an Atomic Nucleus }
L[88]:=[56,72];       { Picture of an Atomic Nucleus }
L[89]:=[38,44,56,59,95,128];
L[90]:=[38,56,59,128];
L[91]:=[37,38,44,51,52,56,59,64,69,95,127,129];
L[92]:=[35,56,59];
L[93]:=[44,52,56];
L[94]:=[2,51,56,87];
L[95]:=[38,44,52,56,121,127];
L[96]:=[38,56,59];
L[97]:=[56,69,129];
L[98]:=[56,59,81,119];
L[99]:=[46,55,56,88];
L[100]:=[55,56];
L[101]:=[46,55,56,88];
L[102]:=[42,54,56,131];
L[103]:=[42,54,131];
L[104]:=[42,54,131];
L[105]:=[42,54,56,131];
L[106]:=[56];
L[107]:=[19,35,56,86];
L[108]:=[55,56,128];
for x:=1 to RMax do L[x]:=L[x]+[30,34,49,60,103,113,116,122,131];
 end;



procedure SF; begin SFlag:=True end;

procedure Cur(Num:byte);
{freepascal only}
 begin

   if Color then

   case Num of
      1: ;{ Underline   }//SetCursorType(crUnderline);
      2: cursorbig;{ Solid block }{SetCursorType(crBlock);}
      3:cursoroff; { Invisible   }{SetCursorType(crHidden);}
    end;
 end;

procedure Col(Num1,Num2:byte);
 begin if Color then textcolor(Num1) else textcolor(Num2) end;

procedure Bak(Num1,Num2:byte);
 begin if Color then textbackground(Num1) else textbackground(Num2) end;

function  En(Num:byte):boolean;
 begin if Num in Events then En:=true else En:=false end;

procedure Add(Num:byte);
 begin Events:=Events+[Num] end;

procedure Min(Num:byte);
 begin Events:=Events-[Num] end;

procedure Score(Num,pointe:integer);
 begin if not en(pointe)then begin Sc:=Sc+Num;Add(pointe)end end;

procedure Cn(s:str78);
 begin gotoxy(40-(length(s)div 2),wherey);writeln(s)end;

procedure Pause;
 begin col(15,15);write('Press any key to continue...');
  CFlag:=readkey;col(11,7);writeln;
 end;

procedure Tune(Octave,Note,Duration:integer);
  var Frequency:real;
      i:integer;
 begin
  Frequency:=32.625;
  for i:=1 to Octave do
   Frequency:=Frequency*2;
  for i:=1 to Note-1 do
   Frequency:=Frequency*1.059463094;
  if Duration <> 0 then
   begin
    sound(round(Frequency));
    delay(Duration);
    nosound
   end
  else sound(round(Frequency));
 end;

procedure Play(Start,Stop,Speed:integer);
  var x:integer;
 begin
  if Start<=Stop then
   for x:=Start to Stop do begin sound(x);delay(Speed)end
  else
   for x:= Start downto Stop do begin sound(x);delay(Speed)end;
  nosound;if Region=4 then sound(20);if Region=5 then sound(60);
 end;

procedure Explode(Duration:byte);
  var x:integer;
 begin for x:=Duration*999 downto 20 do sound(random(x));nosound end;

procedure Walls(Duration:byte);
  var x:integer;
 begin for x:=1 to Duration*999 do sound(random(35)+20);nosound end;

procedure Static;
  var x,y:integer;
 begin
  for x:=1 to 50 do
   case random(2) of
    0:for y:=1 to random(70)+10 do sound(random(4000)+3000);
    1:begin nosound;delay(random(29))end
   end;nosound;if Region=5 then sound(60)
 end;

procedure Blast;
  var x:byte;
 begin
  for x:=1 to 40 do
   begin play(550-x*6,600+x*6,0);play(600+x*6,550-x*6,0)end;explode(2)
 end;

procedure Dopen(Num:byte);
 begin writeln('The door slides open...');
  if Num<>0 then play(50,125-Num,Num)
  else begin for i:=3500 to 5000 do sound(random(4500)+i);nosound;end;
  if Region=5 then sound(60)
 end;

procedure Dclose(Num:byte);
 begin writeln('The sliding door closes.');
  if Num<>0 then play(125-Num,50,Num)
  else begin for i:=5000 downto 3500 do sound(random(4500)+i);nosound;end;
  if Region=5 then sound(60)
 end;

 procedure RL(pointe:integer);
 begin SF;
  if(pointe<>StoreL)then
   begin StoreL:=pointe;
    seek(L1,pointe);
    read(L1,Text3)
   end;
  writeln(Text3);
 end; { Read Line }

procedure RS(pointe:integer);
 begin SF;
  if(pointe<>StoreS)then
   begin StoreS:=pointe;
    seek(S1,pointe);
    read(S1,Text4)
   end;
  writeln(Text4);
 end; { Read Special }



procedure RR(pointe:integer);
 begin SF;
  if(pointe<>StoreR)then
   begin StoreR:=pointe;
    seek(R1,pointe);
    seek(R2,pointe);
    read(R1,Text1);
    read(R2,Text2);
   end;
  writeln(Text1,Text2);
 end; { Read Room }


function FN(vnp:byte): Str29;  {( Finds first Noun ) }
  var Temp:Str29;
 begin SF;
  Temp:=n[VNP];
  FN:=copy(Temp,1,pos('\',Temp)-1);
 end; { FW }


procedure Describe(Room:byte);
 begin
  col(9,9);write(RN[Prm]);col(11,7);writeln;
  if(en(1))or(not(en(1))and not(Prm in Brief))then
   begin Brief:=Brief+[Prm];
    case Prm of   { Alternate Room Descriptions }
     29:if en(35) then begin RS(130);RS(131)end else RR(29);
     34:if en(30) then begin RS(81);RS(82)end else RR(34);
     52:if en(39) then RS(126)else RR(52);
     91:if en(51) then begin RS(157);RS(158)end else RR(91)
     else RR(Room)
    end;
   end;
  case Prm of     { For initial object's description }
    1:if 16 in L[1] then RL(150);
   107:if 19 in L[107] then RL(518);
   38:if 17 in L[38] then RL(260);
   41:if(18 in L[41])and not en(34)then RS(96);
   55:if 11 in L[55] then RL(290);
   63:if 20 in L[63] then RL(356);
   73:if 28 in L[73] then RL(352);
   80:if 17 in L[80] then RL(395);
   94:begin if 26 in L[94] then RL(397);if 2 in L[94] then RL(398)end;
  end;
  for o:=1 to MMax do  { Print the objects that are lying in the room }
   if r[o]=Prm then
    begin
     if o=6 then write('There is some ',FN(o),' here.')
     else
      begin Word:=FN(o);
       if Word[1] in['a','e','i','o','u']then
        write('There is an ',FN(o),' here.')else
        write('There is a ',FN(o),' here.')
      end;
     if((o=29)and(MugCon<>Null))or((o=7)and(HolstCon<>Null))or
       ((o=5)and(SatchCon<>Null))then write('  (with something in it)');
     if(o=5)and(R[5]=20)then write('  (lying in some trash)');
     if(o=7)and(7 in L[12])and(R[7]=12)then write('  (on the shelf)');
     if o=NicheCon then write('  (on the niche)');
     if(en(6))and(o=16)then write('  (on the seat)');
     if o=PyraCon then write('  (in the pyramid''s slot)');
     if o=HingeCon then write('  (inside the statue''s mouth)');
     if o=PodumCon then write('  (on top of the podium)');
     if(o=16)and en(37)then write('  (under the crystal)');
     if o=RobotCon then write('  (in the robot''s panel)');
     if o in Socket then write('  (in one of the regulator''s sockets)');
     writeln;
    end;
 end; { Describe }

procedure Move(New:byte);
 begin SF;
  if en(7) then RL(22) else
  if en(8) then RL(23) else
  begin
   if(MugCon<>Null)and(29 in Inv)then
    begin if Prm<>8 then L[Prm]:=L[Prm]-[MugCon];L[New]:=L[New]+[MugCon]end;
   if(SatchCon<>Null)and(5 in Inv)then
    begin L[Prm]:=L[Prm]-[SatchCon];L[New]:=L[New]+[SatchCon]end;
   if(HolstCon<>Null)and(7 in Inv)then
    begin L[Prm]:=L[Prm]-[HolstCon];L[New]:=L[New]+[HolstCon]end;
   Prm:=New;
   Describe(Prm);
  end
 end; { Move }


procedure Door(New,Num:byte);
 begin
  if en(7)then RL(22)else
  if en(8)then RL(23)else begin DOpen(Num);Move(New);DClose(Num)end
 end;



function Up(Word:Str130):Str1;
 begin word:=word+' ';
  if(Word[1]='l')and(Word[2]=' ')then insert('ook',Word,2);
  if(Word[1]='e')and(Word[2]='x')and(Word[3]=' ')then insert('amine',Word,3);
  delete(Word,length(word),2);Up:='';
  for x:=1 to length(Word) do Word[x]:=upcase(Word[x]);
  col(12,15); write(Word); col(11,7)
 end;

 procedure Directory;
var
    dir : SearchRec;
begin

  FindFirst('*.sm1',archive,Dir);
  while (DosError=0) do
   begin
     Writeln(Dir.Name);
     FindNext(Dir);
   end;
  FindClose(Dir); Pause;
end; {Directory}

procedure Restore;
  label JUMP,JUMPBACK;

 begin SF; JUMPBACK: nosound; for x:=1 to 25 do writeln;
  CFlag:=Drive;Cur(2);
  gotoxy(1,2);{
  write('Which disk drive (default ',Up(Drive),':)? ');
  col(14,15);readln(Drive);col(11,7);
  Drive:=upcase(Drive);if not(Drive in['A','B'])then Drive:=CFlag;
  gotoxy(1,5);
  writeln('Make sure your SAVE/RESTORE disk is in disk drive ',up(Drive),':');
  writeln;writeln; }
  write('RESTORE from what file name (''',up('/'),''' aborts RESTORE)? ');
  col(14,15);readln(input);col(11,7);
  Cur(3);
  while pos(' ',input)>0 do delete(input,pos(' ',input),1);
  while pos('.',input)>0 do delete(input,pos('.',input),1);
  while pos(':',input)>0 do delete(input,pos(':',input),1);
  if pos('/',input)>0 then
   begin writeln;writeln(up('RESTORE ABORTED'));goto JUMP;end;
  LowerCase(input);
  if(pos('list',input)>0)or(pos('dir',input)>0)or(pos('file',input)>0)then
   begin Directory;goto JUMPBACK;end;
  if length(input)=0 then input:='LASTSAVE';writeln;writeln;
  writeln('The game file ',Up(Input),' is now being restored from drive '{,
           up(Drive),':...'});
  input:={Drive+':'+}input;
  assign(Objects,input+'.sm1');
  {$I-}
  reset(Objects);
  {$I+}
  if IOResult<>0 then
   begin close(Objects);col(12,15);writeln;writeln;delete(input,1,2);
    for x:=1 to length(input) do input[x]:=upcase(input[x]);
    Cn('The file '+input+' does not exist on your SAVE/RESTORE disk!');
    writeln(^g);delay(2000);col(11,7);goto JUMPBACK;
   end;
  reset(Objects);
  for x:=0 to RMax do read(Objects,L[x]);
  close(Objects);
  assign(Things,input+'.sm2');
  reset(Things);
  read(Things,Prm,Region,MugCon,FoodCon,SatchCon,NicheCon,PyraCon,
              HingeCon,PodumCon,AlienRm,FriendRm,SinkRm,Serum,TFlag,
              RobotCon,CodeSet,ScrnSet,HolstCon);
  for x:=1 to MMax do read(Things,R[x]);
  close(Things);
  assign(Timers,input+'.sm3');
  reset(Timers);
  read(Timers,Tic,Sc,RC,Floor);
  for x:=1 to TMax do read(Timers,T[x]);
  close(Timers);
  assign(Sets,input+'.sm4');
  reset(Sets);
  read(Sets,SetSave);
  close(Sets);
  with SetSave do
   begin Inv:=aInv;PStat:=aPStat;Events:=aEvents;
    Socket:=aSocket;Wear:=aWear;end;
  Add(126);
  writeln;writeln;delete(input,1,2);
  writeln('Your present game location is now RESTORED from the name ',
           up(input),'.');
  writeln; JUMP: writeln;
 Col(11,7);
  bak(0,0);
  case Region of 4:sound(20);5:sound(60)end;
  if Region>1 then
   begin
    n[84]:='reactor regulat\';
    n[126]:='hinged mouth\mouth\hinge\';
   end
   else
    begin
     n[84]:='middle table\middle\';
     n[126]:='bar\';
    end;
  if en(34)then n[18]:='glass ball\ball\glass\'
   else n[18]:='dusty ball\ball\dusty\';
  if Prm>79 then
   begin
    n[40]:='sockets\socket\';
    n[82]:='laser beam\beam\laser\';
    n[110]:='speaker\';
   end else
   begin
    n[40]:='cyan button\cyan\';
    n[82]:='solar map\map\solar\drawing\';
    n[110]:='keyhole\';
   end;
   Min(128);Line:='l';
 end; { RESTORE }

 procedure DeadMain;
  label JUMP;
 begin writeln;
  gotoxy(1,20);for x:=5 downto 1 do
   begin writeln;delay(99);sound(300+(x*50));bak(x,7)end;
  repeat x:=random(14)+1 until not(x in [4,12]);
  gotoxy(1,15);col(x,15);bak(4,7);
  writeln('***************************************',
          '***************************************');
  delay(99);sound(300);bak(6,0);
  gotoxy(1,16);for x:=3 downto 1 do begin
  write('*                                      ',
        '                                      *');
        delay(99);sound(100+(x*50));bak(x+8,15)end;gotoxy(1,19);
  write('***************************************',
        '***************************************');
  delay(99);sound(100);bak(14,0);
  gotoxy(30,17);col(16,31);write('YOU HAVE DIED!!!');delay(99);sound(50);
  gotoxy(1,20);bak(0,0);col(11,7);bak(12,7);writeln;delay(99);nosound;
  delay(999);i:=random(3)+2;
  tune(i,3,830);tune(i,3,770);tune(i,3,200);tune(i,3,0);delay(800);
  tune(i,6,400);tune(i,5,400);tune(i,5,400);
  tune(i,3,400);tune(i,3,400);tune(i,2,400);tune(i,3,810);
  JUMP: Col(11,7);Cur(2);
  repeat
   write('Would you like to ');Col(14,15);write('S');Col(11,7);
   write('tart a new game, ');Col(14,15);write('R');Col(11,7);
   write('estore or ');Col(14,15);write('Q');Col(11,7);write('uit? ');
   CFlag:=readkey;CFlag:=upcase(CFlag);Col(9,15);writeln(CFlag);
   play(500,500,40);Col(11,7);
  until CFlag in['S','R','Q'];bak(0,0);Cur(3);
  case CFlag of
   'S':begin RL(170);delay(1500);window(1,1,80,25);clrscr;
        close(R1);close(R2);close(S1);close(L1);close(C1);close(T1);close(T2);
        {assign(R1,'nova.com');}exec('nova.exe', '');
       end;
   'R':begin Min(126);Restore;if not en(126)then goto JUMP end;
   'Q':begin window(1,1,80,25);clrscr;Col(3,7);
        close(R1);close(R2);close(S1);close(L1);close(C1);close(T1);close(T2);
        writeln('In ',Tic,' moves you scored ',Sc,
                ' out of a possible 1000 points.');writeln;
        Col(31,16);Bak(1,7);writeln('Good-bye!');writeln;Cur(1);
        HALT;
       end
  end {case}
 end; {DEAD}

procedure DEAD;
begin
    DEADMAIN ;
end;


procedure MC(WhichChar,WatchRoom,ToRoom:byte;MessageNum:Integer);
    { WhichChar refers to the character(s) being moved.               }
    { WatchRoom is the room the player must be in to see the responce.}
    { ToRoom is the room the character(s) move to.                    }
    { MessageNum is the message that is written if the player sees.   }
 begin
  if(Prm=WatchRoom)then RS(MessageNum);
  case WhichChar of     { 1 = Aliens,  2 = Scientist }
   1:begin
      L[AlienRm]:=L[AlienRm]-[124];AlienRm:=ToRoom;
      L[AlienRm]:=L[AlienRm]+[124]
     end;
   2:begin
      L[FriendRm]:=L[FriendRm]-[123];FriendRm:=ToRoom;
      L[FriendRm]:=L[FriendRm]+[123]
     end
  end;
  SFlag:=false;
 end;

procedure Van(o:byte);
 begin
  Inv:=Inv-[o];
  r[o]:=Null;
  L[Prm]:=L[Prm]-[o];
  if o in Wear then Wear:=Wear-[o];
  if o=SatchCon then SatchCon:=Null;
  if o=MugCon then MugCon:=Null;
  if o=16 then Min(6);
  if o=NicheCon then NicheCon:=Null;
  if o=PyraCon then PyraCon:=Null;
  if o=HingeCon then HingeCon:=Null;
  if o=PodumCon then PodumCon:=Null;
  if o=16 then begin Min(37);Min(6)end;
  if o=RobotCon then RobotCon:=Null;
  if o in Socket then Socket:=Socket-[o];
  if o=HolstCon then HolstCon:=Null
 end;

procedure Time1;
 begin Tic:=Tic+1; Min(128); { <--Negates DEAD } col(13,15);
  for x:=1 to TMax do T[x]:=T[x]-1;
  if T[2]=1 then begin PStat:=PStat-[5];RL(1)end;
  case T[3] of { Hunger }
   25:begin PStat:=PStat+[2];RL(2)end;
   12:RL(3);
   4:begin RL(4)end;
   1:begin RL(124);DEAD;end
  end;
  case T[4] of { Thirst }
   22:begin PStat:=PStat+[6];RL(5)end;
   11:RL(6);
   4:begin bak(4,7);RL(7)end;
   1:begin RL(125);DEAD;end
  end;
  case T[5] of { Sleep }
   32:begin PStat:=PStat+[5];RL(8)end;
   14:RL(9);
   5:begin bak(4,7);RL(10)end;
   1:begin RL(126);DEAD;end;
   2..4,6..13:begin x:=random(29)+1;
          if(x in Inv)and not(x in Wear)then
           begin Van(x);R[x]:=Prm;
            writeln('A bout of weariness causes you to loose your grip on',
                    ' the ',FN(x),'!')
           end
         end
  end;
  case T[29] of { Laser Injury }
   9:RS(214);
   4:begin RL(507);bak(4,7)end;
   2,3,5..8,10,11:begin repeat x:=random(27)+1 until x in[1..12,16..20,22..26,28];
     if(x in Inv)and not(x in Wear)then
      begin Van(x);R[x]:=Prm;
       if random(2)=0 then
        writeln('A sudden stab of pain shoots up your side, you drop the ',
                 FN(x),'.') else begin
        writeln('The ',FN(x),' falls from your grip as you almost collapse ',
                'from the');writeln('extreme pain.')end
      end
     end;
   1:begin RS(215);DEAD;end
  end;
  case T[12] of  { Sickness }
   120,99,83,55:RL(207);
   65:begin PStat:=PStat+[3];RL(208)end;
   47:RL(209); 30:RS(73); 15:RS(74); 4:begin bak(4,7);RS(75)end;
   1:begin RS(76);DEAD end;
   2,3,5..14,16..29:if(random(25)=0)and(Inv<>[])and not(en(125))then
          begin RS(232);
           for x:=1 to 29 do if(x in Inv)and not(x in Wear)then
            begin Van(x);R[x]:=Prm end
          end
  end;
  Col(10,7);
  if(Prm in[81..88])and(T[30]<1)and(random(4)=0)then
   if 28 in Wear then
    begin T[30]:=9;RS(153+Prm);
     for i:=999 to 2300 do sound(random(i*3)+i);
     for i:=3000 downto 20 do sound(random(i*4)+i*2);nosound
    end
   else
    begin
     write('A small droid appears from the ');
     case Prm of
      81:write('south'); 82:write('southwest'); 83:write('west');
      84:write('northwest'); 85:write('north'); 86:write('northeast');
      87:write('east'); 88:write('southeast')
     end; writeln(' section of the corridor and flies');
     RS(242);RS(243);for i:=20 to 3000 do sound(random(i*3)+i);nosound;
     delay(1500);DEAD
    end;
 end; { Time1 }


procedure RB(Pointe,Colour:byte);
  var Block:Str255;
      Tstart,TStop:Str19;
 begin SF; Col(Colour,7);
  str(pointe-1,TStart);
  str(pointe,TStop);
  TStart:='('+TStart+')';
  TStop:='('+TStop+')';
  if old>=pointe then reset(T1);
  old:=pointe+1;
  repeat readln(T1,Block) until Block=TStart;
  repeat
   readln(T1,Block);
   if(Block<>TStop)then writeln(Block)
  until Block=TStop; col(11,7);
 end;


function Here(Obj:byte) : Boolean;
 begin Here:=false;
  if Obj in L[Prm] then Here:=true;
  if(Obj=79)and(MugCon=79)and(29 in Inv)then Here:=true;
  if Obj<=MMax then if(R[Obj]=Prm)or(Obj in Inv)then Here:=true;
  if(Obj=58)and((3 in Inv)or(4 in Inv)or(R[4]=Prm)or(R[3]=Prm))then Here:=true;
 end;

procedure RB2(Pointe,Colour:byte);
  var Block:Str255;
      Tstart,TStop:Str19;
 begin SF; Col(Colour,7);
  str(pointe-1,TStart);
  str(pointe,TStop);
  TStart:='('+TStart+')';
  TStop:='('+TStop+')';
  if old2>=pointe then reset(T2);
  old2:=pointe+1;
  repeat readln(T2,Block) until Block=TStart;
  repeat
   readln(T2,Block);
   if(Block<>TStop)then writeln(Block)
  until Block=TStop; col(11,7);
 end;

procedure Time2A;
 begin col(10,7);  { Pre-Jungle Planet }
  case T[1] of
   19:MC(1,13,13,0);
   18:begin MC(1,8,8,1);MC(1,13,8,2)end;
   17:if en(19) then begin RS(9);T[1]:=11;end;
   11..16:if not(en(19))and(Prm=8)and(random(2)=1)then RL(0);
   10:MC(1,8,9,3);
   9:begin MC(1,9,0,4);T[1]:=Null;end;
   5..7:if(en(2))and(en(3))then begin RB2(5-(T[1]-3),10);col(10,7)end;
   4:if Prm=8 then begin T[1]:=11;RS(5)end;
  end;
  if(T[7]=1)then begin RS(35);DEAD;end;
  if(T[6]=2)and(en(7))then RL(140);
  if(T[6]=1)and(en(7))then begin RS(20);DEAD;end;
  case T[8] of { Lift-off countdown }
   5:RL(181); 4:RL(182); 3:RL(191); 2:RL(192);
   1:if en(10)then
      begin Min(10);Min(26);Min(27);Explode(32);
       sound(20);bak(0,0);Score(10,122);
       n[84]:='reactor regulat\';
       RB(7,10);delay(9999);Pause;col(10,7);RS(43);PStat:=PStat-[2,5,6];
       Region:=4;T[3]:=150;T[4]:=125;T[5]:=230;T[8]:=0;T[9]:=1;T[10]:=5;end
     else begin RS(44);Explode(32);DEAD;end;
  end;
  if T[9]<1 then T[9]:=15;
  if(Region=4)and(Prm=1)and(T[9]=12)then RS(62);
  if T[10] in[1..4]then RL(194);
  if(Tic>3)and(Prm=8)and not(en(9))and not(en(7))then
   begin RS(6);Add(9)end else
  if(Tic>5)and(Prm=8)and(en(9))and not(en(16))and not(en(7))then
   begin RS(7);Add(16)end;
  case Prm of
    1:if(random(2)=0)and(T[9]>12)and(T[9]<15)and(Region=4)and not en(129)then
       begin RL(593);RL(594);Add(129)end
      else if(random(20)=0)and(Region=4)then RL(592);
    7:if random(5)=0 then RL(595);
    8:if random(3)=1 then RL(24)else if random(3)=1 then RL(178);
   15,17,19:case random(60) of
     1:RL(596);
     2:RL(597);
     3,4:if RC>40 then begin if T[4]>10 then T[4]:=10;RL(598)end;
     end; {case}
   20:if random(4)=1 then RL(25);
  end; {case}
  if Prm=SinkRm then begin RL(85);L[Prm]:=L[Prm]+[79];end;
end; { Time2A }

procedure Time2B;
 begin col(10,7);  { Jungle Planet }
  Maze:=not(Maze);
  if Prm in[42..49]then
   begin writeln('Some of the walls shift positions.');Walls(4);end;
  case Prm of
   7:if random(5)=0 then RL(595);
   26..29,32..34,59,60:case random(40) of
      0,1:RL(210); 2,3:RL(211); 4:RS(77); 5,6:RS(78); 7,8:RL(212);
      9:RL(213); 10:RL(214); 11:begin RL(215);play(6000,6001,20)end
     end;
   42..50:if random(7)=0 then RL(280);
  end; {case}
  if(Prm=28)and(random(2)=0)then RL(233);
  if Prm=SinkRm then begin RL(85);L[Prm]:=L[Prm]+[79];end;
  if T[11]=2 then RL(205);
  if T[11]=1 then begin RS(70);DEAD;end;
  if T[13]=1 then begin RB(11,10);for x:=1 to 3 do begin tune(4,2,200);
   delay(99);tune(4,5,200);delay(99)end;Pause end;
  if(T[14]=2)and(Prm in[40,41])then RL(251);
  if T[14]=1 then
   case Prm of 40:begin RL(249);Walls(8);end;41:begin RL(250);Walls(8);end end;
  if(T[15]=1)and(Prm=39)then begin RS(94);DEAD;end;
  if T[17]=4 then begin RS(109);DEAD;end;
  if T[17]=1 then begin Add(36);if Prm=56 then begin RS(110);Walls(8);end end;
  if T[18]=2 then begin RS(123);Walls(12)end;
  if(T[18]=1)and(Prm=53)then begin RS(124);Walls(12);DEAD;end;
  if T[19]=1 then begin RS(128);Walls(12);DEAD;end;
 end; { Time2B }

procedure Time2C;
 begin col(11,7);  { Inner Planet }
  if T[20]=1 then
   case Prm of 73:DClose(20);66:begin RL(337);play(105,50,20)end end;
  col(10,7);
  if(Prm=74)and not(en(47))then
   writeln('There is something flashing on the computer''s screen.');
  if(Prm=73)and(CodeSet<>4)then begin
   writeln('There''s an alarm sound coming over the radio.');
   for x:=1 to 23 do
    begin
     for i:=450 to 999 do sound(i);
     for i:=999 downto 450 do sound(i);
    end;nosound
   end;
  case random(50) of
   1..3:if here(38)then RL(588);
   4,5:begin RL(589);Explode(3)end;
   6:begin RS(244);for x:=1 to 7 do Static;end
   else if(Prm in[64,73])and(random(9)=0)then begin RL(590);RL(591)end
  end;
 end; { Time2C }

procedure Time2D;  { Planetship }
  function Warn(Message,IfTime,Said:integer):boolean;
   begin Warn:=false;
    if not en(Said)and(IfTime>=T[26])then
     begin if Said<>59 then begin Static;RS(Message);Static end
           else if Prm>99 then begin Static;RS(Message);Static end;
      if(Said=59)and(Prm<100)then begin end
      else begin Warn:=True;Add(Said)end
     end
   end; {Warn}
 begin col(11,7);
 for x:=0 to 2 do if T[23+x]>2 then Score(20,118+x); { 60 total points }
 if en(64)then Score(10,121);
  if T[21]=1 then
   case Prm of 91:DClose(20);86:begin RL(337);play(110,50,15)end end;
  col(10,7);
  if(Prm=95)and not(en(48))then begin
   writeln('A loud siren is sounding off...');
   play(300,530,6);delay(200);play(300,530,6)end;
  if(Prm=91)and not en(53)then begin writeln('An alarm is ringing...');
    for x:=1 to 23 do begin sound(400);delay(99);sound(940);delay(60);nosound;
   end end;
  if T[22]=1 then
   begin write('The door slides open...');play(50,60,65);
    writeln('then closes.');play(60,50,60);
    if en(50)then RS(153)else
    if Inv=[] then begin RS(247);RS(248)end
    else begin RS(154);RS(155);Inv:=[];end;
    delay(2500);write('The door slides open...');play(50,60,65);
    writeln('then closes.');play(60,50,65);
   end;
  case T[23] of
   13:begin if Prm=91 then RL(438);MC(2,91,91,161);Add(53)end;
   12:MC(2,91,91,162);
   11:begin if Prm in[86,91]then DOpen(15);MC(2,91,86,163);MC(2,86,86,164);
       if Prm in[86,91]then DClose(15)end;
   10:begin MC(2,86,87,165);MC(2,87,87,166)end;
   9:begin if Prm in[87,89]then DOpen(65);MC(2,87,89,167);MC(2,89,89,168);
      if Prm in[87,89]then DClose(65)end;
   7,8:if Prm=89 then begin ScrnSet:=4;RL(417)end;
   6:begin if Prm in[87,89]then DOpen(65);MC(2,89,87,169);MC(2,87,87,170);
      if Prm in[87,89]then DClose(65)end;
   5:begin MC(2,87,86,171);MC(2,86,86,172)end;
   4:if T[21]<2 then begin MC(2,86,91,173);if Prm in[86,91]then DOpen(15);
      if Prm=86 then RL(418);MC(2,91,91,174);if Prm in[86,91]then DClose(15)end
      else if Prm=86 then begin RL(418);MC(2,0,91,0)end;
   1:if Prm=91 then begin RL(419);Van(123);DClose(55)end else Van(123)
  end; {T[23]}
  if(T[23]>1)and(T[23]<4)and(Prm=91)then begin T[24]:=7;T[23]:=NULL;end;
  case T[24] of
   7:if Prm=91 then RS(175);
   6:if Prm=91 then begin RS(176);RS(177)end;
   5:if Prm=91 then begin RS(178);RS(179)end;
   4:begin if Prm=91 then RL(420);if not(1 in Inv)then T[24]:=2;end;
   2,3:if(Prm=91)and(1 in Inv)then RL(419+T[24]);
   1:begin Van(123);if Prm=91 then begin RS(180);DOpen(55);RL(418);
      DClose(55)end;
     end;
  end; {T[24]}
  case T[25] of
   2..5:if Prm=91 then RS(188-T[25]);
   1:begin if Prm=91 then RS(187);T[24]:=2;T[26]:=40;Add(64)end;
  end; {T[25]}
  if en(64)then
  if not Warn(198,38,54)then
  if not Warn(199,33,55)then
  if not Warn(203,30,59)then
  if not Warn(200,25,57)then
  if not Warn(201,20,58)then
  if not Warn(202,15,56)then
  if not Warn(204,10,60)then
  if not Warn(205,6,61)then
  if not Warn(206,3,62)then
  if not Warn(207,2,63)then begin end;
  if T[26]=1 then begin RS(197);DEAD;end;
  if(T[27]=1998)and(Prm=99)then  begin RS(213);Blast;DEAD;end;
  if(T[28]=1998)and(Prm=101)then begin RS(213);Blast;DEAD;end;
 end; { Time2D }

procedure Spaces(var I:Str130);
 begin I:=concat(' ',I,' ')end;

procedure QFormat(var I:Str130);
 begin
  if(I[1]='.')or(I[1]=' ')then delete(I,1,1);
  if(I[length(I)]='.')or(I[length(I)]=' ')then delete(I,length(I),1);
 end;

procedure PreFormat(var I:Str130);
 procedure D(A:Str29;B:byte);
  begin while pos(A,I)<>0 do delete(I,pos(A,I),B)end;
 begin D('  ',1);QFormat(I);
  FFlag:=0; if(length(I)>0)then FFlag:=1;
  Spaces(I);
  Crawl:=false;if pos(' crawl ',I)>0 then Crawl:=true;D(' crawl ',6);
  D(' walk ',5);D(' run ',4);D(' go ',3);D(' travel ',7);
  QFormat(I); if(length(I)=0)and(FFlag=1)then FFlag:=2; Spaces(I);
  D(' of ',3);D(' the ',4);D(' very ',5);D(' more ',5);D(' and ',4);
  D(' large ',6);D(' big ',4);D(' huge ',5);D(' please ',7);
  D(' small ',6);D(' little ',7);D(' tiny ',5);
  D('''',1);D('#',1);D('!',1);D('?',1);D(' number ',7);
  QFormat(I); if(length(I)=0)and(FFlag=1)then FFlag:=3; Spaces(I);
  while pos('examine ',I)>0  do delete(I,pos('examine ',I)+2,5);
  while pos(' into ',I)>0    do delete(I,pos(' into ',I)+3,2);
  while pos(' onto ',I)>0    do delete(I,pos(' onto ',I)+3,2);
  while pos(' inside ',I)>0  do delete(I,pos(' inside ',I)+3,4);
  while pos(' within ',I)>0  do delete(I,pos(' within ',I)+1,4);
  while pos('look ',I)>0     do delete(I,pos('look ',I)+1,3);
  while pos('. ',I)>0        do delete(I,pos('. ',I)+1,1);
  while pos(',',I)>0         do
   begin insert(' ',I,pos(',',I));delete(I,pos(',',I),1)end;
  D('..',1);D(' .',1);D('  ',1);
  QFormat(I);
  if(length(I)=0)then
   begin EFlag:=Null;
    case FFlag of
     2:RL(193);
     3:RL(186)
     else writeln('Pardon me?')
    end;
   end
 end; { PreFormat }

procedure LowerCase(var I:Str130);
 begin
  if(length(I)>0)then
   for x:=1 to length(I) do
    if(I[x] in['A'..'Z'])then
     I[x]:=chr(ord(I[x])+32);
 end; { LowerCase }

procedure ChopSeven(var I:Str130);
  var Word:Str130;
 begin
  if(length(I)>0)then
   begin
    I:=I+' '; x:=1;
     repeat
      Word:='';
      while(I[x]<>' ')and(I[x]<>'.')and(I[x]<>',')do
       begin Word:=Word+I[x]; x:=x+1 end;
      if(length(Word)>7)then
       begin
        y:=pos(Word,I); x:=x+(7-length(Word));
        delete(I,y,length(Word)); delete(Word,8,130);
        insert(Word,I,y)
       end;
      x:=x+1;
     until(x-1)=length(I);
    delete(I,length(I),1)
   end
  end; { ChopSeven }

procedure FindMood(var input:Str130;var Word:Str29;var Md:byte);
  var Temp1:Str53;
      Temp2:Str29;
      Counter:char;
 begin
  Spaces(input);x:=0;
  while x < AMax do
   begin x:=x+1;
    Counter:='1';
    Temp1:=A[x];
    while pos(Counter,Temp1)>0 do
     begin
      Temp2:=copy(Temp1,1,pos(Counter,Temp1)-1);
      if(pos(' '+Temp2+' ',input)>0)then
       begin
        Word:=Temp2;
        Md:=x;if Md=2 then Md:=1;
        x:=AMax;Counter:='8';
        delete(input,pos(Temp2,input),length(Temp2)+1);
       end;
      delete(Temp1,1,pos(Counter,Temp1));
      Counter:=succ(Counter);
     end;
   end;
  QFormat(input);
 end; { FindMood }

function Present : Boolean;
  label JUMP;
 begin Present:=false; x:=0;
  if not(Vb in [17,18,37,39]) then
   if N1<>Null then
    if Here(N1) then
     if N2<>Null then
      if Here(N2) then Present:=true
      else writeln('You can''t see any ',FN(N2),' here.')
     else Present:=true
    else writeln('You can''t see any ',FN(N1),' here.')
   else Present:=true
  else
   begin JUMP: x:=x+1;
    if x<=NMax then
     if x in NounSet then
      if Here(x) then goto JUMP
      else begin writeln('You can''t see any ',FN(x),' here.');end
     else goto JUMP
    else Present:=true
   end
 end; { Present }

procedure Convert(var n:byte;Max:byte);
 begin
  case Max of
   1:case n of                     { Verbs }
      12:n:=11; 14:n:=13; 23:n:=22; 27:n:=26;
      29:n:=28; 34:n:=33; 36:n:=35; 38:n:=37; 40:n:=39; 43:n:=42; 45:n:=44;
      52:n:=51; 55:n:=54; 57,58:n:=56; 60,61:n:=59; 63:n:=62;
     end;
   2:case n of                     { Nouns }
      13..15:n:=12; 21:n:=20; 33:n:=32; 36:n:=35; 39:n:=38; 45:n:=44;
      50:n:=49; 53:n:=52; 65:n:=64; 67:n:=66; 70:n:=69; 76,77:n:=75;
      97:n:=96; 101,102:n:=100; 114:n:=113; 117:n:=116; 63:n:=62;
      27:n:=26; 57:n:=56; 61:n:=60; 91:n:=90; 105..108:n:=109; 31:n:=28;
      133:n:=46; 84:if Prm>21 then n:=128; 115:if Prm=28 then n:=112;
      58:if Prm=52 then n:=64;
     end;
   3:case n of                  { Prepositions }
       2:n:=1; 4:n:=3; 8:n:=7 ;
     end;
  end;
 end; { Convert }

procedure FindWord( var I    : Str130;   { input string }
                    var VNP  : byte;     { flags which # word found }
                    var Word : Str29;    { stores last word found }
                        Max  : byte);    { check which list? }
  const Slash = '\';
  var j,ps:byte;
      Temp1,Temp2:Str29;
 begin
  QFormat(I); Spaces(I); J:=0;
  while (j<m[Max]) do
   begin
    j:=j+1;
    case Max of 1:Temp1:=v[j]; 2:Temp1:=n[j]; 3:Temp1:=p[j] end;
    ps:=pos(Slash,Temp1);
    while ps>0 do
     begin
      Temp2:=copy(Temp1,1,ps-1);
      if(copy(I,1,length(Temp2)+2)=' '+Temp2+' ')then
       begin { Match Found }
        VNP:=j;
        Convert(VNP,Max);
        Word:=Temp2;
        delete(I,1,length(Temp2)+1);
        case Max of 1:VStr:=Word; 2:NStr:=Word end;
        j:=m[Max];
        Temp1:='X';
       end;
      delete(Temp1,1,ps);
      ps:=pos(Slash,Temp1);
     end;
   end; { main loop }
  QFormat(I);
 end; { FindWord }

procedure Dictionary(IfFound,SkipList:byte);
  var StopLoopFlag:byte;
 begin VNP:=Null; list:=1; StopLoopFlag:=1;
  while(list<4)and(StopLoopFlag=1)do
   begin
    if list=SkipList then list:=list+1
     else
      begin
       FindWord(input,VNP,Word,list);
       if(VNP<>Null)then
        begin EFlag:=IfFound;list:=list-1;StopLoopFlag:=0;end;
       list:=list+1;
      end
   end;
  if(EFlag<>IfFound)then
  begin
   EFlag:=5;input:=input+' ';
   Word:=copy(input,1,pos(' ',input)-1);
   if(pos(' '+Word+' ',' top directi next some from is under underne '+
                        'leaning but speak pay ')>0)then
    EFlag:=IfFound
   else If Word[1] in['0','1','2','3','4','5','6','7','8','9'] then EFlag:=17;
   if IfFound=14 then EFlag:=14;
   QFormat(input);
  end;
 end; { Dictionary }


procedure Crazy;
 begin SF; RL(random(7)+127)end;

 procedure Default13;
begin
case Vb of

{ CLOSE }
53:case N1 of
    5:RL(289);
    56:RL(92)
    else writeln('The ',NStr,' is not something that can be closed.')
   end;

{ SCORE }
78:begin col(11,7);
    write('In ');col(12,9);write(Tic);col(11,7);
    write(' moves you scored ');col(12,9);write(Sc);col(11,7);
    writeln(' out of a possible 1000 points.');
    write('This score earns you the rank of ');col(12,9);
    case Sc of
    0..9:writeln(Up('ABSOLUTE BEGINNER!'));
    10..99:write('Rookie');
    100..179:write('Struggling');
    180..259:write('Novice');
    260..349:write('Competent');
    350..449:write('Fair');
    450..549:write('Good');
    550..649:write('Great');
    650..744:write('Brilliant');
    745..829:write('Genius');
    830..899:write('Elite');
    900..949:write('Champion');
    950..1000:write('Galaxy Class')
    end;
    if Sc>9 then writeln(' Adventurer.')
   end;

{ REPAIR }
74:RL(357);

{ FOLLOW }
91:if VStr='follow' then
    case N1 of 123:RL(358);124:RL(359)
     else writeln('Why, did the ',NStr,' leave?')
    end else RL(432+random(5)); { for Scott in VOCAB! }

{ WEAR }
72:if N1 in[7,20,26,28]then
    if N1 in Inv then
     if not(N1 in Wear)then
      begin Wear:=Wear+[N1];writeln('You are now wearing the ',FN(N1),'.');
       if(Prm in[102..105])and(N1=20)then RL(503);
      end
     else writeln('You are already wearing the ',FN(N1),'.')
    else writeln('First you must have the ',FN(N1),'.')
   else crazy;

{ REMOVE }
19:if N1 in Wear then begin Wear:=Wear-[N1];
    writeln('You are no longer wearing the ',FN(N1),'.');
    if Prm in[102..105]then RL(492)end
   else writeln('You are not wearing the ',FN(N1),' to begin with.');

{ TYPE }
56:if here(37)or here(52)then RL(273)else RL(361);

 end; {main case}
end; { Default13 }

procedure Call13; begin Default13 end;

procedure Won;
  const W=800;H=400;Q=200;T=131;
  label JUMP;
 begin writeln;
  gotoxy(1,20);for x:=1 to 5 do
   begin writeln;delay(99);sound(x*50);bak(x,7)end;
  gotoxy(1,15);col(4,15);bak(1,7);
  writeln('#######################################',
          '#######################################');
  delay(99);sound(300);bak(6,0);
  gotoxy(1,16);for x:=1 to 3 do begin
  write('#                                      ',
        '                                      #');
        delay(99);sound(300+(x*50));bak(x+8,15)end;gotoxy(1,19);
  write('#######################################',
        '#######################################');
  delay(99);sound(500);bak(14,0);
  gotoxy(26,17);col(31,31);
  write('Y O U   H A V E   W O N ! !');delay(99);sound(550);
  gotoxy(1,20);bak(0,0);bak(2,7);writeln;delay(99);nosound;
  for x:=1 to 12 do begin writeln;delay(80)end;
  gotoxy(1,9);Col(9,9);
  writeln('                              S U P E R N O V A');writeln;Col(11,7);
  writeln('     Programmed by . . . . . . . . . . . . . . . . . . . . . Scott Miller');
  writeln('     Story by  . . . . . . . . . . . . . . . . . . . . . . . Scott Miller');
  writeln('     Additional story development. . . . . . . . . . . . . . . Terry Nagy');
  writeln;writeln;
  Vb:=78;Call13;writeln;writeln;Col(3,7);
  write('Press any hey to quit...');
  tune(2,8,q);tune(2,8,q);tune(3,1,w);
  repeat
   tune(2,8,q);tune(2,8,q);
   tune(3,1,h);tune(2,12,h);tune(2,10,h);tune(2,8,q);tune(2,8,q);
   tune(3,1,w);tune(2,8,t);tune(2,8,t);tune(2,8,t);
   if keypressed then goto JUMP;
   tune(3,1,h);tune(2,12,h);tune(2,10,h);tune(2,8,t);tune(2,8,t);tune(2,8,t);
   tune(3,3,w);
   if keypressed then goto JUMP;
   tune(2,10,q);tune(2,10,q);
   tune(3,3,h);tune(3,1,h);tune(2,12,h);tune(2,10,q);tune(2,10,q);
   if keypressed then goto JUMP;
   tune(3,3,w);tune(2,10,t);tune(2,10,t);tune(2,10,t);
   tune(3,3,h);tune(3,1,h);tune(2,12,h);tune(2,10,t);tune(2,10,t);tune(2,10,t);
   tune(3,1,w);
  until keypressed;
  JUMP: CFlag:=readkey;
  window(1,1,80,25);clrscr;gotoxy(2,2);Col(31,31);bak(0,0);Cur(1);Bak(2,0);
  writeln('Congratulations!');
  HALT;
 end; { Won }

procedure PlayerInput(var LINE:Str130);
  label JUMP;
  procedure Key(k:Str19); begin Line:=Line+k;QFlag:=true;write(k)end;
 begin
 
  WRITELN; { Main Space In Game }
  if(length(Line)=0)then
   begin
    bak(4,7);col(14,0);
    window(1,1,80,22);
    gotoxy(8,2);write(Tic,'   ');
    gotoxy(35-(length(RN[Prm])div 2),2);
      write('      ',RN[Prm],'      ');
    gotoxy(75,2);write('    ');gotoxy(75,2);write(Sc,' ');
    bak(7,7);
    col(1,0);gotoxy(22,3);
    if PStat=[] then write('Healthy') else write('  *    ');
    col(15,0);gotoxy(33,3);
    if 2 in PStat then begin col(31,16);write('Hungry')end
    else write(' *    ');
    col(4,0);gotoxy(43,3);
    if 3 in PStat then begin col(20,16);write('Sick')end
    else write(' *  ');
    col(0,0);gotoxy(51,3);
    if 4 in PStat then begin col(16,16);write('Injured')end
    else write('   *   ');
    col(6,0);gotoxy(62,3);
    if 5 in PStat then begin col(22,16);write('Tired')end
    else write('  *  ');
    col(5,0);gotoxy(71,3);
    if 6 in PStat then begin col(21,16);write('Thirsty')end
    else write('   *   ');
    bak(0,0);window(2,5,79,24);
    if en(66)then begin gotoxy(1,20);goto JUMP;end;
    gotoxy(1,20);col(28,31);writeln(chr(175));
    Cur(1);
    col(14,7);gotoxy(3,19);
    QFlag:=false;
    repeat
     {intr($16,result);}CFlag:=readkey;
     sound(99);nosound;case Region of 4:sound(20);5:sound(60)end;
     case CFlag of
     chr(8):begin
         if(wherex=1)and(wherey=20)then
          begin window(1,1,80,25);gotoxy(80,23)end;
         if length(Line)>0 then write(^h,' ',^h);
         delete(Line,length(Line),2);
         {window(2,5,79,24);   }
        end;
     chr(13):QFlag:=true
     else
      begin
       if(length(Line)<110)then
        begin write(CFlag);Line:=Line+CFlag;end
       else { read scan }
        begin
         case ord(CFlag) of
          59:key('Save');      71:key('Northwest');
          60:key('Restore');   73:key('Northeast');
          61:key('R D');       79:key('Southwest');
          62:key('Look');      81:key('Southeast');
          63:key('Get all');   82:key('Down');
          64:key('Drop all');  83:key('Up');
          65:key('Score');     104:begin QFlag:=true;RR(0)end;
          66:key('Inventory');
          67:key('Wait');
          68:begin Line:='';key('Repeat')end;
          94,30:key('by Scott Miller');
          95,47:key('Version A Dec 9, 85');
         end;
        if Prm in[1..7] then
         case ord(CFlag) of
          72:key('Fore'); 75:key('Port'); 77:key('Starboard'); 80:key('Aft')
         end
        else
         case ord(CFlag) of
          72:key('North'); 75:key('West'); 77:key('East'); 80:key('South')
         end
       end
      end
     end; {case}
     until QFlag=true;
    Cur(3);
    gotoxy(1,19);col(5,7);write(chr(175));col(11,7);gotoxy(1,20);
    if length(Line)>76 then writeln;
    LowerCase(Line);Spaces(Line);
    if(pos(' r ',Line)>0)or(pos(' repeat ',Line)>0)then PreFormat(Line);
    if(Line='r')or(Line='repeat')then Line:=Again else Again:=Line;
    Spaces(Line);
    while pos(' then ',Line)>0 do
     begin
      x:=pos(' then ',Line);delete(Line,x,5);insert('.',Line,x)
     end;
    ChopSeven(Line);
    PreFormat(Line);
   end;
   if(pos('.',Line)>0)then
    begin    { SEPERATES LINE INTO SINGLE INPUTS }
     input:=copy(Line,1,pos('.',Line));
     delete(Line,1,pos('.',Line));
     delete(input,pos('.',input),1);
     PreFormat(input);
    end
   else
    begin
     input:=Line; Line:='';
    end; { END OF LINE SEPERATION }
   Spaces(input);
   while pos(' it ',input)>0 do
    begin x:=pos(' it ',input)+1;delete(input,x,2);insert(LastNoun,input,x);
     PreFormat(input);ChopSeven(input);
    end;
   while pos(' them ',input)>0 do
    begin x:=pos(' them ',input)+1;delete(input,x,4);insert(LastNoun,input,x);
     PreFormat(input);ChopSeven(input);
    end;
   QFormat(input);
   col(11,7);
   JUMP:
 end; { PlayerInput }

procedure Title;
 begin
  clrscr;textcolor(7);Color:=true;
  if ParamCount=0 then begin
   write('Do you want ');textcolor(15);write('C');textcolor(7);
   write('olor or ');textcolor(15);write('B');textcolor(7);
   write('lack and white? ');textcolor(15);CFlag:=readkey;
   if(upcase(CFlag)='B')or(upcase(CFlag)='M')then
    begin Color:=false;write('Monochrome')end
   else write('Color');delay(300);
  end
  else
   begin input:=ParamStr(1);CFlag:=input[1];
    if(CFlag='/')and(length(input)>1)then CFlag:=input[2];
    if(upcase(CFlag)='B')or(upcase(CFlag)='M')then
     begin Color:=false;writeln('Monochrome screen option...')end
    else writeln('Color screen option...');delay(999)
   end;
  clrscr;textmode(BW80);
  Cur(3);

                 {**** Public Domain title screen ****}
  Col(9,9);gotoxy(1,1);
  cn('S U P E R N O V A');
  Col(9,7);gotoxy(1,3);
  cn('Published by');
  gotoxy(1,5);
  cn('APOGEE SOFTWARE PRODUCTIONS');
  writeln;
  Col(11,7);
  cn('This game is placed in the public domain for your enjoyment.   Please do');
  cn('not abuse this product or the author''s rights.');
  writeln;
  cn('If you enjoy this game the author asks that you contribute $10 (by check).');
  cn('This payment  will encourage the author  to create similar games  and will');
  cn('help compensate him  for the several years work that went into  Supernova.');
  cn('This fee will also register the payer for telephone support and clues.');
  writeln;
  Col(14,15);
  writeln('Please make checks payable to:  Scott Miller');
  writeln;
  writeln('Scott Miller      (214) 240-0614');
  writeln('4206 Mayflower Drive');
  writeln('Garland, TX 75043');
  writeln;
  writeln('Also call for help:  Terry Nagy  (214) 271-3065');
  writeln;
  Col(11,7);delay(7000);
  cn('Thanks, enjoy the game...');

  Col(7,7);gotoxy(27,25);delay(999);
  write('Press any key to continue.');repeat;begin;end;until keypressed;
  CFlag:=readkey;bak(1,0);clrscr;
                 {**** Main SUPERNOVA title screen ****}

  bak(1,0);Col(15,15);Bak(4,0);
  for x:=1 to 80 do
   begin gotoxy(x,1);write(chr(205));gotoxy(x,24);write(chr(205))end;
  for y:=1 to 24 do
   begin gotoxy(1,y);write(chr(186));gotoxy(80,y);write(chr(186))end;
  gotoxy(1,1);write(chr(201)); gotoxy(80,1);write(chr(187));
  gotoxy(1,24);write(chr(200)); gotoxy(80,24);write(chr(188));
  Bak(1,0);
  Col(2,7);gotoxy(1,10);cn('Copyright 1987 Scott Miller');
  Col(14,7);gotoxy(1,12);cn('Version B');
  Col(7,7);gotoxy(1,15);
  cn('Programmed by Scott Miller');
  cn('Story by Scott Miller and Terry Nagy');
  gotoxy(1,23);Col(3,7);
  cn('Press any key to continue.');
  repeat
   gotoxy(32,8);
   if Color then textcolor(random(16))
   else case random(3) of  0:textcolor(0); 1:textcolor(7); 2:textcolor(15)end;
   write('S U P E R N O V A');
  until keypressed;
  CFlag:=readkey;
  if Color then textmode(C80)else textmode(BW80);
 end; { Title }

procedure Init1;
  label Abort;
 begin Abort:
  bak(0,0);bak(0,0);clrscr;nosound;
  Cur(3);randomize;
  GetDir(0,Word);
  for x:=1 to 20 do begin sound(x*9);delay(x*2)end;nosound;
  gotoxy(1,9);y:=0;col(14,7);Identity:='';
  Cn('Please enter your identity code name:');col(12,15);
  repeat i:=random(maxint) until keypressed;
  repeat CFlag:=readkey;
   if(CFlag<>chr(13))then
    if(CFlag<>^h)then Identity:=Identity+upcase(CFlag)
    else delete(Identity,length(Identity),2);
   gotoxy(1,11);Cn(' '+Identity+' ');sound(50);delay(50);nosound;
  until CFlag=chr(13);
  col(10,7);gotoxy(1,7);
  if identity<>'' then
   Cn(' IDENTITY CODE ACCEPTED--YOU MAY PROCEED '+Identity)
  else begin
   col(25,31);bak(4,7);Cn('IDENTITY CODE REJECTED--ABORTING SEQUENCE')end;
  LowerCase(Identity);ChopSeven(Identity);
  delay(1500);
  if Identity='' then goto Abort;
  assign(L1,'L1');
  assign(C1,'C1');
  assign(S1,'S1');
  assign(R1,'R1');assign(R2,'R2');
  assign(T1,'SM');assign(T2,'B1');
  reset(R1);reset(R2);
  reset(S1);reset(L1);reset(C1);
  reset(t1);reset(t2);
 end; { Init1 }

procedure Init2;
 begin
  col(7,15);bak(1,7);
  for x:=1 to 80 do
   begin gotoxy(x,1);write(chr(205));gotoxy(x,24);write(chr(205))end;
  gotoxy(80,24);write(chr(190));gotoxy(1,24);write(chr(212));
  gotoxy(1,4);InsLine;
  for x:=2 to 24 do
   begin gotoxy(1,x);write(chr(179));gotoxy(80,x);write(chr(179))end;
  gotoxy(1,4);write(chr(198));for x:=2 to 79 do
   begin gotoxy(x,4);write(chr(205))end;write(chr(181));
  gotoxy(1,1);write(chr(213));gotoxy(80,1);write(chr(184));
  bak(4,7);col(14,0);gotoxy(2,2);
  for x:=1 to 78 do write(' ');
   gotoxy(2,2);write('Move');
  gotoxy(68,2);write('Score');
  bak(7,7);gotoxy(2,3);
  for x:=1 to 78 do write(' ');
  bak(5,7);col(15,0);
  gotoxy(2,3);write('Player Condition:');
  bak(0,0);
  gotoxy(1,14);col(14,7);
  cn('Working 14 hours a day in the core of some dusty, smelly mine');
  cn('is not your idea of the perfect lifestyle.');
  cn('Barre-An is a dust ball in space, its only salvation being that it is');
  cn('rich in precious barre-an metal.  Or used to be.  Nowadays the mines');
  cn('don''t seem so generous, which is why you''re looking for a more');
  cn('profitable venture.');
  cn('A break, that''s all you ask for, maybe today you figure...');
  writeln;
 end; { Init2 }

procedure Init3;
 begin
  Line    :='';
  Again   :='z';
  LastNoun:='mug';
  Vb      :=Null;
  Prm     :=8;
  Sc      :=0;
  Tic     :=0;
  PStat   :=[6];
  Events  :=[];
  for o   :=1 to MMax do r[o]:=Null;
  Inv     :=[3,8];
  Mov     :=[1..29];
  AlienRm :=Null;
  FriendRm:=91;
  Brief   :=[];
  Wear    :=[];
  MugCon  :=99;
  FoodCon :=4;
  SatchCon:=6;
  HolstCon:=Null;
  NicheCon:=Null;
  SinkRm  :=Null;
  PyraCon :=Null;
  Serum   :=Null;
  HingeCon:=9;
  PodumCon:=18;
  RobotCon:=12;
  Socket  :=[22..25];
  CodeSet :=7;
  ScrnSet :=1;
  Floor   :=1;
  Region  :=1;
  TFlag   :=1;
  Old     :=250;
  Old2    :=Old;
  Maze    :=true;
  Drive   :='A';
  StoreR:=-1;StoreS:=-1;StoreL:=-1;StoreC:=-1;{ Stores Last Read File Number }
  Dir[1]:='NORTH';Dir[2]:='SOUTH';Dir[3]:='EAST';Dir[4]:='WEST';
  Dir[5]:='NORTHEAST';Dir[6]:='NORTHWEST';
  Dir[7]:='SOUTHEAST';Dir[8]:='SOUTHWEST';
  m[1]:=VMax;m[2]:=NMax;m[3]:=PMax;
  for x   :=1 to TMax do T[x]:=Null;
  T[2]    :=0;
  T[3]    :=70;  { Hunger }
  T[4]    :=26;  { Thirst }
  T[5]    :=85; { Sleep (No relation to the T[2] sleep timer!) }
  NoNounOnly  :=[1..8,15,16,30,77..79,82,85..87,95];
  OneNounMaybe:=[9..14,25,32,46,59..60,66..71,80,81,90,91];
  ToNounOnly  :=[33,49,64,88,93];
  ToNounMaybe :=[19,41..44,48,50,53,54,74..76,89,90,92,94];
  { NOTE:  All other verbs would be OneNounOnly! }
  window(2,5,79,24);gotoxy(1,19);
 end; { Init3 }

procedure Save;
  label JUMPAbort,JUMPBACK;

 begin SF; JUMPBACK: nosound; for x:=1 to 20 do writeln;
  CFlag:=Drive;Cur(2);
  gotoxy(1,2);
  {write('Which disk drive (default ',Up(Drive),':)? ');
  col(14,15);readln(Drive);col(11,7);
  Drive:=upcase(Drive);if not(Drive in['A','B'])then Drive:=CFlag;
  gotoxy(1,5);
  writeln('Make sure your SAVE/RESTORE disk is in disk drive ',up(Drive),':');
  writeln;writeln; }
  write('SAVE under what file name (',{'',up('/'),'''} 'aborts SAVE)? ');
  col(14,15);readln(input);col(11,7);
  Cur(3);
  while pos(' ',input)>0 do delete(input,pos(' ',input),1);
  while pos('.',input)>0 do delete(input,pos('.',input),1);
  while pos(':',input)>0 do delete(input,pos(':',input),1);
  if pos('/',input)>0 then
   begin writeln;writeln(up('SAVE ABORTED'));goto JUMPABORT;end;
  LowerCase(input);
  if(pos('list',input)>0)or(pos('dir',input)>0)or(pos('file',input)>0)then
   begin Directory;goto JUMPBACK;end;
  if length(input)=0 then input:='LASTSAVE';writeln;writeln;
  writeln('The game file ',input,' is now being saved on disk drive ',{
           up(Drive),':}'...');
  input:={Drive+':'+}input;
  assign(Objects,input+'.sm1');
  rewrite(Objects);
  for x:=0 to RMax do write(Objects,L[x]);
  close(Objects);
  assign(Things,input+'.sm2');
  rewrite(Things);
  write(Things,Prm,Region,MugCon,FoodCon,SatchCon,NicheCon,PyraCon,
               HingeCon,PodumCon,AlienRm,FriendRm,SinkRm,Serum,TFlag,
               RobotCon,CodeSet,ScrnSet,HolstCon);
  for x:=1 to MMax do write(Things,R[x]);
  close(Things);
  assign(Timers,input+'.sm3');
  rewrite(Timers);
  write(Timers,Tic,Sc,RC,Floor);
  for x:=1 to TMax do write(Timers,T[x]);
  close(Timers);
  with SetSave do
   begin aInv:=Inv;aPStat:=PStat;aEvents:=Events;
    aSocket:=Socket;aWear:=Wear;end;
  assign(Sets,input+'.sm4');
  rewrite(Sets);
  write(Sets,SetSave);
  close(Sets);
  writeln;writeln;{delete(input,1,2);  }
  writeln('Your present game location is now SAVED under the name ',
           up(input),'.');
  writeln; JUMPABORT: writeln;  pause;
  Col(11,7);
  bak(0,0);Line:='l';
  case Region of 4:sound(20);5:sound(60)end
 end; { SAVE }

procedure MoreThanOne;
 begin
  if((N1=58)or(58 in NounSet)or(N2=58))and Here(3) and Here(4) then
   begin Cur(2);
    repeat write('Which one, the R)usty or S)hiney key? ');
     CFlag:=readkey;writeln(CFlag);writeln until upcase(CFlag) in ['R','S'];
    case upcase(CFlag) of 'R':x:=3; 'S':x:=4 end;
    if N1=58 then N1:=x;
    if N2=58 then N2:=x;
    if 58 in NounSet then begin NounSet:=NounSet-[58];NounSet:=NounSet+[x] end;
   end;
  if((N1=86)or(86 in NounSet)or(N2=86))and(Prm=8)then
   begin Cur(2);
    repeat write('Which one, the W)estern, M)iddle or E)astern table? ');
     CFlag:=readkey;writeln(CFlag);
     writeln until upcase(CFlag) in ['W','M','E'];
    case upcase(CFlag) of 'W':x:=83; 'M':x:=84; 'E':x:=85 end;
    if N1=86 then N1:=x;
    if N2=86 then N2:=x;
    if 86 in NounSet then begin NounSet:=NounSet-[86];NounSet:=NounSet+[x] end;
   end;
  if((N1=44)or(44 in NounSet)or(N2=44))and(Prm in[1,70])and(Vb<>28)then
   begin Cur(2);
    repeat write('Which one, the T)an, P)urple or C)yan button? ');
     CFlag:=readkey;writeln(CFlag);
     writeln until upcase(CFlag) in ['T','P','C'];
    case upcase(CFlag) of 'T':x:=41; 'P':x:=43; 'C':x:=40 end;
    if N1=44 then N1:=x;
    if N2=44 then N2:=x;
    if 44 in NounSet then begin NounSet:=NounSet-[44];NounSet:=NounSet+[x] end;
   end;
  if(N1=58)and Here(3)and not(Here(4))then N1:=3;
  if(N2=58)and Here(3)and not(Here(4))then N2:=3;
  if(58 in NounSet)and Here(3)and not(Here(4))then
    begin NounSet:=NounSet-[58];NounSet:=NounSet+[3] end;
  if(N1=58)and Here(4)and not(Here(3))then N1:=4;
  if(N2=58)and Here(4)and not(Here(3))then N2:=4;
  if(58 in NounSet)and Here(4)and not(Here(3))then
    begin NounSet:=NounSet-[58];NounSet:=NounSet+[4] end;
end; { MoreThanOne }


function Print(Word:Str29):Str1;
 begin Print:='';writeln('--you can''t use the word ',Up(Word),' here.')end;

procedure Parser_Syntax(var Input:Str130);
   label JUMP1, JUMP2;
begin
 Word:=''; Md:=Null; Num:=Null; Code:=Null;
 Vb:=Null; N1:=Null; N2:=Null; NounSet:=[];
JUMP1:  { Used if the player forgets the first noun. }
 FFlag:=Null; Pr:=Null;
JUMP2:  { Used if the player forgets the second noun or preposition. }
 EFlag:=Null;
 FindMood(input,Word,Md);
 if(length(input)>0)then
  begin
   FindMood(input,Word,Num);
   if(Num=Null)then
    begin
     FindWord(input,Vb,Word,1);
     if(Vb<>Null)then
      if(length(input)=0)then
       begin
        if(Vb in NoNounOnly)or(Vb in OneNounMaybe)then EFlag:=Legal;
        if EFlag<>Legal then
         begin
          if(Vb=35)and here(35)then begin EFlag:=Legal;N1:=35;NStr:='seat';end;
          if(Vb=47)and here(6)then begin EFlag:=Legal;N1:=6;end;
          if(Vb=62)and here(80)then begin EFlag:=Legal;N1:=80;end;
          if(Vb=65)and here(124)then begin EFlag:=Legal;N1:=124;end;
          if EFlag<>Legal then EFlag:=4
         end
       end
      else
       if(Vb in NoNounOnly)then Dictionary(3,9)
       else
        if not(Vb in[17,18,37,39])then       { get,drop and but branch-off }
         if not(Vb in[25,32,56,66..69,71,80,81])then { characters and type }
          begin
           if(Vb<>FFlag)then FindWord(input,N1,Word,2);
           if(N1<>Null)then LastNoun:=FN(N1);
           if(N1<>Null)then
            if(Word<>'all')then
             if(length(input)=0)then
              if(Vb in ToNounOnly)then
               if(VStr='fill')and(Prm=SinkRm)and(N1=29)then
                  begin N2:=79;Pr:=6;EFlag:=Legal;end else
               if(Vb=64)and(Prm=8)and(N1 in[29,99])and(not en(21))and
                  here(8)then begin Pr:=6;N2:=8;EFlag:=Legal;end else
               if(Vb=88)and(Prm in[9..11])and(N1=56)and here(3)then
                  begin Pr:=6;N2:=3;EFlag:=Legal;end
               else EFlag:=15
              else EFlag:=Legal
             else
              if(Vb in ToNounMaybe)or(Vb in ToNounOnly)then
               begin
                FindWord(input,Pr,Word,3);
                if(Pr<>Null)then
                 if(length(input)=0)then
                   if(Vb=50)and(Pr in[1,9])then EFlag:=Legal
                   else EFlag:=6
                 else
                  if(Vb<>50)then  { branch for turning dials }
                   begin
                    FindWord(input,N2,Word,2);
                    if(N2<>Null)then
                     if(Word<>'all')then
                      if(length(input)=0)then EFlag:=Legal
                      else Dictionary(12,9)
                     else EFlag:=16
                    else Dictionary(11,2)
                   end
                  else
                   begin
                    val(input,Code,testc);
                    if(testc=0)then EFlag:=Legal
                    else begin delete(input,1,testc-1);Dictionary(14,9);end;
                   end
                else Dictionary(9,3)
               end
              else
               begin Dictionary(3,9);if(List=2)then EFlag:=8;end
             else EFlag:=16
           else Dictionary(10,2)
          end
         else { Special case for TYPE, characters, etc. }
          begin
           QFormat(input);
           EFlag:=Legal
          end { of Special case for SAY, TYPE, etc. }
        else  { Special case for GET and DROP }
         while EFlag=Null do
          begin N1:=Null;
           FindWord(input,N1,Word,2);
           if(N1<>Null)then LastNoun:=FN(N1);
           if(N1<>Null)then
            if not(N1 in NounSet)then
             begin
              NounSet:=NounSet+[N1];
              if(length(input)=0)then EFlag:=Legal
             end
            else EFlag:=13
           else Dictionary(10,2)
          end { of Special case for GET and DROP }
     else Dictionary(7,1)
    end
   else EFlag:=2
  end
 else EFlag:=1;
 if EFlag<>Legal then
  begin Line:='';play(199,199,55);delay(70);play(60,60,55)end;
 case EFlag of
 1:RL(186);
 2:writeln('The word ',up(Word),' is too many adverbs.');
 3:write('Illegal input',Print(Word));
 4:if(Vb=56)then RL(187)
   else
    begin
     write('Noun missing--');
     case Vb of
      35,62:writeln('what do you want to ',up(Word),' on?');
      65:writeln('what do you want to ',up(Word),' to?')
      else writeln('what do you want to ',up(Word),'?');
     end;
     PlayerInput(line);
     if(length(input)>0)then goto JUMP1;
    end;
 5:if(length(Word)>1)then
    writeln('The word ',up(Word),' is not used in this adventure.')
   else
    writeln('The letter ',up(Word),' is not used as shorthand in this parser.');
 6:begin
    writeln('Noun missing--what do you want to ',up(VStr),up(' the '),
            up(NStr),'?');
    PlayerInput(line); FFlag:=Vb;
    if(length(input)>0)then goto JUMP2;
   end;
 7:write('Verb missing',Print(Word));
 8:RL(188);
 9:write('Preposition expected',Print(Word));
 10:write('Noun expected',Print(Word));
 11:write('Indirect noun expected',Print(Word));
 12:write('No more input expected',Print(Word));
 13:writeln('Illegal noun used--',up(Word),' referenced more than once.');
 14:write('Number expected',Print(Word));
 15:begin
     write('Preposition and noun missing--');
     if(Vb in[33,48])then
      writeln('where do you want to ',up(VStr),' the ',up(NStr),'?') else
     if Vb=49 then
      begin Pr:=1;
       writeln('who do you want to ',up(VStr),' the ',up(NStr),' to?')end
     else begin Pr:=6;
       writeln('what do you want to ',up(VStr),' the ',up(NStr),' with?')end;
     PlayerInput(line); FFlag:=Vb;
     if(length(input)>0)then goto JUMP2;
    end;
 16:RL(189);
 17:RL(576)
 end;
end; { Parser Syntax }

procedure NoSense;
 begin RL(190) end;

procedure Say(What1,What2:Str29);
 begin SF; writeln('The ',What1,' is already ',What2,'.') end;


{****************************** ROOM ROUTINES *******************************}
procedure Room1;   { The Player's Ship }
begin
case Prm of
 1:case Vb of  { Bridge }
   2,13:Door(2,50);
   11:RL(199);
   22,24,28:case N1 of
        37,38,55,44:if Md<>Null then RL(534)else RB(3,11);103:RL(317);
        35:if en(6)then RL(542)else RL(543);
        59:case Region of
            1:RS(46);
            2:RS(63);
            4:RS(T[9]+46);
           end
       end;
   35:if N1 in[16,35] then
       if(here(16))and(en(6))then
        if not en(4) then
         begin Add(7);sound(440);RS(19);T[6]:=4;for x:=1 to random(30)+9 do
          begin y:=random(6000)+60;play(y,y,70);delay(9)end;Score(10,67)
         end
        else begin Add(7);RL(149); for x:=1 to random(9)+9 do
            begin y:=random(9999);play(y,y,30);delay(55)end;end
       else RL(141);
   56:if en(7)and en(6)then
       if T[6]>0 then
        if input=Identity then
         begin RS(21);T[6]:=Null;Score(15,4);play(400,400,200)end
        else RL(142)
       else
        if input='r2/20-8 d2/vega' then
         if not(Region in[2,4]) then
          begin RS(28);Add(26);Min(27);play(600,600,99)end
         else RL(154)
        else
         begin Min(26);RS(39);Min(27);play(600,600,99)end
       else RL(179);
   44:if en(7)and en(6)then
       case N1 of
        43:begin play(750,750,200);  { Purple }
            if Region=4 then
             if T[9]=11 then begin Score(5,68);Region:=2;T[13]:=3;TFlag:=2;
              n[126]:='hinged mouth\mouth\hinge\';
              RB(9,11);Explode(30)end
             else RS(64)
            else RL(198)
           end;
        40:begin play(900,900,200);  { Cyan }
            if en(26) then begin RS(37);Add(27)end
            else RL(195)
           end;
        41:begin play(600,600,200);  { Tan }
            if en(27) then
             if not(en(22))and not(en(23))then
              begin col(28,23);RL(180);col(11,7);
               RS(38);T[8]:=7;
               for x:=1 to 6 do
                for y:=30 to 200 do begin sound(y);delay(5)end;nosound;
              end
             else begin RS(40);play(500,999,3);Min(26);Min(27)end
            else if en(26)then RL(184)else RL(185)
           end;
       end {case}
      else RL(179);
   39:if(16 in NounSet)and en(6)then
       if en(7)then RL(575)else begin Min(6);RL(145);SFlag:=false;end;
   end; {Vb}
 end; {main case}
end; { Room1 }
{----------}
procedure Room2;   { The Player's Ship }
begin
case Prm of
 2:case Vb of  { Forward Corridor }
   9,13,51:if(n1 in[0,62,64,71])then
     if en(23) then begin RL(237);case Region of 1:move(22);2:move(24);end end
     else RL(99);
   1,11:Door(1,50);
   2:move(3);
   4:move(4);
   24,28:if NStr='hatch' then if en(23) then RL(163)else RL(99);
   50:if N1=78 then
       if en(22)then begin RL(160);Min(22)end else
        begin RL(161);Add(22);
         if T[8]>0 then begin RS(40);play(500,999,3);T[8]:=0;Min(27)end end;
   41:if NStr='hatch' then
       if Region<>4 then
        if en(22) then
         begin RL(96);Add(23);
          if(not en(44))and(Region=2)then
           begin Add(44);RL(327);for i:=1 to 400 do sound(random(3500)+999);
            for i:=7500 downto 500 do begin sound(random(i)+i);
             sound(random(3500)+2000)end;
            for i:=1 to 300 do sound(random(3500)+2500);nosound;
           end
         end
        else RL(97)
       else begin RS(45);DEAD end;
   53:if N1=56 then
       if en(23) then begin RL(98);Min(23)end else say('hatch','closed');
   end; {Vb}

 3:case Vb of  { Rear Corridor }
   1,13:move(2);
   3:move(6);
   4:move(7);
   28,31:if N1 in[55,81] then begin RB2(4,12);Pause;end;
   24,41,76:if N1=55 then if Md in[1,4]then RL(533)else begin RS(22);DEAD;end;
   end; {Vb}
 end; {main case}
end; { Room2 }
{----------}
procedure Room3;   { The Player's Ship }
begin
case Prm of

 4:case Vb of  { Ship's Lab }
   3,13:move(2);
   28,22:case N1 of
          90:RS(23); 52:RS(26); 38:RS(27); 55:RS(31);
          81,119:begin RB(10,14);Pause;end;
          64:if NicheCon<>Null then
              writeln('There is a ',FN(NicheCon),' sitting on the niche.')
             else RL(152);
         end;
   31:if N1 in[81,119] then begin RB(10,14);Pause;end;
   41..44,88:if N1=55 then RL(174);
   33:if N2=64 then
       if N1 in[3,4,8,9,12,17,29] then
        if Pr in[1,5,10] then
         if NicheCon=Null then
          begin Van(N1);R[N1]:=4;NicheCon:=N1;RL(147)end
         else RL(148)
        else crazy
       else RL(146);
   54:if N1 in[38,90]then begin RL(321);Serum:=1;end;
   56:begin Serum:=Serum+1;
       if Serum<3 then
        if NicheCon=Null then RS(24)
        else if NicheCon<>29 then
         writeln('A small amount of serum drips onto the ',FN(NicheCon),' and ',
                  'dries up.')
         else
          if MugCon=Null then begin MugCon:=92;RS(25);L[4]:=L[4]+[92];
           if input='6' then Add(42)else Min(42)end
          else
           if MugCon in[79,92,99] then
            writeln('The serum mixes with the ',FN(MugCon),' inside the mug.')
           else
            writeln('The serum drips on the ',FN(MugCon),' inside the mug and',
                    ' quickly evaporates.')
       else RS(135)
      end; {type}

   end; {Vb}

 5:case Vb of  { Sanitary Facilities }
   2,13:move(6);
   22,28:if N1=98 then RL(122);
   end; {Vb}

 6:case Vb of  { Sleep Chamber }
   1,11:move(5);
   4,13:move(3);
   28:case N1 of 80:RL(159); 69:RS(29) end;
   51:if N1=69 then Vb:=35;
   end; {Vb}

 7:case Vb of  { Cargo Area }
   3,13:move(3);
   22,28:if N1=32 then RL(155);
   24:if N1=32 then RL(156);
   41,53:if N1=32 then RL(157);
   39:if 32 in NounSet then RL(158);
   end; {Vb}

 end; {main case}
end; { Room3 }
{----------}
procedure Room4;   { The Tavern }
begin
case Prm of
 8:case Vb of  { Tavern }
   2,13:if en(7)then RL(22)else begin RL(93);move(13)end;
   3,9,11,51:if en(7)then RL(22)
       else if(N1 in[null,71])then begin RL(283);move(9)end
       else if N1=126 then RL(473);
   31:if N1 in[81,119]then RB(2,9);
   35:case N1 of
      83:if T[1] in[4..7,11..17] then RS(8) else begin Add(19);Add(7);RL(30)end;
      35,84,85:begin Add(7);RL(30);if N1 in[35,84] then Add(2)else Min(2)end;
      end;
   65:if N1=124 then
       if en(2) then
        if T[1] in[5..7,11..18] then
         if(md=1)or(en(18))then begin RL(31);Score(20,3);
          if not en(18)then begin Add(18);T[1]:=8;end end
         else RL(32)
        else RL(41)
       else RL(33);
   28:case N1 of 56:RL(371);81,119:RB(2,9);111:RL(44)end;
   41:if N1=56 then RL(394);
   39:if(29 in NounSet)and not en(21)then RL(86);
   54,93:if N1=111 then begin RS(32);DEAD;end;
   42,44,75:if N1=111 then RL(474);
   59:if N1=126 then RL(473);
   20:if N1=126 then RL(178);
   end; {Vb}

 9:case Vb of  { West Hallway }
   1,2:RL(89);
   3,11:move(10);
   28:if N1=56 then RL(92);
   4,10,13,51:if(n1 in[null,71])then begin RL(284);move(8)end;
   54:if(N1=56)and(T[1]<1)then RS(13)else RL(123);
   41,88:if N1=56 then
          case N2 of 0:RL(107);3:RL(101)else RL(137)end;
   end; {Vb}

10:case Vb of  { Central Hallway }
   1:RL(89);
   4,13:move(9);
   3:move(11);
   28:if N1=56 then if en(11)then RL(370)else RL(92);
   2,11:if en(11) then begin RL(90);Score(5,69);move(12);Min(11)end
        else RL(89);
   41,88:if N1=56 then case N2 of 0:RL(107);3:begin;end else RL(137)end;
   54:if N1=56 then RL(123);
   end; {Vb}

11:case Vb of  { East Hallway }
   1,2:RL(89);
   4,13:move(10);
   28:if N1=56 then RL(92);
   41,88:if N1=56 then
          case N2 of 0:RL(107);3:RL(101)else RL(137)end;
   54:if N1=56 then RL(123);
   53:if N1=56 then begin RL(92);Min(11)end;
   end; {Vb}

12:case Vb of  { Suite #4 }
   1,13:if en(7)then RL(22)else
        if en(11) then begin RL(91);move(10);Min(11)end else RL(92);
   41,88:if N1=56 then begin RL(104);Add(11)end;
   22,28,76:
      case N1 of
       56:if en(11)then RL(370)else RL(92);
       80:if Md<>Null then RL(535)else RL(536);
       87:if 7 in L[12] then begin RL(106);R[7]:=12;Score(5,24)end;
       98:RL(121);
      end;
   53:if N1=56 then begin RL(92);Min(11)end;
   39:if(7 in NounSet)or(30 in NounSet)then Score(5,24);
   end; {vb}

 end; {main case}
end; { Room4 }
{----------}
procedure Room5;   { Barre-An Planet }
 procedure Zap; begin for x:=1 to 29 do if R[x]=Prm then Van(x) end;
begin
case Prm of
13:case Vb of  { Crossroads }
   1,11:if en(7)then RL(22)else begin RL(93);move(8)end;
   2:move(18);
   3:move(16);
   4:move(14);
   28,31:if N1 in[81,88] then begin Score(5,70);RB2(5,6);Pause;end;
   41:if N1=56 then RL(394);
   end; {Vb}

14:case Vb of  { Dusty Road }
   3:move(13);
   4:begin RC:=1;move(15)end;
   end; {Vb}

15:case Vb of  { Dusty Road (endless) }
   3:begin Zap;RC:=RC-1;if RC<1 then move(14)else move(15)end;
   4:begin Zap;RC:=RC+1;move(15);if RC=40 then
      writeln('You notice something unusual.')end;
   11,13:if RC=40 then begin RL(135);Explode(3);play(1,9999,0);play(9999,1,0);
          walls(10);Explode(5);TFlag:=4;Inv:=[1,6,12,17,20,26,28,29];move(78);
          T[3]:=120;T[4]:=120;T[5]:=120;PStat:=[];MugCon:=79;bak(0,0)end;
   end; {Vb}

16:case Vb of  { Gravel Road }
   2,11:begin RL(108);move(20)end;
   3:begin RC:=1;move(17)end;
   4:move(13);
   28,31:if N1=81 then RL(109);
   end; {Vb}

17:case Vb of  { Gravel Road (endless) }
   3:begin Zap;RC:=RC+1;if(RC=80)and(Inv<>[])then
       begin move(17);RS(17);Inv:=[];end
      else move(17)end;
   4:begin Zap;RC:=RC-1;if RC<1 then move(16)else move(17)end;
   end; {Vb}

18:case Vb of  { Paved Road }
   1:move(13);
   2:begin RC:=1;move(19);end;
   4,11:move(21);
   end; {Vb}

19:case Vb of  { Paved Road (endless) }
   1:begin Zap;RC:=RC-1;if RC<1then move(18)else move(19)end;
   2:if RC=60 then RS(18) else begin Zap;RC:=RC+1;move(19)end;
   end; {Vb}

20:case Vb of  { General Store }
   1,13:move(16);
   28:if N1=132 then RL(88);
   20,26,76:if(N1 in[86,87])and(5 in L[20])then
       begin RS(14);R[5]:=20;Score(15,20)end;
   39:if(5 in NounSet)or(30 in NounSet)then Score(15,20);
   end; {Vb}

21:case Vb of  { Gravel Lot }
   3,13:move(18);
   1,4..8:RL(27);
   2,9,51:if N1 in[Null,62,71] then begin RL(234);move(22)end;
   28,31:if n1=81 then begin Score(5,71);RB(1,7);Pause;end;
   end; {Vb}

22:case Vb of  { Top of Ship (Barre-An) }
   1:begin RL(235);move(21)end;
   10,11,51:if(n1 in[null,62,64,71])then
        if en(23) then begin RL(236);move(2);Score(15,72)end else RL(99);
   24,28,31:case N1 of
       56:if en(23) then RL(163)else RL(99);81:begin RB(1,7);Pause;end end;
   50:if N1=78 then
       if en(22)then begin RL(94);Min(22)end else begin RL(95);Add(22)end;
   41:if N1=56 then
       if en(22) then begin RL(96);Add(23);Score(5,73)end else RL(97);
   53:if N1=56 then
       if en(23) then begin RL(98);Min(23)end else say('hatch','closed');
   59:if(N1 in[49,122])or(VStr='jump off')then move(21);
   end; {Vb}

 end {main case}
end; { Room5 }
{----------}
procedure Room6;   { Jungle Planet }
begin
case Prm of
23:case Vb of  { Deep Pit }
    1..13,51:RL(217);
    28,31:case N1 of  73:RL(218); 81,116:RS(80) end;
    75:if N1=73 then move(34);
   end;

24:case Vb of { Top of Ship (Jungle planet) }
   3:begin RL(235);move(25)end;
   10,11,51:if(n1 in[null,62,64,71])then
        if en(23) then begin Score(5,74);RL(236);move(2)end else RL(99);
   24,28:if N1=56 then if en(23) then RL(163)else RL(99);
   50:if N1=78 then
       if en(22)then begin RL(94);Min(22)end else begin RL(95);Add(22)end;
   41:if N1=56 then
       if en(22) then begin RL(96);Add(23)end else RL(97);
   53:if N1=56 then
       if en(23) then begin RL(98);Min(23)end else say('hatch','closed');
   59:if(N1 in[49,122])or(VStr='jump off')then move(25);
   end; {Vb}

25:case Vb of { Sandy Clearing }
   4,9,51:if N1 in[Null,62,71] then begin RL(234);move(24)end;
   1:begin move(26);Score(5,75)end;
   2,3,5..8:RL(200);
   end; {Vb}

26:case Vb of { Winding Path 1 }
   2:move(25);
   5:begin RS(65);DEAD;end;
   59:if N1=66 then
       if VStr='jump in' then begin RL(288);DEAD;end
       else begin RS(66);move(27);Score(25,76)end;
   1,3,4,7,8:RL(200);
   9,51:if N1=112 then RL(204);
   28:if N1=66 then RS(85);
   35,62:if N1=66 then begin RL(288);DEAD;end;
   75,76:if N1=66 then RL(285);
   83:if N1=66 then RL(286);
   84:if N1=66 then begin RL(287);DEAD;end;
   end;

27:case Vb of { Winding Path 2 }
   6:move(28);
   8,11:begin RS(65);DEAD;end;
   1..5,7:RL(200);
   9,51:if N1=112 then RL(204);
   59:if N1=66 then
       if VStr='jump in' then begin RL(288);DEAD;end
       else begin RS(66);move(26)end;
   28:if N1=66 then RS(85);
   35,62:if N1=66 then begin RL(288);DEAD;end;
   75,76:if N1=66 then RL(285);
   83:if N1=66 then RL(286);
   84:if N1=66 then begin RL(287);DEAD;end;
   end;

28:case Vb of { Winding Path 3 }
   7:move(27);
   6:move(29);
   8:begin RS(67);DEAD;end;
   1..5:RL(200);
   9,51:if N1=112 then RL(204);
   28:if N1=112 then RS(86);
   24:if N1=112 then RL(553);
   end;

29:case Vb of { Winding Path 4 }
   7:move(28);
   5:if en(29) then move(32) else
      begin col(10,7);RS(72);col(11,7);T[12]:=146;Add(29);move(32)end;
   9,51:if N1 in[Null,112] then begin RL(201);move(30)end;
   6:begin RS(69);Prm:=31;T[11]:=4;end;
   8:if en(35)or en(130)then begin RC:=1;move(59);Score(20,77)end;
   1..4:RL(200);
   28:case N1 of 112:RL(238);120:RL(544);
       113:if Md=1 then begin RL(314);Add(130)end end;
   59:if N1=120 then begin RL(541);Prm:=31;T[11]:=4;end;
   end;

 end {main case}
end; { Room6 }
{----------}
procedure Room7;   { Jungle Planet }
begin
case Prm of
30:case Vb of { Top of Tree }
   9:RL(202);
   10,51:if N1 in[Null,112] then begin RL(203);move(29)end;
   1..8:RL(200);
   20..28:if N1=68 then RS(79);
   18,17:RL(603);
   end;

31:case Vb of { Quicksand Pit }
   1..8:RL(206);
   9,51:if N1=112 then RL(204);
   39,42,76:if N1=47 then
     if en(78)then RL(549)else begin T[11]:=0;RS(71);Prm:=29;Score(25,78)end;
   28:case N1 of 47:RL(239); 120:RL(240);end
   end;

32:case Vb of { Winding Path 5 }
   1:move(33);
   8:begin move(29);if en(35) and not en(40) then begin RL(314);Add(40)end end;
   2..7:RL(200);
   9,51:if N1=112 then RL(204);
   end;

33:case Vb of { Winding Path 6 }
   2:move(32);
   6:if not en(28)then begin RS(68);Add(28);move(34)end else move(34);
   1,3..5,7,8:RL(200);
   9,51:if N1=112 then RL(204);
   end;

34:case Vb of { Front of Pyramid }
   7:move(33);
   41..44,54,75,88:if N1=56 then RL(220) else
      if N1=126 then
       if HingeCon<>Null then
        begin writeln('The hinged mouth opens, revealing a ',FN(HingeCon),
                      ' inside.');Add(31);R[HingeCon]:=34;Score(25,79)end
       else begin RL(226);Add(31)end;
    53:if N1=56 then RL(220) else
       if N1=126 then
        begin RL(227);if HingeCon<>Null then R[HingeCon]:=Null;Min(31)end;
   1,11:if en(30) then begin Score(25,80);move(35)end else RL(219);
   39:if(PyraCon in NounSet)or((30 in Nounset)and(PyraCon=9))then
       begin RL(225);Min(30);SFlag:=false;end else
      if HingeCon in NounSet then begin RL(228);SFlag:=false;end;
   2..6,8:RL(200);
   9,51:if N1=112 then RL(204);
   92:if N1 in[Null,49,122] then begin RL(216);move(23) end;
   31:if N1 in[81,89,119] then begin RB(8,7);Pause;end;
   28,24:case N1 of 68:RS(87); 89:RS(88); 81,119:begin RB(8,7);Pause;end;
          64:if PyraCon=Null then RL(241)else
              writeln('The small slot contains a ',FN(PyraCon),'.');
          56:if en(30) then RL(244)else RL(245);
          126:if en(31)then
               if HingeCon=Null then RL(242)else
               writeln('The open mouth contains a ',FN(HingeCon),'.')
              else RL(243);
         end;
   end;

 end {main case}
end; { Room7 }
{----------}
procedure Room8;   { Inside Pyramid (Top Level) }
begin
case Prm of
35:case Vb of  { Vestibule }
   2,13:move(34);
   10,11,51:if N1 in[Null,71] then
     if en(32) then move(36) else begin RS(84);Add(32);move(36)end;
   28:if N1=56 then if en(30) then RL(244)else RL(245);
   end;

36:case Vb of  { Descending Stairs }
   10,11,51:if N1 in[Null,71] then move(37);
   9,13:move(35);
   end;

37:case Vb of  { Halcyon Hall }
   1:if T[16]>1 then begin RL(278);DEAD;end else move(39);
   3:move(38);
   10,51:if N1 in[Null,71] then move(42);
   9,13:move(36);
   end;

38:case Vb of  { Departure Room }
   4,13:move(37);
   28:case N1 of
       73:if 10 in L[38] then begin RL(253);RL(252)end else RL(253);
       10:if 10 in L[38] then RL(254);
       30:if 17 in L[38] then begin SF;writeln('It''s a grey disk!')end
      end;
   26:if(N1=10)and(10 in L[38])then RL(255);
   42,44:if N1 in[10,73] then RL(256);
   75:if N1=73 then RL(257);
   47,83,84:RL(258);
   39:if(10 in L[38])and(10 in NounSet)then
       begin L[38]:=L[38]+[17];RL(259);Score(15,81);SFlag:=false;end
      else if(30 in NounSet)and(17 in L[38])then R[17]:=38;
   end;

 end {main case}
end; { Room8 }
{----------}
procedure Room9;   { Inside Pyramid (Top Level) }
begin
case Prm of
39:case Vb of  { Holey Hall }
   2,13:if T[15]>1 then begin RL(269);move(37);Score(5,82)end else move(37);
   4,11:if T[15]>1 then begin RS(95);DEAD;end else move(40);
   end;

40:case Vb of  { Pyramid Lobby }
   1,11:if T[14]>1 then
         begin n[68]:='podium\alter\column\';WRITE('');move(41)end;
   3,13:if(18 in Inv)or(4 in Inv)then begin Brief:=Brief-[39];move(39);
          T[15]:=3;T[16]:=9;col(10,7);RS(93);
          for i:=500 to 5500 do sound(random(i)+random(i));
          for j:=1 to 7000 do sound(random(i)+random(i));
          for j:=i downto 500 do sound(random(j)+random(j));nosound;
         end
        else move(39);
   42,44,51,75,84,94:
     if N1=68 then
      if T[14]>1 then RL(246) else
       if en(33) then begin T[14]:=7;RL(261);Walls(8);end
       else begin T[14]:=7;Score(20,33);RS(89);Walls(8);end;
   28:case N1 of 56:if T[14]>1 then RL(370)else RL(92);68:RL(247)end;
   end;

41:case Vb of  { Treasure's Keeper }
   2,13:if T[14]>1 then begin n[68]:='pyramid\podium\';WRITE('');move(40)end
        else RL(248);
   28,22:case N1 of
          56:if T[14]>1 then RL(370)else RL(92);
          68:if PodumCon=Null then RL(264) else
             writeln('There is a ',FN(PodumCon),' on the podium.');
          18:if(18 in L[41])and not en(34)then RS(90);
         end;
   33:if N2=68 then
       if Pr=1 then
        if N1 in Mov then
         if PodumCon=Null then
          begin Van(N1);R[N1]:=41;PodumCon:=N1;RL(266)end
         else RL(268)
       else crazy;
   75:if N1=68 then RL(276);
   50:if N1=68 then begin RL(277);Walls(8);T[14]:=7;end;
   39:if(30 in NounSet)and(18 in L[41])then R[18]:=41;
   end;

 end {main case}
end; { Room9 }
{----------}
procedure Room10;   { Pyramid Maze }
begin
case Prm of
42:case Vb of  { Ladder Room }
   1..13:if Maze then case Vb of 9,13:move(37);6:move(43);3,8:move(42)end
         else case Vb of 9,13:move(37)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

43:case Vb of  { Shifting Room NW }
   1..8:if Maze then case Vb of 7:move(42)end
        else case Vb of 2:move(44);8:move(45)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

44:case Vb of  { Shifting Room W }
   1..8:if Maze then case Vb of 7:move(47);2:move(45)end
        else case Vb of 1:move(43);5:move(44)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

45:case Vb of  { Shifting Room SW }
   1..8:if Maze then case Vb of 1,3:move(45)end
        else case Vb of 1:move(45);6:move(43)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

46:case Vb of  { Shifting Room N }
   1..8:if Maze then
         case Vb of 1:begin RS(98);DEAD;end;
          7:begin Score(50,84);move(50)end end
        else
         case Vb of 1:begin RS(98);DEAD;end;
          7:begin Score(50,84);move(50)end;3:move(48);8:move(45)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

47:case Vb of  { Shifting Room S }
   1..8:if Maze then case Vb of 6:move(44)end
        else case Vb of 3:move(49);1:move(47);4:move(45)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

48:case Vb of  { Shifting Room NE }
   1..8:if Maze then case Vb of 7:move(49);3,4:move(48)end
        else case Vb of 4:move(46);1,2:move(48)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

49:case Vb of  { Shifting Room SE }
   1..8:if Maze then case Vb of 5:move(48)end
        else case Vb of 4:move(47);2:move(45)end;
   41..44,50,55:if N1=116 then RL(325);
   28:if N1=116 then RL(547);
   end;

50:case Vb of  { Stairway Room E }
   6:move(46);
   4,10,13,51:move(51);
   41..44,50,55:if N1=116 then RL(325);
   end;

 end {main case}
end; { Room10 }
{----------}
procedure Room11;   { Inside Pyramid (Bottom Level) }
begin
case Prm of
51:case Vb of  { Lower Stairway }
   3,9,13,51:move(50);
   1:move(52);
   end;

52:case Vb of  { Misty Passage }
   2:if T[19]>1 then begin RS(129);DEAD;end else move(51);
   4:if en(35)then begin RL(305);DEAD;end else move(53);
   33:if(N1=11)and(11 in Inv)then
       if Pr in[1,5,7,10] then
        if N2 in[34,49,64] then
         if T[19]>0 then
          begin Score(40,39);Van(11);L[52]:=L[52]+[11];T[19]:=0;RS(127)end
         else begin Van(N1);R[N1]:=52;RL(586)end;
   39:if(11 in NounSet)and en(39)then RL(307);
   28:case N1 of 11:RL(312); 64:RL(313) end;
   42,44,55:case N1 of 11:RL(307); 34:RL(308); end;

   end;

53:case Vb of  { Damp Passage }
   2:begin move(54);if en(35)then begin RS(122);DEAD;end end;
   3:if T[18]>1 then begin RL(305);DEAD;end else move(52);
   59:if N1=66 then
       begin RS(125);Brief:=Brief-[52];move(52);T[18]:=0;T[19]:=3;
        col(10,7);RL(306);Walls(12);Score(20,85)end;
   end;

54:case Vb of  { Dark Passage }
   1:move(53);
   2:move(55);
   end;

55:case Vb of  { Circular Chamber }
   1:begin Brief:=Brief-[54];move(54);
      if en(35)then
       if Crawl=true then
        begin col(10,7);RS(119);RS(120);Pause;L[53]:=L[53]+[66];Score(20,86);
         Brief:=Brief-[53];move(53);col(10,7);RS(121);Walls(12);T[18]:=4;end
       else begin col(10,7);RS(118);DEAD;end end;
   2:if Md=1 then RS(230)else
      if random(2)=1 then begin Prm:=58;RL(563)end else begin RS(100);DEAD;end;
   3:begin move(56);if 11 in Inv then begin RS(102);DEAD;end end;
   4:if Md=1 then RS(231)else begin RS(99);DEAD;end;
   39:if(11 in NounSet)then begin RS(101);SFlag:=false;end
      else if(30 in Nounset)and(11 in L[55])then R[11]:=55;
   end;

 end {main case}
end; { Room11 }
{----------}
procedure Room12;   { Inside Pyramid (Bottom Level) }
begin
case Prm of
56:case Vb of  { The Erusaert }
   2,11:if en(36) then begin Score(5,88);move(57)end;
   4,13:if T[17]>4 then begin RS(108);DEAD;end else move(55);
   22,28:case N1 of
         1:if not en(35) then RL(292);
         34:if 1 in L[56]then RL(291)
            else if not en(35)then begin RS(103);L[56]:=L[56]+[1]end;
         49:RS(105);
         56:RL(370);
         66:RL(295);
         68:RS(104);
         110:RL(293);
         end;
   26:if N1 in[49,68] then RL(295);
   39:if 1 in NounSet then
       begin
        if not en(35)then RL(300) else
        if T[17]>4 then
         begin RS(113);T[17]:=3;Van(1);Inv:=Inv+[1];Score(50,87)end
       end
      else if(30 in NounSet)then RL(578);
   37:if not(1 in NounSet)and(not en(35))then RL(300);
   35,51,62:if N1=68 then begin RS(106);DEAD;end;
   59:begin RS(107);DEAD;end;
   41,88:if N1 in[68,110] then
          if N2=4 then
           if not en(35)then
            if here(16)and en(37)then
             begin RS(117);T[17]:=6;L[56]:=L[56]+[1,56];Add(35);Min(37)end
            else begin RS(111);DEAD;end
           else RL(273)
          else RL(296);
   33:if N1=16 then
       begin
        if Pr in[1,10] then
         if N2 in[49,1] then
          begin Van(16);Add(37);R[16]:=56;
           if not en(35)then
            if Pr=1 then RL(297)else RL(298)
           else RL(297)
          end
         else
          if(N2=34)and(Pr=10)then
           begin writeln('Done.');Van(16);SF;R[16]:=56;end
          else if N2=68 then RL(299)
       end
      else
       if N2 in[68,110] then
        if Pr=1 then RL(299) else
        if Pr=5 then
         if N1=4 then
          if not en(35)then
           if here(16)and en(37)then
            begin RS(117);T[17]:=6;L[56]:=L[56]+[1];Add(35);Min(37)end
           else begin RS(111);DEAD;end
          else RL(273)
         else RL(296);
   54,75,76:case N1 of
            1:if 1 in L[56] then RL(300);
            34:RL(304);
            end;
   end; {Vb}

 end {main case}
end; { Room12 }
{----------}
procedure Room13;   { Inside Pyramid (Bottom Level) }
var x:integer;
begin
case Prm of
57:case Vb of  { Solar Chamber }
   1,13:move(56);
   28:case N1 of 56:RL(370);72,82,116:RS(149);109:RS(150)end;
   44,75:if N1=103 then begin Prm:=58;RS(233);Walls(5);Static end;
   end; {Vb}

58:case Vb of  { Eternal Trap }
   9,13,51:RL(554);
   92:RL(555)
   end;

59:case Vb of  { Overgrown Path }
   5:begin RC:=RC-1;if RC<1 then begin RL(309);move(29)end else RL(310)end;
   8:begin RC:=RC+1;if RC>7 then begin RL(309);move(60)end else RL(310)end;
   2..4,6..7:RL(200);
   9,51:if N1=112 then RL(204);
   end;

60:case Vb of  { Antenna Building (Outside) }
   4,11:begin Door(61,25);
         if not en(43)then begin RS(137);Score(10,43)end end;
   5:move(59);
   1..3,6..8:RL(200);
   28:case N1 of 96:RL(323);115:RL(324)end;
   41..44,54,75,88:if N1=56 then RL(315);
   9,51:if N1=112 then RL(204)else RL(316);
   end;

61:case Vb of  { Monitor Outpost }
   3,13:Door(60,25);
   2,11:move(62);
   28,24,31:case N1 of 37,59:RS(133);38,44:RL(322);93:RL(319);
             94:RS(134)end;
   42,44,75:if N1 in[37,38,44] then RL(318);
   end;

62:case Vb of  { Booth (Jungle Planet) }
   1,13:move(61);
   42,44,75:
     case N1 of
      37,38:RL(318);
      44:begin RS(138);
          for y:=60 downto 1 do for x:=800 downto 1 do sound(x*y);
          nosound;TFlag:=3;Brief:=Brief-[70];Score(10,89);
          for x:=1 to MMax do if R[x]=62 then R[x]:=70;move(70)
         end
     end;
   28,24,31:case N1 of 37,59:RS(133);38:RL(322);93:RL(319);
             94:RS(134);44:RL(320);end;
   end; {Vb}

63:case Vb of  { Booth (Ringed Planet) }
   1,13:RL(328);
   42,44,75:case N1 of
            37,38:RL(318);
            44:begin RS(138);
                for y:=60 downto 1 do for x:=800 downto 1 do sound(x*y);
                nosound;TFlag:=3;Brief:=Brief-[70];
                for x:=1 to MMax do if R[x]=63 then R[x]:=70;move(70)
               end
            end;
   28,24,31:case N1 of 37,59:RS(133);38:RL(322);93:RL(319);
             94:RS(134);44:RL(320);end;
   39:if(30 in NounSet)and(20 in L[63])then R[20]:=63;
   end; {Vb}

 end {main case}
end; { Room13 }
{----------}
procedure Room14;   { Inner Planet }
begin
case Prm of
64:case Vb of  { Lobby }
   1,13:begin DOpen(99);RS(139);DEAD;end;
   2,11:move(65);
   28:case N1 of 35:RL(330);49,122:RL(334);72,116:begin Score(5,90);RS(148)end;
       81:RB(5,11);86:RL(333);127:RL(351)end;
   31:if N1=81 then RB(5,11);
   20,24:if N1=127 then RS(142);
   54:if N1=127 then if Md=3 then begin RL(537);DEAD;end else RL(538);
   end;

65:case Vb of  { North Corridor }
   1:move(64);
   2:move(66);
   4:Door(68,20);
   28:if N1=56 then RL(92);
   end;

66:case Vb of  { Central Corridor }
   1:move(65);
   2:move(67);
   3:if T[20]>1 then begin Score(15,91);move(73)end else RL(92);
   4:move(72);
   28:case N1 of 56:if T[20]>1 then RL(370)else RL(92);64:RL(335)end;
   33:if N2=64 then
       if Pr=5 then
        if N1=12 then
         begin RL(336);T[20]:=3;DOpen(20);Score(5,92)end
        else RL(137);
   end; {Vb}

67:case Vb of  { South Corridor }
   1:move(66);
   2,11:Door(75,5);
   4:move(71);
   end;

71:case Vb of  { Monitor Station }
   3:move(67);
   28:case N1 of 59:if CodeSet=4 then RL(353)else RL(355);116:RL(354)end;
   31:if N1=59 then
       if CodeSet=4 then begin RB2(11,14);Pause;end else RL(355);
   end;

72:case Vb of  { Reactor Control }
   3:move(66);
   28,24:case N1 of 128:RL(560);
       37,38:RL(339);46:if Md<>Null then begin Score(5,93);RL(343)end
              else RS(145);
       55:if en(46)then
           if RobotCon<>Null then
            writeln('The robot''s panel contains a ',FN(RobotCon),'.')
           else RL(346)
          else RL(344);
      end;
   33:if N2=55 then
       if Pr=5 then
        if en(46)then
         if RobotCon=Null then
          if N1 in[3,4,8,12,17]then
           begin Van(N1);RL(347);R[N1]:=72;RobotCon:=N1;end
          else RL(137)
         else RL(348)
        else RL(344);
   41:if N1 in[55,46] then
       if RobotCon=Null then RL(558)else
        begin R[RobotCon]:=72;Add(46);Score(25,94);
         writeln('The panel slides open, revealing a ',FN(RobotCon),' inside.')
        end;
   53:if N1=55 then begin Van(RobotCon);Min(46);RL(344)end;
   42,44:case N1 of
          37,38,44:begin RL(340);Walls(9);gotoxy(43,wherey-1);col(28,31);
                    writeln('BOOM!');Explode(32);DEAD;end;
          46:if(VStr='turn on')or(VStr='activat')or
               (VStr='turn off')then RL(341)
             else if(not en(94))and(not en(93))then begin RL(342);RL(559)end
                  else RL(342)
         end;
   end; {Vb}

 end {main case}
end; { Room14 }
{----------}
procedure Room15;   { Inner Planet }
var y,x:integer;
begin
case Prm of
68:case Vb of  { Decontamination }
   3,13:if en(45)then Door(65,20) else RL(331);
   4,11:Door(69,20);
   28,24:case N1 of 131:RL(329);end;
   42,44,75:if N1=44 then begin RL(332);Add(45);play(20,99,7);play(99,99,600);
      play(99,20,7);Score(10,95)end;
   end;

69:case Vb of  { Waiting Room }
   2,11:Door(70,50);
   3,13:Door(68,20);
   28,24:case N1 of 35:RL(330);131:RL(329);end;
   end;

70:case Vb of  { Transporter Booth }
   1,13:Door(69,50);
   28,24:case N1 of 44:RS(140);93:RL(319);94:RS(141);end;
   42,44,75:
     if N1 in[40..43]then
      begin Brief:=Brief-[62,63,78];RS(138);Min(45);
       for y:=60 downto 1 do for x:=800 downto 1 do sound(x*y);nosound;
        case N1 of
         40:begin for x:=1 to MMax do if R[x]=70 then R[x]:=78;
             TFlag:=4;move(78);Score(15,97)end;
         41:begin for x:=1 to MMax do if R[x]=70 then R[x]:=62;
             TFlag:=2;move(62)end;
         43:begin for x:=1 to MMax do if R[x]=70 then R[x]:=63;
             TFlag:=2;move(63);Score(10,96)end
        end;
      end;
   end; {Vb}

{ 71 and 72 are in Room14 }

 end {main case}
end; { Room15 }
{----------}
procedure Room16;   { Inner Planet }
begin
case Prm of
73:case Vb of  { Communications }
   1:move(74);
   4:Door(66,20);
   28:case N1 of
       48:begin RL(366);writeln('The dial is set at number ',CodeSet,'.')end;
       115:RL(350);121:RL(367);127:RL(351)
      end;
   50:if N1=48 then
       if Pr>Null then
        if(code>0)and(code<11)then
         begin RL(363);CodeSet:=Code;if Code=4 then Score(10,98)end
        else RL(362)
       else RL(365);
   end; {Vb}

74:case Vb of  { Computer Station }
   2:move(73);
   28:case N1 of 37:RL(349);38:RL(322);52:RL(37);
       59:begin RB2(7,10);col(26,23);RL(364);Score(5,47)end end;
   31:if N1=59 then begin RB2(7,10);col(26,23);RL(364);Add(47)end;
   end;

75:case Vb of  { Elevator  1st Floor }
   1:Door(67,5);
   42,44,75:begin RS(143);play(20,42,20);sound(42);delay(5500);RL(338);
   play(42,20,20);Prm:=76;for x:=1 to MMax do if R[x]=75 then R[x]:=76;end;
   end;

76:case Vb of  { Elevator  2nd  Floor }
   1:begin Score(5,99);Door(77,5)end;
   42,44,75:begin RS(144);play(20,42,20);sound(42);delay(5500);RL(338);
             play(42,20,20);Prm:=75;for x:=1 to MMax do if R[x]=76 then R[x]:=75;end;
   end;

77:case Vb of  { Observatory }
   2:Door(76,5);
   28:case N1 of 34:RL(562);104:if Nstr='eyepiec' then RL(561)else RS(146)end;
   24:if N1=104 then
       if 20 in Wear then begin Score(5,100);RS(147)end
       else begin RL(368);RL(369)end;
   end;

 end {main case}
end; { Room16 }
{----------}
procedure Room17;   { Planetship }
begin
case Prm of
78:case Vb of  { Icy Platform }
   3,11:door(79,25);
   28:case N1 of
       54:RL(379);93:RL(380);96:RL(381);103:RL(500);115:RL(350);118:RL(382)
      end;
   59:if N1=54 then begin RL(400);DEAD;end;
   end;

79:case Vb of  { Confirmation Port }
   4,13:door(78,25);
   28:case N1 of 44:RL(383);64:RL(384);116:RL(600)end;
   44,75:if N1=44 then begin RS(156);Score(10,50);
          play(20,99,7);play(99,99,600);play(99,20,7)end;
   33:if N2=64 then
       if Pr=5 then
        if N1=17 then
         begin Explode(1);sound(50);RS(151);
          for i:=9000 downto 1 do
           for j:=1 to 4 do sound(random(i div 2 + 400)+i);nosound;
          Van(17);L[80]:=L[80]+[17];move(80);Add(7);T[22]:=3;T[26]:=91;
          delay(900);sound(70);RL(399);delay(999);nosound;Score(25,101);
          n[40]:='sockets\socket\';
          n[82]:='laser beam\laser\beam\';
          n[110]:='speaker\';
         end
        else RL(137);
   end;

80:case Vb of  { Inspection Lobby }
   4,13:door(81,65);
   9:RL(523);
   28:case N1 of 55:RL(385);86:if 17 in L[80]then RL(395);72,116:RS(148)end;
   41..44,88,53:if N1=55 then RL(405);
   end;

 end {main case}
end; { Room17 }
{----------}
procedure Room18;   { Planetship }
begin
case Prm of
81:case Vb of  { Circular Corridor }
   2:move(82);
   3,11:door(80,65);
   6:move(88);
   28:case N1 of 72:RL(386)end;
   end;

82:case Vb of  { Circular Corridor }
   1:move(81);
   3:door(96,50);
   4:door(93,5);
   8:move(83);
   28:case N1 of 72,103:RL(387)end;
   end;

83:case Vb of  { Circular Corridor }
   2,11:door(95,25);
   4:move(84);
   5:move(82);
   28:case N1 of 72,115:RL(388)end;
   end;

93:case Vb of  { Central Elevator }
   3,11,13:case Floor of
      1:door(82,5);
      2..5,30..40,89..95,170..230,333..444,543..600,793..812:RL(413);
      480:if en(64)then
           begin door(98,5);delay(999);RS(217);Score(20,102);
            for x:=1 to 7 do begin i:=random(7000)+1500;j:=random(600)+400;
             play(i,i,j)end;
            RL(516)end
           else RL(413)
      else begin door(97,5);Score(5,103)end
     end;
   28:if N1 in[44,52] then RS(188);
   56:begin val(input,i,testc);
       if testc=0 then
        if(i>0)and(i<837)then
         if i<>Floor then
          begin j:=i;i:=abs(floor-i);Floor:=j;RL(411);play(20,36,35);
           sound(37);for x:=1 to 200 do delay(i div 4);
           RL(412);play(36,20,35);
          end
         else RL(410)
        else RL(410)
       else crazy
      end
   end;

95:case Vb of  { Transmission Room }
   1,13:door(83,25);
   28:if N1 in[38,121]then RS(191);
   42,44,75:if N1=44 then begin Score(5,104);RL(404);play(1200,1200,99);
     if en(48)then Min(48)else Add(48)end;
   end;

96:case Vb of  { Station Control }
   4,13:door(82,50);
   28:case N1 of 38:RS(192);59:begin Score(5,105);RB2(11,5);Pause;end end;
   31:if N1=59 then begin Score(5,105);RB2(11,5);Pause;end;
   end;

 end {main case}
end; { Room18 }
{----------}
procedure Room19;   { Planetship }
begin
case Prm of
84:case Vb of  { Circular Corridor }
   2,11:door(94,65);
   3:move(83);
   6:move(85);
   28:case N1 of 72,46:RL(389)end;
   end;

85:case Vb of  { Circular Corridor }
   1:move(86);
   4,11:door(92,65);
   7:move(84);
   28:case N1 of 72:RL(390)end;
   end;

86:case Vb of  { Circular Corridor }
   2:move(85);
   4,11:if T[21]>1 then begin Score(15,107);move(91);
      if en(52)then T[23]:=2;end else RL(92);
   5:move(87);
   28:case N1 of 56:if T[21]>1 then RL(370);64:RL(335);72,69:RL(391)end;
   33:if N2=64 then
       if Pr=5 then
        if N1=12 then
         begin RL(336);T[21]:=3;DOpen(15);Score(5,106)end
        else RL(137);
   end;

87:case Vb of  { Circular Corridor }
   1,11:door(89,65);
   3:move(88);
   8:move(86);
   28:case N1 of 72:RL(392)end;
   end;

88:case Vb of  { Circular Corridor }
   1,11:door(90,65);
   4:move(87);
   7:move(81);
   28:case N1 of 72:RL(392)end;
   end;

89:case Vb of  { Reactors West }
   2,13:door(87,65);
   3:move(90);
   28:case N1 of 38:RL(414);59:RL(401);128:RS(189)end;
   31:if N1=59 then
       case ScrnSet of
        1:RB2(8,6);   { Orange Crystal }
        2:RB2(10,10); { Green Crystal  }
        3:RB2(12,14); { Yellow Crystal }
        4:begin RB2(14,9);  { Blue Crystal (Cracked) }
           x:=wherex;y:=wherey;gotoxy(40,14);col(25,23);write('LACITIRC');
           gotoxy(x,y);Score(20,108)
          end;
       end;
    44,75:if N1=44 then
           begin RL(402);ScrnSet:=ScrnSet+1;if ScrnSet>4 then ScrnSet:=1;
            for x:=1 to 30 do
             begin i:=random(7000)+999;play(i,i,50);delay(random(15)+5)end
           end else
          if N1 in[38,128]then RL(403);
     42:if N1 in[38,128]then RL(403);
   end;

 end {main case}
end; { Room19 }
{----------}
procedure Room20;   { Planetship }
begin
case Prm of
90:case Vb of  { Reactors East }
   2,13:door(88,65);
   4:move(89);
   28:case N1 of 38:RL(393);59:RL(402);128:RS(190)end;
   31:if N1=59 then begin Score(5,109);RB2(9,random(14)+1)end;
   42,44,75:if N1 in[38,128]then RL(403);
   end;

91:case Vb of  { Emergency Override }
   3,13:begin if T[25]>2 then
      begin Col(10,7);RL(424);T[25]:=Null;T[24]:=Null;T[26]:=14;Add(52)end;
      door(86,15);
      if(T[24]>0)and not en(64)then begin T[24]:=Null;T[26]:=14;Add(52)end
     end;
   4,11:RL(92);
   28:case N1 of 37,38,51:RL(393);44:RL(469);59:RL(468);64:RL(335);
       69:if en(51)then RL(426)else if Md=1 then RL(467)else RS(182);
      end;
   31:if N1=59 then RL(468);
   24:if N1=69 then if en(51)then crazy else RL(427);
   75:if N1=69 then if en(51)then crazy else RL(428);
   54:case N1 of
       69:if en(51)then RL(426)else
          if N2 in[0,60]then RL(601)else
          if not(N2 in[10,18,29])then RL(602)else
           begin RS(160);L[91]:=L[91]+[123];L[91]:=L[91]-[44,129];T[23]:=15;
            Add(51)end;
      end;
   42,44:if(N1=69)and not en(51)then RL(470)else
         if N1=44 then begin RL(471);play(20,440,1);play(440,440,500);
          play(440,20,1);end;
   41,88:if N1=69 then if en(51)then crazy else RL(467);
   39:if N1=95 then RL(442);
   49:if N2=123 then
       if Pr=1 then
        if N1=1 then
         if(T[24]>1)and(T[24]<6)then
          begin T[24]:=Null;T[25]:=7;RS(181)end
         else RL(429)
        else RL(425);
   33:if N2=64 then
       if Pr=5 then
        if N1=12 then RL(577);
   end;

92:case Vb of  { Climate Control }
   3,13:door(85,65);
   28,31:case N1 of 59:RS(152);end;
   end;

 end {main case}
end; { Room20 }
{----------}
procedure Room21;   { Planetship }
begin
case Prm of
94:case Vb of  { Maintenance }
   1,13:door(84,65);
   28:case N1 of
       51:RL(489);
       87:begin RL(490);Score(15,110);
           if not en(49)then
            begin Score(10,49);RL(396);L[94]:=L[94]+[26];end
           else if 26 in L[94] then RL(397);
          end;
      end; {case}
   39:begin
       if(30 in NounSet)then
        begin if 2 in L[94] then R[2]:=94;if 26 in L[94] then R[26]:=94;end;
       if(51 in NounSet)then
        begin RL(491);NounSet:=NounSet-[51];
         if not(NounSet=[])then SFlag:=false end
      end;
   end;

97:case Vb of  { Cryogenic Chamber }
   4,11,13:door(93,5);
   28:if N1=69 then RS(193);
   18:begin RS(194);Van(N1)end;
   end;

98:case Vb of  { Identity Booth }
   2,11:begin door(99,0);
      if T[27]>1 then begin Col(10,7);RS(208);delay(999);Blast;DEAD end
      else begin T[27]:=2000;Col(10,7);RL(504);play(22,22,999);RS(210);
            delay(999);Blast;RL(505)end
     end;
   4,13:door(93,5);
   28,31:case N1 of 81,119:if NStr='message' then RL(517)else RB2(13,13);
          59:RL(517)end;
   end;

99:case Vb of  { Security Tunnel #1 }
   1,13:door(98,0);
   2,11:begin Score(15,111);door(100,0)end;
   4:RL(506);
   41,88:if N1=55 then RL(509);
   28:case N1 of 46:RS(216);55:RL(510);88:RL(511)end;
   42,44,75:if N1=46 then begin RL(513);T[27]:=2000;Add(7)end;
   39:if 88 in NounSet then begin RL(513);T[27]:=2000;Add(7)end;
   end;

100:case Vb of  { Security Tunnel #2 }
    1,13:begin door(99,0);Col(10,7);RS(208);delay(999);Blast;DEAD end;
    2,11:begin door(101,0);
       if T[28]>1 then begin Col(10,7);RS(209);delay(999);Blast;DEAD end
       else begin T[28]:=2000;Col(10,7);RL(504);play(22,22,999);RS(211);
             delay(999);Blast;RS(212);PStat:=PStat+[4];T[29]:=14;end;
      end;
    41,88:if N1=55 then RL(512);
    end;

 end {main case}
end; { Room21 }
{----------}
procedure Room22;   { Planetship (Lower Level) }
begin
case Prm of
101:case Vb of  { Security Tunnel #3 }
    1,13:door(100,0);
    2,11:begin Region:=5;door(102,0);Score(20,112);
       if not(20 in Wear)then RL(492)end;
    41,88:if N1=55 then RL(509);
    28:case N1 of 46:RS(216);55:RL(510);88:RL(511)end;
    42,44,75:if N1=46 then begin RL(513);T[28]:=2000;Add(7)end;
    39:if 88 in NounSet then begin RL(513);T[28]:=2000;Add(7)end;
    end;

102:if(Vb in[1..14,16,20..31,33..44,48..64,73..76,83..85,88..94])and
      not(20 in Wear)then RL(491) else
    case Vb of  { North Catwalk }
    1,11,13:begin Region:=Null;Door(101,0);Col(10,7);RS(209);delay(999);
       Blast;DEAD end;
    7:move(103);
    8:move(105);
    24,25,28:case N1 of 34,49:RL(493);
      131:if NStr='catwalk' then RL(494)else begin RS(195);RS(196)end end;
    75,76:if N1=42 then RL(495);
    51,59:if N1 in[42,54,131]then begin RL(496);DEAD;end;
    end;

103:if(Vb in[1..14,16,20..31,33..44,48..64,73..76,83..85,88..94])and
      not(20 in Wear)then RL(491) else
    case Vb of  { East Catwalk }
    6:move(102);
    8:move(104);
    24,25,28:case N1 of 34,49:RL(493);
      131:if NStr='catwalk' then RL(494)else begin RS(195);RS(196)end end;
    75,76:if N1=42 then RL(495);
    51,59:if N1 in[42,54,131]then begin RL(496);DEAD;end;
    end;

104:if(Vb in[1..14,16,20..31,33..44,48..64,73..76,83..85,88..94])and
      not(20 in Wear)then RL(491) else
    case Vb of  { South Catwalk }
    2,13:begin Region:=Null;Door(106,5);Score(20,113)end;
    5:move(103);
    6:move(105);
    24,25,28:case N1 of 34,49:RL(493);
      131:if NStr='catwalk' then RL(494)else begin RS(195);RS(196)end end;
    75,76:if N1=42 then RL(495);
    51,59:if N1 in[42,54,131]then begin RL(496);DEAD;end;
    end;

105:if(Vb in[1..14,16,20..31,33..44,48..64,73..76,83..85,88..94])and
      not(20 in Wear)then RL(491) else
    case Vb of  { West Catwalk }
    5:move(102);
    7:move(104);
    24,25,28:case N1 of 34,49:RL(493);
      131:if NStr='catwalk' then RL(494)else begin RS(195);RS(196)end end;
    75,76:if N1=42 then RL(495);
    51,59:if N1 in[42,54,131]then begin RL(496);DEAD;end;
    end;

 end {main case}
end; { Room22 }
{----------}
procedure Room23;   { Planetship (Lower Level) }
 label JUMP;
begin
case Prm of
106:case Vb of  { Junction }
    1:begin Region:=5;Door(104,5);if not(20 in Wear)then RL(492)end;
    2:RL(328);
    3:door(108,5);
    4,11,13:door(107,20);
    41..44,88:if N1=56 then RL(532);
    end;

107:case Vb of  { Conference Room }
    3,13:door(106,20);
    39:if(30 in NounSet)and(19 in L[107])then R[19]:=107;
    end;

108:case Vb of  { Reactor Regulators }
    4,13:door(106,5);
    41:if N1=55 then
        if not en(65)then
         begin Add(65);L[108]:=L[108]+[40];Score(5,114);
          for x:=22 to 25 do R[x]:=108;RL(519);RL(520);
         end
        else RL(521);
    53:if en(65)then RL(522)else RL(523);
    28,24:case N1 of 55:if en(65)then goto JUMP else RL(523);
         40:JUMP:
           begin RL(525);
            for x:=1 to 25 do if x in Socket then
             if x=22 then writeln('  An ',FN(x),' is in one of the sockets.')
             else writeln('  A ',FN(x),' is in one of the sockets.')
           end;
          end;
    33:if(N2 in[40,55])and en(65)then
        begin i:=0;for x:=1 to 25 do if x in Socket then i:=i+1;
         if i<4 then
          if N1 in Inv then
           if N1 in[1,22..25]then
            begin
             writeln('The ',FN(N1),' fits perfectly in an open socket.');
             Van(N1);Socket:=Socket+[N1];R[N1]:=108;
             i:=0;for x:=1 to 25 do if x in Socket then i:=i+1;
             if(i>3)and(1 in Socket) and not(25 in Socket)then
              begin { ####  You have won the game!!!!!  #### }
               Col(10,7);delay(999);Static;Static;RS(221);Static;Static;
               delay(999);explode(1);sound(20);RS(222);delay(999);RS(223);
               Pause;bak(0,0);writeln;Score(55,115);
               Add(66);Prm:=109;PStat:=[];PlayerInput(Line);
               Col(10,15);for x:=224 to 229 do RS(x);
               writeln;writeln;Pause;writeln;
               WON;  {  <<<-----  END OF GAME !!! *************}
              end
            end
           else writeln('The ',FN(N1),' won''t fit in any of the sockets.')
          else writeln('First you must have the ',FN(N1),'.')
         else RL(526)
        end;
    end;

 end {main case}
end; { Room23 }
{----------}
{**************************** END OF ROOM ROUTINES **************************}

procedure Default0;
begin
case Vb of

{ N, S, E, W, etc. }
1..8:case Prm of
     14..19:RL(26);
     21:RL(27);
     42..50:RL(279)
     else
      if Prm>7 then writeln('There is not a path leading ',up(Dir[Vb]),'.')
      else writeln('There is not passage in that direction.')
     end;

{ LOOK }
30:begin Brief:=Brief-[Prm];Describe(Prm);
    if(Prm=56)and(T[17]>4)then begin RS(114);RS(115);Pause;end;
   end;

{ SAVE }
82:Save;

{ RESTORE }
87:Restore;

 end {main case}
end; { Default0 }
{----------}

procedure Default1;
begin
case Vb of

{ INVENTORY }
16:if not(Inv=[]) then
    begin
     writeln('You have in your possession...');
     for o:=1 to MMax do
      begin
       if o in Inv then
        begin
         if o=6 then write('  some ',FN(o)) else write('  a ',FN(o));
         if o in Wear then write('  (being worn)');
         case o of
           5:if SatchCon<>Null then write('  (contains something)');
           7:if HolstCon<>Null then write('  (contains something)');
          29:if MugCon<>Null then write('  (has something in it)');
         end;if o in Inv then writeln;
        end;
      end;
    end
   else RL(28);

{ DROP }
18:if not(30 in NounSet)then
    for o:=1 to NMax do
     if o in NounSet then
      if o in Inv then
        begin
         write(FN(o),':  ');
         if o in Wear then
          writeln('First you must remove the ',FN(o),'.')
         else begin writeln('Dropped.');Inv:=Inv-[o];r[o]:=Prm;end;
        end
      else writeln('You don''t have the ',FN(o),'.')
     else begin;end
   else
    begin Min(17); { DROP ALL }
     for o:=1 to MMax do
      if o in Inv then
       begin
        write(FN(o),':  ');Add(17);
        if o in wear then
         writeln('First you must remove the ',FN(o),'.')
        else begin writeln('Dropped.');Inv:=Inv-[o];r[o]:=Prm;end;
       end;
     if not en(17)then RL(303)
    end;

{ DROP ALL BUT }
17:begin
    for o:=1 to MMax do
     if(o in Inv)and not(o in NounSet)then
      begin
       write(FN(o),':  ');
       if o in Wear then
        writeln('First you must remove the ',FN(o),'.')
       else begin writeln('Dropped.');Inv:=Inv-[o];r[o]:=Prm;end;
      end;
   end;

 end; {main case}
end; { Default1 }
{----------}
procedure Default2;
begin
case Vb of

{ ROOM DESCRIPTION }
77:if not(en(1))then begin Add(1);RL(14)end
   else begin Min(1);RL(15)end;

{ QUIT }
79:begin
    writeln('In ',Tic,' moves you scored ',Sc,
            ' out of a possible 1000 points.');
    writeln('If you want to continue this game at a later date you ',
            'should first use the');writeln('SAVE command.');
    write('Are you still sure you want to QUIT?  ');
    Cur(2);
    CFlag:=readkey;
    if upcase(CFlag)='Y' then
     begin
      RL(12);delay(2200);
      close(R1);
      close(R2);
      close(S1);
      close(L1);
      close(C1);
      close(T1);
      close(T2);
      window(1,1,80,25);nosound;clrscr;Cur(1);gotoxy(2,2);
      Col(31,16);Bak(4,7);writeln('Good-bye!');halt;
     end
    else RL(13);bak(0,0);
   end;

{ SLEEP }
62:if(T[5]>32)and(T[8]<1)then
    if(N1 in[19,27,49,69,80,113])then
     begin T[2]:=6;Add(7);
      writeln('You lie down on the ',NStr,
              ' and fall asleep within a few minutes.');
     end
    else RL(16)
   else
    if N1 in[69,80] then
     begin
      T[5]:=230;PStat:=PStat-[5];Add(7);
      case N1 of
       69:if T[8]<1 then begin RS(41);Add(128) end
          else begin RS(42);Add(7);Add(10)end;
       80:if T[8]<1 then
           if not en(18)then RS(218)
           else case random(2)of 0:RS(218);1:RS(219)end
          else begin RS(220);Add(128) end
      end;
     end
    else writeln('The ',FN(N1),' is not a suitable place to sleep.');

{ SIT }
35:if(N1 in[16,32,35,49,54,69,71,80,83..86,98,110])then
    begin Add(7);
     case N1 of
      69:if T[8]<1 then begin RS(41);Add(128) end
         else begin RS(42);T[5]:=160;PStat:=PStat-[5];Add(7);Add(10)end
      else writeln('You sit down on the ',NStr,'.')
     end
    end
   else RL(17);

{ STAND }
32:if(en(7))then
    begin Min(7);Min(2);Min(3);Min(19);T[6]:=Null;RL(18)end
   else RL(19);

{ UP and CLIMB }
9,51:if(N1 in[32,35,54,68,71,80,81,83..86,89,98,112,125])then
      begin Add(8);
       writeln('You manage to climb up the ',NStr,'.');
      end
     else
      if(Vb=9)then writeln('There is not a path in that direction.')
      else RL(20);

{ DOWN }
10:if(en(8))then
    begin Min(8);RL(21)end
   else writeln('There is not a path in that direction.');

{ IN and OUT }
11,13:writeln('Due to the multiple paths you will have to be more specific.');

{ WAIT }
15:begin writeln('Time passes');y:=wherey;for x:=1 to 6 do
    begin gotoxy(11+x,y-1);write('.');sound(x*99);delay(30);end;
    nosound;writeln;if Region=4 then sound(20);if Region=5 then sound(60);
   end;

 end; {main case}
end; { Default2 }
{----------}
procedure Default3;
begin SFlag:=false;
case Vb of

{ EXAMINE }
28:begin
   case N1 of
   1:if en(41) then RS(116) else begin RS(116);RS(132);Score(5,41)end;
   2:RL(454);
   3:RL(45);
   4:RL(294);
   5:begin RL(105);if SatchCon<>Null then
      if SatchCon=6 then writeln('The satchel contains ',FN(SatchCon),'.')
      else writeln('The satchel contains a ',FN(SatchCon),'.')
     end;
   6:begin RL(54);case FoodCon of 1:RL(55);2:RL(56);3:RL(57);4:RL(58)end end;
   7:begin RL(579);if HolstCon=Null then RL(580)else
      writeln('The gun strap contains a ',FN(HolstCon),'.')end;
   8:RL(59);
   9:RL(374);
   10:RL(262);
   11:RL(311);
   12:RB2(6,13);
   16:RL(151);
   17:RL(263);
   18:if en(34) then begin Score(5,116);RS(92)end else RL(267);
   19:begin RB(12,11);Pause end;
   20:RL(372);
   22:begin RL(527);if 22 in Socket then RL(528)end;
   23:begin RL(529);if 23 in Socket then RL(528)end;
   24:begin RL(530);if 24 in Socket then RL(528)end;
   25:begin RL(531);if 25 in Socket then RL(528)end;
   26:RL(455);
   28:if NStr='badge' then RL(406)else if Md=1 then RL(407)else RL(408);
   29:begin write('The mug is quite small.  ');
       if MugCon=Null then RL(60)else RL(61)end;
   42:begin RS(195);RS(196)end;
   54:if NStr='column' then begin RS(195);RS(196)end;
   56:begin RL(92);if Prm in[81..88]then RL(423)end;
   62:case Prm of 21,25:RS(15);22,24:RS(246)end;
   99:RL(63);
   103:case Prm of 24..34,59,60:RL(317)else RL(326)end;
   113:RR(Prm);
   123:RS(159);
   124:RL(62)
   end; {case}
   if not SFlag then
    case random(20) of
    0..6:writeln('You can''t find anything unusual about the ',FN(N1),'.');
    7..14:writeln('You see nothing special about the ',FN(N1),'.');
    15..17:writeln('It looks like any other ',NStr,' you''ve ever seen.');
    18..20:writeln('It looks like an ordinary ',NStr,'.')
    end
   end;

{ EAT }
47:if N1=6 then
    begin RL(68);FoodCon:=FoodCon-1;T[3]:=175;PStat:=PStat-[2];bak(0,0);
     if FoodCon=0 then begin Van(6);RL(69)end
    end
   else writeln('The ',NStr,' would not do much for your digestive system.')

 end {main case}
end; { Default3 }
{----------}
procedure Default4;
begin
case VB of

{ GET }
39:begin
    Weight:=Null;Min(17);
    for o:=1 to MMax do if o in Inv then
     begin Weight:=Weight+1;if o=11 then Weight:=Weight+3 end;
    if not(30 in NounSet)then
     for o:=1 to NMax do
      if o in NounSet then
       if o in Mov then
        begin
         write(FN(o),':  ');
         Weight:=Weight+1;if o=11 then Weight:=Weight+3;
         if Weight<9 then
          if not(o in Inv)then
           if(o in Socket)and not(26 in Wear)then RL(524) else
            begin if(o=PyraCon)and(o=9)then Walls(8);
             writeln('Taken.');Van(o);Inv:=Inv+[o];
            end
          else writeln('You already have that.')
         else
          begin RL(587);
           if o=11 then Weight:=Weight-3;
          end
        end
       else begin write(FN(o),':  ');
        if N1 in[32,35,80,83..86,90,121]then RL(502)else crazy;end
      else begin;end
    else
     begin  { GET ALL }
      for o:=1 to MMax do
       if o in Mov then
        if r[o]=Prm then
         begin
          write(FN(o),':  ');Add(17);
          Weight:=Weight+1;if o=11 then Weight:=Weight+3;
          if Weight<9 then
           if(o in Socket)and not(26 in Wear)then RL(524) else
            begin writeln('Taken.');Van(o);Inv:=Inv+[o]end
          else
           begin RL(587);
            if o=11 then Weight:=Weight-3;
           end
         end;
      if not en(17)then RL(29)
     end
   end;

{ GET ALL BUT }
37:begin
    Weight:=Null;Min(17);
    for o:=1 to MMax do if o in Inv then
      begin Weight:=Weight+1;if o=11 then Weight:=Weight+3 end;
     for o:=1 to MMax do
      if(o in Mov)and not(o in NounSet)then
       if r[o]=Prm then
        begin
         write(FN(o),':  ');
         Weight:=Weight+1;if o=11 then Weight:=Weight+3;
         if Weight<9 then
          if(o in Socket)and not(26 in Wear)then RL(524) else
           begin writeln('Taken.');Van(o);Inv:=Inv+[o];Add(17)end
         else
          begin RL(587);
           if o=11 then Weight:=Weight-3;
          end
        end;
     if not en(17)then RL(29)
   end;

 end; {main case}
end; { Default4 }
{----------}
procedure Default5;
 label JUMP,JUMP1;
begin
case Vb of

{ PURCHASE }
64:if Prm=8 then
    if N1=100 then RS(10) else
    if(N1 in[29,99])or(Pr=11)then
     if Pr in[6,9] then
      if N2 in[8,111] then
       if Here(8) then
        begin Inv:=Inv+[29];Van(8);Score(15,21);RS(11);T[1]:=21;Add(9);Add(16)
        end
       else RL(39)
      else RL(40)
     else
      if Pr=11 then
       if(N1 in[29,99,111,124])and(N2 in[29,99,111,124])then begin
        if(N1=111)xor(N2=111)then RL(196)else
        if(N1=124)xor(N2=124)then RL(197)
        else crazy end
       else crazy
      else NoSense
    else
     if N2<>124 then RL(34) else RL(35)
   else
    if Prm=AlienRm then RL(35) else
    if Prm=FriendRm then RL(36)
    else RL(38);

{ DRINK }
46:if N1=Null then
    if Here(29) then
     if(Prm=8)and not(29 in Inv)then RL(67) else
JUMP: if MugCon<>Null then
       case MugCon of
        99:begin MugCon:=Null;T[4]:=130;bak(0,0);PStat:=PStat-[6];RL(64)end;
        79:begin MugCon:=Null;T[4]:=130;bak(0,0);PStat:=PStat-[6];RL(66);
            Van(79)end;
        92:JUMP1:begin MugCon:=Null;
            if T[12]<2 then RL(162)else
            if en(42) then begin RS(136);Van(92);T[12]:=Null;bak(0,0);
             PStat:=PStat-[3];Score(20,124)end
            else RL(162)
           end;
       end
      else RL(65)
    else
     if Here(98) then  { For the Sink }
      if SinkRm=Prm then begin T[4]:=130;bak(0,0);PStat:=PStat-[6];RL(66)end
      else RL(67)
     else RL(67)
   else  { If N1 = something }
    case N1 of
     29,99:if 29 in Inv then goto JUMP else RL(87);
     98:if SinkRm=Prm then begin T[4]:=130;bak(0,0);PStat:=PStat-[6];RL(66)end
        else RL(67);
     121,66:begin RS(12);Add(128);end;
     92:goto JUMP1;
     79:begin
         if(Here(29)and(MugCon=79))then
          begin T[4]:=130;bak(0,0);MugCon:=Null;Van(79);PStat:=PStat-[6];
           RL(66)end
         else if Here(79)then begin T[4]:=130;bak(0,0);PStat:=PStat-[6];
               RL(66)end
              else RL(67);
        end
     else writeln('The ',NStr,' would not quench your thirst.')
    end;

 end; {main case}
end; { Default5 }
{----------}
procedure Default6;
 function Word(W:Str29):boolean;
  begin if pos(' '+W+' ',input)>0 then Word:=true else Word:=false end;
begin
case Vb of

{ TALKING TO CHARACTERS}
66..69,71:
  begin Spaces(input);
   if Vb=66 then  { Bartender }
    if Here(111)then
     if Word('follow')then RL(46)else
     if Word('go')or Word('east')or Word('south')then RL(567)else
     if Word('hi')or Word('hello')then RL(51)else
     if Word('infocom')then RL(498)else
     if Word('scott')or Word('miller')then RL(499)else
     if Word('what')or Word('why')or Word('where')or Word('who')or
        Word('how')or Word('which')or Word('when')then RL(463)else
     if(Word('ill')or Word('give')or Word('buy')or Word('get me')or
        Word('purchas'))and(Word('drink')or Word('glunk'))then RL(47)else
     if Word('ambross')or Word('pink')or Word('bloody')or Word('foeboz')or
        Word('ztulctw')then RL(565)else
     if Word('kill')or Word('fight')or Word('hit')then RL(566)else
     if Word('give')then RL(564)else
     if Word('help')or Word('tell me')then RL(479)else
     case random(3) of 0:RL(50); 1:RL(480); 2:RL(481)end
    else RL(52);
   if Vb=67 then  { Two Aliens }
    if Here(124)then
     if Word('follow')then RL(48)else
     if Word('go')or Word('south')or Word('east')then RL(568)else
     if Word('crystal')then RL(484)else
     if Word('coordin')or Word('where')or Word('world')or Word('sagan')or
        Word('planet')or Word('locatio')then RL(485)else
     if Word('what')or Word('why')or Word('who')or Word('tell me')or
        Word('how')or Word('which')or Word('when')then RL(464)else
     case random(3) of 0:RL(49); 1:RL(482); 2:RL(483)end
    else RL(53);
   if Vb=68 then  { Scientist }
    if here(123)then
     if Word('follow')then RL(440)else
     if Word('hi')or Word('hello')or Word('bye')then RL(441)else
     if Word('wristba')then RL(442)else
     if Word('card')or Word('green')then RL(459)else
     if Word('give')then RL(456)else
     if Word('go')or Word('east')or Word('west')then RL(457)else
     if Word('help')then RL(462)else
     if Word('ship')or Word('planets')then RL(497)else
     if Word('star')or Word('superno')then RL(486)else
     if(Word('crystal')or Word('clear'))and((T[24]>1)and(T[24]<6))and
       (1 in Inv)then begin T[24]:=Null;T[25]:=7;RS(181)end else
     if(Word('crystal')or Word('clear'))and((T[23]>1)or(T[24]>5))then
      RL(446)else
     if Word('crystal')or Word('clear')then RL(487)else
     if(Word('who')or Word('what'))and Word('you')then RL(461)else
     if Word('what')or Word('why')or Word('where')or Word('who')or
        Word('how')or Word('which')or Word('when')or
        Word('tell me')then RL(458)else
     case random(3) of 0:RL(443); 1:RL(477); 2:RL(478)end
    else RL(439);
    if Vb=69 then  { Robot }
     if here(46)then RL(508)
     else RL(584);
    if Vb=71 then  { Computer }
     if here(37) then RL(545)
     else RL(546)
  end; {characters}

 end; {main case}
end; { Default6 }
{----------}
procedure Default7;
begin
case Vb of

{ READ }
31:case N1 of
    12:RB2(6,13);
    19:begin RB(12,7);Pause end
    else writeln('There is nothing on the ',FN(N1),' to read.')
   end;

{ TOUCH }
75:if 26 in Wear then RL(571)else
    case N1 of
     1,22..25:if N1 in Socket then RL(569)else RL(570);
     79:RL(552);
     120:RL(551);
     34,103,115:writeln('You can''t reach the ',NStr,'.')
     else writeln('You feel nothing unusual about the ',NStr,'.')
    end;

{ TASTE }
84:case N1 of
    6:RL(377);
    29,92,99:if MugCon=99 then RL(70) else RL(71);
    111:RL(466)
    else writeln('It tastes like a ',NStr,' should taste.')
   end;

{ SMELL }
83:case N1 of
    6:RL(378);
    29,99:if MugCon=99 then RL(72)else RL(599);
    111:RL(466)
    else
     if Prm in[42..50]then RL(572)
     else writeln('It smells like an ordinary ',NStr,'.')
   end;

{ LISTEN }
65:case N1 of
    42:RL(501);
    62:if Region=4 then RL(573)else RL(574);
    111:RL(73)
    else writeln('The ',NStr,' is not making any sound.')
   end;

{ HELLO }
80:if(word='hi')or(word='hello')then writeln('Hello to you.') else RL(74);

{ YES/NO/MAYBE }
81:RL(random(6)+75);

{ COMMANDS }
95:begin RB(4,11);Pause;RB(6,11);Pause;end;

{ ATTACK }
93:if Pr=6 then
    if(N2 in Mov)or(N2=60)then
     case N1 of
      60:begin Cur(2);write('Are you sure? ');CFlag:=readkey;Cur(3);writeln;
          if upcase(CFlag)='Y' then begin RL(488);Add(128);end
          else writeln('Whew!')end;
      123:RL(465);
      124:case random(6) of
           0:RL(175);
           1:begin RL(176);Add(7)end;
           2:begin RL(177);Van(N2);R[N2]:=Prm;end;
           3:begin RS(33);T[3]:=26;T[4]:=23;T[5]:=33;end;
           4:begin RS(34);Van(N2);Prm:=13;Add(7)end;
           5:begin RS(36);T[7]:=9;PStat:=PStat+[4];Add(7)end
          end
      else writeln('The ',FN(N1),' offers no resistance.')
     end
    else crazy
   else NoSense;

 end; {main case}
end; { Default7 }
{----------}
procedure Default8;
 label JUMP;
begin
case Vb of

{ TURN }
50:if Pr=Null then   {eg. turn knob}
    case N1 of
     48:JUMP:begin
         if Prm=SinkRm then begin SinkRm:=Null;L[Prm]:=L[Prm]-[79];RL(81)end
         else if Prm in[5,12] then
               begin SinkRm:=Prm;L[Prm]:=L[Prm]+[79];RL(82)end
              else RL(540)
        end
     else RL(83)
    end {case}
   else
    if input='' then  {eg. turn sink on}
     case N1 of
      2:begin RL(460);Score(5,123);
        case random(4)of
         0:for i:=20 to random(99)+50 do play(20,i,1);
         1:for i:=random(5000)+4500 downto 20 do begin sound(i);
            delay(1);sound(31)end;
         2:begin i:=random(9999)+1;x:=0;repeat j:=random(9999);play(j,i,0);
            i:=random(9999)+1;play(i,j,0);x:=x+1;until x>9 end;
         3:for x:=1 to 200 do begin i:=random(9999)+1;play(i,i,1);delay(16)end
        end;nosound;if Region=5 then sound(60);
       end;
      37,38:RL(373);
      48,79,98:goto JUMP;
      46:RL(360);
      127:if NStr<>'window' then RL(360);
      131:RL(84)
      else crazy
     end
    else             {eg. turn dial to 123}
     if Pr=1 then
      if N1=48 then
       case Prm of
        79:begin;end;
       end
      else crazy
     else NoSense;

{ OPEN and UNLOCK }
41,88:
  if N1=5 then RL(289)
  else
   if N2=Null then
    case N1 of { if N1 only }
     56:RL(409)
     else RL(100)
    end
   else
    if Pr=6 then
     if N1=56 then
      if Prm in[9,11] then
       if N2=3 then RL(101)
       else crazy
      else
       if Prm=10 then
        if N2=3 then begin RL(102);Add(11)end
        else crazy
       else RL(103)
     else
      if N1 in[32,38,45,55,62,68,69,78,89,90,119] then RL(103)
      else crazy
    else NoSense;

 end; {main case}
end; { Default8 }
{----------}
procedure Default9;
 label JUMP;
begin
case Vb of

{ LOOK INSIDE }
24:case N1 of
    5:if SatchCon<>Null then writeln('The satchel contains ',FN(SatchCon),'.')
      else RL(110);
    7:if HolstCon=Null then RL(580)else
       writeln('The gun strap contains a ',FN(HolstCon),'.');
    18:if en(34)then RL(270)else RL(271);
    29:if MugCon<>Null then writeln('The mug contains ',FN(MugCon),'.')
       else RL(111);
    35:if NStr='toilet' then RL(114)else RL(113);
    10,26,28,32,62,64,69,98,113:writeln('The ',NStr,' is empty.');
    119:RL(112);
    103..109,115,118:if Prm=63 then RL(113)else RL(115)
    else RL(113)
   end;

{ LOOK UNDER, LOOK BEHIND and REACH IN }
20,26,76:
   case N1 of
    5:if SatchCon<>Null then writeln('The satchel contains ',FN(SatchCon),'.')
      else RL(110);
    80:if not en(127) then begin RS(16);Add(127)end else RL(116);
    103..109,115,118:if Prm=63 then RL(113)else RL(115)
    else RL(116)
   end;

{ LOOK ON TOP }
22:case N1 of
    66:RL(117);
    80:RL(118);
    99:RL(119);
    103..109,115,118:if Prm=63 then RL(113)else RL(115)
    else RL(120)
   end;

{ CLUE }
70:begin if Sc<25 then begin RL(302);goto JUMP;end;
    if not en(15) then
     begin Add(15);RS(30);
      Cur(2);
      write('Do you still wish to see the clue? ');CFlag:=readkey;writeln;
      if upcase(CFlag)='N' then
       begin writeln('OK, no clue will be shown.');goto JUMP;end
     end;
    Cn('---Here is your clue---');Sc:=Sc-25;
    if(Prm<>StoreC)then
     begin StoreC:=Prm;
      seek(C1,Prm);
      read(C1,Text5)
     end;
    col(12,9);Cn(Text5);col(11,7); JUMP:
   end; { Read Clue }

 end; {main case}
end; { Default9 }
{----------}
procedure Default10;
begin
case Vb of

{ PUT }
33:begin SFlag:=False;if VStr='fill' then begin x:=N1;N1:=N2;N2:=x;end;
    if((N1 in Mov)and(N1 in Inv))or(N1 in[66,79])then
     case N2 of
      64:case Prm of
         34:if N1 in[3,8,9] then
             if Pr=5 then
              if PyraCon=Null then
               begin Van(N1);R[N1]:=34;PyraCon:=N1;
                if N1=9then begin RS(83);Walls(8);Add(30)end else RL(224)
               end
              else RL(223)
             else RL(222)
            else RL(221);
         end;
     126:if en(31) then
          if N1 in[3,8,9] then
           if Pr in[1,5,7,10] then
            if HingeCon=Null then
             begin Van(N1);R[N1]:=34;HingeCon:=N1;RL(231)end
            else RL(230)
           else NoSense
          else RL(229)
         else RL(232);
      35:if Prm=1 then
          if N1=16 then
           begin Van(16);Add(6);R[16]:=1;RL(144);Score(5,25)end
          else begin RL(143);Van(N1);R[N1]:=1;end;
      120:begin RL(550);Van(N1)end;
      62:if Prm in[22,24] then
          if en(23) then begin Van(N1);R[N1]:=2;RL(134)end else RL(99);
      66:begin if random(2)=0 then RL(375)else RL(376);Van(N1)end;
      42:RL(495);
      29:if MugCon=Null then
          if N1 in[3,4,9,17,19,66,79,99] then begin
           writeln('The ',FN(N1),' is now in the mug.');
           if N1 in Mov then Van(N1);L[Prm]:=L[Prm]+[N1];MugCon:=N1;end
          else if N1 in Mov then RL(137)else crazy
         else RL(136);
      5 :if SatchCon=Null then
          if N1 in[3,4,6,8,9,12,17,19] then
           begin Van(N1);L[Prm]:=L[Prm]+[N1];SatchCon:=N1;
            writeln('The ',FN(N1),' is now in the brown satchel.')end
          else if N1 in Mov then RL(137)else crazy
         else RL(138);
      7 :if HolstCon=Null then
          if N1 in[3,4,8,9,12,17,19] then
           begin Van(N1);L[Prm]:=L[Prm]+[N1];HolstCon:=N1;
            writeln('The ',FN(N1),' is now in the holster.')end
          else if N1 in Mov then RL(137)else crazy
         else RL(581);
     end {main N2 case}
    else writeln('First you must have the ',FN(N1),'.');

     if not SFlag then
      case Pr of
       1:if N2 in[32..37,49,71,80,83..87,90,93,98,113,112,126,132] then
          begin Van(N1);R[N1]:=Prm;
           writeln('The ',FN(N1),' is now on the ',FN(N2),'.')end
         else RL(139);
       5:RL(139);
       7:if N2 in[32,35,37,49,51,54,56,62,66..73,80..87,89,90,94..98,104,112,
                  113,116,120..122,125..128,132] then
          begin Van(N1);R[N1]:=Prm;
           writeln('The ',FN(N1),' is now beside the ',FN(N2),'.')end
         else RL(139);
      10:if N2 in[80,81,83..86,98,104,112] then
          begin Van(N1);R[N1]:=Prm;
           writeln('The ',FN(N1),' is now under the ',FN(N2),'.')end
         else RL(139)
       else crazy
      end

   end

 end; {main case}
end; { Default10 }
{----------}
procedure Default11;
begin
case Vb of

{ PUSH and TURN ON }
44:if(VStr='turn on')or(VStr='activat')then
    case N1 of
     2:begin RL(460);Score(5,117);
        case random(4)of
         0:for i:=400 to random(250)+420 do play(400,i,1);
         1:begin y:=random(35)+2;for x:=1 to 99 do
            begin i:=random(9000)+60;play(i,i,y);delay(y)end end;
         2:for x:=1 to random(230)+21 do
            for y:=1 to random(230)+22 do sound(x*y);
         3:for i:=1 to random(9999)+999 do sound(random(i)+i);
        end;nosound;if Region=5 then sound(60);
       end;
     37,38:RL(373);
     98,48:if Prm=SinkRm then say('water','flowing out')
        else begin SinkRm:=Prm;L[Prm]:=L[Prm]+[79];RL(82)end;
     127:if NStr<>'window' then RL(360)
     else RL(164)
    end
   else
    case N1 of
     116:if Prm in[42..50]then RL(282)else RL(281);
     123:RL(472)
     else RL(103)
    end;

{ PULL and TURN OFF }
42:if(VStr='turn off')or(VStr='deactiv')then
    case N1 of
     98,48,79:if Prm<>SinkRm then say('water','off')
        else begin SinkRm:=Null;L[Prm]:=L[Prm]-[79];RL(81)end;
     127:if NStr<>'window' then RL(360)else RL(165)
     else RL(165)
    end
   else RL(103);

{ CLEAN }
94:case N1 of
    18:if en(34) then RL(265) else
        begin if 18 in L[41] then R[18]:=41;Score(15,34);
         RS(91);n[18]:='glass ball\ball\glass\';;;end;
    126:if NStr='bar' then RL(167);
    80:RL(166);
    98:RL(168)
    else writeln('The ',NStr,' doesn''t need to be cleaned.');
   end;

{ RESTART }
86:begin bak(1,0);Cur(2);
    write('Are you sure you want to restart your game? ');
    CFlag:=readkey;
    if upcase(CFlag)<>'Y' then RL(169)
    else
     begin RL(170);delay(2000);window(1,1,80,25);clrscr;bak(0,0);nosound;
      close(R1);close(R2);close(S1);close(L1);close(C1);close(T1);close(T2);
      {assign(R1,'nova.com');}exec('nova.exe', '')
     end;bak(0,0);
   end;

{ SHOOT }
89:RL(171);

{ TIE and UNTIE }
90:if VStr='tie' then RL(172)else if VStr='untie' then RL(173)else RL(437);

{ FIND }
73:if N1 in Inv then
    writeln('You are carrying the ',NStr,'.')
   else writeln('The ',NStr,' is close by, just look around.');

 end; {main case}
end; { Default11 }
{----------}
 procedure Default12;
begin
case Vb of

{ HIT and BREAK }
54:if N2<>Null then
    if(N2 in Mov)or(N2=60)then
     if N1<>N2 then
      if Pr in[3,6] then
       case N1 of
        1:if(Prm=56)and(1 in L[56])then RL(300)else RL(83);
        18:if N2 in[10,11,29] then begin RS(97);Van(18);R[4]:=Prm;end
           else RL(272);
        123:RL(416)
        else RL(273)
       end {case}
      else NoSense
     else crazy
    else crazy
   else { N2=Null }
    case N1 of
     18:RL(274)
     else
      if random(3)=0 then
       writeln('At the last moment you decide to spare the ',NStr,'''s life!')
      else writeln('Hitting the ',NStr,' doesn''t help.')
    end;

{ THROW }
48:if N2<>Null then
    if N1 in Inv then
     if N1 in Mov then
      if N1<>N2 then
       if Pr in[1..5] then
        begin
         if(N1=29)and(MugCon in[79,92,99])then begin
          MugCon:=Null;RL(585);SFlag:=false;end;
         if(N2=1)and(Prm=56)and(1 in L[56])then
          begin Van(N1);R[N1]:=56;RL(301)end;
         if(N2=49)and(Prm=56)and(N1 in[1,10,18,29])then
          begin RS(112);Add(128);end;
         if(N2=69)and(Prm=91)then begin RS(160);L[91]:=L[91]+[123];
          L[91]:=L[91]-[44,129];T[23]:=15;Add(51);Van(N1);R[N1]:=91;end;
         if(N1 in[1,22..25])then begin Van(N1);RL(430)end;
         if(N2=46)and(Prm in[99,101])then begin RL(514);Blast;
          if Prm=99 then T[27]:=2000 else T[28]:=2000;Van(N1)end;
         case N2 of
          1,22..25:begin Van(N2);RL(431)end;
          42:begin Van(N1);RL(515)end;
          66:begin RL(375);Van(N1)end;
          111:begin RL(449);Van(N1)end;
          120:begin RL(550);Van(N1)end;
          123:begin RL(450);RL(451);Van(N1);R[N1]:=Prm;end;
          124:begin RL(452);RL(453);Van(N1);R[N1]:=Prm;end;
          127:if Prm=64 then if Md=3 then begin RL(537);Add(128);end else RL(538);
         end;
         if(N1=18)or(N2=18)then
          begin Van(N1);R[N1]:=Prm;Van(18);RS(97);R[4]:=Prm;end;
         if not SFlag then begin writeln('The ',FN(N1),' collides with the ',
         FN(N2),', but nothing interesting happens.');Van(N1);R[N1]:=Prm;end
        end
       else NoSense
      else crazy
     else crazy
    else writeln('First you must have the ',FN(N1),'.')
   else { N2=Null }
    begin Van(N1);R[N1]:=Prm;RL(275)end;

 end; {main case}
end; { Default12 }
{----------}

{----------}
procedure Default14;
begin
case Vb of

{ SHOW / GIVE }
49:if N2 in[46,111,123,124]then
    if Pr=1 then
     case N2 of
      46:RL(447);
      111:if N1=8 then begin Inv:=Inv+[29];Van(8);Score(10,21);RS(11);
           T[1]:=21;Add(9);Add(16)end
          else RL(444);
      124:RL(445);
      123:RL(446)
     end
    else nosense
   else crazy;

{ JUMP }
59:if N1<>Null then
    if(VStr='jump over')or(VStr='leap over')or(VStr='jump across')then
     if N1 in[1..29,36,49,51,69,71,73,132]then
      writeln('You land on the other side of the ',NStr,'.')
     else crazy
    else
     if(VStr='jump off')and en(8)then begin RL(475);Min(8)end else
     if N1 in[34,56,60,62,68,72,82,92] then crazy else
     if(N1 in[1..29])and not(N1 in Inv)then
      writeln('You land on the ',NStr,'.')
     else
      if NStr='quicksa' then begin RL(582);Add(128)end else
      if NStr='swamp' then begin RL(583);Add(128)end
      else RL(476)
   else
    if(VStr='jump off')and en(8)then begin RL(475);Min(8)end
    else RL(539);

{ DIG }
92:case N1 of
    49,116,122:RL(556);
    120:RL(557)
    else crazy
   end;

{ TALK / GREET }
21:if VStr='greet' then
    case N1 of 111:RL(51); 124:RL(46); 123:RL(441) else crazy end
   else
    if N1 in[111,123,124] then
     begin writeln('To talk to the ',FN(N1),' enter:');
      writeln(FN(N1),', < what you want to say goes here >')
     end
    else crazy;

25:RS(245);

 end; {main case}
end; { Default14 }
{----------}


BEGIN { Main Program }
Assign1;Assign2;Assign3;Assign4;Assign5;
Names1;Names2;Names3;
Title;
Init1;Init2;Init3;
Place1;Place2;
Describe(Prm);

repeat

PlayerInput(LINE);
if length(input)>0 then Parser_Syntax(input);
if EFlag=Legal then
 begin
  MoreThanOne;
  if Present then
   if T[2]>1 then
    begin RL(11);Time1;
     case TFlag of 1:Time2A;2:Time2B;3:Time2C;4:Time2D;end end
   else
    begin SFlag:=false; if(Vb=71)and(Prm=55)and not en(35)then Vb:=1;
     case Prm of
       1                          :Room1;
       2,3                        :Room2;
       4..7                       :Room3;
       8..12                      :Room4;
      13..22                      :Room5;
      23..29                      :Room6;
      30..34                      :Room7;
      35..38                      :Room8;
      39..41                      :Room9;
      42..50                      :Room10;
      51..55                      :Room11;
      56                          :Room12;
      57..63                      :Room13;
      64..67,71,72                :Room14;
      68..70                      :Room15;
      73..77                      :Room16;
      78..80                      :Room17;
      81..83,93,95,96             :Room18;
      84..89                      :Room19;
      90..92                      :Room20;
      94,97..100                  :Room21;
      101..105                    :Room22;
      106..108                    :Room23;
     end; { Room Defaults }
     if not SFlag then
      case Vb of
       1..8,30,82,87              :Default0;
       16,17,18                   :Default1;
       9..15,32,35,51,77,79,62    :Default2;
       28,47                      :Default3;
       37,39                      :Default4;
       46,64                      :Default5;
       66..69,71                  :Default6;
       31,65,75,80,81,83,84,93,95 :Default7;
       41,50,88                   :Default8;
       20,22,24,26,70,76          :Default9;
       33                         :Default10;
       42,44,73,86,89,90,94       :Default11;
       48,54                      :Default12;
       19,53,56,72,74,78,91       :Default13;
       21,25,49,59,92             :Default14
      end;
     if en(128)then DEAD;Min(128);
     if not(Vb in[77..79,82,86,87,95])then
      begin Time1;case TFlag of 1:Time2A;2:Time2B;3:Time2C;4:Time2D;end end;
    end;
 end;

until false;
END. { ADGAME2 (Supernova) }
