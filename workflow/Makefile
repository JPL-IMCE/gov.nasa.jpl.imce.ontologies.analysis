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

clean:
	/bin/rm -rf $(WORKFLOW)
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

$(WORKFLOW)/log:
	mkdir $@

bootstrap: $(WORKFLOW)/Makefile

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

identify-unsat-func-props: validate-roots
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} identify-unsat-func-props)

load-production: 
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} load-production)

run-audits: location-mapping
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} run-audits)

run-reports: location-mapping
	(cd $(WORKFLOW); nice make ${PARALLEL_MAKE_OPTS} run-reports)
