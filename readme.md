# Effective Octo Lamp: Autocommiter Tool
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Effective Octo Lamp: Autocommiter Tool](#effective-octo-lamp-autocommiter-tool)
    - [How t](#how-t)

<!-- markdown-toc end -->


Welcome to the Effective Octo Lamp, a powerful and efficient autocommiter tool that makes managing your GitHub repos a breeze. This shell script utilizes the power of cron to automatically commit and push any changes made in your repo to GitHub, saving you the hassle of having to manually commit and push your changes.

With this tool, you can set up a schedule for committing your changes, so you can choose how often you want your changes to be committed. This means you can focus on writing code, and let the script handle the tedious task of committing and pushing your changes for you. This is especially useful for developers who want to keep their repos up-to-date without interrupting their workflow.


## How To Use
* Add to your personal git repo

```sh
git submodule add https://github.com/luyangliuable/effective-octo-lamp.git auto-commit
```

* Use <kbd>cron -</kbd>e or <kbd>crontab -e</kbd> depending on mac os linux.

* Add the follow line which checks every 30 minutes for enough changes to commit
```sh
*/30 * * * * cd $PATH_TO_FOLDER && $PATH_TO_FOLDER/auto-commit/auto-commit.sh
```
* Changes will automatically be pushed upstream to default branch


### Change Number of Lines Changes Triggering A Commit and Push
* In code replace:

```sh
LINES_TRIGGER=0
```

With the number of changes lines of code.
