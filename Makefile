.PHONY: collect enable

package=com.doten.teams.sdPlugin
pluginDestination=~/Library/Application\ Support/com.elgato.StreamDeck/Plugins

enable:
	cp -R Release/ $(pluginDestination)/$(package)/

collect:
	cp -R Sources/$(package)/ Release/
	cp Sources/Build/Products/Release/Plugin Release/
