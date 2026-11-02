{
  Names of the Mojave: export CREA (creature) data, e.g. to find generic super mutant names.
  Same columns as NotM_ExportNPCs, except: Type = the creature type (Super Mutant, Robot, ...),
  LvlcRefs = leveled creature list references, PlacedRefs = placed creatures (ACRE).
  Run in FNVEdit after "Background Loader: finished" (needed for referenced-by counts).
  Select the plugins to export, then right-click > Apply Script > NotM_ExportCreatures.
  Output: NotM_creatures.tsv in the FNVEdit folder. Only master records; overrides are skipped.
}
unit NotM_ExportCreatures;

var
  sl: TStringList;

function Initialize: integer;
begin
  sl := TStringList.Create;
  sl.Add('Sig'#9'File'#9'FormID'#9'EditorID'#9'Name'#9'Type'#9'Flags'#9'TemplateFlags'#9'Template'#9'LvlcRefs'#9'PlacedRefs'#9'Factions');
  Result := 0;
end;

function Process(e: IInterface): integer;
var
  facs, refSig: string;
  f: IInterface;
  i, lvlc, placed: integer;
begin
  Result := 0;
  if not IsMaster(e) then Exit;
  if Signature(e) <> 'CREA' then Exit;
  facs := '';
  lvlc := 0;
  placed := 0;
  f := ElementByName(e, 'Factions');
  for i := 0 to ElementCount(f) - 1 do
    facs := facs + GetElementEditValues(ElementByIndex(f, i), 'Faction') + ';';
  for i := 0 to ReferencedByCount(e) - 1 do begin
    refSig := Signature(ReferencedByIndex(e, i));
    if refSig = 'LVLC' then Inc(lvlc)
    else if refSig = 'ACRE' then Inc(placed);
  end;
  sl.Add('CREA'#9 + GetFileName(GetFile(e)) + #9 + IntToHex(FormID(e), 8) + #9 + EditorID(e) + #9 +
    GetElementEditValues(e, 'FULL') + #9 + GetElementEditValues(e, 'DATA\Type') + #9 +
    GetElementEditValues(e, 'ACBS\Flags') + #9 + GetElementEditValues(e, 'ACBS\Template Flags') + #9 +
    GetElementEditValues(e, 'TPLT') + #9 + IntToStr(lvlc) + #9 + IntToStr(placed) + #9 + facs);
end;

function Finalize: integer;
begin
  sl.SaveToFile(ProgramPath + 'NotM_creatures.tsv');
  AddMessage('NotM: wrote ' + IntToStr(sl.Count - 1) + ' rows to ' + ProgramPath + 'NotM_creatures.tsv');
  sl.Free;
  Result := 0;
end;

end.
