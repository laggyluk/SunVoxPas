program SunVoxTest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, sysutils,
  {$ifdef Linux}
    sunvox in './../sunvox.pas';
  {$endif}
  {$ifdef Windows}
    sunvox in '.\..\sunvox.pas';
  {$endif}

var
  ver,major,minor1,minor2:integer;
begin
  if sv_load_dll>0 then begin
     writeln('couldn''t load library!');
     readln;
     exit;
  end;
  ver := sv_init( nil, 44100, 2, 0 );
  if ver >= 0 then begin
     major := ( ver >> 16 ) and 255;
     minor1 := ( ver >> 8 ) and 255;
     minor2 := ( ver ) and 255;
     writeln(format('SunVox lib version: %d.%d.%d ', [major, minor1, minor2]));
     sv_open_slot( 0 );

     writeln('Loading SunVox song from file...');
     if sv_load( 0, 'test.sunvox') = 0 then
        writeln('Loaded song')
     else
        writeln( 'Load error.' );
     sv_volume( 0, 256 );

     //Send two events (Note ON):
     sv_send_event( 0, 0, 64, 128, 7, 0, 0 );
     sleep( 1 );
     sv_send_event( 0, 0, 64, 128, 7, 0, 0 );
     sleep( 1 );

     sv_play_from_beginning( 0 );
     writeln('Playing.. press enter to stop');
     //writeln('Line counter: ', sv_get_current_line( 0 ) );
     readln;
     sv_stop( 0 );
     sv_close_slot( 0 );

     sv_deinit();
   end
   else
     writeln(format('sv_init() error %d', [ver] ));

   sv_unload_dll();
end.

