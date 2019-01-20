unit usbdrive;

interface
  uses windows, classes;

{$MINENUMSIZE 4}
const
  IOCTL_STORAGE_QUERY_PROPERTY =  $002D1400;

type
  STORAGE_QUERY_TYPE = (PropertyStandardQuery = 0, PropertyExistsQuery, PropertyMaskQuery, PropertyQueryMaxDefined);
  TStorageQueryType = STORAGE_QUERY_TYPE;

  STORAGE_PROPERTY_ID = (StorageDeviceProperty = 0, StorageAdapterProperty);
  TStoragePropertyID = STORAGE_PROPERTY_ID;

  STORAGE_PROPERTY_QUERY = packed record
    PropertyId: STORAGE_PROPERTY_ID;
    QueryType: STORAGE_QUERY_TYPE;
    AdditionalParameters: array [0..9] of AnsiChar;
  end;
  TStoragePropertyQuery = STORAGE_PROPERTY_QUERY;

  STORAGE_BUS_TYPE = (BusTypeUnknown = 0, BusTypeScsi, BusTypeAtapi, BusTypeAta, BusType1394, BusTypeSsa, BusTypeFibre,
    BusTypeUsb, BusTypeRAID, BusTypeiScsi, BusTypeSas, BusTypeSata, BusTypeMaxReserved = $7F);
  TStorageBusType = STORAGE_BUS_TYPE;

  STORAGE_DEVICE_DESCRIPTOR = packed record
    Version: DWORD;
    Size: DWORD;
    DeviceType: Byte;
    DeviceTypeModifier: Byte;
    RemovableMedia: Boolean;
    CommandQueueing: Boolean;
    VendorIdOffset: DWORD;
    ProductIdOffset: DWORD;
    ProductRevisionOffset: DWORD;
    SerialNumberOffset: DWORD;
    BusType: STORAGE_BUS_TYPE;
    RawPropertiesLength: DWORD;
    RawDeviceProperties: array [0..0] of AnsiChar;
  end;
  TStorageDeviceDescriptor = STORAGE_DEVICE_DESCRIPTOR;


procedure GetUsbDrives(List: TStrings);

implementation

uses
  sysutils;

function GetBusType(Drive: Char): TStorageBusType;
var
  H: THandle;
  Query: TStoragePropertyQuery;
  dwBytesReturned: DWORD;
  Buffer: array [0..1023] of Byte;
  sdd: TStorageDeviceDescriptor absolute Buffer;
  OldMode: UINT;
begin
  Result := BusTypeUnknown;

  OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    H := CreateFile(PChar(Format('\\.\%s:', [AnsiLowerCase(Drive)])), 0, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
      OPEN_EXISTING, 0, 0);
    if H <> INVALID_HANDLE_VALUE then
    begin
      try
        dwBytesReturned := 0;
        FillChar(Query, SizeOf(Query), 0);
        FillChar(Buffer, SizeOf(Buffer), 0);
        sdd.Size := SizeOf(Buffer);
        Query.PropertyId := StorageDeviceProperty;
        Query.QueryType := PropertyStandardQuery;
        if DeviceIoControl(H, IOCTL_STORAGE_QUERY_PROPERTY, @Query, SizeOf(Query), @Buffer, SizeOf(Buffer), dwBytesReturned, nil) then
          Result := sdd.BusType;
      finally
        CloseHandle(H);
      end;
    end;
  finally
    SetErrorMode(OldMode);
  end;
end;


procedure GetUsbDrives(List: TStrings);
var
  DriveBits: set of 0..25;
  I: Integer;
  Drive: Char;
begin
  List.BeginUpdate;
  try
    Cardinal(DriveBits) := GetLogicalDrives;

    for I := 0 to 25 do
      if I in DriveBits then
      begin
        Drive := Chr(Ord(('a')) + I);
        if GetBusType(Drive) = BusTypeUsb then
          List.Add(Uppercase(Drive) + ':');
      end;
  finally
    List.EndUpdate;
  end;
end;

end.
