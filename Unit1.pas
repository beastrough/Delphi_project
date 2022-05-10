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
  tW3d = record                   { атрибуты окна диметрии }
           xw, yw, ww, hw : word; { геометрия окна }
           x0, y0 : word;         { начало декартовых координат }
           xe, yxe, yye, ze : word; { окончание декартовых осей }
           mx, my, mz : real;       { масштабы по осям X, Y, Z }
         end;
Var
  w : tW3d;                { окно диметрии     }
  N : integer;
  M : real;
implementation

{$R *.dfm}



Procedure DPoint( var w : Tw3D; x, y, z : real;color : longint );
{ изображение точки в диметрии                 }
Const pi4 = pi / 4;
Var yx, yy : word;        { координаты точки на оси y }
    xs, ys : word;        { координаты точки в плоскости экрана }
Begin
  with w do
    begin
    yx := x0 - round( my * y * sin( pi/4.0 ) ); { x объемного y }
    yy := y0 + round( my * y * cos( pi/4.0 ) ); { y объемного y }

    xs := yx + round( mx * x );{x-координата в плоскости экрана }
    ys := yy - round( mz * z );{y-координата в плоскости экрана }

    Form1.PaintBox1.Canvas.Pixels [ xs, ys ]:= color;  { точка <x,y,z> }
    end;
End; { DPoint }


Procedure DVector( var w : Tw3D;x1, y1, z1, x2, y2, z2 : real; color : longint );
{ изображение вектора в диметрии по координатам двух точек }
Const pi4 = pi / 4;
Var yx, yy : word;   { координаты точки на оси y }
    xs1, ys1 : word; { коорд. начала вектора в плоскост и экрана }
    xs2, ys2 : word; { коорд. конца вектора в плоскости экрана }
Begin
  with w do
    begin
                      { начало вектора }
    yx := x0 - round( my * y1 * sin( pi4 ) );  { x объемного y1 }
    yy := y0 + round( my * y1 * cos( pi4 ) );  { y объемного y1 }

    xs1 := yx + round( mx * x1 );    { начало вектора на экране }
    ys1 := yy - round( mz * z1 );

                       { конец вектора }
    yx := x0 - round( my * y2 * sin( pi4 ) );  { x объемного y2 }
    yy := y0 + round( my * y2 * cos( pi4 ) );  { y объемного y2 }

    xs2 := yx + round( mx * x2 );     { конец вектора на экране }
    ys2 := yy - round( mz * z2 );     { конец вектора на экране }
    end;
  with Form1.PaintBox1.Canvas  do
    begin
    Pen.Color :=  color;                           { цвет вектора }
    Pen.Style := psSolid;
    MoveTo ( xs1,ys1);
    LineTo ( xs2, ys2 );           { вектор }
    end;
End; { DVector }

Procedure Win3D( var w : Tw3d; fx, fy, fw, fh : word; bx : real );
{    Окно кабинетной проекции диметрии }
Var  r, rx, ry : word;
Begin
  with w do
    begin
    xw := fx;                { геометрия окна }
    yw := fy;
    ww := fw;
    hw := fh;
    x0 := xw + ww div 2 - 60; { начало координат }
    y0 := yw + hw div 2 + 60;

    xe  := xw + ww - 60;      { окончание оси x }
    ze  := yw + 40;           { окончание оси z }

    rx:=x0-(xw+20);           { катет вдоль xw для оси Y }
    ry:=(yw+hw-20)-y0;        { катет вдоль yw для оси Y }
    if rx>ry then r:=ry else r:=rx;{ наименьший катет }
    yxe := x0 - r   ;         { x-координата окончания оси y }
    yye := y0 + r;            { y-координата окончания оси y }
    mx := ( xe - x0 ) / bx;          { число пикселей на 1 по X }
    my := mx / 2;                { кабинетная проекция диметрии }
    mz := mx;                  { одинаковый масштаб по осям X,Z }

{ рисование осей координат }
    with Form1.PaintBox1.Canvas do
      begin
      Pen.Color:=clSilver;
      Pen.Style:=psSolid;
      Pen.Width:=1;
      MoveTo( x0, y0);
      LineTo( yxe, yye );        { ось Y }
      MoveTo( x0, y0);
      LineTo( x0, ze );          { ось Z }
      MoveTo( x0, y0);
      LineTo ( xe,y0);           { ось X }
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
  A1, B1, C1, D1 : real;   { коэффициенты уравнения плоскости 1 }
  A2, B2, C2, D2 : real;   { коэффициенты уравнения плоскости 2 }
  A3, B3, C3, D3 : real;   { коэффициенты уравнения плоскости 3 }
  A4, B4, C4, D4 : real;   { коэффициенты уравнения плоскости 4 }
  x1, x2, x3, x4, y1, y2, y3, y4,
  z1, z2, z3, z4 : real;   { для следов }
  x, y, z : real;          { координаты точки }
  i : word;                                        { цикл точек }
  rx, ry ,rz: real;   { диапазоны генераторов случайных чисел }
  f : TextFile;    { файл произвольных точек }
  tf1 : boolean;   { точка на плоскости 1: Да или Нет? }
  tf2 : boolean;   { точка на плоскости 2: Да или Нет? }
  tf3,tf4, tf5, tf6, tf7 : boolean;   { точка перед плоскостью }
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

  Randomize;    {  генератор случайных чисел }
  AssignFile( f, 'point.txt' );      { имя файла }
  Rewrite( f ); { открыть файл для записи    }

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



