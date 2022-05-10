unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    ColorBox3: TColorBox;
    ColorBox4: TColorBox;
    PaintBox1: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    ColorBox5: TColorBox;
    ColorBox6: TColorBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Type
  tW3d = record                   { �������� ���� �������� }
           xw, yw, ww, hw : word; { ��������� ���� }
           x0, y0 : word;         { ������ ���������� ��������� }
           xe, yxe, yye, ze : word; { ��������� ���������� ���� }
           mx, my, mz : real;       { �������� �� ���� X, Y, Z }
         end;
Var
  w : tW3d;                { ���� ��������     }
  N : integer;
  M : real;
implementation

{$R *.dfm}



Procedure DPoint( var w : Tw3D; x, y, z : real;color : longint );
{ ����������� ����� � ��������                 }
Const pi4 = pi / 4;
Var yx, yy : word;        { ���������� ����� �� ��� y }
    xs, ys : word;        { ���������� ����� � ��������� ������ }
Begin
  with w do
    begin
    yx := x0 - round( my * y * sin( pi/4.0 ) ); { x ��������� y }
    yy := y0 + round( my * y * cos( pi/4.0 ) ); { y ��������� y }

    xs := yx + round( mx * x );{x-���������� � ��������� ������ }
    ys := yy - round( mz * z );{y-���������� � ��������� ������ }

    Form1.PaintBox1.Canvas.Pixels [ xs, ys ]:= color;  { ����� <x,y,z> }
    end;
End; { DPoint }


Procedure DVector( var w : Tw3D;x1, y1, z1, x2, y2, z2 : real; color : longint );
{ ����������� ������� � �������� �� ����������� ���� ����� }
Const pi4 = pi / 4;
Var yx, yy : word;   { ���������� ����� �� ��� y }
    xs1, ys1 : word; { �����. ������ ������� � �������� � ������ }
    xs2, ys2 : word; { �����. ����� ������� � ��������� ������ }
Begin
  with w do
    begin
                      { ������ ������� }
    yx := x0 - round( my * y1 * sin( pi4 ) );  { x ��������� y1 }
    yy := y0 + round( my * y1 * cos( pi4 ) );  { y ��������� y1 }

    xs1 := yx + round( mx * x1 );    { ������ ������� �� ������ }
    ys1 := yy - round( mz * z1 );

                       { ����� ������� }
    yx := x0 - round( my * y2 * sin( pi4 ) );  { x ��������� y2 }
    yy := y0 + round( my * y2 * cos( pi4 ) );  { y ��������� y2 }

    xs2 := yx + round( mx * x2 );     { ����� ������� �� ������ }
    ys2 := yy - round( mz * z2 );     { ����� ������� �� ������ }
    end;
  with Form1.PaintBox1.Canvas  do
    begin
    Pen.Color :=  color;                           { ���� ������� }
    Pen.Style := psSolid;
    MoveTo ( xs1,ys1);
    LineTo ( xs2, ys2 );           { ������ }
    end;
End; { DVector }

Procedure Win3D( var w : Tw3d; fx, fy, fw, fh : word; bx : real );
{    ���� ���������� �������� �������� }
Var  r, rx, ry : word;
Begin
  with w do
    begin
    xw := fx;                { ��������� ���� }
    yw := fy;
    ww := fw;
    hw := fh;
    x0 := xw + ww div 2 - 60; { ������ ��������� }
    y0 := yw + hw div 2 + 60;

    xe  := xw + ww - 60;      { ��������� ��� x }
    ze  := yw + 40;           { ��������� ��� z }

    rx:=x0-(xw+20);           { ����� ����� xw ��� ��� Y }
    ry:=(yw+hw-20)-y0;        { ����� ����� yw ��� ��� Y }
    if rx>ry then r:=ry else r:=rx;{ ���������� ����� }
    yxe := x0 - r   ;         { x-���������� ��������� ��� y }
    yye := y0 + r;            { y-���������� ��������� ��� y }
    mx := ( xe - x0 ) / bx;          { ����� �������� �� 1 �� X }
    my := mx / 2;                { ���������� �������� �������� }
    mz := mx;                  { ���������� ������� �� ���� X,Z }

{ ��������� ���� ��������� }
    with Form1.PaintBox1.Canvas do
      begin
      Pen.Color:=clSilver;
      Pen.Style:=psSolid;
      Pen.Width:=1;
      MoveTo( x0, y0);
      LineTo( yxe, yye );        { ��� Y }
      MoveTo( x0, y0);
      LineTo( x0, ze );          { ��� Z }
      MoveTo( x0, y0);
      LineTo ( xe,y0);           { ��� X }
      Font.Style:=[fsBold,fsItalic];
      Font.Color:=clYellow;
      TextOut(xe+7,y0-5,'X');
      TextOut(yxe-10,yye+3,'Y');
      TextOut(x0-5,ze-15,'Z');
      end;
    end;
