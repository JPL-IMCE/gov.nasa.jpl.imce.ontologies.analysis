## Manually running the workflow


### Prerequisites
  * Input model is checked out from a repo
  * A Fuseki server is setup locally

### Run Manually
To run, execute the following commands in a terminal, starting at the project root:
```sh
## checkout design model repo into ~/git/<model_repo>

sbt clean cleanFiles
sbt setupTools setupExportResults
cd target/workflow/artifact

## runs omlConverter on the oml model and copies bundles 
bash -x ../../../scripts/setup ~/git/<model_repo>
cd ../../../workflow
source env.sh <dataset_name> 3030
make bootstrap
make location-mapping
make validate-roots
make identify-unsat-roots
../scripts/create-dataset.sh
make load-production
./load-prefix.sh
make run-audits
make run-reports
```
