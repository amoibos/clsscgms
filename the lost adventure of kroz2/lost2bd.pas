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

unit LOST2BD;

interface

procedure Level48;
procedure Level52;
procedure Level53;
procedure Level54;
procedure Level55;
procedure Level56;
procedure Level59;
procedure Level61;
procedure Level64;
procedure Level66;
procedure Level68;
procedure Level70;
procedure Level72;
procedure Level74;
procedure Level75;


implementation { ---------------------------------------------------------- }

uses CRT, DOS, Lost1D;

procedure Level48;
 begin
  FP[1]:= '##################RRRRRRRRRRR#the#swamp#RRRRRRR-\\�\\\\/\\\\\\\C';
  FP[2]:= 'LL�D�D�D--VVVV--44----------------------------RR-\\\\\\\\\\\\\\\';
  FP[3]:= 'LL�D�D�D--VVVV--44--RRRRRRRRRRRRRRRRRRRRRRRR--RRR-/\\\\\\\\\U\\\';
  FP[4]:= '##################RRRR-------------------------RRR-\\\\/\\\\\\\\';
  FP[5]:= 'RRRRRRRRRRRRRRRRRRRRRR--RRRRRRRRRRRRRRRRRRRRK))RRRR--\\\\\\\\\\\';
  FP[6]:= 'R-----RRR-------R----)))RR)))))))3)3)3)3)3)3)3)3)3RRR--\\\\\\\\\';
  FP[7]:= 'R-RRR�RR-RRRRRRR-RRR-RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR--/\\\/\�';
  FP[8]:= 'R-RR-RR-RRR\\\RRR-RRR--------------------------�-------RR--\\\\\';
  FP[9]:= 'R-RRRR-RR\\\K\\RRR-RR-RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR--\\\';
  FP[10]:='R-RRR-RRRR\\\\\\RRR-RR------------Z-8�-999999999999�--RRRRRRR--\';
  FP[11]:='R-RR-RRRR\\\\\\�\RR-RRR-RRRRRRRRRRRRR8-111111111111RRR-----RRRR-';
  FP[12]:='R---RRRRRR-\\\RRRR-RRRRRFRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR-RRRR';
  FP[13]:='RRRR-RRRRR-RRRRRR-RRRS(((((+((((((((((((((((((K++(3RRRRRRRRR-RRR';
  FP[14]:='RRRRR-RRRR��RRRR-RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR*R.R*RRR-RR';
  FP[15]:='RRRRRRTRRR1R-RR-RRR@@@@@@@RRRRRRRRRRRRRRRRRR-----------�-�RRR�RR';
  FP[16]:='###RRRRRR11RR--RRRR@@RRRRFRR-66----H----------RRRRRRR*R.R*RRRRRR';
  FP[17]:='77###RRR111RR--RR*F@@@22@WRR-RR-RRORRRRRRRRRRRRRRRRRRRRRRRRRRR  ';
  FP[18]:='7777###RR11RR--RR*F@@@22@WRR-RR-RRORR                          P';
  FP[19]:='77777###RR1RR--RR*F@@@22@WRR-RR-RRORR  RRRRRRRRR-RRRRRRRRRRRRR  ';
  FP[20]:='77!777###RRRR--RR*F@@@22@WRR-RR-RR>RRFSRRRRRRRRR�RRRRRRRRRRRRRRR';
  FP[21]:='7777777##RRRR--RR*F@@@22@WRR-RR-RRRRR����������3333333333C������';
  FP[22]:='77777777##RRR--RRRRFFRRRRRRR-RR-RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR--';
  FP[23]:='U7777777##RRR----------------RR---------------------------------';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level48 }

