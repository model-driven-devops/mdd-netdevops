# The following script will create your GitLab project, copy the MDD-Base repo into your project, and set the correct GitLab variables so the runner can execute.

#!/usr/bin/env bash

# Uncomment the following and define proper values (or specify as environment variables)
# GITLAB_HOST=
# GITLAB_PROJECT=
# GITLAB_BRANCH=
# CML_HOST=
# CML_USERNAME=
# CML_PASSWORD=
# DEV Lab is the name of your CML Development Lab and Prod Lab is the name of your production Lab.
# TEST_CML_LAB=test
# PROD_CML_LAB=prod
# CML_VERIFY_CERT=false

# Clone the GitHub repo and change to mdd directory
git clone https://github.com/model-driven-devops/mdd-base.git
cd mdd-base

while IFS=, read -r NAME PASSWORD TOKEN CML_HOST; do
    # Create the project
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects" --form "name=$GITLAB_PROJECT"
    # Add CI vars
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects/$NAME%2f$GITLAB_PROJECT/variables" --form "key=CML_HOST" --form "value=$CML_HOST" 
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects/$NAME%2f$GITLAB_PROJECT/variables" --form "key=CML_USERNAME" --form "value=$CML_USERNAME" 
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects/$NAME%2f$GITLAB_PROJECT/variables" --form "key=CML_PASSWORD" --form "value=$CML_PASSWORD" 
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects/$NAME%2f$GITLAB_PROJECT/variables" --form "key=DEV_CML_LAB" --form "value=dev"
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects/$NAME%2f$GITLAB_PROJECT/variables" --form "key=PROD_CML_LAB" --form "value=prod"
    curl --request POST -sSLk --header "PRIVATE-TOKEN:$TOKEN" "https://$GITLAB_HOST/api/v4/projects/$NAME%2f$GITLAB_PROJECT/variables" --form "key=CML_VERIFY_CERT" --form "value=false"
    # Push repo into project
    git push https://$NAME:$PASSWORD@$GITLAB_HOST/$NAME/$GITLAB_PROJECT
done < ../podvars

# Remove mdd directory
cd ..
rm -rf base_demo
