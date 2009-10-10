#!/usr/bin/env bash

appcfg.py upload_data --batch_size=100 --config_file=classes/loaders.py --filename=../parseddata/out-all.csv --kind=CrimeEntry --url=http://localhost:8080/remote_api .