procedure Level52;
 begin 
  FP[1]:= '�  ]  �]�   ]��] �]]�  ���]��� ] � �    �]��         �]���] �---';
  FP[2]:= ' �� �] � ��] �� � ]� �� ]���] � � � ]��� ]� ��]���]�� �]�� � -P-';
  FP[3]:= '  ���]� ��] �� �] � ��]�� ��] ���]���]�� � ]��    �] ���] ���---';
  FP[4]:= '�� �]���]� ��]� �� ]���]�� �]�   ��]���  ] �� �]��  �]���] ���]�';
  FP[5]:= '�]�  ��]��� ]� ��]��  �]�� �]���] ���] ��� ]��   �]���]���]  ���';
  FP[6]:= '���]� ��]��� ]� ��  ]�  ��] ���] ���  ]��� ]���]� ��]   ���]� ��';
  FP[7]:= '���] ���  ]��  �] ���]�� �]� �� ]�� �]���]� ��]�� �] ��� ]���] �';
  FP[8]:= '�]� ��  ]� ��]�� �]�  ��] ���  ]�� ��]���]��  �]��  �]  ���]��� ';
  FP[9]:= '�� ]� ��]��     �]� �� ]�� �]���] ��     �]��� ]���]� ��]�  �� ]';
  FP[10]:='� �] ��� ]���]���] ���] ��� ]��� ]� ��]�� ��]�� ��]� ��]� �� ]� ';
  FP[11]:=' �� ]�� � � ] � ��] ���] ����]�� �]� ��]�� �]���]� ��]�� �] � �';
  FP[12]:=']  ��� ]�� � ] �   ��]���   ]���]   ���]���    ]���]     ���] ��';
  FP[13]:='#####444############follow#the#bread#crumbs#####################';
  FP[14]:='����#555#&����������������������������������������@MMMMMMMMK##LL';
  FP[15]:='����66666�����������������������������������������@MMMMMMMMM##��';
  FP[16]:='��������������������������������������������������@MMMMMMMMM##``';
  FP[17]:='��������������������������������������������������@MMMMMMMMM##��';
  FP[18]:='�������������������������!������������������������@MMMMMMMMM##``';
  FP[19]:='��������������������������������������������������@MMMMMMMMM##��';
  FP[20]:='��������������������������������������������������@MMMMMMMMM##--';
  FP[21]:='��������������������������������������������������@MMMMMMMMM##--';
  FP[22]:='00������������������������������������������������@MMMMMMMMM##--';
  FP[23]:='K0������������������������������������������������@MMMMMMMMM66--';
  Fast:=#234;{or #1}
  Convert_Format;
  MakeFloor(#250,6,7,0,0); HideCreate:=true; HideMBlock:=true;
 end; { Level52 }

procedure Level53;
 begin
  FP[1]:= 'U----------; 55555------------------------�--##-U-##            ';
  FP[2]:= 'XXXXXXXXX�-; ##�############################-##---## ##������##�';
  FP[3]:= '-----------; #2�2#K--B-----------------------##---## ##������##-';
  FP[4]:= '-----------; ##�##-############################-I-## ##W����W##-';
  FP[5]:= '-----------; #2�2#      M   M   M   M   M    ##-W-## ##-W��W-##-';
  FP[6]:= '-----------; ##�############################-##--W## ##::WW::##-';
  FP[7]:= 'XX�XXXX----; #2�2#�------------------K-------##-W-## ##2 22 2##-';
  FP[8]:= '------;----; ##�##�####################-----:##W--## ##########-';
  FP[9]:= '------;----; #2�2#�-----------------------:::##-W-## C--�7;-;---';
  FP[10]:='------;----; ##�##�---------------------::-::##--W## ##########-';
  FP[11]:='[-----;----; #2�2#--------------------:::::-:##-�-## -1--1--�##-';
  FP[12]:='------;----; ##�##XXXXXXXXXXXX�-----::::::::-##W--## ##########-';
  FP[13]:='------;----; #2�|#-------------XXX::::::::::"##-W-## -------C##-';
  FP[14]:='------;----; ##�##--------------�##############--W##4##########-';
  FP[15]:='------;----; #2�2#---------------#####-�----C##-W-##--------K##-';
  FP[16]:='------;----; ##�##`::::::::::::::##�##XOXXXXX##W--##4##########-';
  FP[17]:='------;----; #2�2#--`---�---`LL# �-----------66���##--------<##-';
  FP[18]:='------;--�-; ##�################ ::�::;;;;;;;##888##4##########-';
  FP[19]:='------#3333#     F               ##H##3333333##VVV##--------�##-';
  FP[20]:='------######XXXXXXXXXXXXXXXXXXXXX###################4##########-';
  FP[21]:='-------------------------I--------------------------------------';
  FP[22]:='XX�XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  FP[23]:='                                P                               ';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level53 }

procedure Level54;
 begin
  FP[1]:= '  P  ##-U--------##-------##��------------------##--DDDD-�-KKKKK';
  FP[2]:= 'II#II##----------##�#####-##--------------777---##�5555555555555';
  FP[3]:= 'M   M###########-##�-----�###########X##�##�######-##LLLLLLLLLLL';
  FP[4]:= 'M   M##---;---------------##K---------##-##7-<[|##-#############';
  FP[5]:= 'M   M###-#########################---###-######X##-----�----�-C"';
  FP[6]:= 'M   M##----------------�----------7�7-44--------##-#############';
  FP[7]:= 'M   M##-######################################�-##-�������������';
  FP[8]:= 'M   M##---------------------------------D--K##--##-]]]]]]]]]]?]]';
  FP[9]:= 'M   M######################################-##--##-abcdefghijklm';
  FP[10]:='M   M##K�`�:�-�-�-�:�-�:�:�-�:�-�-�-�:�:�##-##--##-#############';
  FP[11]:='M   M##-�`�-�:�-�:�:�:�-�-�:�-�:�-�:�:�-�##-##--##-##---------�!';
  FP[12]:='M   M##-�`�:�:�-�:�-�:�:�-�:�:�-�-�:�:�:�##-##--##-##�##########';
  FP[13]:='M   M##-�`�:�:�-�:�-�:�-�W�:�-�:�-�:�:�:�##-##--##-##-----------';
  FP[14]:='M   M##-�`�:�-�-�:�:�-�:�-�:�:�:�-�:�-�:�##-##--##-########�####';
  FP[15]:='M   M##-�`�:�-�W�:�-�:�:�7�:�:�:�-�:�:�-�##-##--##-##-----------';
  FP[16]:='M   M##-�`�-�:�-�:�:�:�:���:�-�:�-�:�-�:�##-##-.##-####�########';
  FP[17]:='M   M##-�-�-�:�-�:�:�-�-�-�:�:�-�W�:�-�:�##-##--##-##-----------';
  FP[18]:='M   M##:�:�:�:�:�:�:�:�:�:�:�:�:�-�:�:�:����##--##-############�';   
  FP[19]:='M   M##---                       ;          ##--##�88----------�';
  FP[20]:='M   M##-##VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV##--##0############�';
  FP[21]:='M   M##D######################################--##~------------�';
  FP[22]:='M K M##K-�1��1��1�11�1��11�11�1�11��1��1��11�-�-44�------------�';
  FP[23]:='M U M##K--�11�11�1��1�11��1��1�1��11�11�11��1�--44--------------';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level54 }

