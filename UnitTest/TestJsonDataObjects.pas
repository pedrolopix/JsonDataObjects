unit TestJsonDataObjects;

interface

uses
  TestFramework, System.Classes, JsonDataObjects, System.SysUtils;

type
  TestTJsonBaseObject = class(TTestCase)
  private
    procedure LoadFromEmptyStream;
    procedure LoadFromArrayStreamIntoObject;
    procedure ParseUtf8BrokenJSON1;
    procedure ParseUtf8BrokenJSON2;
    procedure ParseUtf8BrokenJSON3;
    procedure ParseUtf8BrokenJSON5;
    procedure ParseUtf8BrokenJSON6;
    procedure ParseUtf8BrokenJSON4;
    procedure ParseUtf8BrokenJSON7;
    procedure ParseBrokenJSON1;
    procedure ParseBrokenJSON2;
    procedure ParseBrokenJSON3;
    procedure ParseBrokenJSON4;
    procedure ParseBrokenJSON5;
    procedure ParseBrokenJSON6;
    procedure ParseBrokenJSON7;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestNewInstance;
    procedure TestParseUtf8Empty;
    procedure TestParseUtf8EmptyObjectArray;
    procedure TestParseUtf8;
    procedure TestParseUtf8BrokenJSON;
    procedure TestParseEmpty;
    procedure TestParseEmptyObjectAndArray;
    procedure TestParse;
    procedure TestParseBrokenJSON;
    procedure TestParseFromStream;
    procedure TestLoadFromStream;
    procedure TestSaveToStream;
    procedure TestSaveToLines;
    procedure TestToJSON;
    procedure TestToString;
    procedure TestDateTimeToJSON;
  end;

  TestTJsonArray = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestClear;
    procedure TestDelete;
    procedure TestAssign;
    procedure TestAdd;
    procedure TestInsert;
  end;

  TestTJsonObject = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAssign;
    procedure TestClear;
    procedure TestRemove;
    procedure TestDelete;
    procedure TestIndexOf;
    procedure TestContains;
    procedure TestAccess;
    procedure TestAutoArrayAndObjectCreationOnAccess;
    procedure TestEasyAccess;
    procedure TestObjectAssign;
    procedure TestToSimpleObject;
    procedure TestFromSimpleObject;
  end;

implementation

{ TestTJsonBaseObject }

procedure TestTJsonBaseObject.SetUp;
begin
end;

procedure TestTJsonBaseObject.TearDown;
begin
end;

procedure TestTJsonBaseObject.TestNewInstance;
var
  O: TJsonObject;
  A: TJsonArray;
begin
  O := TJsonObject.Create;
  try
    CheckEquals(0, O.Count);
    CheckEquals(0, O.Capacity);
  finally
    O.Free;
  end;

  A := TJsonArray.Create;
  try
    CheckEquals(0, A.Count);
    CheckEquals(0, A.Capacity);
  finally
    A.Free;
  end;
end;

