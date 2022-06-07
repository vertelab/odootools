# GIT HOOKS

These are developed to be used by all developers.

## How to use
To enable these hooks, copy the files into the .git/hooks directory on the repository where you wish to enable this functionality.

## pre-push
This hook checks your commits before you push to remote.
If there does not exist any string matching "\\[[-0-9][0-9]*\\]" the developer is not allowed to push to remote.
This functionality is intended to link a commit to a corresponding task on vertel.se for traceability in the future. These tasks needs to have a global sequence so that all tasks can be searched for using their unique id.
### Examples of allowed commit messages using this hook:
```[-] WIP``` (this is intended to be used if there is no associated task, but highly discouraged)

```[123] My title```
```
My title [345]
My great commit message
```
``` [345] and also [681]```

### Examples of  commit messages that will not be allowed using this hook:
```WIP```

```[123-456] Commit Title```

```
Commit Title
[123] Solved X
[345] Solved Y
 ```

## Possible improvements
* Create a script that automatically populates the .git/hooks directory when using, for example, `odoogitpull`.  There probably needs to exist some sort of whitelist where the repositories where this should be enabled in is listed.
* Investigate if it's possible to enforce this rule server side instead, so that a repository where this is not set up will have its commit rejected server side.