procedure Level55;
 begin
  FP[1]:= '� P          ;           1   �#diary�#day#five�#################';
  FP[2]:= '#######################XXXX#####################################';
  FP[3]:= 'VVVYVVVVVVVVVVVVVVVVVVV----VVV#you�ve#traveled#deeper#into#kroz#';
  FP[4]:= 'VVVVVVVVVVVVVVVVVVYYVV-�--VVVV##################################';
  FP[5]:= 'VVVVVVVYYVVVVVVVVVVYVV----VVYV#than#ever#before�##where#will####';
  FP[6]:= 'YVVVVVVVYVVVVYVVVVVVV----VVVVV##################################';
  FP[7]:= 'VVVVVVVVVVVVVVVVVVVV--�-VVVVVV#the#many#chambers#lead#to�##and##';
  FP[8]:= 'VVVYVVVVVVYVVVVVVVV----VVYYVVV##################################';
  FP[9]:= 'VVVYVVVVVVVVVVVVVVV-�--VVVYVVV#what#do#they#protect#below�######';
  FP[10]:='VVVVVVVVVVVVYVVVVVVV----VVVVVV##################################';
  FP[11]:='VVVVVVVYVVVVYYVVVVVV----VVVVYV#you#have#a#good#feeling#these####';
  FP[12]:='VVVVVVVVVVVVVVVVVVV--�-VVVVVVV##################################';
  FP[13]:='VVYYYVVVVVVVVVVVVV----VVVVVVVV#questions#might#finally#be#######';
  FP[14]:='VVVVVVVVYVVVYVVVV----VVVYYYVVV##################################';
  FP[15]:='VVVVVVVVYVVVVVVV--�-VVVVVVVVVV#answered#during#this#expedition�#';
  FP[16]:='VVVVVVVVYVVVVVVV----VVVYYVVVVV##################################';
  FP[17]:='YYVVVYVVVVVVVVV----VVVVYVVVVVV#but#can#you#survive#to#learn#the#';
  FP[18]:='VYVVVVVVVVVVVV--�-VVVVVVVVVVYV##################################';
  FP[19]:='VVVVVVVVYVVVV----VVVYVVVVVVVVV#answers�##a#deep#lava#pit#lies###';
  FP[20]:='VVYVVVVVVVVV----VVVYYVVVVVVVVV##################################';
  FP[21]:='VVYYVVVVVVV-�--VVVVVVVVVVYYYVV#before#you#forbidding#your#######';
  FP[22]:='VVVVVVVYVV----VVYYVVVVVVVVVVVV##################################';
  FP[23]:='VVVVVVVVVLLLLVVVVYVVVVVYVVVVVV#progress���it#doesn�t#work����###';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=1;Sideways:=true; HideStairs:=true;
 end; { Level55 }