procedure TestTJsonBaseObject.TestParseUtf8Empty;
begin
  Check(TJsonBaseObject.ParseUtf8('') = nil, '1: nil expected');
  Check(TJsonBaseObject.ParseUtf8('', 0) = nil, '2: nil expected');
  Check(TJsonBaseObject.ParseUtf8('', -1) = nil, '3: nil expected');
  Check(TJsonBaseObject.ParseUtf8(' ') = nil, '4: nil expected');
  Check(TJsonBaseObject.ParseUtf8(' ', 0) = nil, '5: nil expected');
  Check(TJsonBaseObject.ParseUtf8(' ', 1) = nil, '6: nil expected');
  Check(TJsonBaseObject.ParseUtf8(nil, -1) = nil, '7: nil expected');
  Check(TJsonBaseObject.ParseUtf8(nil, 0) = nil, '8: nil expected');
  Check(TJsonBaseObject.ParseUtf8(#0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15#16#17#18#19#20#21#22#23#24#25#26#27#28#29#31#32, -1) = nil, '9: nil expected');
  Check(TJsonBaseObject.ParseUtf8(#0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15#16#17#18#19#20#21#22#23#24#25#26#27#28#29#31#32, 32) = nil, '10: nil expected');
end;

procedure TestTJsonBaseObject.TestParseUtf8EmptyObjectArray;
var
  B: TJsonBaseObject;
  O: TJsonObject;
  A: TJsonArray;
begin
  B := TJsonBaseObject.ParseUtf8('{}');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(0, O.Count);
    CheckEquals(0, O.Capacity);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('   {}   ');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(0, O.Count);
    CheckEquals(0, O.Capacity);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('[]');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(0, A.Count);
    CheckEquals(0, A.Capacity);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('    []   ');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(0, A.Count);
    CheckEquals(0, A.Capacity);
  finally
    B.Free;
  end;
end;

procedure TestTJsonBaseObject.TestParseUtf8;
var
  B: TJsonBaseObject;
  O: TJsonObject;
  A: TJsonArray;
begin
  B := TJsonBaseObject.ParseUtf8('{ "Key": "Value" }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');
    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtString, 'jdtString expected');
    CheckEquals('Value', O.S['Key']);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('{ "Key": "Value", "SecondKey": "SecondValue" }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(2, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');

    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtString, 'jdtString expected');
    CheckEquals('Value', O.S['Key']);

    CheckTrue(O.Contains('SecondKey'));
    Check(O.Types['SecondKey'] = jdtString, 'jdtString expected');
    CheckEquals('SecondValue', O.S['SecondKey']);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('{ "Key": "Value", "SecondKey": "SecondValue", "Array": [ "Item1", "Item2" ] }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(3, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');

    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtString, 'jdtString expected');
    CheckEquals('Value', O.S['Key']);

    CheckTrue(O.Contains('SecondKey'));
    Check(O.Types['SecondKey'] = jdtString, 'jdtString expected');
    CheckEquals('SecondValue', O.S['SecondKey']);

    CheckTrue(O.Contains('Array'));
    Check(O.Types['Array'] = jdtArray, 'jdtString expected');
    CheckEquals(2, O.A['Array'].Count);
    Check(O.A['Array'].Types[0] = jdtString, 'jdtString expected');
    CheckEquals('Item1', O.A['Array'].S[0]);
    Check(O.A['Array'].Types[1] = jdtString, 'jdtString expected');
    CheckEquals('Item2', O.A['Array'].S[1]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('{ "Key": [] }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');
    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtArray, 'jdtArray expected');
    CheckEquals(0, O.A['Key'].Count);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('{ "Key": [ { "Key": 123, "Bool": true, "Bool2": false, "Null": null, "Float": -1.234567890E10, "Int64": 1234567890123456789 } ] }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');
    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtArray, 'jdtArray expected');
    A := O.A['Key'];
    CheckEquals(1, A.Count);

    Check(A.Types[0] = jdtObject, 'jdtObject expected');
    CheckEquals(6, A.O[0].Count);

    CheckTrue(A.O[0].Contains('Key'));
    Check(A.O[0].Types['Key'] = jdtInt, 'jdtInt expected');
    CheckEquals(123, A.O[0].I['Key']);

    CheckTrue(A.O[0].Contains('Bool'));
    Check(A.O[0].Types['Bool'] = jdtBool, 'jdtBool expected');
    CheckEquals(True, A.O[0].B['Bool']);

    CheckTrue(A.O[0].Contains('Bool2'));
    Check(A.O[0].Types['Bool2'] = jdtBool, 'jdtBool expected');
    CheckEquals(False, A.O[0].B['Bool2']);

    CheckTrue(A.O[0].Contains('Null'));
    Check(A.O[0].Types['Null'] = jdtObject, 'jdtObject expected');
    Check(A.O[0].O['Null'] = nil);

    CheckTrue(A.O[0].Contains('Float'));
    Check(A.O[0].Types['Float'] = jdtFloat, 'jdtFloat expected');
    CheckEquals(-1.234567890E10, A.O[0].F['Float'], 0.00001);

    CheckTrue(A.O[0].Contains('Int64'));
    Check(A.O[0].Types['Int64'] = jdtLong);
    CheckEquals(1234567890123456789, A.O[0].L['Int64'], 'jdtInt64 expected');
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('{ "key": "\u0000" }');
  try
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    CheckEqualsString(#0, O.S['key']);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('{ "key": "X\u0000X" }');
  try
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    CheckTrue(O.Contains('key'));
    CheckFalse(O.Contains('Key'));
    CheckFalse(O.Contains('KEY'));
    CheckFalse(O.Contains('kEy'));
    CheckFalse(O.Contains('kEY'));
    CheckFalse(O.Contains('keY'));
    CheckFalse(O.Contains('KeY'));
    CheckEqualsString('X'#0'X', O.S['key']);
  finally
    B.Free;
  end;

  // Array

  B := TJsonBaseObject.ParseUtf8('[ "Item1" ]');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(1, A.Count);
    Check(A.Capacity >= A.Count, 'A.Capacity >= A.Count');
    Check(A.Types[0] = jdtString);
    CheckEquals('Item1', A.S[0]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('[ "Item1", "Item2"] ]');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(2, A.Count);
    Check(A.Capacity >= A.Count, 'A.Capacity >= A.Count');

    Check(A.Types[0] = jdtString);
    CheckEquals('Item1', A.S[0]);

    Check(A.Types[1] = jdtString);
    CheckEquals('Item2', A.S[1]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('[ "Item1", "Item2", {} ] ]');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(3, A.Count);
    Check(A.Capacity >= A.Count, 'A.Capacity >= A.Count');

    Check(A.Types[0] = jdtString);
    CheckEquals('Item1', A.S[0]);

    Check(A.Types[1] = jdtString);
    CheckEquals('Item2', A.S[1]);

    Check(A.Types[2] = jdtObject);
    CheckEquals(0, A.O[2].Count);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('[ "\u0000" ]');
  try
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(1, A.Count);
    CheckEqualsString(#0, A.S[0]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('[ "X\u0000X" ]');
  try
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(1, A.Count);
    CheckEqualsString('X'#0'X', A.S[0]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.ParseUtf8('[ "\t", "\r\n", "X\r\n", "\r\nX", "Xx\r\n\xX" ]');
  try
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(5, A.Count);
    CheckEqualsString(#9, A.S[0]);
    CheckEqualsString(#13#10, A.S[1]);
    CheckEqualsString('X'#13#10, A.S[2]);
    CheckEqualsString(#13#10'X', A.S[3]);
    CheckEqualsString('Xx'#13#10'xX', A.S[4]);
  finally
    B.Free;
  end;
end;

procedure TestTJsonBaseObject.TestParseEmpty;
begin
  Check(TJsonBaseObject.Parse('') = nil, '1: nil expected');
  Check(TJsonBaseObject.Parse('', 0) = nil, '2: nil expected');
  Check(TJsonBaseObject.Parse('', -1) = nil, '3: nil expected');
  Check(TJsonBaseObject.Parse(' ') = nil, '4: nil expected');
  Check(TJsonBaseObject.Parse(' ', 0) = nil, '5: nil expected');
  Check(TJsonBaseObject.Parse(' ', 1) = nil, '6: nil expected');
  Check(TJsonBaseObject.Parse(nil, -1) = nil, '7: nil expected');
  Check(TJsonBaseObject.Parse(nil, 0) = nil, '8: nil expected');
  Check(TJsonBaseObject.Parse(#0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15#16#17#18#19#20#21#22#23#24#25#26#27#28#29#31#32, -1) = nil, '9: nil expected');
  Check(TJsonBaseObject.Parse(#0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15#16#17#18#19#20#21#22#23#24#25#26#27#28#29#31#32, 32) = nil, '10: nil expected');
end;

procedure TestTJsonBaseObject.TestParseEmptyObjectAndArray;
var
  B: TJsonBaseObject;
  O: TJsonObject;
  A: TJsonArray;
begin
  B := TJsonBaseObject.Parse('{}');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(0, O.Count);
    CheckEquals(0, O.Capacity);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('   {}   ');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(0, O.Count);
    CheckEquals(0, O.Capacity);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('[]');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(0, A.Count);
    CheckEquals(0, A.Capacity);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('    []   ');
  try
    Check(B <> nil, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(0, A.Count);
    CheckEquals(0, A.Capacity);
  finally
    B.Free;
  end;
end;

procedure TestTJsonBaseObject.TestParse;
var
  B: TJsonBaseObject;
  O: TJsonObject;
  A: TJsonArray;
begin
  B := TJsonBaseObject.Parse('{ "Key": "Value" }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');
    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtString, 'jdtString expected');
    CheckEquals('Value', O.S['Key']);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('{ "Key": "Value", "SecondKey": "SecondValue" }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(2, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');

    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtString, 'jdtString expected');
    CheckEquals('Value', O.S['Key']);

    CheckTrue(O.Contains('SecondKey'));
    Check(O.Types['SecondKey'] = jdtString, 'jdtString expected');
    CheckEquals('SecondValue', O.S['SecondKey']);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('{ "Key": "Value", "SecondKey": "SecondValue", "Array": [ "Item1", "Item2" ] }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(3, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');

    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtString, 'jdtString expected');
    CheckEquals('Value', O.S['Key']);

    CheckTrue(O.Contains('SecondKey'));
    Check(O.Types['SecondKey'] = jdtString, 'jdtString expected');
    CheckEquals('SecondValue', O.S['SecondKey']);

    CheckTrue(O.Contains('Array'));
    Check(O.Types['Array'] = jdtArray, 'jdtString expected');
    CheckEquals(2, O.A['Array'].Count);
    Check(O.A['Array'].Types[0] = jdtString, 'jdtString expected');
    CheckEquals('Item1', O.A['Array'].S[0]);
    Check(O.A['Array'].Types[1] = jdtString, 'jdtString expected');
    CheckEquals('Item2', O.A['Array'].S[1]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('{ "Key": [] }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');
    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtArray, 'jdtArray expected');
    CheckEquals(0, O.A['Key'].Count);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('{ "Key": [ { "Key": 123, "Bool": true, "Bool2": false, "Null": null, "Float": -1.234567890E10, "Int64": 1234567890123456789 } ] }');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonObject);
    O := B as TJsonObject;
    CheckEquals(1, O.Count);
    Check(O.Capacity >= O.Count, 'O.Capacity >= O.Count');
    CheckTrue(O.Contains('Key'));
    Check(O.Types['Key'] = jdtArray, 'jdtArray expected');
    A := O.A['Key'];
    CheckEquals(1, A.Count);

    Check(A.Types[0] = jdtObject, 'jdtObject expected');
    CheckEquals(6, A.O[0].Count);

    CheckTrue(A.O[0].Contains('Key'));
    Check(A.O[0].Types['Key'] = jdtInt, 'jdtInt expected');
    CheckEquals(123, A.O[0].I['Key']);

    CheckTrue(A.O[0].Contains('Bool'));
    Check(A.O[0].Types['Bool'] = jdtBool, 'jdtBool expected');
    CheckEquals(True, A.O[0].B['Bool']);

    CheckTrue(A.O[0].Contains('Bool2'));
    Check(A.O[0].Types['Bool2'] = jdtBool, 'jdtBool expected');
    CheckEquals(False, A.O[0].B['Bool2']);

    CheckTrue(A.O[0].Contains('Null'));
    Check(A.O[0].Types['Null'] = jdtObject, 'jdtObject expected');
    Check(A.O[0].O['Null'] = nil);

    CheckTrue(A.O[0].Contains('Float'));
    Check(A.O[0].Types['Float'] = jdtFloat, 'jdtFloat expected');
    CheckEquals(-1.234567890E10, A.O[0].F['Float'], 0.00001);

    CheckTrue(A.O[0].Contains('Int64'));
    Check(A.O[0].Types['Int64'] = jdtLong);
    CheckEquals(1234567890123456789, A.O[0].L['Int64'], 'jdtInt64 expected');
  finally
    B.Free;
  end;

  // Array

  B := TJsonBaseObject.Parse('[ "Item1" ]');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(1, A.Count);
    Check(A.Capacity >= A.Count, 'A.Capacity >= A.Count');
    Check(A.Types[0] = jdtString);
    CheckEquals('Item1', A.S[0]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('[ "Item1", "Item2"] ]');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(2, A.Count);
    Check(A.Capacity >= A.Count, 'A.Capacity >= A.Count');

    Check(A.Types[0] = jdtString);
    CheckEquals('Item1', A.S[0]);

    Check(A.Types[1] = jdtString);
    CheckEquals('Item2', A.S[1]);
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('[ "Item1", "Item2", {} ] ]');
  try
    CheckNotNull(B, 'B <> nil');
    CheckIs(B, TJsonArray);
    A := B as TJsonArray;
    CheckEquals(3, A.Count);
    Check(A.Capacity >= A.Count, 'A.Capacity >= A.Count');

    Check(A.Types[0] = jdtString);
    CheckEquals('Item1', A.S[0]);

    Check(A.Types[1] = jdtString);
    CheckEquals('Item2', A.S[1]);

    Check(A.Types[2] = jdtObject);
    CheckEquals(0, A.O[2].Count);
  finally
    B.Free;
  end;
end;

procedure TestTJsonBaseObject.TestParseFromStream;
var
  Stream: TStringStream;
  B: TJsonBaseObject;
begin
  Stream := TStringStream.Create('', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.ParseFromStream(Stream);
    try
      CheckNull(B, 'B = nil');
      CheckEquals(Stream.Size, Stream.Position);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create('{}', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.ParseFromStream(Stream);
    try
      CheckNotNull(B, 'B <> nil');
      CheckEquals(Stream.Size, Stream.Position);
      CheckIs(B, TJsonObject);
      CheckEquals(0, TJsonObject(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create('{}', TEncoding.Unicode, False);
  try
    B := TJsonBaseObject.ParseFromStream(Stream, TEncoding.Unicode);
    try
      CheckNotNull(B, 'B <> nil');
      CheckEquals(Stream.Size, Stream.Position);
      CheckIs(B, TJsonObject);
      CheckEquals(0, TJsonObject(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create(' [ "Item" ] ', TEncoding.Unicode, False);
  try
    B := TJsonBaseObject.ParseFromStream(Stream, TEncoding.Unicode);
    try
      CheckNotNull(B, 'B <> nil');
      CheckEquals(Stream.Size, Stream.Position);
      CheckIs(B, TJsonArray);
      CheckEquals(1, TJsonArray(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create(' [ "Item" ] ', TEncoding.Default, False);
  try
    B := TJsonBaseObject.ParseFromStream(Stream, TEncoding.Default);
    try
      CheckNotNull(B, 'B <> nil');
      CheckEquals(Stream.Size, Stream.Position);
      CheckIs(B, TJsonArray);
      CheckEquals(1, TJsonArray(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestTJsonBaseObject.LoadFromEmptyStream;
var
  Stream: TStringStream;
  B: TJsonBaseObject;
begin
  Stream := TStringStream.Create('', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.Parse('{ "Key": "Value" }');
    try
      CheckIs(B, TJsonObject);
      CheckEquals(1, TJsonObject(B).Count);
      B.LoadFromStream(Stream);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestTJsonBaseObject.LoadFromArrayStreamIntoObject;
var
  Stream: TStringStream;
  B: TJsonBaseObject;
begin
  Stream := TStringStream.Create('[]', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.Parse('{}');
    try
      CheckIs(B, TJsonObject);
      B.LoadFromStream(Stream);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestTJsonBaseObject.TestLoadFromStream;
var
  Stream: TStringStream;
  B: TJsonBaseObject;
begin
  CheckException(LoadFromEmptyStream, EJsonParserException);
  CheckException(LoadFromArrayStreamIntoObject, EJsonParserException);

  Stream := TStringStream.Create('{}', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.Parse('{ "Key": "Value" }');
    try
      CheckIs(B, TJsonObject);
      CheckEquals(1, TJsonObject(B).Count);
      B.LoadFromStream(Stream);
      CheckEquals(Stream.Size, Stream.Position);
      CheckEquals(0, TJsonObject(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create('{ }', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.Parse('{ "Key": "Value" }');
    try
      CheckIs(B, TJsonObject);
      CheckEquals(1, TJsonObject(B).Count);
      B.LoadFromStream(Stream);
      CheckEquals(Stream.Size, Stream.Position);
      CheckEquals(0, TJsonObject(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create(' [ "Item" ] ', TEncoding.Unicode, False);
  try
    B := TJsonBaseObject.ParseFromStream(Stream, TEncoding.Unicode);
    try
      CheckNotNull(B, 'B <> nil');
      CheckEquals(Stream.Size, Stream.Position);
      CheckIs(B, TJsonArray);
      CheckEquals(1, TJsonArray(B).Count);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestTJsonBaseObject.TestSaveToStream;
var
  Stream: TStringStream;
  B: TJsonBaseObject;
begin
  Stream := TStringStream.Create('', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.Parse('{ "Entry1": "Value1" }');
    try
      CheckNotNull(B, 'B <> nil');
      CheckIs(B, TJsonObject);
      CheckEquals(1, TJsonObject(B).Count);
      CheckEquals('Value1', TJsonObject(B).S['Entry1']);

      B.SaveToStream(Stream);
      Check(Stream.Position > 0, 'Stream.Position > 0');
      Check(Stream.Size > 0, 'Stream.Size > 0');
      CheckEquals('{"Entry1":"Value1"}', Stream.DataString);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;

  Stream := TStringStream.Create('', TEncoding.UTF8, False);
  try
    B := TJsonBaseObject.Parse('{ "Entry1": "Value1" }');
    try
      CheckNotNull(B, 'B <> nil');
      CheckIs(B, TJsonObject);
      CheckEquals(1, TJsonObject(B).Count);
      CheckEquals('Value1', TJsonObject(B).S['Entry1']);

      B.SaveToStream(Stream, False);
      Check(Stream.Position > 0, 'Stream.Position > 0');
      Check(Stream.Size > 0, 'Stream.Size > 0');
      CheckEquals('{' + JsonSerializationConfig.LineBreak +
                  JsonSerializationConfig.IndentChar + '"Entry1": "Value1"' + JsonSerializationConfig.LineBreak +
                  '}' + JsonSerializationConfig.LineBreak, Stream.DataString);
    finally
      B.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestTJsonBaseObject.TestSaveToLines;
var
  Lines: TStrings;
  B: TJsonBaseObject;
  S: string;
begin
  Lines := TStringList.Create;
  try
    CheckEquals(#9, JsonSerializationConfig.IndentChar);

    S :=
      '{' + #13#10 +
      #9'"Entry1": "Value1",' + #13#10 +
      #9'"Entry2": "Value2",' + #13#10 +
      #9'"Entry3": true,' + #13#10 +
      #9'"Entry3": false,' + #13#10 +
      #9'"Entry4": null,' + #13#10 +
      #9'"Entry5": 1234567890123456789,' + #13#10 +
//      #9'"Entry6": 1.12233445E5,' + #13#10 +
      #9'"Entry6": 112233.445,' + #13#10 +
      #9'"Entry7": {' + #13#10 +
      #9#9'"Array": [' + #13#10 +
      #9#9#9'"Item1",' + #13#10 +
      #9#9#9'"Item2"' + #13#10 +
      #9#9']' + #13#10 +
      #9'},' + #13#10 +
      #9'"Entry8": {},' + #13#10 +
      #9'"Entry9": []' + #13#10 +
      '}' + #13#10;

    B := TJsonBaseObject.Parse(S);
    try
      CheckNotNull(B, 'B <> nil');
      CheckIs(B, TJsonObject);

      Lines.LineBreak := #13#10;
      B.SaveToLines(Lines);
      CheckEqualsString(S, Lines.Text);
    finally
      B.Free;
    end;
  finally
    Lines.Free;
  end;
end;

procedure TestTJsonBaseObject.TestToJSON;
var
  B: TJsonBaseObject;
  S, CompactS: string;
begin
  B := TJsonBaseObject.Parse('{}');
  try
    CheckEquals('{}', B.ToJSON);
    CheckEquals('{}', B.ToJSON(True));
    CheckEquals('{}'+JsonSerializationConfig.LineBreak, B.ToJSON(False));
  finally
    B.Free;
  end;

  B := TJsonBaseObject.Parse('{ "Key": "Value" }');
  try
    CheckEquals('{"Key":"Value"}', B.ToJSON);
    CheckEquals('{"Key":"Value"}', B.ToJSON(True));
    CheckEquals('{' + JsonSerializationConfig.LineBreak +
                JsonSerializationConfig.IndentChar + '"Key": "Value"' + JsonSerializationConfig.LineBreak +
                '}'+JsonSerializationConfig.LineBreak, B.ToJSON(False));
  finally
    B.Free;
  end;

  CheckEquals(#9, JsonSerializationConfig.IndentChar);
  S :=
    '{' + JsonSerializationConfig.LineBreak +
    #9'"Entry1": "Value1",' + JsonSerializationConfig.LineBreak +
    #9'"Entry2": "Value2",' + JsonSerializationConfig.LineBreak +
    #9'"Entry3": true,' + JsonSerializationConfig.LineBreak +
    #9'"Entry3": false,' + JsonSerializationConfig.LineBreak +
    #9'"Entry4": null,' + JsonSerializationConfig.LineBreak +
    #9'"Entry5": 1234567890123456789,' + JsonSerializationConfig.LineBreak +
    #9'"Entry6": 112233.445,' + JsonSerializationConfig.LineBreak +
    #9'"Entry7": {' + JsonSerializationConfig.LineBreak +
    #9#9'"Array": [' + JsonSerializationConfig.LineBreak +
    #9#9#9'"Item1",' + JsonSerializationConfig.LineBreak +
    #9#9#9'"Item2"' + JsonSerializationConfig.LineBreak +
    #9#9']' + JsonSerializationConfig.LineBreak +
    #9'},' + JsonSerializationConfig.LineBreak +
    #9'"Entry8": {},' + JsonSerializationConfig.LineBreak +
    #9'"Entry9": []' + JsonSerializationConfig.LineBreak +
    '}' + JsonSerializationConfig.LineBreak;

  CompactS :=
    '{' +
    '"Entry1":"Value1",' +
    '"Entry2":"Value2",' +
    '"Entry3":true,' +
    '"Entry3":false,' +
    '"Entry4":null,' +
    '"Entry5":1234567890123456789,' +
    '"Entry6":112233.445,' +
    '"Entry7":{"Array":["Item1","Item2"]},' +
    '"Entry8":{},' +
    '"Entry9":[]' +
    '}';
  B := TJsonBaseObject.Parse(S);
  try
    CheckEquals(CompactS, B.ToJSON);
    CheckEquals(S, B.ToJSON(False));
  finally
    B.Free;
  end;
end;

procedure TestTJsonBaseObject.TestToString;
var
  B: TJsonBaseObject;
  S: string;
begin
  S :=
    '{' +
    '"Entry1":"Value1",' +
    '"Entry2":"Value2",' +
    '"Entry3":true,' +
    '"Entry3":false,' +
    '"Entry4":null,' +
    '"Entry5":1234567890123456789,' +
    '"Entry6":112233.445,' +
    '"Entry7":{"Array":["Item1","Item2"]},' +
    '"Entry8":{},' +
    '"Entry9":[]' +
    '}';
  B := TJsonBaseObject.Parse(S);
  try
    CheckEquals(B.ToJSON, B.ToString);
  finally
    B.Free;
  end;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON1;
begin
  TJsonBaseObject.ParseUtf8('{').Free;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON2;
begin
  TJsonBaseObject.ParseUtf8('{ "foo" }').Free;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON3;
begin
  TJsonBaseObject.ParseUtf8('{ "foo", "bar" }').Free;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON4;
begin
  TJsonBaseObject.ParseUtf8('{ "foo": "bar" "foo" }').Free;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON5;
begin
  TJsonBaseObject.ParseUtf8('[ 1 ').Free;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON6;
begin
  TJsonBaseObject.ParseUtf8('[ "abc\').Free;
end;

procedure TestTJsonBaseObject.ParseUtf8BrokenJSON7;
begin
  TJsonBaseObject.ParseUtf8('[ "abc\n\').Free;
end;

procedure TestTJsonBaseObject.TestParseUtf8BrokenJSON;
begin
  CheckException(ParseUtf8BrokenJSON1, EJsonParserException);
  CheckException(ParseUtf8BrokenJSON2, EJsonParserException);
  CheckException(ParseUtf8BrokenJSON3, EJsonParserException);
  CheckException(ParseUtf8BrokenJSON4, EJsonParserException);
  CheckException(ParseUtf8BrokenJSON5, EJsonParserException);
  CheckException(ParseUtf8BrokenJSON6, EJsonParserException);
  CheckException(ParseUtf8BrokenJSON7, EJsonParserException);
end;

procedure TestTJsonBaseObject.ParseBrokenJSON1;
begin
  TJsonBaseObject.Parse('{').Free;
end;

procedure TestTJsonBaseObject.ParseBrokenJSON2;
begin
  TJsonBaseObject.Parse('{ "foo" }').Free;
end;

procedure TestTJsonBaseObject.ParseBrokenJSON3;
begin
  TJsonBaseObject.Parse('{ "foo", "bar" }').Free;
end;

procedure TestTJsonBaseObject.ParseBrokenJSON4;
begin
  TJsonBaseObject.Parse('{ "foo": "bar" "foo" }').Free;
end;

procedure TestTJsonBaseObject.ParseBrokenJSON5;
begin
  TJsonBaseObject.Parse('[ 1 ').Free;
end;

procedure TestTJsonBaseObject.ParseBrokenJSON6;
begin
  TJsonBaseObject.Parse('[ "abc\').Free;
end;

procedure TestTJsonBaseObject.ParseBrokenJSON7;
begin
  TJsonBaseObject.Parse('[ "abc\n\').Free;
end;

procedure TestTJsonBaseObject.TestParseBrokenJSON;
begin
  CheckException(ParseBrokenJSON1, EJsonParserException);
  CheckException(ParseBrokenJSON2, EJsonParserException);
  CheckException(ParseBrokenJSON3, EJsonParserException);
  CheckException(ParseBrokenJSON4, EJsonParserException);
  CheckException(ParseBrokenJSON5, EJsonParserException);
  CheckException(ParseBrokenJSON6, EJsonParserException);
  CheckException(ParseBrokenJSON7, EJsonParserException);
end;

procedure TestTJsonBaseObject.TestDateTimeToJSON;
var
  S: string;
  ExpectDt, dt: TDateTime;
begin
  ExpectDt := EncodeDate(2015, 2, 14);
    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, True);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, False);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

  ExpectDt := EncodeDate(2000, 2, 29);
    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, False);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, True);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

  ExpectDt := EncodeDate(2000, 2, 29) + EncodeTime(1, 2, 3, 4);
    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, False);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, True);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

  ExpectDt := EncodeDate(2014, 1, 1) + EncodeTime(5, 4, 2, 1);
    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, False);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

    S := TJsonBaseObject.DateTimeToJSON(ExpectDt, True);
    Dt := TJsonBaseObject.JSONToDateTime(S);
    CheckEquals(ExpectDt, Dt, 'expected datetime: ' + DateTimeToStr(ExpectDt) + ', retured: ' + DateTimeToStr(Dt));

  TJsonBaseObject.JSONToDateTime('2009-01-01T12:00:00+01:00');
  TJsonBaseObject.JSONToDateTime('2009-01-01T12:00:00+0100');
  TJsonBaseObject.JSONToDateTime('2015-02-14T22:58+01:00');
  TJsonBaseObject.JSONToDateTime('2015-02-14T22:58+0100');
end;


{ TestTJsonArray }

procedure TestTJsonArray.SetUp;
begin
end;

procedure TestTJsonArray.TearDown;
begin
end;

procedure TestTJsonArray.TestClear;
var
  A: TJsonArray;
begin
  A := TJsonArray.Create;
  try
    A.FromUtf8JSON('[ 1, 2, { "Key": { "Key": [] } }, true, false, null, 1234, 1234567890123456789, 1.12 ]');
    CheckEquals(9, A.Count);
    A.Clear;
    CheckEquals(0, A.Count);
    A.Add('Hello');
    CheckEquals(1, A.Count);
    A.Clear;
    CheckEquals(0, A.Count);
  finally
    A.Free;
  end;
end;

procedure TestTJsonArray.TestDelete;
var
  A: TJsonArray;
begin
  A := TJsonArray.Create;
  try
    A.FromUtf8JSON('[ 1, 2, { "Key": { "Key": [] } }, true, false, null, 1234, 1234567890123456789, 1.12 ]');
    CheckEquals(9, A.Count);
    CheckEquals(1, A.I[0]);
    A.Delete(0);
    CheckEquals(8, A.Count);
    CheckEquals(2, A.I[0]);

    CheckEquals(1234567890123456789, A.L[6]);
    CheckEqualsString('1.12', A.S[7]);
    A.Delete(7);
    CheckEquals(7, A.Count);
    CheckEquals(1234567890123456789, A.L[6]);
  finally
    A.Free;
  end;
end;

procedure TestTJsonArray.TestAssign;
var
  A, A2: TJsonArray;
begin
  A := TJsonArray.Create;
  try
    A.FromUtf8JSON('[ 1, 2, { "Key": { "Key": [ 123, 2.4, "Hello" ] } }, true, false, null, 1234, 1234567890123456789, 1.12 ]');
    CheckEquals(9, A.Count);

    A2 := TJsonArray.Create;
    try
      A2.Assign(A);
      CheckEqualsString(A.ToJSON, A2.ToJSON);
    finally
      A2.Free;
    end;
  finally
    A.Free;
  end;
end;

procedure TestTJsonArray.TestAdd;
var
  A: TJsonArray;
begin
  A := TJsonArray.Create;
  try
    A.FromUtf8JSON('[ 1, 2, { "Key": { "Key": [] } }, true, false, null, 1234, 1234567890123456789, 1.12 ]');
    CheckEquals(9, A.Count);

    A.FromJSON('[ 1, 2, { "Key": { "Key": [] } }, true, false, null, 1234, 1234567890123456789, 1.12 ]');
    CheckEquals(9, A.Count);
    A.Add('Value9');
    CheckEquals(10, A.Count);
    Check(A.Types[9] = jdtString, 'jdtString');
    CheckEqualsString('Value9', A.S[9]);

    A.Add(10);
    CheckEquals(11, A.Count);
    Check(A.Types[10] = jdtInt, 'jdtInt');
    CheckEquals(10, A.I[10]);

    A.Add(1234567890123456789);
    CheckEquals(12, A.Count);
    Check(A.Types[11] = jdtLong, 'jdtLong');
    CheckEquals(1234567890123456789, A.L[11]);

    A.Add(1.12E5);
    CheckEquals(13, A.Count);
    Check(A.Types[12] = jdtFloat, 'jdtFloat');
    CheckEquals(1.12E5, A.F[12]);

    A.Add(False);
    CheckEquals(14, A.Count);
    Check(A.Types[13] = jdtBool, 'jdtBool');
    CheckEquals(False, A.B[13]);

    A.Add(TJsonObject(nil));
    CheckEquals(15, A.Count);
    Check(A.Types[14] = jdtObject, 'jdtObject');
    CheckNull(A.O[14]);

    A.Add(TJsonArray.Create);
    CheckEquals(16, A.Count);
    Check(A.Types[15] = jdtArray, 'jdtArray');
    CheckNotNull(A.A[15]);

    A.AddObject;
    CheckEquals(17, A.Count);
    Check(A.Types[16] = jdtObject, 'jdtObject');
    CheckNotNull(A.O[16]);

    A.AddArray;
    CheckEquals(18, A.Count);
    Check(A.Types[17] = jdtArray, 'jdtArray');
    CheckNotNull(A.A[17]);

    A.AddObject(nil);
    CheckEquals(19, A.Count);
    Check(A.Types[18] = jdtObject, 'jdtObject');
    CheckNull(A.O[18]);
  finally
    A.Free;
  end;
end;

procedure TestTJsonArray.TestInsert;
var
  A: TJsonArray;
begin
  A := TJsonArray.Create;
  try
    A.FromJSON('[ 1, 2 ]');
    CheckEquals(2, A.Count);

    A.Insert(1, 'Key');
    CheckEquals(3, A.Count);
    CheckEqualsString('Key', A.S[1]);

    A.Insert(0, 'AAA');
    CheckEquals(4, A.Count);
    CheckEqualsString('AAA', A.S[0]);

    A.Insert(4, 'ZZZ');
    CheckEquals(5, A.Count);
    CheckEqualsString('ZZZ', A.S[4]);

    CheckEquals('["AAA",1,"Key",2,"ZZZ"]', A.ToJSON);
  finally
    A.Free;
  end;
end;

{ TestTJsonObject }

procedure TestTJsonObject.SetUp;
begin
end;

procedure TestTJsonObject.TearDown;
begin
end;

procedure TestTJsonObject.TestAssign;
var
  O, O2: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O.FromJSON('{ "Key": "Value", "Array": [ 123, "Abc", true, null, 12.3, 98765432109876, { "Msg": "Exception\tClass\n" } ] }');
    O2 := TJsonObject.Create;
    try
      O2.Assign(O);
      CheckEqualsString(O.ToJSON, O2.ToJSON);
    finally
      O2.Free;
    end;
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestClear;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O.FromJSON('{ "Key": { "Key": [] }, "Delphi": "XE7" }');
    CheckEquals(2, O.Count);
    O.Clear;
    CheckEquals(0, O.Count);
    O.S['Data'] := 'Hello';
    CheckEquals(1, O.Count);
    O.Clear;
    CheckEquals(0, O.Count);
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestRemove;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O.FromJSON('{ "Key": { "Key": [] }, "Delphi": "XE7" }');
    CheckEquals(2, O.Count);
    O.Remove('Key');
    CheckEquals(1, O.Count);
    CheckFalse(O.Contains('Key'));
    CheckTrue(O.Contains('Delphi'));
    CheckEqualsString('XE7', O.S['Delphi']);
    CheckFalse(O.Contains('delphi'));
    O.Remove('delphi');
    CheckTrue(O.Contains('Delphi'));
    CheckEquals(1, O.Count);
    O.Remove('Delphi');
    CheckEquals(0, O.Count);
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestDelete;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O.FromJSON('{ "Key": { "Key": [] }, "Delphi": "XE7" }');
    CheckEquals(2, O.Count);
    O.Delete(0);
    CheckEquals(1, O.Count);
    CheckFalse(O.Contains('Key'));
    CheckTrue(O.Contains('Delphi'));
    CheckEqualsString('XE7', O.S['Delphi']);
    O.Delete(0);
    CheckEquals(0, O.Count);
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestIndexOf;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O.FromJSON('{ "Key": { "Key": [] }, "Delphi": "XE7" }');
    CheckEquals(2, O.Count);
    CheckEquals(1, O.IndexOf('Delphi'));
    CheckEquals(-1, O.IndexOf('delphi'));
    CheckEquals(0, O.IndexOf('Key'));
    CheckEquals(-1, O.IndexOf('key'));
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestContains;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O.FromJSON('{ "Key": { "Key": [] }, "Delphi": "XE7" }');
    CheckEquals(2, O.Count);
    CheckTrue(O.Contains('Delphi'));
    CheckFalse(O.Contains('delphi'));
    CheckTrue(O.Contains('Key'));
    CheckFalse(O.Contains('key'));
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestAccess;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    CheckEquals(0, O.Count);

    O.S['Key'] := 'Value';
    CheckTrue(O.Contains('Key'));
    CheckFalse(O.Contains('key'));
    CheckEquals(0, O.IndexOf('Key'));
    O.O['MyObject'].S['Str'] := 'World';
    O.O['MyObject'].I['Int'] := -123;
    O.O['MyObject'].L['Int64'] := -1234567890123456789;
    O.O['MyObject'].F['Float'] := -12.3456789;
    O.O['MyObject'].B['Bool'] := True;
    O.O['MyObject'].O['Null'] := nil;
    O.A['MyArray'].Add('Hello');

    CheckEquals('{"Key":"Value","MyObject":{"Str":"World","Int":-123,"Int64":-1234567890123456789,"Float":-12.3456789,"Bool":true,"Null":null},"MyArray":["Hello"]}', O.ToJSON);

    CheckEqualsString('Value', O.S['Key']);
    CheckEqualsString('World', O.O['MyObject'].S['Str']);
    CheckEquals(-123, O.O['MyObject'].I['Int']);
    CheckEquals(-1234567890123456789, O.O['MyObject'].L['Int64']);
    CheckEquals(-12.3456789, O.O['MyObject'].F['Float'], 0.0000000001);
    CheckEquals(True, O.O['MyObject'].B['Bool']);
    CheckNull(O.O['MyObject'].O['Null']);
    CheckEquals('Hello', O.A['MyArray'].S[0]);

    // implicit type casts
    O.S['LongStr'] := '-123456789012345';
    O.S['IntStr'] := '123456';
    O.S['FloatStr'] := '12.345';
    O.S['BoolStr'] := 'true';

    CheckEquals(-123456789012345, O.L['LongStr']);
    CheckEquals(-123456789012345, O.F['LongStr']);
    CheckEquals(False, O.B['LongStr']);

    CheckEquals(123456, O.I['IntStr']);
    CheckEquals(123456, O.L['IntStr']);
    CheckEquals(123456, O.F['IntStr'], 0.0000000001);
    CheckEquals(False, O.B['IntStr']);

    CheckEquals(12, O.I['FloatStr']);
    CheckEquals(12, O.L['FloatStr']);
    CheckEquals(12.345, O.F['FloatStr'], 0.0000000001);
    CheckEquals(False, O.B['FloatStr']);

    CheckEquals(True, O.B['BoolStr']);

    CheckEqualsString('-123', O.O['MyObject'].S['Int']);
    CheckEquals(-123, O.O['MyObject'].I['Int']);
    CheckEquals(-123, O.O['MyObject'].L['Int']);
    CheckEquals(-123, O.O['MyObject'].F['Int'], 0.0000000001);
    CheckEquals(True, O.O['MyObject'].B['Int']);

    CheckEqualsString('-1234567890123456789', O.O['MyObject'].S['Int64']);
    //CheckEquals(-1234567890123456789, O.O['MyObject'].I['Int64']);
    CheckEquals(-1234567890123456789, O.O['MyObject'].L['Int64']);
    CheckEquals(FloatToStr(-1234567890123456789), FloatToStr(O.O['MyObject'].F['Int64']));
    CheckEquals(True, O.O['MyObject'].B['Int64']);

    CheckEqualsString('-12.3456789', O.O['MyObject'].S['Float']);
    CheckEquals(-12, O.O['MyObject'].I['Float']);
    CheckEquals(-12, O.O['MyObject'].L['Float']);
    CheckEquals(FloatToStr(-12.3456789), FloatToStr(O.O['MyObject'].F['Float']));
    CheckEquals(True, O.O['MyObject'].B['Float']);

    CheckEqualsString('true', O.O['MyObject'].S['Bool']);
    CheckEquals(1, O.O['MyObject'].I['Bool']);
    CheckEquals(1, O.O['MyObject'].L['Bool']);
    CheckEquals(1, O.O['MyObject'].F['Bool']);
    CheckEquals(True, O.O['MyObject'].B['Bool']);

  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestAutoArrayAndObjectCreationOnAccess;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    CheckEqualsString('', O.S['NewString']); // default ''
    CheckEquals(0, O.I['NewInt']);           // default 0
    CheckEquals(0, O.L['NewInt64']);         // default 0
    CheckEquals(0, O.F['NewFloat']);         // default 0
    CheckEquals(False, O.B['NewBool']);      // default false
    CheckNotNull(O.O['NewObject']);          // auto creation
    CheckNotNull(O.A['NewArray']);           // auto creation

    CheckEquals('{"NewObject":{},"NewArray":[]}', O.ToJSON);
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestEasyAccess;
var
  O: TJsonObject;
  S: string;
  I: Integer;
  L: Int64;
  F: Double;
  B: Boolean;
  Obj: TJsonObject;
  Arr: TJsonArray;
begin
  O := TJsonObject.Create;
  try
    S := O['NewString'];   // default ''
    I := O['NewInt'];      // default 0
    L := O['NewInt64'];    // default 0
    F := O['NewFloat'];    // default 0
    B := O['NewBool'];     // default false
    Arr := O['NewArray'];  // auto creation
    Obj := O['NewObject']; // auto creation

    CheckEqualsString('', S);
    CheckEquals(0, I);
    CheckEquals(0, L);
    CheckEquals(0, F);
    CheckEquals(False, B);
    CheckNotNull(Arr);
    CheckNotNull(Obj);

    O['NewObject']['Value'] := 'Hello';
    S := O['NewObject']['Value'];
    CheckEquals('Hello', S);

    O['NewObject']['IntValue'] := 10;
    I := O['NewObject']['IntValue'];
    CheckEquals(10, I);

    O['NewObject']['FloatValue'] := -55.1;
    F := O['NewObject']['FloatValue'];
    CheckEquals(-55.1, F, 0.000000001);

    O['NewObject']['Array'] := TJsonArray.Create;
    O['NewObject']['Array'].ArrayValue.Add(1);
    I := O['NewObject']['Array'].Items[0];
    CheckEquals(1, I);

    CheckEquals('{"NewArray":[],"NewObject":{"Value":"Hello","IntValue":10,"FloatValue":-55.1,"Array":[1]}}', O.ToJSON);
  finally
    O.Free;
  end;
end;

type
  {$M+}
  TMyObject = class(TObject)
  private
    FMyString: string;
    FMyInt: Integer;
    FMyInt64: Int64;
    FMyDouble: Double;
    FMyBool: Boolean;
    FMyDateTime: TDateTime;
    FMyVariant: Variant;
    FNonStored: string;
  published
    property MyString: string read FMyString write FMyString;
    property MyInt: Integer read FMyInt write FMyInt;
    property MyInt64: Int64 read FMyInt64 write FMyInt64;
    property MyDouble: Double read FMyDouble write FMyDouble;
    property MyBool: Boolean read FMyBool write FMyBool;
    property MyDateTime: TDateTime read FMyDateTime write FMyDateTime;
    property MyVariant: Variant read FMyVariant write FMyVariant;
    property NonStored: string read FNonStored write FNonStored stored False;
  end;

procedure TestTJsonObject.TestToSimpleObject;
var
  O: TJsonObject;
  Obj: TMyObject;
  dt: TDateTime;
begin
  dt := EncodeDate(2014, 12, 31) + EncodeTime(23, 59, 59, 999);

  // Case Sensitive
  O := TJsonObject.Create;
  try
    O['MyString'] := 'Hello World!';
    O['MyInt'] := 135711;
    O['MyInt64'] := 135711131719232931;
    O['MyDouble'] := 3.14159265359;
    O['MyBool'] := True;
    O['MyDateTime'] := TJsonBaseObject.DateTimeToJSON(dt, True);
    O['MyVariant'] := 'Variant String';
    O['NonStored'] := 'xxxxxx';

    Obj := TMyObject.Create;
    try
      Obj.NonStored := 'aaa';
      O.ToSimpleObject(Obj);
      CheckEqualsString('Hello World!', Obj.MyString);
      CheckEquals(135711, Obj.MyInt);
      CheckEquals(135711131719232931, Obj.MyInt64);
      CheckEquals(3.14159265359, Obj.MyDouble, 0.000000000001);
      CheckEquals(True, Obj.MyBool);
      CheckEquals(dt, Obj.MyDateTime);
      Check(Obj.MyVariant = 'Variant String', 'Obj.MyVariant = ''Variant String''');
      CheckEquals('aaa', Obj.NonStored);

      O['MyVariant'] := 123;
      O.ToSimpleObject(Obj);
      Check(Obj.MyVariant = 123, 'Obj.MyVariant = 123');
    finally
      Obj.Free;
    end;
  finally
    O.Free;
  end;

  // Case-Insensitive
  O := TJsonObject.Create;
  try
    O['mystring'] := 'Hello World!';
    O['myint'] := 135711;
    O['myint64'] := 135711131719232931;
    O['mydouble'] := 3.14159265359;
    O['mybool'] := True;
    O['mydatetime'] := TJsonBaseObject.DateTimeToJSON(dt, True);
    O['myvariant'] := 'Variant String';
    O['nonstored'] := 'xxxxxx';

    Obj := TMyObject.Create;
    try
      Obj.NonStored := 'aaa';
      O.ToSimpleObject(Obj, False);
      CheckEqualsString('Hello World!', Obj.MyString);
      CheckEquals(135711, Obj.MyInt);
      CheckEquals(135711131719232931, Obj.MyInt64);
      CheckEquals(3.14159265359, Obj.MyDouble, 0.000000000001);
      CheckEquals(True, Obj.MyBool);
      CheckEquals(dt, Obj.MyDateTime);
      Check(Obj.MyVariant = 'Variant String', 'Obj.MyVariant = ''Variant String''');
      CheckEquals('aaa', Obj.NonStored);
    finally
      Obj.Free;
    end;
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestFromSimpleObject;
var
  O: TJsonObject;
  Obj: TMyObject;
  dt: TDateTime;
begin
  dt := EncodeDate(2014, 12, 31) + EncodeTime(23, 59, 59, 999);

  // Case Sensitive
  O := TJsonObject.Create;
  try

    Obj := TMyObject.Create;
    try
      Obj.MyString := 'Hello World!';
      Obj.MyInt := 135711;
      Obj.MyInt64 := 135711131719232931;
      Obj.MyDouble := 3.14159265359;
      Obj.MyBool := False;
      Obj.MyDateTime := dt;
      Obj.MyVariant := 12.2;
      Obj.NonStored := 'abc';

      O.FromSimpleObject(Obj);
      CheckEquals(7, O.Count);

      CheckEqualsString('Hello World!', O.S['MyString']);
      CheckEquals(135711, O.I['MyInt']);
      CheckEquals(135711131719232931, O.L['MyInt64']);
      CheckEquals(3.14159265359, O.F['MyDouble'], 0.000000000001);
      CheckEquals(False, O.B['MyBool']);
      CheckEquals(TJsonBaseObject.DateTimeToJSON(dt, True), O.S['MyDateTime']);
      CheckEquals('12.2', O.S['MyVariant']);
      CheckFalse(O.Contains('NonStored'), 'Contains(''NonStrored''');
    finally
      Obj.Free;
    end;
  finally
    O.Free;
  end;
end;

procedure TestTJsonObject.TestObjectAssign;
var
  O: TJsonObject;
begin
  O := TJsonObject.Create;
  try
    O['MyObject']['Data'] := 'Hello';
    O['MySecondObject'] := O['MyObject']; // creates a copy of MyObject
    O['MySecondObject']['SecondData'] := 12;

    Check(O.O['MyObject'] <> O.O['MySecondObject']); // different instances
    CheckEquals('{"MyObject":{"Data":"Hello"},"MySecondObject":{"Data":"Hello","SecondData":12}}', O.ToJSON);
  finally
    O.Free;
  end;
end;

initialization
  RegisterTest(TestTJsonBaseObject.Suite);
  RegisterTest(TestTJsonArray.Suite);
  RegisterTest(TestTJsonObject.Suite);

end.