End; { Win3D }






procedure TForm1.Button1Click(Sender: TObject);
Var
  r : tRect;
  A1, B1, C1, D1 : real;   { ������������ ��������� ��������� 1 }
  A2, B2, C2, D2 : real;   { ������������ ��������� ��������� 2 }
  A3, B3, C3, D3 : real;   { ������������ ��������� ��������� 3 }
  A4, B4, C4, D4 : real;   { ������������ ��������� ��������� 4 }
  x1, x2, x3, x4, y1, y2, y3, y4,
  z1, z2, z3, z4 : real;   { ��� ������ }
  x, y, z : real;          { ���������� ����� }
  i : word;                                        { ���� ����� }
  rx, ry ,rz: real;   { ��������� ����������� ��������� ����� }
  f : TextFile;    { ���� ������������ ����� }
  tf1 : boolean;   { ����� �� ��������� 1: �� ��� ���? }
  tf2 : boolean;   { ����� �� ��������� 2: �� ��� ���? }
  tf3,tf4, tf5, tf6, tf7 : boolean;   { ����� ����� ���������� }
  t : real;
  k : longint;
begin

N:=strtoint(Edit1.Text);
M:=strtoFloat(Edit2.Text);

  with PaintBox1.Canvas do
    begin
      Brush.Style:=bsSolid;
      Brush.Color:=clBlack;
      r:= Rect (15,34,485,365);
      Fillrect( r);
      end;
  M:=strtofloat(Edit2.Text);
  Win3D ( w,15,34,470,300,M);

  Randomize;    {  ��������� ��������� ����� }
  AssignFile( f, 'point.txt' );      { ��� ����� }
  Rewrite( f ); { ������� ���� ��� ������    }

  with StringGrid1 do
  begin
   A1 := strtofloat(Cells[1,1]);  B1 := strtofloat(Cells[2,1]);
   C1 := strtofloat(Cells[3,1]);  D1 := strtofloat(Cells[4,1]);
   A2 := strtofloat(Cells[1,2]);  B2 := strtofloat(Cells[2,2]);
   C2 := strtofloat(Cells[3,2]);  D2 := strtofloat(Cells[4,2]);
   A3 := strtofloat(Cells[1,3]);  B3 := strtofloat(Cells[2,3]);
   C3 := strtofloat(Cells[3,3]);  D3 := strtofloat(Cells[4,3]);
   A4 := strtofloat(Cells[1,4]);  B4 := strtofloat(Cells[2,4]);
   C4 := strtofloat(Cells[3,4]);  D4 := strtofloat(Cells[4,4]);
  end;

   //rx := - ( B2*0 + C2*0 + D2 )/A2;



