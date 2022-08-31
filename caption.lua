local vips = require('vips')
local coro_http = require('coro-http')

local function long_caption(msg, url, message)

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

    -- Download Image

    local res, body = coro_http.request("GET", url)
    local imagefile = io.open("image.png", "wb")
    imagefile:write(body)
    imagefile:close()

    -- Image Processing

    local im = vips.Image.new_from_file('image.png', {access = "sequential"}):colourspace('srgb')
    local text = vips.Image.text(message_string, {dpi = im:width() / 1.7, fontfile = 'esm.otf', font = "Futura Extra Black Condensed", spacing = 2, align = 'centre'}):colourspace('srgb')
    local caption_box = vips.Image.black(im:width(), text:height() + im:height() / 8.5)
    local text = text:gravity("centre", caption_box:width(), caption_box:height())
    local caption_box = caption_box:composite(text, "over")
    local caption_box = caption_box:extract_band(1)
    local caption_box = caption_box:invert()
    local image = caption_box:join(im, 'vertical')
    image:write_to_file('upload.png')

    message.channel:send({file = "upload.png"})
end

local function caption(msg, url, message)

    -- Download Image

    local res, body = coro_http.request("GET", url)
    local imagefile = io.open("image.png", "wb")
    imagefile:write(body)
    imagefile:close()

    -- Image Processing

    local im = vips.Image.new_from_file('image.png', {access = "sequential"}):colourspace('srgb')
    local text = vips.Image.text(msg, {dpi = im:width() / 1.7, fontfile = 'esm.otf', font = "Futura Extra Black Condensed", spacing = 2, align = 'centre'}):colourspace('srgb')
    local caption_box = vips.Image.black(im:width(), text:height() + im:height() / 8.5)
    local text = text:gravity("centre", caption_box:width(), caption_box:height())
    local caption_box = caption_box:composite(text, "over")
    local caption_box = caption_box:extract_band(1)
    local caption_box = caption_box:invert()
    local image = caption_box:join(im, 'vertical')
    image:write_to_file('upload.png')

    message.channel:send({file = "upload.png"})
end

return {
    long_caption = long_caption,
    caption = caption,

}