procedure Level56;
 begin
  FP[1]:= 'YVV P VVVYVVVVVYVVVVVVYVVYVVVVVXXVVVVVVVVV#U#VVVVVV�-----7�--!~+';
  FP[2]:= 'VVV---VVVVVYVVVVVVVYVVVVYVVVYVVXXVVVVVVVVVV-VVVVVVVO#########X##';
  FP[3]:= 'VYV--WVVYVVVVVYVVVVVVYVVVVYVVVVXXVVVVVVVVV---VVVVVVOVVVVVVVVVRVV';
  FP[4]:= 'VVVV---VVVYVVVVVYVYVVVVVYVVVVYVXXVVVVVVVVV---VVVVVVOVVVVVVVVVRVV';
  FP[5]:= 'VVYV---VYVVVVYVVVVVVVYVVVVVYVVVXXVVVVVVVVV--VVVVVVVOVVVVVVVVVRVV';
  FP[6]:= 'VVVVV---VVVVVVVYVVVVVVVYVVVVVYVXXVVVVVVVVVV--VVVVVVOVVVVVVVVVRVV';
  FP[7]:= 'VVYVVV---VVYVYVVVVYVVVYVVVVYVVVXXVVVVVVVVVV--VVVVVVOVVVVVVVVVRVV';
  FP[8]:= 'VYVVYVV-W-VVVVVYVVVVYVVVVYVVVYVXXVVVVVVVVVV--VVVVVVOVVVVVVVVVRVV';
  FP[9]:= 'VVYVVVV---VVYVVVVYVVVVYVVVVYVVVXXVVVVVVVVVVVHHVVVVVOVVVVVVVVVRVV';
  FP[10]:='VYVVYVVV---VVVYVVVVYVVVVYVVVYVVXXVVVVVVVVVVV--VVVVVOVVVVVVVVVRVV';
  FP[11]:='VVVYVVYVV---VYVVYVVVVYVVVVYVVVVXXVVVVVVVVVVV--VVVVVOVVVVVVVVVRVV';
  FP[12]:='VYVVYVVVV---VVVVVVVYVVVYVVVVVYVXXVVVVVVVVVV--VVVVVVOVVVVVVVVVRVV';
  FP[13]:='VVVVVVVYVV-W-VVYVVYVVVVVVVYVYVVXXVVVVVVVVVV--VVVVVVOVVVVVVVVVRVV';
  FP[14]:='VVYVYVVVV---VVVVYVVVVYVVYVVVVVVXXVVVVVVVVVV--VVVVVVOVVVVVVVVVRVV';
  FP[15]:='YVVVVVVYVV---VVYVVYVVVVVVVVYVVVXXVVVVVVVVV--VVVVVVVOVVVVVVVVVRVV';
  FP[16]:='VVYVVYVVVVV-W-VVVYVVVVVYVVVVVYVXXVVVVVVVVV�-VVVVVVVOVVVVVVVVVRVV';
  FP[17]:='VYVVVVVVYVV---VVYVVVVYVVVVVYVVVXXVVVVVVVVV--VVVVVVVOVVVVVVVVVRVV';
  FP[18]:='VVVVYVYVVVYV---VVVVYVVVVYVVVYVVXXVVVVVVVVV--VVVVVVVOVVVVVVVVVRVV';
  FP[19]:='VYVVVVVYVVVVV---VVYVVVYVVVYVVVVXXVVVVVVVV--VVVVVVVVOVVVVVVVVVRVV';
  FP[20]:='VVVYVVVVVVYVVV-W-VVVYVVVYVVVVYVXXVVVVVVVV--VVVVVVVVOVVVVVVVVVRVV';
  FP[21]:='YVVVVVVVYVVVYVV---VVVVYVVVYVVVVXXVVVVVVVV--VVVVVVVVOVVVVVVVVVRVV';
  FP[22]:='VVVYVYVVVVYVVVV---VVYVVVYVVVVYVXXVVVVVVVVV--VVVVVVVOVVVVVVVVVRVV';
  FP[23]:='VYVVVVYVVVVVYVV#U#VVVVYVVVYVYVVXXVVVVVVVVV----------VVVVVVVVLLLV';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=1;Sideways:=true;
 end; { Level56 }

procedure Level59;
 begin
  FP[1]:= '##########K]K-WWWW�D          00%00         D�D�D�&&LL##########';
  FP[2]:= '##VVVVVV############          00000    .    ############VVVVVV##';
  FP[3]:= '##VVVVVV44                                            44VVVVVV##';
  FP[4]:= '##VVVVVV44      .      .                        .     44VVVVVV##';
  FP[5]:= '#####44444                               )            44444#####';
  FP[6]:= 'MMMM(                           P  .                       )MMMM';
  FP[7]:= 'MMMM(                   (                                  )MMMM';
  FP[8]:= 'MMMM(         .                                   (        )MMMM';
  FP[9]:= 'MMMM(                                 .                    )MMMM';
  FP[10]:='MMMM(                      44444444444                 .   )MMMM';
  FP[11]:='MMMM(                      44VVVVVVV44                     )MMMM';
  FP[12]:='CMMM(   .                  44VVVGVVV44       .             )MMMC';
  FP[13]:='MMMM(          )       .   44VVVVVVV44                     )MMMM';
  FP[14]:='MMMM(                      44444444444                     )MMMM';
  FP[15]:='MMMM(                                           )          )MMMM';
  FP[16]:='MMMM(                                   .                  )MMMM';
  FP[17]:='MMMM(     .       .                                .       )MMMM';
  FP[18]:='MMMM(                                                      )MMMM';
  FP[19]:='#####44444                     .            .         44444#####';
  FP[20]:='##VVVVVV44         (                     (            44VVVVVV##';
  FP[21]:='##VVVVVV44                 )                          44VVVVVV##';
  FP[22]:='##VVVVVV############          00000  .      ############VVVVVV##';
  FP[23]:='##########K]-WWWWWW�          00C00         D-D--K-K]K##########';
  Fast:=#234;{or #1}
  Convert_Format;
  LavaFlow:=true;LavaRate:=140;
  HideCreate:=true;HideOpenWall:=true;HideTrap:=true;HideMBlock:=true;
 end; { Level59 }

