# GitHub + RStudio setup (first-time)

Do this once. Takes ~20 minutes.

## 1. Install Git
- Windows: https://git-scm.com/download/win (accept defaults)
- Mac: `xcode-select --install` in Terminal

Verify in RStudio: Tools → Global Options → Git/SVN. The "Git executable" path should be populated. If not, browse to it (usually `C:\Program Files\Git\bin\git.exe` or `/usr/bin/git`).

## 2. Configure your Git identity (once per machine)
In RStudio's Terminal tab (not Console):
```bash
git config --global user.name  "Laura Thompson"
git config --global user.email "your_github_email@example.com"
```

## 3. Create the GitHub repo
1. Go to https://github.com/new
2. Name it something like `homelessness-housing-coc-2023`
3. Set visibility (private is fine for coursework)
4. **Do not** add a README, .gitignore, or license — you're creating them locally

## 4. Create a Personal Access Token (PAT) for HTTPS
GitHub no longer accepts passwords for push/pull.
1. GitHub → profile menu → Settings → Developer settings → Personal access tokens → **Tokens (classic)** → Generate new token (classic)
2. Scope: check `repo`
3. Expiration: 90 days is fine
4. Copy the token (starts with `ghp_…`) — you won't see it again

When RStudio first prompts for a password on push, paste the PAT. Better: store it:
```r
install.packages("gitcreds")
gitcreds::gitcreds_set()   # paste PAT when asked
```

## 5. Turn the local folder into a project with Git
1. Unzip the `homelessness_project/` folder I gave you somewhere sensible (e.g. `Documents/R/`).
2. RStudio → File → New Project → **Existing Directory** → browse to `homelessness_project/` → Create Project. This creates the `.Rproj` file.
3. In the RStudio Terminal (still inside the project):
   ```bash
   git init
   git branch -M main
   git add .
   git commit -m "Initial commit: scripts, outline, .gitignore"
   git remote add origin https://github.com/<your-username>/homelessness-housing-coc-2023.git
   git push -u origin main
   ```
4. Refresh the GitHub page — your files should be there.

## 6. Daily workflow (once set up)
RStudio has a **Git** tab (top-right pane). You no longer need the terminal.
1. Edit a script. Save.
2. Git tab → check the box next to the file → **Commit** → type a short message → Commit.
3. Click **Push** (green up-arrow) to send to GitHub.
4. **Pull** (blue down-arrow) before you start working each day, to grab any changes.

## 7. If you get a merge conflict
(You mentioned you've hit these before.)
- RStudio will mark the file with an orange "U" (unmerged).
- Open the file. You'll see `<<<<<<< HEAD`, `=======`, `>>>>>>> origin/main` markers.
- Delete the markers and keep the text you want.
- Save, stage, commit, push.

Short rule to avoid most conflicts: **pull before you start, push when you stop**, and don't edit the same lines of the same file from two places between pushes.
