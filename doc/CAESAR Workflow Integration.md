#CAESAR Workflow Integration

##TODO

1) Parameterize the following variables in `/scripts/setup` to reference Jenkins parameter values:

 - CONVERT 
 - PUBLIC
 
2) `/workflow/Makefile.erb`

- script argument $1 (should point to gov.nasa.jpl.imce.caesar.worfklow/europa/resource model on branch user-model/authored/oml/europa/fse) 

3) `/workflow/env.sh` fuseki config settings should use the parent parameters define by CAESAR query service

- JENA_DATASET
- JENA_HOST
- JENA_PORT