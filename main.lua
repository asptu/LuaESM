local discordia = require('discordia')
local client = discordia.Client()
local add = require("./caption")
discordia.extensions.string()


client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)

        if string.sub(message.content, 1, 9) ~= "-caption " then
            return
        end

        if message.referencedMessage ~= nil then
            if message.referencedMessage.attachment ~= nil then
                for _,v in pairs(message.referencedMessage.attachments) do
                    local msg = string.sub(message.content, 10, #message.content)
                    local url = v.url

                    local message_sent = message.channel:send('processing...')

                    if msg:len() > 17 then

                        add.long_caption(msg, url, message)
                        message_sent:delete()

                    else

                        add.caption(msg, url, message)
                        message_sent:delete()

                    end
                end

            elseif message.referencedMessage.content then

                if string.find(message.referencedMessage.content, "https://") ~= nil then


                    local url = ''
                    for substring in message.referencedMessage.content:gmatch("%S+") do
                        if substring:startswith('https://') then
                            url = substring
                        end
                    end

                    local msg = string.sub(message.content, 10, #message.content)

                    local message_sent = message.channel:send('processing...')


                    if msg:len() > 17 then

                        add.long_caption(msg, url, message)
                        message_sent:delete()

                    else

                        add.caption(msg, url, message)
                        message_sent:delete()

                    end
                end
            else
                message.channel:send('cant find content')
                return
            end
        end

        if string.find(message.content, " https://") ~= nil then
            local startindex = tostring(string.find(message.content, " https://")):split(" ")[1]

            local url = string.sub(message.content, startindex + 1, #message.content)
            local msg = string.sub(message.content, 10, startindex)

            local message_sent = message.channel:send('processing...')

            if msg:len() > 17 then

                add.long_caption(msg, url, message)
                message_sent:delete()

            else

                add.caption(msg, url, message)
                message_sent:delete()

            end
	end
end)

client:run('Bot '..io.open("token.txt"):read())







