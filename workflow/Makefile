#
#    $HeadURL$
#
#    $LastChangedRevision$
#    $LastChangedDate$
#
#    $LastChangedBy$
#
#    Copyright (c) 2009,2010 California Institute of Technology.
#    All rights reserved.
#

JRUBY ?= jruby
JRUBY_CMD ?= $(JRUBY) --headless -J-Xmx16384m 
MAKE_MAKEFILE ?= $(TOOLS)/tools/make-makefile

FUSEKI_PID ?= $(WORKFLOW)/log/fuseki.pid
FUSEKI_LOG ?= $(WORKFLOW)/log/fuseki.log
FUSEKI_CONFIG ?= $(WORKFLOW_SOURCES)/etc/fuseki

clean:
	/bin/rm -rf $(WORKFLOW) $(FUSEKI_BASE)
	mkdir $(WORKFLOW)
	mkdir $(WORKFLOW)/artifacts
	mkdir $(WORKFLOW)/log


# Copy required files, and create directory target/workflow in the process
# if it does not already exist

$(WORKFLOW)/Makefile.erb: $(WORKFLOW_SOURCES)/Makefile.erb
	cp -p $< $@

$(WORKFLOW)/log4j.properties: $(WORKFLOW_SOURCES)/log4j.properties
	cp -p $< $@

$(WORKFLOW)/logging.properties: $(WORKFLOW_SOURCES)/logging.properties
	cp -p $< $@

.PHONY: start-fuseki stop-fuseki

$(WORKFLOW)/log:
	mkdir $@

$(FUSEKI_BASE):
	mkdir $@

start-fuseki: $(WORKFLOW)/log $(FUSEKI_BASE)
	cp -pv $(ETC)/fuseki/imce-ontologies.ttl $(FUSEKI_BASE)/config.ttl
	(cd $(FUSEKI_BASE); nohup $(FUSEKI_HOME)/fuseki-server --port=$(JENA_PORT) > $(FUSEKI_LOG) 2>&1 & echo $$! > $(FUSEKI_PID) )

#(cd $(FUSEKI_BASE); nohup $(FUSEKI_HOME)/fuseki-server --port=$(JENA_PORT) --config=$(FUSEKI_BASE)/configuration/imce-ontologies.ttl > $(FUSEKI_LOG) 2>&1 & echo $$! > $(FUSEKI_PID) )

stop-fuseki:
	[ -f $(FUSEKI_PID) ] && kill -9 `cat $(FUSEKI_PID)` 

bootstrap: $(WORKFLOW)/Makefile start-fuseki

$(WORKFLOW)/Makefile: $(WORKFLOW_SOURCES)/Makefile.erb $(WORKFLOW)/logging.properties $(WORKFLOW)/log4j.properties $(WORKFLOW)/Makefile.erb
	@echo $< '->' $@
	(cd $(WORKFLOW); $(JRUBY_CMD) $(MAKE_MAKEFILE) $< > $@.tmp) && mv $@.tmp $@

$(WORKFLOW)/.symlinks:
	ln -s $(ONTOLOGIES)/* $(WORKFLOW)
	touch $(WORKFLOW)/.symlinks



location-mapping: bootstrap $(WORKFLOW)/.symlinks
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} location-mapping)

validate-roots: location-mapping
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} validate-roots)

identify-unsats: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsats)

identify-unsat-props: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsat-props)

identify-unsat-prop-sources: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsat-prop-sources)

identify-unsat-prop-targets: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsat-prop-targets)

identify-unsat-sups: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsat-sups)

identify-unsat-roots: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsat-roots)