procedure Level61;
 begin
  FP[1]:= '     U--2--U--2--U--2--U--2--U--55-====-===--=====-===--==--=--=';
  FP[2]:= ' #######-#####-#####-#####-#######=-==-=-=-==--==-=-=-==--==-==-';
  FP[3]:= ' ######-B-###-B-###-B-###-B-######==--===-=====--===W==========-';
  FP[4]:= ' ########chamber#of#horror########======================-------=';
  FP[5]:= ' ##22222222222222222222222222##�##=---=-=-=-==--==--=---========';
  FP[6]:= ' ##22222222222222222222222222222##-===-=-=-=--==-=-=-=====-----=';
  FP[7]:= ' ##22222222222222222222222########=-============-=-===----=====-';
  FP[8]:= ' ##2222222222222222222222266"0LL##-==-=-=-W-====-==---======---=';
  FP[9]:= ' ####-############################=--=-=-===-===-========---====';
  FP[10]:='      ##---##�OOOOOOOOO33333333!##=========-====-====----===-===';
  FP[11]:='########---##H####################==----====-====-�--========--�';
  FP[12]:='<F  22##111##��333333##3333333-[##=-====-==-============--======';
  FP[13]:='FF  22##���##��333333##3333333--##-===-==-==------=====-==-=--==';
  FP[14]:='    22##YYY##��333333##333333333##-==-=-==-=======-===-====-==-=';
  FP[15]:=' P  22##���##�#########444444444##=--==-==W======-===-========-=';
  FP[16]:='    22##111##        ##         ##=====-===------===-==---=-===-';
  FP[17]:='    22##���######### ##   ##�   ##=--==-============-=-===-=---=';
  FP[18]:='    22##             ##   �##   ##-==W==-=====---===-==--=======';
  FP[19]:='    22##   ~~~~~  ## ##   ##�   ##=-==-==-===-===--==-===W=----=';
  FP[20]:='    22##   ~~%~~  ## ##   �##   ##==-==-==---==-===--==-==-====-';
  FP[21]:='    22##   ~~0~~  ## ##   ##�   ##===-=-======-=--====-=-=====-=';
  FP[22]:='    22##�  ~~0~~  ## ##   �##   ##=-=-==-=-==-==-=--==-=-==-===-';
  FP[23]:='      77�  ~~     ##      ##�   44-=-====-=--==|====--===--=---=';
  Fast:=#1;
  Convert_Format;
 end; { Level61 }

procedure Level64;
 begin
  FP[1]:= '3333333333333333333333333333333333333333333333333333##C33�)))F��';
  FP[2]:= '4444444444444444444444444444444444444444444444444444##333�))F)��';
  FP[3]:= 'LL@@@@;@@@@@@@F@@;@@@@@@@@F@@@;@@@@@@@@@F@@@@@@@@@@@##333�))))F)';
  FP[4]:= 'LL@;@@@@F@@;@@@@@@@@F@@;@@@@F@@@@@F@@@;@@@@@F@@@;@F@##333�)F))))';
  FP[5]:= '#########################@@@;@@@F@@;@@F@@@@F@@@F@@@@##333�)))F))';
  FP[6]:= '  �        ���      YY>##&@@@@F@;@@@F@@@F@@;@F@�����##333�)F))))';
  FP[7]:= '88~  ��##-##3�      YYY#########################����##333�))))F)';
  FP[8]:= 'M�~  �3## ##3�              D��F��D77777777777##6666#####�FFFFFF';
  FP[9]:= 'M�~  �3##S##3����������� P  #######77777777777##�����33##T������';
  FP[10]:='M�~  �3##F##33333333333�   +##�K�##77777777777##�������####YYY##';
  FP[11]:='M�~����#######################(((##77777777777--����������������';
  FP[12]:='M�~    �333333333WWW�  ��999##���###############################';
  FP[13]:='M�~    ��������������  ##MMM##(((##33333333333333333333333333333';
  FP[14]:='M�~                   �##MOM##(((##33333333333333333333333333333';
  FP[15]:='M�~           �     #####OMO##���##33333333333333333333333333333';
  FP[16]:='M�~               ��##K##MOM##(((##(((((((((((((((((((((((((((((';
  FP[17]:='M�~   �          ��3##�##OMO##((((((((((((((((((((((((((((((((((';
  FP[18]:='M�~             ��33##-##MOM##(YY++YY((YYYYY+((+YYYY+(YYYYYYY(((';
  FP[19]:='XX~            ��333##-##OMO##(YY+YY+((YY++YY((YY++YY(++++YY+(((';
  FP[20]:='XX~ ������ �  ��3333##�##MOM##(YYYY++((YYYYY+((YY++YY(+++YY++(((';
  FP[21]:='XX~ �3333�    �3333C##-##OUO##(YYYY++((YY+YY+((YY++YY(++YY+++(((';
  FP[22]:='XX~ ##################-#######(YY+YY+((YY++YY((YY++YY(+YY++++(((';
  FP[23]:='X!~     �����          ���~H##(YY++YY((YY++YY((+YYYY+(YYYYYYY((U';
  Fast:=#1; 
  Convert_Format;
 end; { Level64 }

