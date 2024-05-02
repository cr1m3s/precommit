# pre-commit script that detects secrets with gitleaks and prevent commits

Installation:

```curl https://raw.githubusercontent.com/cr1m3s/precommit/main/gitleaks-precommit.sh | sh```

Supposed to work on linux, macOS and Windows.
Tested only for linux (requires curl, make, go).

Example of successful commit:
```
[cr1m3s@debian:/precommit]$ git commit -m "meaningful comment"
Download script and install into hooks subdirrectory
Check gitleaks installation.
gitleaks already installed
Running gitleaks...

    ○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

10:29PM INF scan completed in 2.72ms
10:29PM INF no leaks found
```

Example of failed commit:
```
[cr1m3s@debian:/precommit]$ git commit -m "meaningful commit"
Download script and install into hooks subdirrectory
Check gitleaks installation.
gitleaks already installed
Running gitleaks...

    ○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

Finding:     TELE_TOKEN="...secret..."
Secret:      ..secret...
RuleID:      telegram-bot-api-token
Entropy:     4.925523
File:        gitleaks-precommit.sh
Line:        50
Fingerprint: gitleaks-precommit.sh:telegram-bot-api-token:50

10:29PM INF scan completed in 4.09ms
10:29PM WRN leaks found: 1
Gitleaks found secrets in your code. Please remove them before committing.
```
