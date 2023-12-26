function init(plugin)
  plugin.preferences.name = "sprite.h"

  plugin:newCommand{
    id="save-cheader",
    title="Save as C Header",
    group="file_save",
    onclick=function() --> save as c header
      -- Get the active sprite
      local spr = app.activeSprite

      if spr == nil then
        return app.alert{title="Error", text="No sprite to save", buttons="OK"}
      end

      if spr.colorMode ~= ColorMode.RGB then
        return app.alert{title="Error", text="Sprite color mode needs to be RGB", buttons="OK"}
      end

      while true do
        -- Open a dialog for the user to specify the file path
        local dlg = Dialog("Save File as C Header")
        dlg:file{ id="out", label="Output header file:", open=false, save=true, focus=true, entry=true, filename=plugin.preferences.name }
        dlg:button{ id="save", text="Save" }
        dlg:button{ id="cancel", text="Cancel" }
        dlg:show()

        local data = dlg.data
        if (data.cancel) then break end
        if data.save then
          local out_dot = data.out:match("^.*()%.")
          local out = data.out
          if out_dot > 0 then
            out = out:sub(1, out:match("^.*()%.") - 1)
          end

          local name = nil
          local name_index = out:match("^.*()/")
          if name_index < #out then name = out:sub(name_index + 1) end

          if name == nil or name == "" then
            app.alert{title="Error", text="Invalid header file name", buttons="OK"}
            goto continue
          end

          plugin.preferences.name = data.out

          local out_h = io.open(data.out, "w")

          if out_h then
            -- Get name

            -- Write C header file content
            out_h:write(string.format("#ifndef __%s_DATA_H__\n",   name:upper()))
            out_h:write(string.format("#define __%s_DATA_H__\n\n", name:upper()))
            out_h:write(string.format("#define %s_WIDTH   %d\n", name:upper(), spr.width));
            out_h:write(string.format("#define %s_HEIGHT  %d\n", name:upper(), spr.height));
            out_h:write(string.format("#define %s_FRAMES  %d\n", name:upper(), #spr.frames));
            out_h:write(string.format("static unsigned int %s_data[SPRITE_FRAMES][SPRITE_WIDTH*SPRITE_HEIGHT] = {", name))
            local img = Image(spr.spec)
            for f = 1, #spr.frames do
              img:drawSprite(spr, f)
              out_h:write("\n  {")
              for y = 0, img.height-1 do
                for x = 0, img.width-1 do
                  out_h:write("\n    ")
                  local index = (y * img.width * 4 + 1) + (x * 4)
                  local r = img.bytes:byte(index + 0)
                  local g = img.bytes:byte(index + 1)
                  local b = img.bytes:byte(index + 2)
                  local a = img.bytes:byte(index + 3)
                  if r == nil or g == nil or b == nil or a == nil then
                    return print(r, " ", g, " ", b, " ", a, " ", index, " ", img.rowStride * img.height, " ", x, " ", y)
                  end
                  out_h:write(string.format("0x%.2x%.2x%.2x%.2x", a, r, g, b))
                  if y ~= img.height-1 or x ~= img.width-1 then out_h:write(",") end
                end
              end
              out_h:write("\n  }")
              if f ~= #spr.frames then out_h:write(",") end
            end
            out_h:write(string.format("\n};\n\n#endif/*__%s_DATA_H__*/", name:upper()))

            out_h:close()
            app.alert{title="Error", text="Sprite saved as C header file.", buttons="OK"}
          else
            app.alert{title="Error", text="Failed to save the file.", buttons="OK"}
          end
          spr:saveAs(out .. ".aseprite")
          break
        end
        ::continue::
      end
    end --< save as c header
  }

  plugin:newCommand{
    id="open-cheader",
    title="Open from C Header",
    group="file_open",
    onclick=function() --> open from c header
      while true do
        -- Open a dialog for the user to specify the file path
        local dlg = Dialog("Open File from C Header")
        dlg:file{ id="inp", label="Input header file:", open=true, save=false, focus=true, entry=true, filename=plugin.preferences.name }
        dlg:button{ id="open", text="Open" }
        dlg:button{ id="cancel", text="Cancel" }
        dlg:show()

        local data = dlg.data
        if (data.cancel) then break end
        if data.open then
          local inp_dot = data.inp:match("^.*()%.")
          local inp = data.inp
          if inp_dot ~= nil then
            inp = inp:sub(1, inp:match("^.*()%.") - 1)
          end

          local name = nil
          local name_index = inp:match("^.*()/")
          if name_index ~= nil then name = inp:sub(name_index + 1) end

          if name == nil or name == "" then
            app.alert{title="Error", text="Invalid header file name", buttons="OK"}
            goto continue
          end

          plugin.preferences.name = data.inp

          local spr = Sprite{fromFile = inp .. ".aseprite"}
          if spr == nil then
            app.alert{title="Error", text="Couldn't open file", buttons="OK"}
            goto continue
          end
          app.activeSprite = spr
          break
        end
        ::continue::
      end
    end --< open from c header
  }
end

function exit(plugin)
end
