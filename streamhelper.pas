unit StreamHelper;

{$mode objfpc}
{$h+}

{ Unit StreamHelper

  This uit provides safe reading methods for TStream descendants.
  The TryReadXXX functions won't raise exceptions when trying to read
  beyond the end of the stream.

  Copyright (C) 2014 by Bart Broersma and Flying Sheep Software
  http://www.flyingsheep.nl/software.htm

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


interface

uses
  SysUtils, Classes;

type

  { TStreamHelper }

  TStreamHelper = class helper for TStream
  public
    function TryReadByte(out B: Byte): Boolean;
    function TryReadWord(out W : Word): Boolean;
    function TryReadDWord(out DW : DWord): Boolean;
    function TryReadQWord(out QW : QWord): Boolean;
    //convenience functions
    function TryReadInt16(out I16: Int16): Boolean;
    function TryReadInt32(out I32: Int32): Boolean;
    function TryReadInt64(out I64: Int64): Boolean;
    function TryReadAnsiChar(out C: AnsiChar): Boolean;
    function TryReadWideChar(out WC: WideChar): Boolean;
  end;

implementation

{ TStreamHelper }

function TStreamHelper.TryReadByte(out B: Byte): Boolean;
begin
  Result := (Read(B{%H-}, SizeOf(Byte)) = SizeOf(B));
end;

function TStreamHelper.TryReadWord(out W: Word): Boolean;
begin
  Result := (Read(W{%H-}, SizeOf(Word)) = SizeOf(Word));
end;

function TStreamHelper.TryReadDWord(out DW: DWord): Boolean;
begin
  Result := (Read(DW{%H-}, SizeOf(DWord)) = SizeOf(DWord));
end;

function TStreamHelper.TryReadQWord(out QW: QWord): Boolean;
begin
  Result := (Read(QW{%H-}, SizeOf(QWord)) = SizeOf(QWord));
end;

function TStreamHelper.TryReadInt16(out I16: Int16): Boolean;
begin
  Result := (Read(I16{%H-}, SizeOf(Int16)) = SizeOf(Int16));
end;

function TStreamHelper.TryReadInt32(out I32: Int32): Boolean;
begin
  Result := (Read(I32{%H-}, SizeOf(Int32)) = SizeOf(Int32));
end;

function TStreamHelper.TryReadInt64(out I64: Int64): Boolean;
begin
  Result := (Read(I64{%H-}, SizeOf(Int64)) = SizeOf(Int64));
end;

function TStreamHelper.TryReadAnsiChar(out C: AnsiChar): Boolean;
begin
  Result := (Read(C{%H-}, SizeOf(AnsiChar)) = SizeOf(AnsiChar));
end;

function TStreamHelper.TryReadWideChar(out WC: WideChar): Boolean;
begin
  Result := (Read(WC{%H-}, SizeOf(WideChar)) = SizeOf(WideChar));
end;

end.
