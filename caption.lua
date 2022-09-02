local vips = require('vips')
local coro_http = require('coro-http')
local fs = require('fs')
local timer =  require('timer')

local function caption_image(msg, url, message)


    if msg:len() > 17 then

        -- String Formatting

        local chunks = {}
        for substring in msg:gmatch("%w+") do
            table.insert(chunks, substring)
        end

        local message_string = ""
        local total_len = 0

        for k, v in pairs(chunks) do
            total_len = total_len + chunks[k]:len() + 1
                if total_len > 17 then
                    message_string = message_string .. v .. "\n"
                    total_len = 0
                else
                    message_string = message_string .. v .. " "
            end
        end

        if #message_string == message_string:find("\n") then
            print('true')
            message_string = message_string:sub(1, -2)
        end        
        
        -- Generate Name

        local ran_string = ''
        for i=1, 10 do
            local randlowercase = string.char(math.random(65, 65 + 25)):lower()
            ran_string = ran_string .. randlowercase
        end


        -- Download Image

        local res, body = coro_http.request("GET", url)
        if not body then error(res) end
        fs.writeFileSync("./contents/"..ran_string..".png", body)

        -- Image Processing

        local im = vips.Image.new_from_file('image.png', {access = "sequential"}):colourspace('srgb')
        local text = vips.Image.text(message_string, {dpi = im:width() / 1.7, fontfile = 'esm.otf', font = "Futura Extra Black Condensed", spacing = 2, align = 'centre'}):colourspace('srgb')
        local caption_box = vips.Image.black(im:width(), text:height() + im:height() / 8.5)
        local text = text:gravity("centre", caption_box:width(), caption_box:height())
        local caption_box = caption_box:composite(text, "over")
        local caption_box = caption_box:extract_band(1)
        local caption_box = caption_box:invert()
        local image = caption_box:join(im, 'vertical')
        image:write_to_file("./contents/"..ran_string.."_upload"..".png")

        message.channel:send({file = "./contents/"..ran_string.."_upload"..".png"})

    else
        -- Generate Name

        local ran_string = ''
        for i=1, 10 do
            local randlowercase = string.char(math.random(65, 65 + 25)):lower()
            ran_string = ran_string .. randlowercase
        end

        -- Download Image

        local res, body = coro_http.request("GET", url)
        if not body then error(res) end
        fs.writeFileSync("./contents/"..ran_string..".png", body)


        -- Image Processing

        local im = vips.Image.new_from_file("./contents/"..ran_string..".png", {access = "sequential"}):colourspace('srgb')
        local text = vips.Image.text(msg, {dpi = im:width() / 1.7, fontfile = 'esm.otf', font = "Futura Extra Black Condensed", spacing = 2, align = 'centre'}):colourspace('srgb')
        local caption_box = vips.Image.black(im:width(), text:height() + im:height() / 8.5)
        local text = text:gravity("centre", caption_box:width(), caption_box:height())
        local caption_box = caption_box:composite(text, "over")
        local caption_box = caption_box:extract_band(1)
        local caption_box = caption_box:invert()
        local image = caption_box:join(im, 'vertical')
        image:write_to_file("./contents/"..ran_string.."_upload"..".png")

        message.channel:send({file = "./contents/"..ran_string.."_upload"..".png"})

    end
end

