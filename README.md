# talashly-monitor

Tiny repo whose only job: **ping your Talashly server on a schedule and alert you when it is down.**

- Every 10 minutes GitHub Actions calls `<your-url>/api/health` (up to 3 tries, 90 s timeout, so a sleeping Render free service has time to wake).
- If it fails, it opens a GitHub Issue **"Talashly is DOWN"** (GitHub emails you; set Watch -> All activity) and keeps commenting. When the server recovers, the issue is closed automatically.
- The failed run also shows a red X and GitHub sends a failed-workflow email (Settings -> Notifications -> Actions).

<!-- AUTO-SEO:START -->
> **Summary:** The workflow pings the specified URLs every 10 minutes. If a ping fails, it opens a GitHub issue and keeps commenting until the server recovers, then closes the issue.

**Keywords:** github-actions · render · schedule · ping · alert · health-check · oracle-cloud · free-service

### FAQ

**How do I configure the URLs to ping?**  
Set the GitHub Actions variable TARGET_URLS to a comma- or space-separated list of URLs, e.g., TARGET_URLS="https://your-app.onrender.com".

**What happens when the server recovers?**  
The workflow automatically closes the open issue and stops commenting once the ping succeeds again.

**Will this work with a Render free service?**  
Yes, the workflow pings every 10 minutes, which is frequent enough to wake a Render free service that sleeps after 15 minutes of inactivity.

### Related projects
- [talashly](https://github.com/musman550/talashly): Self-hosted open-source search engine with its own crawler, RAG answers and multilingual support (Python). No third-part
- [Website](https://musfiraai.com)

<sub>Generated automatically from this repository's own content. [How this works](https://musman550.github.io/github-traffic-analytics-dashboard/optimizer/)</sub>
<!-- AUTO-SEO:END -->

## Setup (2 minutes)
1. Make this repo **Public** (public repos get free Actions minutes; private ones can run out).
2. Settings -> Secrets and variables -> Actions -> **Variables** -> New variable:
   `TARGET_URLS` = `https://your-app.onrender.com` (several URLs can be separated by commas or spaces).
3. Actions tab -> enable workflows -> **keepalive-and-alert** -> Run workflow once to test.

## Honest limits
- **Oracle Cloud Always Free VM never sleeps**, so it does not need pings; this repo is just the alert for it. Oracle may *reclaim* an idle Always Free VM (CPU, network and memory below 20% for 7 days), so keep the crawler running; pinging does not prevent that.
- **Render free sleeps after 15 min** of no traffic. An hourly ping is too rare; use every 10 minutes. GitHub says scheduled runs can be delayed (often 5-20 min under load) or skipped, so this is *best effort*: a service may still sleep sometimes. Render also gives 750 free hours per month per workspace and wipes the disk on restart.
- GitHub disables scheduled workflows after 60 days without repo activity (public repos). The `push` trigger and an occasional commit re-arm it; check the Actions tab if alerts stop.
- Email goes only to you (and watchers). For phone alerts install the GitHub mobile app and keep notifications on.
