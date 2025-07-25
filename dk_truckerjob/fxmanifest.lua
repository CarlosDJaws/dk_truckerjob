fx_version 'cerulean'
game 'gta5'

author 'Dark'
description 'A simple truck driving job for ESX.'
version '1.5.3'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    'locales/en.lua'
}

server_scripts {
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

dependencies {
    'es_extended',
    'esx_skin'
}