{ --------------Плоскость 1 ---------------- }
  rz :=  -( A1*0+B1*0+D1 )/C1;

  for i := 1 to N do         { создание точек плоскости }
    begin
    z := rz ;    //координата y:
   // x := rx*random;  // координата x (с учетом пересечения):
    y:= (rz)*random;
    x:= rz*random;
   // y := -( A1*x+C1*z+D1 )/B1;
   //z := ry*random;  // координата z:
    //z:= (10/3)*random;
    writeln( f, x:6:2, y:6:2, z:6:2 );
    end;
{ --------------Плоскость 2 ----------------- }

  //rx := - ( B2*0 + C2*0 +D2 )/A2;  { rx = x2(y=0,z=0)}

  for i := 1 to N do
    begin
   // x:= - ( B2*y + C2*z +D2 )/A2; ;  { координита x }
    y := (rz)*random; { координата y2}
    z := rz*random;
    //z := - ( A2*x + B2*y + D2 ) / C2;
    x:= - ( B2*y + C2*z +D2 )/A2; ;
    //z := rz*random; { координита z2}
   // z:= (10/3)*random;
    writeln( f, x:6:2, y:6:2, z:6:2 );
    end;
{ -------------Плоскость 3----------------- }

  for i := 1 to N do
    begin
    x := (rz)*random;  { координита x: }
    y := (-C3*12/B3)*random; { координата y: }
    z := - ( A3*x + B3*y + D3 )/C3; { координита z2}
    writeln( f, x:6:2, y:6:2, z:6:2 );
    end;

   CloseFile( f );

  { -------------Плоскость 4----------------- }


  y1 := 0; x1 := 0;
  z1 := -( A4*x1 + B4*y1 + D4 ) / C4;  { на оси Z }

  x2 := 12;  z2 := z1;
  y2 := 0;    { на оси Y}
  DVector( w, x1, y1, z1, x2, y2, z2,clYellow ); { след в XY }

  x3 := 0; y3 := 12; z3 := z1;    { в плоскости XZ }
  DVector( w, x1, y1, z1, x3, y3, z3, clYellow ); { след в XZ }
 // x4 := 0;  y4 := y2;  z4 := 14;  {  }
  //DVector ( w, x2, y2, z2, x4, y4, z4, clYellow); { след в YZ}




   Memo1.Clear;
   Reset( f );
   i := 0;                { номера точек }
  while not eof( f ) do
    begin
    i := i + 1;
    readln( f, x, y, z );
    Memo1.Lines.Add( Format('%8d',[i])+
                         Format('%8.2n',[x])+
                         Format('%8.2n',[y])+
                         Format('%8.2n',[z]));


   tf3 := A3*x + B3*y + C3*z + D3 < 0; { точка до пересечения с пл. 3? }
   tf5:=  A4*x + B4*y + C4*z + D4 < 0;
   tf6:=  A1*x + B1*y + C1*z + D1 < 0;
   tf7:=  A2*x + B2*y + C2*z + D2 < 0;

   tf1 := abs( A1*x + B1*y + C1*z + D1 ) < 0.1;{ на плоскости 1? }
   if tf1 then  { да, точка на пл.1}
      begin
      if not tf7 then DPoint( w, x, y, z, clBlack)
        else
         if tf5 then DPoint( w, x, y, z, ColorBox1.Selected)
             else
             DPoint( w, x, y, z, ColorBox2.Selected ); { перед пл.3}
      continue
      end;

     tf2 := abs ( A2*x + B2*y + C2*z +D2 ) < 0.1; { на пл.2 ?}
     if tf2 then { да, точка на пл.2}
      begin
       if not tf3 then DPoint( w, x, y, z, clblack)
       else
        if tf5 then DPoint( w, x, y, z, ColorBox3.Selected)
            else
            DPoint( w, x, y, z, ColorBox4.Selected ); { перед пл.3}
       continue
       end;

      tf4 := abs ( A3*x + B3*y + C3*z +D3 ) < 0.1; { на пл.2 ?}
      if tf4 then
      begin
       if not tf7 then DPoint( w, x, y, z, clblack)
       else
       if tf5 then DPoint( w, x, y, z, ColorBox5.Selected)
        else
       DPoint( w, x, y, z, ColorBox6.Selected ); { перед пл.3}
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
 StringGrid1.Cells[0,0]:='№ + коэф';
 StringGrid1.Cells[1,0]:='  А  ';
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
