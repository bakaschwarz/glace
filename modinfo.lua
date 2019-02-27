name = "Glace - The Freezer 2.0"
description = "Adds the cold hearted (?) Glace as a playable character."
author = "BakaSchwarz"
version = "2.3.1"

forumthread = ""

api_version = 10

dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
"character",
}

configuration_options =
{
    {
        name = "GIANTS", label = "Freeze giants?", default = false,
        options = {
            {
                description = "Yes",
                data = true,
                hover = "Glace will freeze giants when they touch his ice plane"
            },
            {
                description = "No",
                data = false,
                hover = "Glace will not freeze giants when they touch his ice plane"
            }
        }
    },
    {
        name = "SPEED", label = "Speed Modifier", default = "NORMAL",
        options = {
            {
                description = "Normal",
                data = "NORMAL",
                hover = "Default Glace walking and running speed"
            },
            {
                description = "Slow",
                data = "SLOW",
                hover = "Same speed as Wilson"
            }
        }
    }
}