#!/usr/bin/env bash

set -e

for data_source in $(ls data/*.json); do
  output_data=$(basename ${data_source%.*})
  output_file="$output_data.md"
  ruby generate.rb -d $data_source -t templates/markdown.erb -o $output_file
done

ruby generate.rb -t README.md.erb -o README.md
