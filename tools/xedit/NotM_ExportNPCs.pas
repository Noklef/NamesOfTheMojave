{
  Names of the Mojave: export NPC_ and FACT data to build the pool tables.
  Run in FNVEdit after "Background Loader: finished" (needed for referenced-by counts).
  Select FalloutNV.esm, the DLC .esm files and TaleOfTwoWastelands.esm, then
  right-click > Apply Script > NotM_ExportNPCs.
  Output: NotM_npcs.tsv in the FNVEdit folder. Only master records; overrides are skipped.
}
unit NotM_ExportNPCs;

var
  sl: TStringList;

function Initialize: integer;
begin
  sl := TStringList.Create;
  sl.Add('Sig'#9'File'#9'FormID'#9'EditorID'#9'Name'#9'Race'#9'Flags'#9'TemplateFlags'#9'Template'#9'LvlnRefs'#9'PlacedRefs'#9'Factions');
  Result := 0;
end;

function Process(e: IInterface): integer;
var
  sig, facs, refSig: string;
  f: IInterface;
  i, lvln, placed: integer;
begin
  Result := 0;
  if not IsMaster(e) then Exit;
  sig := Signature(e);
  if (sig <> 'NPC_') and (sig <> 'FACT') then Exit;
  facs := '';
  lvln := 0;
  placed := 0;
  if sig = 'NPC_' then begin
    f := ElementByName(e, 'Factions');
    for i := 0 to ElementCount(f) - 1 do
      facs := facs + GetElementEditValues(ElementByIndex(f, i), 'Faction') + ';';
    for i := 0 to ReferencedByCount(e) - 1 do begin
      refSig := Signature(ReferencedByIndex(e, i));
      if refSig = 'LVLN' then Inc(lvln)
      else if refSig = 'ACHR' then Inc(placed);
    end;
  end;
  sl.Add(sig + #9 + GetFileName(GetFile(e)) + #9 + IntToHex(FormID(e), 8) + #9 + EditorID(e) + #9 +
    GetElementEditValues(e, 'FULL') + #9 + GetElementEditValues(e, 'RNAM') + #9 +
    GetElementEditValues(e, 'ACBS\Flags') + #9 + GetElementEditValues(e, 'ACBS\Template Flags') + #9 +
    GetElementEditValues(e, 'TPLT') + #9 + IntToStr(lvln) + #9 + IntToStr(placed) + #9 + facs);
end;

function Finalize: integer;
begin
  sl.SaveToFile(ProgramPath + 'NotM_npcs.tsv');
  AddMessage('NotM: wrote ' + IntToStr(sl.Count - 1) + ' rows to ' + ProgramPath + 'NotM_npcs.tsv');
  sl.Free;
  Result := 0;
end;

end.