procedure Level66;
 begin
  FP[1]:= '--------------------#figurit�s#revenge#ii#-----�-----!-------4U#';
  FP[2]:= ' P  �666666666666---------------------K------+�-9999999999999#-#'; 
  FP[3]:= '     66           -------�-----------�9999999#####�####5####-#2#';
  FP[4]:= '     66 +� WWWWWWW ------------------------------------�##YYY#-#';
  FP[5]:= '   ; 668888888888888888888888888888888888888�------YY---##YYY#2#';
  FP[6]:= '000~ 66---------------------------�������---------------##YYY#-#';
  FP[7]:= 'VVV~ 66-------------------------------------------------##YYY#B#';
  FP[8]:= '-<-~ 66-------------------------------------------0----�##YYY#-#';
  FP[9]:= '-[-~ 66---------.U.-----------------.�.---------#####�#-##YYY#2#';
  FP[10]:='-|-~ 66----------------------------------------------�#Y##YYY#-#';
  FP[11]:='-"-~� --+++.+++.+++.+++.+++--------------------------�#�##KY�#2#';
  FP[12]:='-�-~-7777777777777777777777777--###########----------�#-##-###-#';
  FP[13]:='---~662222222222222222222222266-DDVVLLLVVDD 2              2    ';
  FP[14]:='����������������������������������������������������������������';
  FP[15]:='#diary�#day#six�################################################';
  FP[16]:='################################################################';
  FP[17]:='#it�s#becoming#more#and#more#difficult#to#survive�##the#idea#of#';
  FP[18]:='################################################################';
  FP[19]:='#turning#back#now#hangs#heavy#on#your#thoughts�##how#much#can###';
  FP[20]:='################################################################';
  FP[21]:='#any#adventurer#take#before#adversity#wins�##but#your#will#and##';
  FP[22]:='################################################################';
  FP[23]:='#courage#guide#you#now�#and#they#refuse#to#let#you#give#up���###';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level66 }

procedure Level68;
 begin
  FP[1]:= '----W---I------:--"0|0[0<0--:----------------:------------------';
  FP[2]:= '�YYYYYYYY------:--666666666�:----------�####-#LL-DDD------------';
  FP[3]:= '---------------:------------:------�########-#9999999�----------';
  FP[4]:= '---------------:---------------�############�########�##--------';
  FP[5]:= '---------------:--YYYYYYYYY-########C-;22;--]---------##--------';
  FP[6]:= '-:----------�-----YYYYYYYYY-############################�::::::;';
  FP[7]:= '-~�~-~------U-----YYYYYYYYY-##--�------------------------:------';
  FP[8]:= '-~�~-~------------YYYYKYYYY-##!##--------******0---------:------';
  FP[9]:= '-~�~9~------------��������--##-##YYYY::::YYYYYYYYYYYYYYY-------K';
  FP[10]:='-~�~�~----------------------##K##------------------------------U';
  FP[11]:='�~-9-9-------------------------##VVVVVVVVVVVVVVVVVV##-----------';
  FP[12]:='#########################piece#o�#cake�##############4444444####';
  FP[13]:='-: P :-------------------:-������--:----------------------------';
  FP[14]:='-:   :-�############MMMMM#-X77777#-#--�88888#######0-----######�';
  FP[15]:='-:   :-�-----------#MMMMM#-�:::::#I#--�--------0CC~------#�....-';
  FP[16]:='-: W :-�-----------#MMMMM#-X-----#-#--�88888##5#########Y######-';
  FP[17]:='-:   :-�-----------#MMMMM#-�-----#F#--�-----##K##---------------';
  FP[18]:='-: W :-�-----------#MM�MM#-X-]+++#�#--�-----##�##               ';
  FP[19]:='-:   :---�---------#::::;#-�-YYYY#;#--�------                   ';
  FP[20]:='T     -7777777777�    2       -       2     -      2    -     2 ';
  FP[21]:=';;;;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;XXXXXXXX~~~~~~~XXXX';
  FP[22]:='                                                        �       ';
  FP[23]:='VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV#-#VVVVVV';
  Fast:=#234;{or #1}
  Convert_Format;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level68 }

