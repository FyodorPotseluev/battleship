program battleship;
uses crt;
const
    GameFieldSize = 10;
    NumberOfFields = 2;
    WaterImg = '~';
    SplashImg = '*';
    ShipImg = '#';
    HitImg = 'X';
    LastLetter = char(64 + GameFieldSize);

type
    cell = (water, splash, ship, hit);
    visibility = (shown, hidden);
    GameField = record
        map: array ['A'..LastLetter, 1..GameFieldSize] of cell;
        show: visibility;
        number: byte;                           {Field's number on the screen}
    end;

function
    TwoDigits: boolean;                         {Are there two digits in cell                                                    addresses?}
begin
    TwoDigits := GameFieldSize >= 10;
end;

function
    FieldGap(var field: GameField): word;       {Calculate spc field taking up}
begin
    if TwoDigits then
        FieldGap := 2 * GameFieldSize + 1
    else
        FieldGap := 2 * GameFieldSize;
end;

function
    SideGap(var field: GameField): word;        {Calculating gap aside field}
var
    gap: word;
begin
    gap := (ScreenWidth - FieldGap(field) * NumberOfFields) div (NumberOfFields + 1);
    SideGap := field.number * gap + (field.number - 1) * FieldGap(field) + 1;
end;

function
    AboveGap: word;                             {Calculating gap above fields}
begin
    AboveGap:= (ScreenHeight - (GameFieldSize + 1)) div 2 + 1;
end;

procedure
    InitialFieldSetup(var field: GameField);    {Setting up initial field value}
var
    c: char;
    i: byte;
begin
    for c := 'A' to LastLetter do
        begin
        for i := 1 to GameFieldSize do
            field.map[c,i] := water;
        end;
end;

function
    AddressString(var field: GameField): string;
var
    str: string;
    c, i: byte;
begin
    if TwoDigits then                           {Writing corner of field}
        str := '   '
    else
        str := '  ';
    c := 65;                                    {A in ASCII code}
    for i := 65 to (ord(LastLetter)) do         {Writing adres capital letters}
        begin
        str := str + chr(c) + ' ';
        c := c + 1;
        end;
    AddressString := str;
end;

procedure
    ShowWater(c: char);
begin
    TextColor(Cyan);
    if c = LastLetter then
        write(WaterImg)
    else
        write(WaterImg, ' ');
end;

procedure
    ShowSplash(c: char);
begin
    TextColor(LightGray);
    if c = LastLetter then
        write(SplashImg)
    else
        write(SplashImg, ' ');
end;

procedure
    ShowShip(c: char);
begin
    TextColor(LightMagenta);
    if c = LastLetter then
        write(ShipImg)
    else
        write(ShipImg, ' ');
end;

procedure
    ShowHit(c: char);
begin
    TextColor(LightRed);
    if c = LastLetter then
        write(HitImg)
    else
        write(HitImg, ' ');
end;

procedure
    ShowingField(var field: GameField);
var
    i: word;
    c: char;
begin
    GotoXY(SideGap(field), AboveGap);
    TextColor(LightGray);
    write(AddressString(field));
    for i := 1 to GameFieldSize do
        begin
        GotoXY(SideGap(field), AboveGap + i);
        TextColor(LightGray);
        if i < 10 then
            write (' ', i, ' ')
        else
            write(i, ' ');
        for c := 'A' to LastLetter do
            begin
            case field.map[c, i] of
                water:
                    ShowWater(c);
                splash:
                    ShowSplash(c);
                ship:
                    ShowShip(c);
                hit:
                    ShowHit(c);
                end;
            end;
        end;
end;

var
    player, AI: GameField;
begin
    clrscr;
    player.number := 1;
    AI.number := 2;
    player.show := shown;
    AI.show := hidden;
    InitialFieldSetup(player);
    InitialFieldSetup(AI);
    ShowingField(player);
    ShowingField(AI);
    GotoXY(1, 1);
    while true do
        if KeyPressed then
            break;
    clrscr;
    write(#27'[O')
end.