local function caption_gif(msg, url, message)

    if msg:len() > 17 then

        -- String Formatting

        local chunks = {}
        for substring in msg:gmatch("%w+") do
            table.insert(chunks, substring)
        end

        local message_string = ""
        local total_len = 0

        for k, v in pairs(chunks) do
            total_len = total_len + chunks[k]:len() + 1
                if total_len > 17 then
                    message_string = message_string .. v .. "\n"
                    total_len = 0
                else
                    message_string = message_string .. v .. " "
            end
        end

        if #message_string == message_string:find("\n") then
            print('true')
            message_string = message_string:sub(1, -2)
        end

        -- Generate Name

        local ran_string = ''
        for i=1, 10 do
            local randlowercase = string.char(math.random(65, 65 + 25)):lower()
            ran_string = ran_string .. randlowercase
        end

        -- Download Image

        local res, body = coro_http.request("GET", url)
        if not body then error(res) end
        fs.writeFileSync("./contents/"..ran_string..".gif", body)

        -- Gif Processing
  
        local im = vips.Image.new_from_file("./contents/"..ran_string..".gif", {n = -1})
        local frame = vips.Image.new_from_file("./contents/"..ran_string..".gif")
        
        local text = vips.Image.text(msg, {dpi = frame:width() / 1.7, fontfile = 'esm.otf', font = "Futura Extra Black Condensed", spacing = 2, align = 'centre'}):colourspace('srgb')
        local caption_box = vips.Image.black(frame:width(), text:height() + frame:height() / 7.8)
        local text = text:gravity("centre", caption_box:width(), caption_box:height())
        local caption_box = caption_box:composite(text, "over")
        local caption_box = caption_box:extract_band(1)
        local caption_box = caption_box:invert()
        
        local width = tonumber(frame:width())
        local height = tonumber(frame:height())
        local page_height = im:get('page-height')
        local n_frames = im:height() / page_height
        
        local inv_frame
        local frames = {}
        for i = 0, n_frames - 1 do
        
            inv_frame = im:crop(0, i * page_height, width, height)
            inv_frame = caption_box:join(inv_frame, 'vertical')
        
            table.insert(frames, inv_frame)
        end
        
        local image = vips.Image.arrayjoin(frames, {across = 1})
        
        image:set("page-height", height + text:height())
        
        image:write_to_file("./contents/"..ran_string.."_upload"..".gif")

        message.channel:send({file = "./contents/"..ran_string.."_upload"..".gif"})
        -- timer.sleep(60000)
        -- fs.unlink("./contents/"..ran_string.."_upload"..".gif")
        -- fs.unlink("./contents/"..ran_string..".gif")
    else

        -- Generate Name

         local ran_string = ''
         for i=1, 10 do
             local randlowercase = string.char(math.random(65, 65 + 25)):lower()
             ran_string = ran_string .. randlowercase
         end

         -- Download Image

        local res, body = coro_http.request("GET", url)
        if not body then error(res) end
        fs.writeFileSync("./contents/"..ran_string..".gif", body)

        -- Gif Processing

        local im = vips.Image.new_from_file("./contents/"..ran_string..".gif", {n = -1})
        local frame = vips.Image.new_from_file("./contents/"..ran_string..".gif")

        local text = vips.Image.text(msg, {dpi = frame:width() / 1.7, fontfile = 'esm.otf', font = "Futura Extra Black Condensed", spacing = 2, align = 'centre'}):colourspace('srgb')
        local caption_box = vips.Image.black(frame:width(), text:height() + frame:height() / 7.8)
        local text = text:gravity("centre", caption_box:width(), caption_box:height())
        local caption_box = caption_box:composite(text, "over")
        local caption_box = caption_box:extract_band(1)
        local caption_box = caption_box:invert()

        local width = tonumber(frame:width())
        local height = tonumber(frame:height())
        local page_height = im:get('page-height')
        local n_frames = im:height() / page_height

        local inv_frame
        local frames = {}
        for i = 0, n_frames - 1 do

            inv_frame = im:crop(0, i * page_height, width, height)
            inv_frame = caption_box:join(inv_frame, 'vertical')

            table.insert(frames, inv_frame)
        end

        local image = vips.Image.arrayjoin(frames, {across = 1})

        image:set("page-height", height + text:height())

        image:write_to_file("./contents/"..ran_string.."_upload"..".gif")

        message.channel:send({file = "./contents/"..ran_string.."_upload"..".gif"})
        -- timer.sleep(60000)
        -- fs.unlink("./contents/"..ran_string.."_upload"..".gif")
        -- fs.unlink("./contents/"..ran_string..".gif")

        end
end


return {
    caption_image = caption_image,
    caption_gif = caption_gif,

}