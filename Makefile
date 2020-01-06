SHELL = /bin/sh
MarketCommons = ./Tools/MarketCommons/MarketCommons

documentSources := $(wildcard Documents/*.market)
documentTargets := $(patsubst %.market,%,$(documentSources))
documentResults := $(patsubst %.market,%.xhtml,$(documentSources))

all: $(documentTargets) ;
$(documentTargets): %: %.xhtml ;
$(documentResults): %.xhtml: %.market
	$(MarketCommons) $< $@

.PHONY: $(documentTargets) all
