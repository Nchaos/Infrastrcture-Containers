#!/bin/bash

# Script to grab Github Runner API Token if not provided
#echo "Runner Token is: $RUNNER_TOKEN"
if [ -z "$RUNNER_TOKEN" ]
then
        export RUNNER_TOKEN=$(curl -X POST -H "Accept: application/vnd.github.v3+json" \
                -H "Authorization: token $API_TOKEN" \
                https://api.github.com/orgs/USDC-ORG/actions/runners/registration-token | jq -r '.token')
fi

# Create a folder
mkdir $RUNNER_WORKPLACE && cd $RUNNER_WORKPLACE

# Download the latest runner package
curl -o actions-runner-linux-x64-2.280.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.280.1/actions-runner-linux-x64-2.280.1.tar.gz

# Optional: Validate the hash
echo "24a8857b7f124f7c1852b030686a2f2205ec5d59ed7e2c0635a2c321d2b9fde6  actions-runner-linux-x64-2.280.1.tar.gz" | shasum -a 256 -c

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.280.1.tar.gz

printf "$GITHUB_RUNNER_GROUP\n$GITHUB_RUNNER_NAME\n$GITHUB_RUNNER_LABELS\n$GITHUB_RUNNER_WORKDIRETORY\n" | ./config.sh --url https://github.com/$GITHUB_ORG --token $RUNNER_TOKEN

#"enter name of runner group to add this runner to: [press enter for default]"
# GITHUB_RUNNER_GROUP

#"enter name of runner to add this runner to: [press enter for 'garbage name value']"
# GITHUB_RUNNER_NAME


#"this runner will have the following labels 'self hosted', 'Linux', 'X64'"
#"Enter any additional labels (ex. label-1,label-2)": [press enter to skip]
# GITHUB_RUNNER_LABELS

#Enter the name of the work folder: [press enter for _work]
# GITHUB_RUNNER_WORKDIRECTORY

# Last step, run it!
./run.sh