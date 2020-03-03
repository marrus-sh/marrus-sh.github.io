SHELL = /bin/sh
CodexMake = ./Tools/CodexMake/CodexMake
MarketCommons = ./Tools/MarketCommons/MarketCommons

codexSources := $(wildcard Codices/*/@.ttl)
codexTargets := $(patsubst %/@.ttl,%,$(documentSources))
codexResults := $(patsubst %/@.ttl,%/index.xhtml,$(documentSources))

documentSources := $(wildcard Documents/*.market)
documentTargets := $(patsubst %.market,%,$(documentSources))
documentResults := $(patsubst %.market,%.xhtml,$(documentSources))

# Do documents first in case codices depend on them.
all: $(documentResults) $(codexResults) ;

codices: $(codexResults) ;
$(codexTargets): %: %/index.xhtml ;
$(codexResults): %/index.xhtml: Codices/style.css Codices/script.js %/@.ttl
	$(CodexMake) $+

documents: $(documentResults) ;
$(documentTargets): %: %.xhtml ;
$(documentResults): %.xhtml: %.market
	$(MarketCommons) $< $@

.PHONY: $(codexTargets) $(documentTargets) all codices documents
