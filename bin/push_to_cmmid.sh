#!/bin/bash

# Get or update CMMID
cd ..
base_url="https://github.com/cmmid/"
project="cmmid.github.io"

# Update git or clone if not present
if ([ -e $project ]); then
printf "\tUpdating project: %s \n" $project
cd $project
git pull
cd ..
else
  printf "\tCloning project: %s into projects: %s\n" $project $1
git clone "$base_url$project.git"
fi

# Add new report to Repo

cd CovidGlobalNow

Rscript -e "EpiNow::copy_report(
               yaml = 'man/global-report-yaml.md',
               report = 'vignettes/cmmid_report/global-report.html',
               date = Sys.Date(),
               lines_to_cut = 1:7,
               report_target = '../cmmid.github.io/topics/covid19/current-patterns-transmission/_posts/2020-03-02-global-time-varying-transmission.html')"


# Copy across summary pdf reports

cp vignettes/rendered_output/global-report.pdf ../cmmid.github.io/topics/covid19/current-patterns-transmission/reports/global-time-varying-transmission/summary.pdf
# Update Repo

cd ../$project

git add --all
git commit -m "Update time-varying rt"
git push

cd ../$source
