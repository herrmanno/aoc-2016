program Day_16;

uses strutils, sysutils;
// uses sysutils;

const
    START_INPUT = '10111100110001111';
    MAX_LENGTH = 35651584;

var
    reverse: boolean;
    data: ansistring;
    chunk: ansistring;
    checksum: ansistring;
    readData: longint;
    tmp: ansistring;
    chunksize: longint;

function getChunksize(const input: integer): integer;
var
    i: integer;
    size: integer;
begin
    size:=1;
    i:=input;

    while((i and 1) = 0) do
    begin
        i:=Round(i / 2);
        size:=size + 1;
    end;

    getChunksize:=Round(input / size);
end;

function generateData(const input: ansistring): ansistring;
var    
    reversed: ansistring;
begin
    reversed:=copy(input, 1, length(input));
    reversed:=ReverseString(reversed);

    if(reverse) then
        generateData:=Concat(input, '0', reversed)
    else
        generateData:=Concat(reversed, '0', input);
    
    reverse:=reverse xor true;
end;


function generateChecksum(const chunk: ansistring): ansistring;
var
    count: longint;
    i: longint;
begin
    count:=0;
    i:=0;
    while(i < length(data)) do
    begin
        if data[i] = '1' then
            count:=count+1;

        i:=i+1;
    end;

    if(count*2 = length(data)) then
        generateChecksum:='1'
    else
        generateChecksum:='0';
end;


begin    
    reverse:= false;
    readData:=0;
    chunksize:=getChunksize(MAX_LENGTH);
    data:='';
    checksum:='';

    while(readData < MAX_LENGTH) do
    begin
        while(length(data) < chunksize) do
        begin
            tmp:=generateData(START_INPUT);
            readData:=readData+length(tmp);
            data:=concat(data, tmp);
        end;

        chunk:=copy(data, 1, chunksize);
        data:=copy(data, getChunksize(MAX_LENGTH), length(data));
        
        checksum:=concat(checksum, generateChecksum(chunk));
        
    end;

    write(checksum);
    write('\n');
end.