procedure Level70;
 begin
  FP[1]:= '----------�HT66-;K-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)-- 66111�111--';
  FP[2]:= '-66666666666666-66))))))))))))))))))))))))))))))))66 6611111116-';
  FP[3]:= '----------66----662222222222222222222222222222222266 6611111116�';
  FP[4]:= '66�����66-66-66-66((((((((((((((((((((((((((((((((66 66666-6666-';
  FP[5]:= '661111166-66�66--(22222222222222222222222222222222--       YY�6<';
  FP[6]:= '666666666-66-666666666666666666666666666666666666666 66666-66666';
  FP[7]:= '----�--------66666>;S---622222222222222222222222662YWY2666-66666';
  FP[8]:= 'I6666666666666666666666-6@@@@@@@@@@@@@@@@@@@@@@@662YPY266W6666//';
  FP[9]:= 'O:OO:::O:OO:66�-�-�66K@@@@                      662YWY26W666///\';
  FP[10]:=':O::O:O:O::O66-LLL-666666@@@@@@@@@@@@@@@@@@@@   6666 666666//\"\';
  FP[11]:=':::::O::::O:66DDDDD6666662222222222222222222@        66666//\\\\';
  FP[12]:=':OOO::::O::O66DDDDD6666666666666666666666666666666666666///\\\\\';
  FP[13]:='O:::O:OO:O:O664444466666666666666666666666666666---6666///\\\U\\';
  FP[14]:=':O[66O66::O:6666666-1-1-1-1-1-1-1-1-1-1-1-1-1-1--U-666///\\\\\\\';
  FP[15]:='RRRR6-6RRRRRRR6666666666666666666666666666666666---66////\\\\\\\';
  FP[16]:='RRRR6-6RRRRRRRRRRRRRRRRRRRRRRRRRQX.X.X.X.X.X.X.X6666////\\\\\\\\';
  FP[17]:='?]]66-66]]RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR66-66\';
  FP[18]:='-------------------$$$$$$$$�RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR6-6RR';
  FP[19]:='$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$�RRRRR6-6RR';
  FP[20]:='WWWWWWWWWW$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$66-66+';
  FP[21]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[22]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  FP[23]:='KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM|MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM';
  Fast:=#234;{or #1}
  Convert_Format;
 end; { Level70 }

procedure Level72;
 begin
  FP[1]:= '----------------------?##2--------;;TTTT#-�-------�------�------';
  FP[2]:= '�~~~~~~~~~~~~~~~~~~~~~-P##�##############----------------------�';
  FP[3]:= '�0-���������������-K# +##--:-�;-&-�-�-�-�----------------------�';
  FP[4]:= '�###�################ ##----#mystery#ramp#----I----------------�';
  FP[5]:= '��##-82-2-2-2-2-2-8Q#  ##2----------�---:-------|----[-----I---�';
  FP[6]:= '�###-################  T##-############-:---"--------I---------�';
  FP[7]:= '�2##---Y-Y-Y-Y-Y-Y-C# +##---D�����--.##�:-----------------<----�';
  FP[8]:= '�###-################ ##---##VVVVV##-##-:----------------------�';
  FP[9]:= '�2##-F�;;***++++++�2#  ##2-##-----##*##::-�-------�------�-----�';
  FP[10]:='�###-################  T##-##::::;##*##------------------------�';
  FP[11]:='�2##-0-�-�-�-�-�-�-C# +##--##�-!--##*##VVVVVVVVVVVVVVVVVVVVVV##�';
  FP[12]:='�###-################ ##---#######-#-##########################�';
  FP[13]:='�2##----2----2-----�#  ##2-::CWWWW:-�-----7---D.##.------------�';
  FP[14]:='�#################�##  T##-::;:::##�###########-##-#######99999�';
  FP[15]:='�2##]-------;------�# +##--:-------�-##WWW------##-##88---#####�';
  FP[16]:='�###-################ ##---:-�������-##########-##-##�#########�';
  FP[17]:='�2##11111111111111-C#  ##2---�-----Y-:2222222222##K##-------88#�';
  FP[18]:='�#########Y##########  T##---�-------#X###########X##########�#�';
  FP[19]:='�2##-------�## 8 2   -+##--::::-:::--#-----`--LL##---K---7----#�';
  FP[20]:='�###-#########  ~00000##-------+-----#############---##########�';
  FP[21]:='�2##�           ~      ##2--------------�-�-�-�-�-�------------�';
  FP[22]:='�###            ~      T##X###########0XXXXXXXXXXXXXXX---------�';
  FP[23]:='C2-2-2-2-2-2-2-2~ YYY-�44--�����M�M�##�-2222222222222XWWWWWWWWWW';
  Fast:=#234;{or #1}
  Convert_Format;
  MagicEWalls:=true;
  GravOn:=true;GravRate:=0;Sideways:=true;
 end; { Level72 }

