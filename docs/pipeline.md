# Table of Contents

* [Initial Setup](setup.md)   
* [Topology Creation](topology.md)
* [Data Harvest](dataharvest.md)
* [Pipeline Deployment](pipeline.md)
   * [Environment Variables](#environment-variables)
   * [Pipeline File (Optional)]
   * [Pipeline Creation](#pipeline-creation)
* [Data Validation](validation.md)
* [Stateful Checks](check.md)
* [Telemetry Collection](telemetry.md)

## Pipeline Deployment

Now that we have deployed our production network and created our source-of-truth, we want to commit everything to our repository and start using the built-in features of a source control manager to operate our network.

Note: In the instructor led class, the repository will already be created for you and we will be working with GitLab from the start. If you are doing this outside of the infrastructure led class, cloning from GitHub and pushing to GitLab, you will need to do the following:

### Environment Variables

Before committing your data to git, login and verify your environment variables are set. Much like our environment variables we set for our endpoint, GitLab needs to know how to access CML since it will be making changes on your behalf when the pipeline runs.

You can find this menu under settings - CI/CD - Variables

![Screenshot 2023-09-05 at 10 41 13 AM](https://github.com/model-driven-devops/mdd-base/assets/65776483/ac07e88e-c65e-40e7-a7a5-2bf78f1ab84c)

### Remove github folder (optional)
```
rm -rf .git
```
### initialize new repo (optional)
```
git init .
git add .
git commit -m "Initialize new repo"
```
### Push to GitLab (optional)
```
git remote add origin https://<your-git>/<your-repo>.git
```
If you want to verify you have added your new repo, you can run this command:
```
git config --get remote.origin.url
```
Push changes to new repo
```
git push -u -f origin main
```

## Pipeline File

Placeholder - Add to describe pipeline and what it does.

## Pipeline Creation

After verifying the environment variables are set, you can go back to your local IDE and commit your changes.

```
git add .
git commit -m "Initial pipeline creation"
git push
```

Your initial push to the main branch will have three phases of the pipeline. The first phase is updating the test network. All configurations that were harvested from the production network will be applied to the test network. Once successful, any changes to the main branch will also be applied to your production network. This won't be the case during your first push since no changes have yet been made. Finally, additional checks will be conducted against the production network. These will be implemented later in the lab. You should see three green checks. 

![Screenshot 2023-09-05 at 10 46 54 AM](https://github.com/model-driven-devops/mdd-base/assets/65776483/e5c48601-a210-4119-b75a-ef97eff64d40)

Congrats! You have officially created a CI/CD pipeline to manage network infrastructure. To make this pipeline usable, lets add some automated tests. Proceed to the [Data Validation](validation.md) section.