{ --------------��������� 1 ---------------- }
  rz :=  -( A1*0+B1*0+D1 )/C1;

  for i := 1 to N do         { �������� ����� ��������� }
    begin
    z := rz ;    //���������� y:
   // x := rx*random;  // ���������� x (� ������ �����������):
    y:= (rz)*random;
    x:= rz*random;
   // y := -( A1*x+C1*z+D1 )/B1;
   //z := ry*random;  // ���������� z:
    //z:= (10/3)*random;
    writeln( f, x:6:2, y:6:2, z:6:2 );
    end;
{ --------------��������� 2 ----------------- }

  //rx := - ( B2*0 + C2*0 +D2 )/A2;  { rx = x2(y=0,z=0)}

  for i := 1 to N do
    begin
   // x:= - ( B2*y + C2*z +D2 )/A2; ;  { ���������� x }
    y := (rz)*random; { ���������� y2}
    z := rz*random;
    //z := - ( A2*x + B2*y + D2 ) / C2;
    x:= - ( B2*y + C2*z +D2 )/A2; ;
    //z := rz*random; { ���������� z2}
   // z:= (10/3)*random;
    writeln( f, x:6:2, y:6:2, z:6:2 );
    end;
{ -------------��������� 3----------------- }

  for i := 1 to N do
    begin
    x := (rz)*random;  { ���������� x: }
    y := (-C3*12/B3)*random; { ���������� y: }
    z := - ( A3*x + B3*y + D3 )/C3; { ���������� z2}
    writeln( f, x:6:2, y:6:2, z:6:2 );
    end;

   CloseFile( f );

  { -------------��������� 4----------------- }


  y1 := 0; x1 := 0;
  z1 := -( A4*x1 + B4*y1 + D4 ) / C4;  { �� ��� Z }

  x2 := 12;  z2 := z1;
  y2 := 0;    { �� ��� Y}
  DVector( w, x1, y1, z1, x2, y2, z2,clYellow ); { ���� � XY }

  x3 := 0; y3 := 12; z3 := z1;    { � ��������� XZ }
  DVector( w, x1, y1, z1, x3, y3, z3, clYellow ); { ���� � XZ }
 // x4 := 0;  y4 := y2;  z4 := 14;  {  }
  //DVector ( w, x2, y2, z2, x4, y4, z4, clYellow); { ���� � YZ}




   Memo1.Clear;
   Reset( f );
   i := 0;                { ������ ����� }
  while not eof( f ) do
    begin
    i := i + 1;
    readln( f, x, y, z );
    Memo1.Lines.Add( Format('%8d',[i])+
                         Format('%8.2n',[x])+
                         Format('%8.2n',[y])+
                         Format('%8.2n',[z]));


   tf3 := A3*x + B3*y + C3*z + D3 < 0; { ����� �� ����������� � ��. 3? }
   tf5:=  A4*x + B4*y + C4*z + D4 < 0;
   tf6:=  A1*x + B1*y + C1*z + D1 < 0;
   tf7:=  A2*x + B2*y + C2*z + D2 < 0;

   tf1 := abs( A1*x + B1*y + C1*z + D1 ) < 0.1;{ �� ��������� 1? }
   if tf1 then  { ��, ����� �� ��.1}
      begin
      if not tf7 then DPoint( w, x, y, z, clBlack)
        else
         if tf5 then DPoint( w, x, y, z, ColorBox1.Selected)
             else
             DPoint( w, x, y, z, ColorBox2.Selected ); { ����� ��.3}
      continue
      end;

     tf2 := abs ( A2*x + B2*y + C2*z +D2 ) < 0.1; { �� ��.2 ?}
     if tf2 then { ��, ����� �� ��.2}
      begin
       if not tf3 then DPoint( w, x, y, z, clblack)
       else
        if tf5 then DPoint( w, x, y, z, ColorBox3.Selected)
            else
            DPoint( w, x, y, z, ColorBox4.Selected ); { ����� ��.3}
       continue
       end;

      tf4 := abs ( A3*x + B3*y + C3*z +D3 ) < 0.1; { �� ��.2 ?}
      if tf4 then
      begin
       if not tf7 then DPoint( w, x, y, z, clblack)
       else
       if tf5 then DPoint( w, x, y, z, ColorBox5.Selected)
        else
       DPoint( w, x, y, z, ColorBox6.Selected ); { ����� ��.3}
       continue
       end;
       end;
    { while not eof ...}
    CloseFile( f );
end;

procedure TForm1.Button2Click(Sender: TObject);
var r:Trect;
begin
  with PaintBox1.Canvas do
    begin
      Brush.Style:=bsSolid;
      Brush.Color:=clBlack;
      r:= Rect (15,34,485,365);
      Fillrect( r);
      end;
end;

procedure TForm1.Button3Click(Sender: TObject);
 var w:integer;
begin
 StringGrid1.Cells[0,0]:='� + ����';
 StringGrid1.Cells[1,0]:='  �  ';
 StringGrid1.Cells[2,0]:='  B  ';
 StringGrid1.Cells[3,0]:='  C  ';
 StringGrid1.Cells[4,0]:='  D  ';
 StringGrid1.Cells[0,1]:='  1  ';
 StringGrid1.Cells[0,2]:='  2  ';
 StringGrid1.Cells[0,3]:='  3  ';
 StringGrid1.Cells[0,4]:='  4  ';

 StringGrid1.Cells[1,1]:='0';
 StringGrid1.Cells[2,1]:='0';
 StringGrid1.Cells[3,1]:='1';
 StringGrid1.Cells[4,1]:='-12';

 StringGrid1.Cells[1,2]:='1';
 StringGrid1.Cells[2,2]:='0';
 StringGrid1.Cells[3,2]:='-0,6';
 StringGrid1.Cells[4,2]:='0';

 StringGrid1.Cells[1,3]:='0';
 StringGrid1.Cells[2,3]:='0,6';
 StringGrid1.Cells[3,3]:='-0,6';
 StringGrid1.Cells[4,3]:='0';

 StringGrid1.Cells[1,4]:='0';
 StringGrid1.Cells[2,4]:='0';
 StringGrid1.Cells[3,4]:='1';
 StringGrid1.Cells[4,4]:='-6';

  Colorbox1.Selected:=clGreen;
  Colorbox2.Selected:=clLime;
  Colorbox3.Selected:=clMaroon;
  Colorbox4.Selected:=clRed;
  Colorbox5.Selected:=clTeal;
  Colorbox6.Selected:=clAqua;
 
 Edit1.Text:='2000';
 N:=strtoint(Edit1.Text);
 Edit2.Text:='20';
 M:=strtoFloat(Edit2.Text);
end;

end.