procedure Level74;
 begin
  FP[1]:= '    0             #heat#wave�#    @�RRRRR22222222222222222244�`L';
  FP[2]:= ';;===00  99999F                   @@@RRRRR2222222222222222244�::';
  FP[3]:= '$===00   99�99.             F  .      RRRRRR22222222222222244444';
  FP[4]:= 'W====00  99999        F .         ���   RRRRR2222222222222222222';
  FP[5]:= 'WW====0            .    77777            RRRRRR22222222222222222';
  FP[6]:= 'WWW===00        F       77�77.    F     F RRRRRR2222222222222222';
  FP[7]:= '�$====0   F             77777            .  RRRRRR22222222222222';
  FP[8]:= '�=====00  $$$$$$$$$$$ F      F@@@@@@@@@      RRRRRR2222222222222';
  FP[9]:= '====000   $222222222$         @2222222@   F    RRRRR222222222222';
  FP[10]:='==000     ##############################        RRRRRR2222222222';
  FP[11]:='00� � � �Z##2-U-<##2-U-[##2-U-|##2-U-"##Z .   P   RRRRRR22222222';
  FP[12]:='#############################################��    RRRRRRR222222';
  FP[13]:='K88------�##�-----88K##K88-----�##�-----88K##2� F    RRRRRRR2222';
  FP[14]:='#########-##-##################-##-##########2�   .    RRRRRRR22';
  FP[15]:='Q002222222222222222222222222222222222222222##2�      F   RRRRRRR';
  FP[16]:='0002222222222222222222222222222222222222222##2�            RRRRR';
  FP[17]:='0002222222222222222222222222222222222222222##��  F       F   RRR';
  FP[18]:='666666666666666666666666666666666666666666688        .     .    ';
  FP[19]:=')))))))))))))))))))))))))))))))))))))))))))##5#######��      :  ';
  FP[20]:='MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM##-:-�-:�62�    :::  ';
  FP[21]:='(((((((((((((((((((((((((((((((((((((((((((##-:-:-:�#2� F ::>:: ';
  FP[22]:='####-########################################-:-:-:-#2�    :;:  ';
  FP[23]:='�00---22222222222222222-<[|"D-�-D-�-D-�-��!##-�-:-�-#2�    :   U';
  Fast:=#234;{or #1}
  Convert_Format;
  HideMBlock:=true;
 end; { Level74 }

procedure Level75;
 begin
  FP[1]:= '��22222229       &#the#sacred#chamber#of#kroz#&2      82222222��';
  FP[2]:= '��22222999      F       $�$$$$$$$$$$$�$ 2    .    F   88822222��';
  FP[3]:= '22222999     2� .   �   $$$333333333$$$         �    2  88822222';
  FP[4]:= '222999   �   ###        $$3=========3$$   ]    ###        888222';
  FP[5]:= '2999   .     #K#       $$3==�������==3$$       #�# .        8882';
  FP[6]:= '99   F  ]    #K#  2   $$3==���VVV���==3$$   2  #2#    �    2  88';
  FP[7]:= 'RRRRRRR      #0#      $3==����VAV����==3$      #2#       RRRRRRR';
  FP[8]:= '22222RR.     #0# .    $3==����VVV����==3$ .    #2#  2   .RR22222';
  FP[9]:= '22222RR  2   #0#      $$3==����6����==3$$      #2#       RR22222';
  FP[10]:='22222RR      #D#   2   $$3==���&���==3$$    �  #D#     2 RR22222';
  FP[11]:='22222RR                 $$3==��0��==3$$                  RR22222';
  FP[12]:='22222RR     2        ]   $3==��G��==3$    �    .   2   . RR22222';
  FP[13]:='22222RR  .     �     .   $$3==�D�==3$$                ]  RR22222';
  FP[14]:='22222RR    F              $$3=====3$$   2      2    �    RR22222';
  FP[15]:='RRRRRRR 2         2        $$33333$$       ]      F     2RRRRRRR';
  FP[16]:='444444444444444�            $$$$$$$   .      .  H444444444444444';
  FP[17]:='77777777777777###   � .        P           2   ###YYYYYYYYYYYYYY';
  FP[18]:='77777777777777#U#       2                      #U#YYXXXXXXXXXXXX';
  FP[19]:='77777777777777#-#  2       .   T      2        #0#YYXXYYYYYYYYYY';
  FP[20]:='77777777777777#<#   ]          � 2       �    2#0#YYXXYYOOOOOOOO';
  FP[21]:='77777777777777#[#        2  5555555 N     .    #0#YYXXYYOOYYYYYY';
  FP[22]:='77777777777777#|#          55DDDDD55 2      F  #0#YYXXYYOOYYXXXX';
  FP[23]:='K777777777777C#"#E  2     555D]!]D555     2    40#CYXXYYOOYYXX]K';
  Fast:=#234;{or #1}
  Convert_Format;
  MagicEWalls:=true;HideCreate:=true;EvapoRate:=22;
 end; { Level75 }

BEGIN
END.
