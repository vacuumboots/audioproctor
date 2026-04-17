Deploy the AudioProctor Chrome extension for Chromebook testing. Run these steps in order:

1. Zip the extension/ folder from the audioproctor project into the returnspace static directory:
   `cd /Users/administrator/Git/audioproctor && zip -r /Users/administrator/Git/returnspace/static/audioproctor-extension.zip extension/ --exclude "extension/.DS_Store" --exclude "extension/__MACOSX"`

2. In the returnspace repo, stage the zip, commit, and push:
   `cd /Users/administrator/Git/returnspace && git add static/audioproctor-extension.zip && git commit -m "update AudioProctor extension zip" && git push github master`
   If the push is rejected, pull --rebase first then push again.

3. In the audioproctor repo, stage all changes in extension/ AND .claude/commands/deploy-extension.md, commit with a descriptive message summarising what changed, and push to main.

Report the final download URL: https://returnspace.net/audioproctor-extension.zip
