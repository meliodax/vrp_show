dependency "vrp_general" client_script "@vrp_general/client.lua" fx_version 'cerulean'
game 'gta5'

client_scripts {
    "@vrp/lib/utils.lua",
	"client-side/*"
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server-side/*"
}
