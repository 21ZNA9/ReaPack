-- @description Render items to new take (using all of source)
-- @version 1.0
-- @author 21ZNA9
-- @about
--   
-- @changelog
--   + Initial release

selitems = reaper.CountSelectedMediaItems(0)

if selitems == 0 then 
  reaper.MB("No items selected!", "Render items", 0)
else
  ret = reaper.MB("Render " .. selitems .. " item(s)?", "Render items", 1)

  if ret == 1 then
    for n=0, selitems-1, 1 do
      local item = reaper.GetSelectedMediaItem(0, n)
      
      reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SAVEALLSELITEMS1"), 0, 0)
      reaper.Main_OnCommandEx(40289, 0, 0) -- Unselect all items
      
      reaper.SetMediaItemSelected(item, true)
      
      local take = reaper.GetActiveTake(item)
      local source = reaper.GetMediaItemTake_Source(take)
      
      
      item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      fade_in = reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN")
      fade_out = reaper.GetMediaItemInfo_Value(item, "D_FADEOUTLEN")
  
      take_offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")
      source_length, _ = reaper.GetMediaSourceLength(source)
  
      local new_pos = math.max(0, item_pos-take_offset)
      local new_offset = take_offset-(item_pos-new_pos)
  
    
      --reaper.SetMediaItemTakeInfo_Value(take, "D_STARTOFFS", new_offset)
      --reaper.SetMediaItemInfo_Value(item, "D_POSITION", new_pos)
  
  
      reaper.ApplyNudge(0, 1, 1, 1, new_pos, 0, 0)
      reaper.SetMediaItemInfo_Value(item, "D_LENGTH", source_length-new_offset)
      reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", 0)
      reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", 0)
      
      reaper.Main_OnCommandEx(41999, 0, 0) -- Render items to new take
      
      
      reaper.ApplyNudge(0, 1, 1, 1, item_pos, 0, 0)
      reaper.SetMediaItemInfo_Value(item, "D_LENGTH", item_length)
      reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fade_in)
      reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fade_out)
      
      
      reaper.UpdateArrange()
      
      
      reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_RESTALLSELITEMS1"), 0, 0)
      
    end
  end
end
