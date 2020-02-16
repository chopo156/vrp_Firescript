resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script {
	"client.lua",
	"firehose.lua",
	"FireScript.net.dll"
}

server_script{
    "@vrp/lib/utils.lua",
    "server.lua"
}
