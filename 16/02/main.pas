program Day_16;

uses strutils, sysutils;
// uses sysutils;

const
    START_INPUT = '10111100110001111';
    MAX_LENGTH = 35651584;

var
    data: ansistring;
    checksum: ansistring;

function generateData(const input: ansistring; const maxLength: integer): ansistring;
var    
    a: ansistring;
    b: ansistring;
    data: ansistring;
begin
    data:=input;

    while(Length(data) <= maxLength) do
    begin
        a:=copy(data, 1, Length(data));
        b:=copy(data, 1, Length(data));
        b:=ReverseString(b);
        b:=StringReplace(b, '0', 'N', [rfReplaceAll]);
        b:=StringReplace(b, '1', 'E', [rfReplaceAll]);
        b:=StringReplace(b, 'N', '1', [rfReplaceAll]);
        b:=StringReplace(b, 'E', '0', [rfReplaceAll]);
        data:=Concat(a, '0', b);
    end;
        
    data:=copy(data, 1, maxLength);
    generateData:=data;
end;


function generateChecksum(const data: ansistring): ansistring;
var
    i: integer;
    checksum: ansistring;
begin
    checksum:='';

    i:=1;
    while i < length(data) do
    begin
        if data[i] <> data[i+1] then
            checksum:=concat(checksum, '0')
        else
            checksum:=concat(checksum, '1');

        i:=i+2;
    end;

    if(length(checksum) and 1 = 0) then // even length
        generateChecksum:=generateChecksum(checksum)
    else
        generateChecksum:=checksum;
end;


begin
    data:=generateData(START_INPUT, MAX_LENGTH);
    writeln(length(data));
    checksum:=generateChecksum(data);

    write(checksum);
    write('\n');
end.